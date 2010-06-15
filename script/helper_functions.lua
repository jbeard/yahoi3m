require('ai_configuration')

local GOODS_TO_STRING = { [0] = "_SUPPLIES_","_FUEL_",	"_MONEY_",	"_CRUDE_OIL_",	"_METAL_",	"_ENERGY_",	"_RARE_MATERIALS_" }

-------------------------------------------------------------------------------
-- DEBUG Functions
-------------------------------------------------------------------------------
function PrintCountryTable(ai, minIC)
	for country1 in CCurrentGameState.GetCountries() do
		countryTag1 = country1:GetCountryTag()
		
		if IsValidCountry(country1) and country1:GetMaxIC() > minIC then
			Utils.LUA_DEBUGOUT("-------------------- " .. tostring(countryTag1) .. " --------------------")
			local neutrality = country1:GetNeutrality():Get()
			local effectiveNeutrality = country1:GetEffectiveNeutrality():Get()
			
			for country2 in CCurrentGameState.GetCountries() do
				countryTag2 = country2:GetCountryTag()
				
				if IsValidCountry(country2) and not (countryTag1 == countryTag2) and country2:GetMaxIC() > minIC then
					Utils.LUA_DEBUGOUT("\t---------- " .. tostring(countryTag2) .. " ----------")

					local diplomacyStatus = country1:GetRelation(countryTag2)
					local strategy = country1:GetStrategy()

					Utils.LUA_DEBUGOUT("\tCCountry")
					Utils.LUA_DEBUGOUT("\t\tGetDiplomaticDistance = " .. country1:GetDiplomaticDistance(countryTag2):Get())
					
					Utils.LUA_DEBUGOUT("\tCDiplomacyStatus")
					Utils.LUA_DEBUGOUT("\t\tGetValue = " .. diplomacyStatus:GetValue():Get())
					Utils.LUA_DEBUGOUT("\t\tGetThreat = " .. diplomacyStatus:GetThreat():Get())
					
					Utils.LUA_DEBUGOUT("\tCAIStrategy")
					Utils.LUA_DEBUGOUT("\t\tGetAntagonism = " .. strategy:GetAntagonism(countryTag2))
					Utils.LUA_DEBUGOUT("\t\tGetFriendliness = " .. strategy:GetFriendliness(countryTag2))
					Utils.LUA_DEBUGOUT("\t\tGetProtectionism = " .. strategy:GetProtectionism(countryTag2))
					Utils.LUA_DEBUGOUT("\t\tGetThreat = " .. strategy:GetThreat(countryTag2))						
					
					Utils.LUA_DEBUGOUT("\tCAI")
					Utils.LUA_DEBUGOUT("\t\tGetCountryAlignmentDistance = " .. ai:GetCountryAlignmentDistance(country1, country2):Get())
				end
			end
			
			Utils.LUA_DEBUGOUT("\n")
		end
	end
end

-------------------------------------------------------------------------------
-- START Common helper functions
-------------------------------------------------------------------------------

gCommon = {}
gCommon["average_infra"] = {}
function IsValidCountry(country)
	local countryTag = country:GetCountryTag()
	return countryTag:IsReal() and countryTag:IsValid() and country:Exists()
end

function GetAverageInfrastructure(country)
	if IsValidCountry(country) then
		local key = tostring(country:GetCountryTag())
		-- re-calculate occasionally
		if gCommon["average_infra"][key] and 0 ~= math.mod(CCurrentGameState.GetAIRand(), 50) then
			return gCommon["average_infra"][key]
		end

		local provinceCount = 0
		local infrastructure = 0
		local result = 0

		for provinceId in country:GetOwnedProvinces() do
			local province = CCurrentGameState.GetProvince(provinceId)
			infrastructure = infrastructure + province:GetInfrastructure():Get()
			provinceCount = provinceCount + 1
		end

		if provinceCount > 0 then
			result = infrastructure / provinceCount
		end

		gCommon["average_infra"][key] = result
		return result
	else
		return 1
	end
end

-- Modulo function with the property, that the remainder of a division z / d
-- and z < 0 is positive. For example: zmod(-2, 30) = 28.
function Zmod(z, d)
	return math.mod((math.mod(z, d) + d), d);
end

function IsNeighbourOnSameContinent(tagA, countryA, tagB, countryB)
	local a = tostring(tagA)
	local b = tostring(tagB)

	-- Island countries
	if a == 'ENG' or b == 'ENG' then
		return false
	elseif a == 'AST' or b == 'AST' then
		return false
	elseif a == 'JAP' or b == 'JAP' then
		return false
	elseif a == 'NZL' or b == 'NZL' then
		return false
	elseif a == 'PHI' or b == 'PHI' then
		return false
	end

	local continentA = countryA:GetCapitalLocation():GetContinent()
	local continentB = countryB:GetCapitalLocation():GetContinent()
	return countryA:IsNeighbour(tagB) and (continentA == continentB)
end

-------------------------------------------------------------------------------
-- END Common helper functions
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- START Trade specific functions
-------------------------------------------------------------------------------

-- Trade specific global variables and constants.
-- Variables will be updated by HFInit_ManageTrade.
gEconomy = {}
--~ gEconomy["deal"] = {}
gDayCount = -1
gLastDate = {
	day = 0,
	month = 0,
	year = 0
}
G_MEASURED_TIME_PERIOD = 8 -- For how many days are we accounting for
G_AVERAGING_TIME_PERIOD = 7 -- How many days are averaged (must be < G_MEASURED_TIME_PERIOD)
G_MAX_GC_OVER_PRODUCTION = 15 -- How much IC are allowed to put into GC in %
TRADING_THRESHOLD = 0.4

function HFInit_Economy()
	gEconomy["import"] = {}
	gEconomy["export"] = {}
	gEconomy["stock"] = {}
	gEconomy["AI"] = {}
	gEconomy["manual"] = {}
	gEconomy["goods_cost"] = {
		[0] = 	defines.goods_cost.SUPPLIES,
				defines.goods_cost.FUEL,
				defines.goods_cost.MONEY,
				defines.goods_cost.CRUDE_OIL,
				defines.goods_cost.METAL,
				defines.goods_cost.ENERGY,
				defines.goods_cost.RARE_MATERIALS
	}
end

HFInit_Economy()

-- Must be called by ForeignMinister_ManageTrade
function HFInit_ManageTrade(ai, ministerTag)
	-- Update gEconomy["stock"] once a day for all countries
	local MAX_GOODS = CGoodsPool._GC_NUMOF_-1
	if tostring(ministerTag) == '---' then -- Always first country called a day
		--Utils.LUA_DEBUGOUT("->HFInit_ManageTrade")
		--PrintCountryTable(ai, 40)

		-- Global variables won't be deleted if we load a new game.
		-- Check last saved date and if time difference is > 1 day we know we're in
		-- a new game.
		local currentDate = CCurrentGameState.GetCurrentDate()

		--Utils.LUA_DEBUGOUT(tostring(gLastDate.day) .. "." .. tostring(gLastDate.month) .. "." .. tostring(gLastDate.year))
		--Utils.LUA_DEBUGOUT(tostring(currentDate:GetDayOfMonth()) .. "." .. tostring(currentDate:GetMonthOfYear()) .. "." .. tostring(currentDate:GetYear()))

		-- If a new game is loaded up the minister tick functions are called twice
		-- on first day (at lease this behaviour is true in 1.2).
		-- Use this behaviour instead of measuring time difference but leave time
		-- measure here in case this behaviour changes in future patches.
		local init = false
		if 	gLastDate.year == currentDate:GetYear() and
			gLastDate.month == currentDate:GetMonthOfYear() and
			gLastDate.day == currentDate:GetDayOfMonth()
		then
			init = true
		end

		--[[
		local init = true
		if gLastDate.year ~= currentDate:GetYear() then
			-- Different year
			if	(currentDate:GetYear() - gLastDate.year) == 1 and
				gLastDate.month == 11 and
				currentDate:GetMonthOfYear() == 0 and
				gLastDate.day == 30 and
				currentDate:GetDayOfMonth() == 0
			then
				-- New year's eve -> ok
				init = false
			end
		else
			-- Same year
			if gLastDate.month ~= currentDate:GetMonthOfYear() then
				-- Different month
				if	(currentDate:GetMonthOfYear() - gLastDate.month) == 1 and
					currentDate:GetDayOfMonth() == 0 and
					(
						-- Month was february => Last day must be either 27 or 28 OR
						-- Month was even => Last day must be 30 OR
						-- Month was unevent => Last day must be 29
						(not (gLastDate.month == 1) or (gLastDate.day == 27 or gLastDate.day == 28)) or
						(not (math.mod(gLastDate.month, 2) == 0) or (gLastDate.day == 30)) or
						(not (math.mod(gLastDate.month, 2) == 1) or (gLastDate.day == 29))
					)
				then
					init = false
				end
			else
				-- Same month
				if (currentDate:GetDayOfMonth() - gLastDate.day) == 1 then
					-- Last date was yesterday -> ok
					init = false
				end
			end
		end
		]]

		if init then
			--Utils.LUA_DEBUGOUT("Initializing global variables")

			gDayCount = -1
			HFInit_Economy()
		end
		gLastDate.year = currentDate:GetYear()
		gLastDate.month = currentDate:GetMonthOfYear()
		gLastDate.day = currentDate:GetDayOfMonth()

		gDayCount = gDayCount + 1
		--Utils.LUA_DEBUGOUT("--> Day " .. tostring(gDayCount))
		-- save today's trades
		BufferingTrades()
		-- reset 'today'
		gEconomy["manual"] = {}

		day = math.mod(gDayCount, G_MEASURED_TIME_PERIOD) -- Measuring a period of G_MEASURED_TIME_PERIOD days
		for country in CCurrentGameState.GetCountries() do
			countryTag = country:GetCountryTag()

			if countryTag:IsReal() and countryTag:IsValid()
				and country:Exists()
			then
				strCountryTag = tostring(countryTag)
				--Utils.LUA_DEBUGOUT(strCountryTag)

				if gEconomy["stock"][strCountryTag] == nil then
					gEconomy["stock"][strCountryTag] = {}
					--Utils.LUA_DEBUGOUT("gEconomy["stock"] for " .. strCountryTag .. " not set!")
				end

				local pool = country:GetPool()

				for goods = 0, MAX_GOODS do
					if gEconomy["stock"][strCountryTag][goods] == nil then
						gEconomy["stock"][strCountryTag][goods] = {}
					end

					gEconomy["stock"][strCountryTag][goods][day] = pool:Get(goods):Get()

					--Utils.LUA_DEBUGOUT("	" .. GOODS_TO_STRING[goods] .. " - Income: " .. country:GetDailyIncome(goods):Get() .. " Expense: " .. country:GetDailyExpense(goods):Get() .. " Balance: " .. country:GetDailyBalance(goods):Get())
				end
				-- if country was not AI controlled 'yesterday'
				if gEconomy["AI"][strCountryTag] == nil then
					-- add country to list of manual (human) trading countries
					gEconomy["manual"][strCountryTag] = strCountryTag
					--Utils.LUA_DEBUGOUT("Trade of " .. strCountryTag .. " is controlled by human player.")
				end
			end
		end
		-- reset for 'tomorrow'
		gEconomy["AI"] = {}

		--Utils.LUA_DEBUGOUT("<-HFInit_ManageTrade")
	end

	-- Add this country to the list of AI controlled countries
	gEconomy["AI"][tostring(ministerTag)] = tostring(ministerTag)
end

--~ function TradeSpam( goods, BuyerCountry, SellerCountry)
--~ 	if not gEconomy["deal"][goods] then
--~ 		gEconomy["deal"][goods] = {}
--~ 	end
--~ 	if not gEconomy["deal"][goods][BuyerCountry] then
--~ 		gEconomy["deal"][goods][BuyerCountry] = {}
--~ 	end
--~ 	if not gEconomy["deal"][goods][BuyerCountry][SellerCountry] then
--~ 		gEconomy["deal"][goods][BuyerCountry][SellerCountry] = gDayCount-30
--~ 	end
--~ 	-- less than 30 days ago?
--~ 	if gEconomy["deal"][goods][BuyerCountry][SellerCountry] > gDayCount-30 then
--~ 		Utils.LUA_DEBUGOUT(tostring(gDayCount)..": "..tostring(SellerCountry:GetCountryTag()).." tries to SPAM "..tostring(BuyerCountry:GetCountryTag()).." with "
--~ 			..tostring( GOODS_TO_STRING[goods]).." after only "
--~ 			..tostring(gDayCount-gEconomy["deal"][goods][BuyerCountry][SellerCountry]).." days!")
--~ 		return true
--~ 	else -- ok
--~ 		return false
--~ 	end
--~ end

--~ function TradeSpamSet(goods, BuyerCountry, SellerCountry)
--~ 	--Utils.LUA_DEBUGOUT(tostring(gDayCount)..": "..tostring(SellerCountry:GetCountryTag()).." trying to sell to "..tostring(BuyerCountry:GetCountryTag()).." some "..tostring( GOODS_TO_STRING[goods]))
--~ 	gEconomy["deal"][goods][BuyerCountry][SellerCountry] = gDayCount
--~ 	--Utils.LUA_DEBUGOUT(tostring(gDayCount)..": ".."---")
--~ end

function BufferingTrades()
	--Utils.LUA_DEBUGOUT("->BufferingTrades")
	local MAX_GOODS = CGoodsPool._GC_NUMOF_-1
	gEconomy["import"] = {}
	gEconomy["export"] = {}
	gEconomy["trade_routes"] = {}
	local Iters = 0
	local Counter = 0
	for AliceCountry in CCurrentGameState.GetCountries() do
		local AliceTag = AliceCountry:GetCountryTag()
		gEconomy["trade_routes"][tostring(AliceTag)] = {}

		for BobCountry in CCurrentGameState.GetCountries() do
			local BobTag = BobCountry:GetCountryTag()
			--if tostring(BobTag) ~= tostring(AliceTag) then
				for route in AliceCountry:GetRelation( BobTag ):GetTradeRoutes() do
					if route:IsValid() then
						table.insert(gEconomy["trade_routes"][tostring(AliceTag)], route)
						if Counter < Iters then
							for goods = 0, MAX_GOODS do
								if goods ~= CGoodsPool._MONEY_ then
									local switch = false
									local Bob2Alice = route:GetTradedToOf(goods):Get()
									--local Alice2Bob = route:GetTradedFromOf(goods):Get()
									if  0~=Bob2Alice then
										-- direction?
										if tostring(route:GetConvoyResponsible()) == tostring(BobTag) and Bob2Alice>0 then
											--Utils.LUA_DEBUGOUT("Switch (1)")
											--Alice2Bob, Bob2Alice = Bob2Alice, Alice2Bob
											AliceTag, BobTag = BobTag, AliceTag
											switch = true
										end
										-- if tostring(route:GetConvoyResponsible()) == tostring(AliceTag) and Alice2Bob>0 then
											-- Utils.LUA_DEBUGOUT("Switch (2)")
											-- Alice2Bob, Bob2Alice = Bob2Alice, Alice2Bob
										-- end
										-- ok Bob sends to ALice
										if Bob2Alice>0 then
											-- Utils.LUA_DEBUGOUT(tostring(AliceTag).." 2 "..tostring(BobTag).." (1) "..tostring(Alice2Bob).." "..tostring( GOODS_TO_STRING[goods]))
										-- else
											--Utils.LUA_DEBUGOUT(tostring(BobTag).." 2 "..tostring(AliceTag).." (2) "..tostring(Bob2Alice).." "..tostring( GOODS_TO_STRING[goods]))
										end

										-- if Bob2Alice > 0 then
											-- AliceTag, BobTag = BobTag, AliceTag
										-- end
										if nil == gEconomy["export"][goods] then
											gEconomy["import"][goods] = {}
											gEconomy["export"][goods] = {}
										end
										if nil == gEconomy["export"][goods][tostring(BobTag)] then
											gEconomy["export"][goods][tostring(BobTag)] = {}
										end
										if nil == gEconomy["import"][goods][tostring(AliceTag)] then
											gEconomy["import"][goods][tostring(AliceTag)] = {}
										end
										gEconomy["export"][goods][tostring(BobTag)][tostring(AliceTag)]= Bob2Alice
										gEconomy["import"][goods][tostring(AliceTag)][tostring(BobTag)] = Bob2Alice
										-- reverse switch
										if switch then
											--Utils.LUA_DEBUGOUT("Switch (2)")
											--Alice2Bob, Bob2Alice = Bob2Alice, Alice2Bob
											AliceTag, BobTag = BobTag, AliceTag
										end
									end
								end
							end
						end
					end
				--end
			end
			Counter = Counter + 1
		end
		Iters = Iters + 1
		Counter = 0
	end
	--Utils.LUA_DEBUGOUT("<-BufferingTrades")
end

-- Returns true if trade of given country is controlled by human.
-- Note: This function needs one day to return correct results;
-- 		 will always return true on first day (gDayCount == 0).
function IsTradeControlledByHuman(countryTag)
	key = tostring(countryTag)
	if gEconomy["manual"][key] then
		return true
	else
		return false
	end
end

-- Returns average balance of given goods.
-- G_AVERAGING_TIME_PERIOD defines how much days are averaged.
-- Note: This function needs some days to return good results.
function GetAverageBalance(ministerCountry, goods)
	key = tostring(ministerCountry:GetCountryTag())
	if gEconomy["stock"][key] == nil then
		--Utils.LUA_DEBUGOUT(tostring(ministerCountry:GetCountryTag()).." GetAverageBalance - HFInit_ManageTrade wasn't called yet.")
		-- HFInit_ManageTrade wasn't called yet.
		return 0
	end

	period = math.min(gDayCount, G_AVERAGING_TIME_PERIOD)
	if period == 0 then
		--Utils.LUA_DEBUGOUT(tostring(ministerCountry:GetCountryTag()).." GetAverageBalance - No data yet!")
		return 0 -- we have nothing to compare with
	end
	
	-- Averaging doesn't work if max stockpile reached.
	if Stock(ministerCountry, goods) >= 99990 then
		return ministerCountry:GetDailyBalance(goods):Get()
	end

	today = math.mod(gDayCount, G_MEASURED_TIME_PERIOD)
	yesterday = math.mod(gDayCount - 1, G_MEASURED_TIME_PERIOD)

	sum = 0
	for i = 0, period - 1 do
		sum = sum + (gEconomy["stock"][key][goods][today] - gEconomy["stock"][key][goods][yesterday])
		today = Zmod(today - 1, G_MEASURED_TIME_PERIOD)
		yesterday = Zmod(yesterday - 1, G_MEASURED_TIME_PERIOD)
	end
	--Utils.LUA_DEBUGOUT(tostring(ministerCountry:GetCountryTag()).." GetAverageBalance: "..tostring(sum / period))
	return sum / period
end

-- Returns daily balance of a faction.
function GetFactionBalance(faction, goods)
	local sum = 0
	for countryTag in faction:GetMembers() do
		local country = countryTag:GetCountry()
		sum = sum + country:GetDailyBalance(goods)
	end
	return sum
end

function MinStock(country, goods)
	-- min for a 100 IC country in peace:
	-- 200 oil, rare
	-- 5k supply, fuel
	-- 500 energy and metal
	-- min for a 100 IC country in war:
	-- 400 oil, rare
	-- 10k supply, fuel
	-- 1k energy and metal
	local factor = ai_configuration.STOCKPILE_FACTOR/25 -- 2 -> oil, rare
	if goods == CGoodsPool._SUPPLIES_ or goods == CGoodsPool._FUEL_ then
		factor = ai_configuration.STOCKPILE_FACTOR -- 50
	elseif goods == CGoodsPool._METAL_ or goods == CGoodsPool._ENERGY_ then
		factor = ai_configuration.STOCKPILE_FACTOR/10 -- 5
	end
	if country:IsAtWar() or country:GetStrategy():IsPreparingWar() then
		return factor*2*country:GetTotalIC()
	end
	return factor*country:GetTotalIC()
end

function MaxStock(country, goods)
	if country:IsAtWar() or country:GetStrategy():IsPreparingWar() then
		return math.min(90000, 1000*country:GetTotalIC())
	end
	return math.min(90000, 500*country:GetTotalIC())
end

function HasMinStock(country, goods)
	return country:GetPool():Get( goods ):Get() > MinStock(country, goods)
end

function HasMaxStock(country, goods)
	return country:GetPool():Get( goods ):Get() > MaxStock(country, goods)
end

function Stock(country, goods)
	return country:GetPool():Get(goods):Get()
end

function Importing(countryTag, goods)
	return _ImportingExporting("import", tostring(AliceTag), goods)
end

function Exporting(countryTag, goods)
	return _ImportingExporting("export", tostring(AliceTag), goods)
end

function _ImportingExporting(key, countryKey, goods)
	if not gEconomy[key] or not gEconomy[key][goods] or not gEconomy[key][goods][countryKey] then
		return 0
	end

	local sum = 0
	for k,v in pairs(gEconomy[key][goods][countryKey]) do
		sum = sum + v
	end

	return sum
end

function ExistsExport(aliceTag, goods)
	if goods ~= CGoodsPool._MONEY_ and gEconomy["export"][goods] and gEconomy["export"][goods][tostring(aliceTag)] then
		-- Utils.LUA_DEBUGOUT(tostring( aliceTag ).." exports "..tostring(GOODS_TO_STRING[goods]).." "..tostring(gEconomy["export"][goods][tostring(aliceTag)]))
		-- for bobTag, Export in pairs(gEconomy["export"][goods][tostring(aliceTag)]) do
			-- Utils.LUA_DEBUGOUT(tostring( aliceTag ).." exports "..tostring(Export).." "..tostring(GOODS_TO_STRING[goods]).." to "..tostring(bobTag))
		-- end
		return true
	end
	return false
end

function ExistsImport(aliceTag, goods)
	if goods ~= CGoodsPool._MONEY_ and gEconomy["import"][goods] and gEconomy["import"][goods][tostring(aliceTag)] then
		--Utils.LUA_DEBUGOUT(tostring(gDayCount)..": "..tostring( aliceTag ).." imports "..tostring(GOODS_TO_STRING[goods]))
		-- for bobTag, Import in pairs(gEconomy["export"][goods][tostring(aliceTag)]) do
			-- Utils.LUA_DEBUGOUT(tostring( aliceTag ).." imports "..tostring(Import).." "..tostring(GOODS_TO_STRING[goods]).." from "..tostring(bobTag))
		-- end
		return true
	end
	return false
end

-- return true if country has money, makes money and doesn't overproduce CG to do so
function IsRich(AliceCountry)
	local MoneyStockFactor = AliceCountry:GetPool():Get( CGoodsPool._MONEY_ ):Get()/AliceCountry:GetTotalIC()
	if	-- loaded bank account
		MoneyStockFactor > 5 and
		-- current cg setting less than 110% need or dissent (so high cg allowed if dissent)
		(AliceCountry:GetProductionDistributionAt( CDistributionSetting._PRODUCTION_CONSUMER_ ):GetNeeded():Get()*1.1 > AliceCountry:GetICPart( CDistributionSetting._PRODUCTION_CONSUMER_ ):Get() or
			AliceCountry:GetDissent():Get() > 0.01) and
		-- we can maintain our expenses for at least 100 days
		GetAverageBalance(AliceCountry, CGoodsPool._MONEY_) > -AliceCountry:GetPool():Get( CGoodsPool._MONEY_ ):Get()/100
	then
		--Utils.LUA_DEBUGOUT(tostring(AliceCountry:GetCountryTag()).." IsRich ")
		return true
	else
		-- If we're not importing anything other than supplies and have positive money balance
		-- we can consider ourselves as being rich.
		local importer = false
		local needResources = false
		for goods = 0, CGoodsPool._GC_NUMOF_ - 1 do
			if goods ~= CGoodsPool._SUPPLIES_ and goods ~= CGoodsPool._FUEL_ then
				if ExistsImport(AliceCountry:GetCountryTag(), goods) then
					importer = true
					break
				end
				if GetAverageBalance(AliceCountry, goods) < 0 then
					needResources = true
					break
				end
			end
		end

		if 	not needResources and
			not importer and
			not ExistsExport(AliceCountry:GetCountryTag(), CGoodsPool._SUPPLIES_) and
			GetAverageBalance(AliceCountry, CGoodsPool._MONEY_) > 0
		then
			--Utils.LUA_DEBUGOUT(tostring(AliceCountry:GetCountryTag()).." IsRich ")
			return true
		else
			--Utils.LUA_DEBUGOUT(tostring(AliceCountry:GetCountryTag()).." NOT IsRich ")
			return false
		end
	end
end

-- return true if country has barely money
function IsPoor(AliceCountry)
	local MoneyStockFactor = AliceCountry:GetPool():Get( CGoodsPool._MONEY_ ):Get()/AliceCountry:GetTotalIC()
	if	MoneyStockFactor < 2
	and GetAverageBalance(AliceCountry, CGoodsPool._MONEY_) < 0
	then
		--Utils.LUA_DEBUGOUT(tostring(AliceCountry:GetCountryTag()).." IsPoor ")
		return true
	else
		--Utils.LUA_DEBUGOUT(tostring(AliceCountry:GetCountryTag()).." NOT IsPoor ")
		return false
	end
end

function GetGoodsCost(goods)
	return gEconomy["goods_cost"][goods]
end

-------------------------------------------------------------------------------
-- END Trade specific functions
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- START Politics specific functions
-------------------------------------------------------------------------------

gPolitics = {}
gPolitics["law_tables"] = {}
gPolitics["law_group_tables"] = {}
gPoliticsInitialized = false

function HFInit_Politics()
	if gPoliticsInitialized then
		return
	end

	for law in CLawDataBase.GetLawList() do
		gPolitics["law_tables"][tostring(law:GetKey())] = law:GetIndex()
	end

	for group in CLawDataBase.GetGroups() do
		gPolitics["law_group_tables"][tostring(group:GetKey())] = group:GetIndex()
	end

	gPoliticsInitialized = true
end

function GetLawIndexByName(name)
	HFInit_Politics() -- Make sure gPolitics["law_tables"] is set up properly
	if gPolitics["law_tables"][name] then
		return gPolitics["law_tables"][name]
	else
		return 0 -- Index for no law
	end
end

function GetLawGroupIndexByName(name)
	HFInit_Politics() -- Make sure gPolitics["law_group_tables"] is set up properly
	if gPolitics["law_group_tables"][name] then
		return gPolitics["law_group_tables"][name]
	else
		return 0 -- Index for no law group
	end
end

-------------------------------------------------------------------------------
-- END Politics specific functions
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- START Tech specific functions
-------------------------------------------------------------------------------

gTech = {}
gTech["tech_table"] = {}
gTechInitialized = false

function HFInit_Tech()
	if gTechInitialized then
		return
	end

	for tech in CTechnologyDataBase.GetTechnologies() do
		gTech["tech_table"][tostring(tech:GetKey())] = tech
	end

	gTechInitialized = true
end

function GetTechByName(name)
	HFInit_Tech() -- Make sure gTech["tech_table"] is set up properly
	if gTech["tech_table"][name] then
		return gTech["tech_table"][name]
	else
		return nil
	end
end

-------------------------------------------------------------------------------
-- END Tech specific functions
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- START Diplomacy specific functions
-------------------------------------------------------------------------------

function GetWarRunningTime(tag1, tag2)
	local tag1Country = tag1:GetCountry()
	for diploStatus in tag1Country:GetDiplomacy() do
		local target = diploStatus:GetTarget()
		if target:IsValid() and diploStatus:HasWar() then
			local war = diploStatus:GetWar()
			if war:IsPartOfWar(tag2) then
				--If at war with tag2, return running time in months
				return war:GetCurrentRunningTimeInMonths()
			end
		end
	end
	return 0
end
-------------------------------------------------------------------------------
-- END Diplomacy specific functions
-------------------------------------------------------------------------------
