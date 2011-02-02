-----------------------------------------------------------
-- LUA Hearts of Iron 3 Production File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 7/10/2010
-----------------------------------------------------------

-- ######################
-- Global Variables
--    CAREFUL: Variables are remembered from country to country
-- ######################
local laUnitNeeds -- Gets reset each time the tick starts
local lbBuiltRocketSite -- Gets reset each time the tick starts

local _GARRISON_BRIGADE_ = 1
local _MILITIA_BRIGADE_ = 2

local _INFANTRY_BRIGADE_ = 3
local _CAVALRY_BRIGADE_ = 4
local _BERGSJAEGER_BRIGADE_ = 5
local _MARINE_BRIGADE_ = 6
local _PARATROOPER_BRIGADE_ = 7

local _LIGHT_ARMOR_BRIGADE_ = 8
local _ARMOR_BRIGADE_ = 9
local _HEAVY_ARMOR_BRIGADE_ = 10
local _SUPER_HEAVY_ARMOR_BRIGADE_ = 11

local _MECHANIZED_BRIGADE_ = 12

local _MOTORIZED_BRIGADE_ = 13


local _ANTI_AIR_BRIGADE_ = 14
local _ANTI_TANK_BRIGADE_ = 15
local _ARTILLERY_BRIGADE_ = 16
local _ENGINEER_BRIGADE_ = 17
local _ROCKET_ARTILLERY_BRIGADE_ = 18

local _ARMORED_CAR_BRIGADE_ = 19
local _SP_ARTILLERY_BRIGADE_ = 20
local _SP_RCT_ARTILLERY_BRIGADE_ = 21
local _TANK_DESTROYER_BRIGADE_ = 22

local _POLICE_BRIGADE_ = 23


local _BATTLECRUISER_ = 24
local _BATTLESHIP_ = 25
local _SUPER_HEAVY_BATTLESHIP_ = 26
local _CARRIER_ = 27
local _ESCORT_CARRIER_ = 28
local _CAG_ = 29
local _DESTROYER_ = 30
local _LIGHT_CRUISER_ = 31
local _HEAVY_CRUISER_ = 32
local _SUBMARINE_ = 33
local _NUCLEAR_SUBMARINE_ = 34
local _TRANSPORT_SHIP_ = 35

local _CAS_ = 36
local _INTERCEPTOR_ = 37
local _MULTI_ROLE_ = 38
local _ROCKET_INTERCEPTOR_ = 39
local _NAVAL_BOMBER_ = 40
local _STRATEGIC_BOMBER_ = 41
local _TACTICAL_BOMBER_ = 42
local _TRANSPORT_PLANE_ = 43
local _FLYING_BOMB_ = 44
local _FLYING_ROCKET_ = 45

local _HQ_BRIGADE_ = 46
local _PARTISAN_BRIGADE_ = 47

-- Static Arrays used for Ratio setup
local _LandRatio_Units_ = {
	'garrison_brigade', -- Garrison
	'infantry_brigade', -- Infantry
	'motorized_brigade', -- Motorized
	'mechanized_brigade', -- Mechanized
	'light_armor_brigade|armor_brigade|heavy_armor_brigade|super_heavy_armor_brigade', -- Armor
	'militia_brigade', -- Militia
	'cavalry_brigade'}; -- Cavalry

local _AirRatio_Units_ = {
	'interceptor|multi_role|rocket_interceptor', -- Fighter
	'cas', -- CAS
	'tactical_bomber', -- Tactical
	'naval_bomber', -- Naval Bomber
	'strategic_bomber'}; -- Strategic
	
local _NavalRatio_Units_ = {
	'destroyer', -- Destroyers
	'submarine', -- Submarines
	'light_cruiser|heavy_cruiser', -- Cruisers
	'battlecruiser|battleship|super_heavy_battleship', -- Capital
	'escort_carrier', -- Escort Carrier
	'carrier'}; -- Carrier
		
-- ######################
-- Default parameters for countries 
-- ######################





-- Countries Default build weights for land based only
local DefaultProdLand = {}

-- Land Brigades vs Air Units ratio
--   If Air Ratio is met AI will shift its Air IC to build land units
function DefaultProdLand.LandToAirRatio(minister)
	local laArray = {
		8, -- Land Briages
		1}; -- Air
	
	return laArray
end

function DefaultProdLand.ProductionWeights(minister)
	local rValue
	
	if minister:GetCountry():IsAtWar() then
		local laArray = {
			0.65, -- Land
			0.25, -- Air
			0.0, -- Sea
			0.10}; -- Other
		
		rValue = laArray	
	else
		local laArray = {
			0.55, -- Land
			0.25, -- Air
			0.0, -- Sea
			0.20}; -- Other
		
		rValue = laArray
	end
	
	return rValue
end
-- Land ratio distribution
function DefaultProdLand.LandRatio(minister)
	local laArray = {
		0, -- Garrison
		13, -- Infantry
		2, -- Motorized
		1, -- Mechanized
		1, -- Armor
		0, -- Militia
		0}; -- Cavalry

	
	return laArray
end
-- Special Forces ratio distribution
function DefaultProdLand.SpecialForcesRatio(minister)
	local laArray = {
		25, -- Land
		1}; -- Special Forces Unit
	
	return laArray
end
-- Air ratio distribution
function DefaultProdLand.AirRatio(minister)
	local laArray = {
		8, -- Fighter
		3, -- CAS
		4, -- Tactical
		0, -- Naval Bomber
		0}; -- Strategic
	
	return laArray
end
-- Flying Bomb/Rocket distribution against total Air Power
function DefaultProdLand.RocketRatio(minister)
	local laArray = {
		10, -- Air
		1}; -- Bomb/Rockety
	
	return laArray
end

-- Naval ratio distribution
function DefaultProdLand.NavalRatio(minister)
	local laArray = {
		0, -- Destroyers
		0, -- Submarines
		0, -- Cruisers
		0, -- Capital
		0, -- Escort Carrier
		0}; -- Carrier
	
	return laArray
end

function DefaultProdLand.TransportLandRatio(minister)
	local laArray = {
		0, -- Land
		0}; -- Transport
	
	return laArray
end


-- Countries Default build weights for mixed based only
local DefaultProdMix = {}

-- Land Brigades vs Air Units ratio
--   If Air Ratio is met AI will shift its Air IC to build land units
function DefaultProdMix.LandToAirRatio(minister)
	local laArray = {
		8, -- Land Briages
		1}; -- Air
	
	return laArray
end

function DefaultProdMix.ProductionWeights(minister)
	local rValue
	
	if minister:GetCountry():IsAtWar() then
		local laArray = {
			0.50, -- Land
			0.25, -- Air
			0.20, -- Sea
			0.05}; -- Other
		
		rValue = laArray	
	else
		local laArray = {
			0.40, -- Land
			0.25, -- Air
			0.20, -- Sea
			0.15}; -- Other
		
		rValue = laArray
	end
	
	return rValue
end
-- Land ratio distribution
function DefaultProdMix.LandRatio(minister)
	local laArray = {
		0, -- Garrison
		13, -- Infantry
		2, -- Motorized
		1, -- Mechanized
		1, -- Armor
		0, -- Militia
		0}; -- Cavalry
	
	return laArray
end
-- Special Forces ratio distribution
function DefaultProdMix.SpecialForcesRatio(minister)
	local laArray = {
		50, -- Land
		1}; -- Special Forces Unit
	
	return laArray
end
-- Air ratio distribution
function DefaultProdMix.AirRatio(minister)
	local laArray = {
		8, -- Fighter
		3, -- CAS
		4, -- Tactical
		1, -- Naval Bomber
		0}; -- Strategic
	
	return laArray
end
-- Flying Bomb/Rocket distribution against total Air Power
function DefaultProdMix.RocketRatio(minister)
	local laArray = {
		10, -- Air
		1}; -- Bomb/Rockety
	
	return laArray
end
-- Naval ratio distribution
function DefaultProdMix.NavalRatio(minister)
	local laArray = {
		6, -- Destroyers
		4, -- Submarines
		4, -- Cruisers
		1, -- Capital
		0, -- Escort Carrier
		0}; -- Carrier
	
	return laArray
end
-- Transport to Land unit distribution
function DefaultProdMix.TransportLandRatio(minister)
	local laArray = {
		20, -- Land
		1}; -- Transport
	
	return laArray
end

-- ######################
-- END OF Default parameters for countries 
-- ######################



-- ###################################
-- # Main Method called by the EXE
-- #####################################
function ProductionMinister_Tick(minister)
	ManageProduction(minister)	
end

-- ###################################
-- # Main Method called by the EXE
-- #####################################
function BalanceProductionSliders(ai, ministerCountry, prioSelection)
	local PRIO_SETTINGS = {
		[0] = { -- full ai automation
			[0] = CDistributionSetting._PRODUCTION_CONSUMER_, 
			CDistributionSetting._PRODUCTION_SUPPLY_,
			CDistributionSetting._PRODUCTION_REINFORCEMENT_,	
			CDistributionSetting._PRODUCTION_PRODUCTION_,
			CDistributionSetting._PRODUCTION_UPGRADE_
		},
		[1] = {  -- prio production
			[0] = CDistributionSetting._PRODUCTION_CONSUMER_, 
			CDistributionSetting._PRODUCTION_SUPPLY_,
			CDistributionSetting._PRODUCTION_PRODUCTION_,
			CDistributionSetting._PRODUCTION_REINFORCEMENT_,
			CDistributionSetting._PRODUCTION_UPGRADE_
		},
		[2] = {   -- prio upgrades
			[0] = CDistributionSetting._PRODUCTION_CONSUMER_, 
			CDistributionSetting._PRODUCTION_SUPPLY_,
			CDistributionSetting._PRODUCTION_UPGRADE_,
			CDistributionSetting._PRODUCTION_REINFORCEMENT_,	
			CDistributionSetting._PRODUCTION_PRODUCTION_
		},
		[3] = {   -- prio reinforcement
			[0] = CDistributionSetting._PRODUCTION_CONSUMER_, 
			CDistributionSetting._PRODUCTION_SUPPLY_,
			CDistributionSetting._PRODUCTION_REINFORCEMENT_,	
			CDistributionSetting._PRODUCTION_PRODUCTION_,
			CDistributionSetting._PRODUCTION_UPGRADE_
		},
		[4] = {   -- prio special reinforcement case
			[0] = CDistributionSetting._PRODUCTION_REINFORCEMENT_,	
			CDistributionSetting._PRODUCTION_CONSUMER_, 
			CDistributionSetting._PRODUCTION_SUPPLY_,
			CDistributionSetting._PRODUCTION_PRODUCTION_,
			CDistributionSetting._PRODUCTION_UPGRADE_
		}
	}
	
	local liOrigPrio = prioSelection
	local lbIsMajor = ministerCountry:IsMajor()
	
	-- If country just started mobilizing (or gets bonus reinforcements for some other reason), boost reinforcements
	if ( prioSelection == 0 or prioSelection == 3 )then
		local reinforcement_multiplier = ministerCountry:CalculateReinforcementMultiplier():Get()
		if reinforcement_multiplier > 1.0 then
			prioSelection = 4
		end
	end
	
	local sum = 0
	local changes = { [0] = 0, 0, 0, 0, 0 }	
	
	local totalIC = ministerCountry:GetTotalIC()
	
	-- Load the Change Array with existing settings
	for setting = 0, table.getn( PRIO_SETTINGS[prioSelection] ) do
		local slider = ministerCountry:GetProductionDistributionAt( setting )
		local percentage = slider:GetNeeded():Get() / totalIC
		percentage = percentage 
		changes[ setting ] = math.max(percentage, 0.0 )
	end
	
	-- If Dissent is present add 10% to the Production of Consumer Goods
	local dissent = ministerCountry:GetDissent():Get()
	if dissent > 0.01 then -- fight dissent 
		changes[ CDistributionSetting._PRODUCTION_CONSUMER_ ] = changes[ CDistributionSetting._PRODUCTION_CONSUMER_ ] + 0.1
	end
	
	-- Performance check make sure its above 0 before we even look at this
	if changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] > 0 then
		local supplyStockpile = ministerCountry:GetPool():Get( CGoodsPool._SUPPLIES_ ):Get()
		local weeksSupplyUse = ministerCountry:GetDailyExpense( CGoodsPool._SUPPLIES_ ):Get() * 7
	
		-- Major power check
		if lbIsMajor then
			-- Increase supply production by 25% if less than 20 weeks and stockpile less than 50k
			if (supplyStockpile < weeksSupplyUse * 20.0) and supplyStockpile < 50000 then
				changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] = changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] + (changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] * 0.25)
				
			-- Increase supply production by 15% if stockpile less than 70k
			elseif supplyStockpile < 70000 then
				changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] = changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] + (changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] * 0.15)
				
			-- Decrease supply production by 50% if stockpile greater than 90k
			elseif supplyStockpile > 90000 then
				changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] = changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] - (changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] * 0.5)
				
			-- Decrease supply production by 10% if stockpile greater than 80k
			elseif supplyStockpile > 80000 then
				changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] = changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] - (changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] * 0.1)
			end
		else
			-- Increase supply production by 25% if less than 8 weeks and stockpile less than 2k
			if (supplyStockpile < weeksSupplyUse * 8.0) and supplyStockpile < 2000 then
				changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] = changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] + (changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] * 0.25)
				
			-- Increase supply production by 15% if less than 20 weeks and stockpile less than 4k
			elseif (supplyStockpile < weeksSupplyUse * 20.0) and supplyStockpile < 4000 then
				changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] = changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] + (changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] * 0.15)
				
			-- Decrease supply production by 50% if stockpile greater than 10k
			elseif supplyStockpile > 10000 then
				changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] = changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] - (changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] * 0.5)
				
			-- Decrease supply production by 10% if more than 20 weeks and stockpile greater than 4k
			elseif (supplyStockpile > weeksSupplyUse * 20.0) and supplyStockpile > 4000 then
				changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] = changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] - (changes[ CDistributionSetting._PRODUCTION_SUPPLY_ ] * 0.1)
			end
		end
	end
	
	-- Normalize the percentages based on priority so the total does not exceed 1.0 (100%)
	local factor_left = 1
	for i = 0, table.getn( PRIO_SETTINGS[prioSelection] ) do -- normalize
		local index = PRIO_SETTINGS[prioSelection][i]
		local factor = changes[ index ] + 0.00005 -- stop dumb roundoff errors
		factor = math.min(factor, factor_left)
		factor_left = math.max(factor_left - factor, 0.0)

		changes[ index ] = factor
	end
	
	factor_left = math.max(factor_left, 0.0)
	if liOrigPrio == 0 then
	                
		local neededUpgrades = ministerCountry:GetProductionDistributionAt( CDistributionSetting._PRODUCTION_UPGRADE_ ):GetNeeded():Get()
		local neededPercentage = (neededUpgrades / totalIC) 
		local liProdUpgradeTotalPercentage = changes[ CDistributionSetting._PRODUCTION_UPGRADE_ ] +  changes[ CDistributionSetting._PRODUCTION_PRODUCTION_ ] + factor_left
		
		-- If the total needed for Upgrading exceedes the total amount available between
		--   Production and Upgrades then divide then umber in half so something gets produced.
		if neededPercentage > liProdUpgradeTotalPercentage or neededPercentage > (liProdUpgradeTotalPercentage / 2)  then
			changes[ CDistributionSetting._PRODUCTION_UPGRADE_ ] = (liProdUpgradeTotalPercentage / 2)
			changes[ CDistributionSetting._PRODUCTION_PRODUCTION_ ] = (liProdUpgradeTotalPercentage / 2)

		-- Upgrades is covered put everything extra into Production
		else
			changes[ CDistributionSetting._PRODUCTION_UPGRADE_ ] = neededPercentage
			changes[ CDistributionSetting._PRODUCTION_PRODUCTION_ ] = liProdUpgradeTotalPercentage - neededPercentage
		end
	else
		-- We have some dessent so put extra IC to lower it
		if dissent > 0.01 then
			changes[ CDistributionSetting._PRODUCTION_CONSUMER_ ] = changes[ CDistributionSetting._PRODUCTION_CONSUMER_ ] + factor_left
		else
			changes[ CDistributionSetting._PRODUCTION_PRODUCTION_ ] = changes[ CDistributionSetting._PRODUCTION_PRODUCTION_ ] + factor_left
		end
	end
	
	local command = CChangeInvestmentCommand( ministerCountry:GetCountryTag(), changes[0], changes[1], changes[2], changes[3], changes[4] )
	ai:Post( command )
end

-- Main method for doing production, all other methods are called from this one.
function ManageProduction(minister)
	-- Reset Arrays since global variables are remembered from country to country
	local prodArrayCounts = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	local currentArrayCounts = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	--local theaterArrayCounts = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	laUnitNeeds = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	lbBuiltRocketSite = false
	
	local ministerTag = minister:GetCountryTag()
	local ministerCountry = minister:GetCountry()
	local icProdAllocated = ministerCountry:GetICPart( CDistributionSetting._PRODUCTION_PRODUCTION_ ):Get()
	local ai = minister:GetOwnerAI()	
	local ic = icProdAllocated - ministerCountry:GetUsedIC():Get()

	-- Performance check
	--   if no IC just exit completely so no objects get created
	if ic <= 0.2 then
		return
	end

	-- Check to make sure they have Manpower
	--    IC check added for performance. If none dont bother executing.
	if ministerCountry:HasExtraManpowerLeft() then
		--Utils.LUA_DEBUGOUT("Country: " .. tostring(ministerTag))
		--Utils.LUA_DEBUGOUT("IC: " .. tostring(ministerCountry:GetTotalIC()))

		local loTechStatus = ministerCountry:GetTechnologyStatus()
		local lbNaval = (ministerCountry:GetNumOfPorts() > 0 and ministerCountry:GetTotalIC() >= 20)
		local lbAir = (ministerCountry:GetNumOfAirfields() > 0)
		
		local laProdWeights = GetBuildRatio(minister, ministerTag, lbNaval, "ProductionWeights")
		local laLandRatio = GetBuildRatio(minister, ministerTag, lbNaval, "LandRatio")
		local laSpecialForcesRatio = GetBuildRatio(minister, ministerTag, lbNaval, "SpecialForcesRatio")
		local laAirRatio = GetBuildRatio(minister, ministerTag, lbNaval, "AirRatio")
		local laRocketRatio = GetBuildRatio(minister, ministerTag, lbNaval, "RocketRatio")
		local laNavalRatio = GetBuildRatio(minister, ministerTag, lbNaval, "NavalRatio")
		local laLandToAirRatio = GetBuildRatio(minister, ministerTag, lbNaval, "LandToAirRatio")
		local laTransportLandRatio = GetBuildRatio(minister, ministerTag, lbNaval, "TransportLandRatio")
		
		-- If no air fields set all of its ratios to 0 so the Air power code does not fire
		if not(lbAir) then
			for i = 1, table.getn(laAirRatio) do
				laAirRatio[i] = 0
			end
			
			-- Now move the Air IC over to the Land section
			laProdWeights[1] = laProdWeights[1] + laProdWeights[2]
		end
		
		-- Figure out how much IC is suppose to be designated in the appropriate area
		local liPotentialLandIC = tonumber(tostring(icProdAllocated * laProdWeights[1]))
		local liPotentialAirIC = tonumber(tostring(icProdAllocated * laProdWeights[2]))
		local liPotentialNavalIC = tonumber(tostring(icProdAllocated * laProdWeights[3]))
		local liPotentialOtherIC = tonumber(tostring(icProdAllocated * laProdWeights[4]))
		
		local liNeededLandIC = 0
		local liNeededAirIC = 0
		local liNeededNavalIC = 0
		local liNeededOtherIC = 0
		
		-- Verify Build Ratios against avaialbe units
		if Utils.HasCountryAIFunction( ministerTag, "_LandRatio_Units_") then
			laLandRatio = VerifyRatio(loTechStatus, laLandRatio, Utils.CallCountryAI(ministerTag, "_LandRatio_Units_", minister))
		else
			laLandRatio = VerifyRatio(loTechStatus, laLandRatio, _LandRatio_Units_)
		end

		if Utils.HasCountryAIFunction( ministerTag, "_AirRatio_Units_") then
			laAirRatio = VerifyRatio(loTechStatus, laAirRatio, Utils.CallCountryAI(ministerTag, "_AirRatio_Units_", minister))
		else
			laAirRatio = VerifyRatio(loTechStatus, laAirRatio, _AirRatio_Units_)
		end
		
		if Utils.HasCountryAIFunction( ministerTag, "_NavalRatio_Units_") then
			laNavalRatio = VerifyRatio(loTechStatus, laNavalRatio, Utils.CallCountryAI(ministerTag, "_NavalRatio_Units_", minister))
		else
			laNavalRatio = VerifyRatio(loTechStatus, laNavalRatio, _NavalRatio_Units_)
		end
		
		
		-- Figure out what the AI is currently producin in each category
		for loBuildItem in ministerCountry:GetConstructions() do
			if loBuildItem:IsMilitary() then
				local loMilitary = loBuildItem:GetMilitary()
				
				if loMilitary:IsLand() then
					liNeededLandIC = liNeededLandIC + loBuildItem:GetCost()
				elseif loMilitary:IsAir() then
					for loConstDef in loMilitary:GetBrigades() do
						local loSubUnit = loConstDef:GetType()
						
						-- If it is a cag add it to naval IC count instead of air
						if loSubUnit:IsCag() then
							liNeededNavalIC = liNeededNavalIC + loBuildItem:GetCost()
						else
							liNeededAirIC = liNeededAirIC + loBuildItem:GetCost()
						end
						
						-- Exit the loop right away
						break
					end
				elseif loMilitary:IsNaval() then
					liNeededNavalIC = liNeededNavalIC + loBuildItem:GetCost()
				end
			else
				liNeededOtherIC = liNeededOtherIC + loBuildItem:GetCost()
			end
		end
		
		-- Now figure out what it needs
		liNeededLandIC = liPotentialLandIC - liNeededLandIC
		liNeededAirIC = liPotentialAirIC - liNeededAirIC
		liNeededNavalIC = liPotentialNavalIC - liNeededNavalIC
		liNeededOtherIC = liPotentialOtherIC - liNeededOtherIC
		
		-- Normalize the IC counts in case of shifts
		local liOverIC = 0
		
		-- Variables are negative numbers so add them
		if liNeededLandIC < 0 then
			liOverIC = liOverIC + liNeededLandIC
		end
		if liNeededAirIC < 0 then
			liOverIC = liOverIC + liNeededAirIC
		end
		if liNeededNavalIC < 0 then
			liOverIC = liOverIC + liNeededNavalIC
		end
		if liNeededOtherIC < 0 then
			liOverIC = liOverIC + liNeededOtherIC
		end

		if liOverIC > 0 then
			if liNeededNavalIC > 0 and liOverIC > 0 then
				if liNeededNavalIC >= liOverIC then
					liNeededNavalIC = liNeededNavalIC - liOverIC
					liOverIC = 0
				else
					liOverIC = liOverIC - liNeededNavalIC
					liNeededNavalIC = 0
				end
			end
			if liNeededAirIC > 0 and liOverIC > 0 then
				if liNeededAirIC >= liOverIC then
					liNeededAirIC = liNeededAirIC - liOverIC
					liOverIC = 0
				else
					liOverIC = liOverIC - liNeededAirIC
					liNeededAirIC = 0
				end
			end
			if liNeededLandIC > 0 and liOverIC > 0 then
				if liNeededLandIC >= liOverIC then
					liNeededLandIC = liNeededLandIC - liOverIC
					liOverIC = 0
				else
					liOverIC = liOverIC - liNeededLandIC
					liNeededLandIC = 0
				end
			end
			if liNeededOtherIC > 0 and liOverIC > 0 then
				if liNeededOtherIC >= liOverIC then
					liNeededOtherIC = liNeededOtherIC - liOverIC
					liOverIC = 0
				else
					liOverIC = liOverIC - liNeededOtherIC
					liNeededOtherIC = 0
				end
			end			
		end
		-- End of IC Normalization
		
		
		-- Get the counts of the unit types currently being produced
		local laTempProd = ai:GetProductionSubUnitCounts()
		local laTempCurrent = ai:GetDeployedSubUnitCounts()
		--local laTempTReq = ai:GetTheatreSubUnitNeedCounts()
		
		for subUnit in CSubUnitDataBase.GetSubUnitList() do
			local nIndex = subUnit:GetIndex()
			local lsUnitType = subUnit:GetKey():GetString() 
			
			if lsUnitType == "infantry_brigade" then
				prodArrayCounts[_INFANTRY_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_INFANTRY_BRIGADE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "light_armor_brigade" then
				prodArrayCounts[_LIGHT_ARMOR_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_LIGHT_ARMOR_BRIGADE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "armor_brigade" then
				prodArrayCounts[_ARMOR_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_ARMOR_BRIGADE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "bergsjaeger_brigade" then
				prodArrayCounts[_BERGSJAEGER_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_BERGSJAEGER_BRIGADE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "cavalry_brigade" then
				prodArrayCounts[_CAVALRY_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_CAVALRY_BRIGADE_] = laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "garrison_brigade" then
				prodArrayCounts[_GARRISON_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_GARRISON_BRIGADE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "heavy_armor_brigade" then
				prodArrayCounts[_HEAVY_ARMOR_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_HEAVY_ARMOR_BRIGADE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "marine_brigade" then
				prodArrayCounts[_MARINE_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_MARINE_BRIGADE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "mechanized_brigade" then
				prodArrayCounts[_MECHANIZED_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_MECHANIZED_BRIGADE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "militia_brigade" then
				prodArrayCounts[_MILITIA_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_MILITIA_BRIGADE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "motorized_brigade" then
				prodArrayCounts[_MOTORIZED_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_MOTORIZED_BRIGADE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "paratrooper_brigade" then
				prodArrayCounts[_PARATROOPER_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_PARATROOPER_BRIGADE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "super_heavy_armor_brigade" then
				prodArrayCounts[_SUPER_HEAVY_ARMOR_BRIGADE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_SUPER_HEAVY_ARMOR_BRIGADE_] =  laTempCurrent:GetAt(nIndex)
			
			-- Start Naval Unit counts
			elseif lsUnitType == "battlecruiser" then
				prodArrayCounts[_BATTLECRUISER_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_BATTLECRUISER_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "battleship" then
				prodArrayCounts[_BATTLESHIP_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_BATTLESHIP_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "carrier" then
				prodArrayCounts[_CARRIER_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_CARRIER_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "destroyer" then
				prodArrayCounts[_DESTROYER_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_DESTROYER_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "escort_carrier" then
				prodArrayCounts[_ESCORT_CARRIER_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_ESCORT_CARRIER_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "heavy_cruiser" then
				prodArrayCounts[_HEAVY_CRUISER_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_HEAVY_CRUISER_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "light_cruiser" then
				prodArrayCounts[_LIGHT_CRUISER_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_LIGHT_CRUISER_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "nuclear_submarine" then
				prodArrayCounts[_NUCLEAR_SUBMARINE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_NUCLEAR_SUBMARINE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "submarine" then
				prodArrayCounts[_SUBMARINE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_SUBMARINE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "super_heavy_battleship" then
				prodArrayCounts[_SUPER_HEAVY_BATTLESHIP_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_SUPER_HEAVY_BATTLESHIP_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "transport_ship" then
				prodArrayCounts[_TRANSPORT_SHIP_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_TRANSPORT_SHIP_] =  laTempCurrent:GetAt(nIndex)
				
			-- Start Air Unit counts
			elseif lsUnitType == "cag" then
				prodArrayCounts[_CAG_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_CAG_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "cas" then
				prodArrayCounts[_CAS_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_CAS_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "interceptor" then
				prodArrayCounts[_INTERCEPTOR_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_INTERCEPTOR_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "multi_role" then
				prodArrayCounts[_MULTI_ROLE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_MULTI_ROLE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "naval_bomber" then
				prodArrayCounts[_NAVAL_BOMBER_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_NAVAL_BOMBER_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "strategic_bomber" then
				prodArrayCounts[_STRATEGIC_BOMBER_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_STRATEGIC_BOMBER_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "tactical_bomber" then
				prodArrayCounts[_TACTICAL_BOMBER_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_TACTICAL_BOMBER_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "transport_plane" then
				prodArrayCounts[_TRANSPORT_PLANE_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_TRANSPORT_PLANE_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "flying_bomb" then
				prodArrayCounts[_FLYING_BOMB_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_FLYING_BOMB_] =  laTempCurrent:GetAt(nIndex)
			elseif lsUnitType == "flying_rocket" then
				prodArrayCounts[_FLYING_ROCKET_] = laTempProd:GetAt(nIndex)
				currentArrayCounts[_FLYING_ROCKET_] =  laTempCurrent:GetAt(nIndex)
			end
		end		

		-- Process Land Units
		local liTotalLandUnits = 0 -- User for Special forces (it does not count support brigades
		
		-- Used to figure out Air to Land Ratio
		local liTotalLandRatio = CalculateRatio(GetUnitCount(_GARRISON_BRIGADE_, _POLICE_BRIGADE_, prodArrayCounts, currentArrayCounts), laLandToAirRatio[1])
		local liTotalAirRatio = CalculateRatio(GetUnitCount(_CAS_, _TRANSPORT_PLANE_, prodArrayCounts, currentArrayCounts), laLandToAirRatio[2])
		
		-- If the Air ratio is higher than the Land ration then move all the Air IC into Land
		if liTotalAirRatio > liTotalLandRatio then
			liNeededLandIC = liNeededLandIC + liNeededAirIC
			liNeededAirIC = 0
		end
		
		--    PERFORMANCE: only process if IC has been allocated
		--       Naval check is adding for Convoy ratio calculating.
		if liNeededLandIC > 0 or liNeededNavalIC > 0 then
			--    Array order Garrison, Infantry, Motorized, Mechanized, Armor
			local laLandUnitCount = {}
			laLandUnitCount[1] = prodArrayCounts[_GARRISON_BRIGADE_] + currentArrayCounts[_GARRISON_BRIGADE_]
			laLandUnitCount[2] = GetUnitCount(_INFANTRY_BRIGADE_, _PARATROOPER_BRIGADE_, prodArrayCounts, currentArrayCounts)
			laLandUnitCount[3] = prodArrayCounts[_MOTORIZED_BRIGADE_] + currentArrayCounts[_MOTORIZED_BRIGADE_]
			laLandUnitCount[4] = prodArrayCounts[_MECHANIZED_BRIGADE_] + currentArrayCounts[_MECHANIZED_BRIGADE_]
			laLandUnitCount[5] = GetUnitCount(_LIGHT_ARMOR_BRIGADE_, _SUPER_HEAVY_ARMOR_BRIGADE_, prodArrayCounts, currentArrayCounts)
			laLandUnitCount[6] = prodArrayCounts[_MILITIA_BRIGADE_] + currentArrayCounts[_MILITIA_BRIGADE_]
			laLandUnitCount[7] = prodArrayCounts[_CAVALRY_BRIGADE_] + currentArrayCounts[_CAVALRY_BRIGADE_]

			-- Used for Calculating Transports and Special Forces
			for i = 1, 6 do
				liTotalLandUnits = liTotalLandUnits + laLandUnitCount[i]
			end
			
			-- PERFORMANCE: Make sure you need the rest of this to run
			if liNeededLandIC > 0 then
				local laLandUnitRatio = {}
				laLandUnitRatio[1] = CalculateRatio(laLandUnitCount[1], laLandRatio[1])
				laLandUnitRatio[2] = CalculateRatio(laLandUnitCount[2], laLandRatio[2])
				laLandUnitRatio[3] = CalculateRatio(laLandUnitCount[3], laLandRatio[3])
				laLandUnitRatio[4] = CalculateRatio(laLandUnitCount[4], laLandRatio[4])
				laLandUnitRatio[5] = CalculateRatio(laLandUnitCount[5], laLandRatio[5])
				laLandUnitRatio[6] = CalculateRatio(laLandUnitCount[6], laLandRatio[6])
				laLandUnitRatio[7] = CalculateRatio(laLandUnitCount[7], laLandRatio[7])
				
				-- Multiplier used to figure out how many units of each type you need
				--   to keep the ratio
				local liMultiplier = GetMultiplier(laLandUnitRatio, laLandRatio)
				
				local laLandUnitNeed = {}
				laLandUnitNeed[1] = (laLandRatio[1] * liMultiplier) - laLandUnitCount[1]
				laLandUnitNeed[2] = (laLandRatio[2] * liMultiplier) - laLandUnitCount[2]
				laLandUnitNeed[3] = (laLandRatio[3] * liMultiplier) - laLandUnitCount[3]
				laLandUnitNeed[4] = (laLandRatio[4] * liMultiplier) - laLandUnitCount[4]
				laLandUnitNeed[5] = (laLandRatio[5] * liMultiplier) - laLandUnitCount[5]
				laLandUnitNeed[6] = (laLandRatio[6] * liMultiplier) - laLandUnitCount[6]
				laLandUnitNeed[7] = (laLandRatio[7] * liMultiplier) - laLandUnitCount[7]
				
				laUnitNeeds[_GARRISON_BRIGADE_] = laLandUnitNeed[1]
				laUnitNeeds[_INFANTRY_BRIGADE_] = laLandUnitNeed[2]
				laUnitNeeds[_MOTORIZED_BRIGADE_] = laLandUnitNeed[3]
				laUnitNeeds[_MECHANIZED_BRIGADE_] = laLandUnitNeed[4]
				
				-- Armor
				if laLandUnitNeed[5] > 0 then
					local lbLA = loTechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("light_armor_brigade"))
					local lbA = loTechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("armor_brigade"))
					local lbHA = loTechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("heavy_armor_brigade"))
					local lbSHA = loTechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("super_heavy_armor_brigade"))

					local liArmorCount = GetUnitCount(_LIGHT_ARMOR_BRIGADE_, _ARMOR_BRIGADE_, prodArrayCounts, currentArrayCounts)
					local liHeavyCount = GetUnitCount(_HEAVY_ARMOR_BRIGADE_, _SUPER_HEAVY_ARMOR_BRIGADE_, prodArrayCounts, currentArrayCounts)

					-- Helps prevent the AI from mass building Heavy Armor
					local liHeavyShiftBalancer = (liArmorCount - (liHeavyCount * 2)) * 0.01
					
					if lbLA and lbA and lbHA and lbSHA then
						-- Makes it almost impossible for the AI to build Light Armor since he has better techs
						local liShift = ((math.random(1, 10)) * 0.01) - liHeavyShiftBalancer
						laUnitNeeds[_LIGHT_ARMOR_BRIGADE_] = Utils.Round(laLandUnitNeed[5] * liShift)
						
						-- Makes it more likely that Armor will be built over heavy
						liShift = ((math.random(40, 60)) * 0.01) - liHeavyShiftBalancer
						laUnitNeeds[_ARMOR_BRIGADE_] = Utils.Round((laLandUnitNeed[5] - laUnitNeeds[_LIGHT_ARMOR_BRIGADE_]) * liShift)
						
						local liUnitsLeft = laLandUnitNeed[5] - laUnitNeeds[_ARMOR_BRIGADE_] - laUnitNeeds[_LIGHT_ARMOR_BRIGADE_]
						if liUnitsLeft > 0 then
							-- Makes it so Heavy is more than likely built over Super
							liShift = (math.random(40, 60)) * 0.01
							laUnitNeeds[_HEAVY_ARMOR_BRIGADE_] = Utils.Round(liUnitsLeft * liShift)
							laUnitNeeds[_SUPER_HEAVY_ARMOR_BRIGADE_] = Utils.Round(liUnitsLeft * (1 - liShift))
						end
					elseif lbLA and lbA and lbHA then
						-- Makes it almost impossible for the AI to build Light Armor since he has better techs
						local liShift = ((math.random(1, 10)) * 0.01) - liHeavyShiftBalancer
						laUnitNeeds[_LIGHT_ARMOR_BRIGADE_] = Utils.Round(laLandUnitNeed[5] * liShift)
						
						-- Makes it more likely that Armor will be built over heavy
						liShift = ((math.random(40, 60)) * 0.01) - liHeavyShiftBalancer
						local liUnitsLeft = laLandUnitNeed[5] - laUnitNeeds[_LIGHT_ARMOR_BRIGADE_]
						laUnitNeeds[_ARMOR_BRIGADE_] = Utils.Round(liUnitsLeft * liShift)
						laUnitNeeds[_HEAVY_ARMOR_BRIGADE_] = Utils.Round(liUnitsLeft * (1 - liShift))
					elseif lbLA and lbA then
						local liShift = (math.random(5, 20)) * 0.01
						laUnitNeeds[_LIGHT_ARMOR_BRIGADE_] = Utils.Round(laLandUnitNeed[5] * liShift)
						laUnitNeeds[_ARMOR_BRIGADE_] = Utils.Round(laLandUnitNeed[5] * (1 - liShift))				
					elseif lbLA then
						laUnitNeeds[_LIGHT_ARMOR_BRIGADE_] = laLandUnitNeed[5]
					end
				end
				
				laUnitNeeds[_MILITIA_BRIGADE_] = laLandUnitNeed[6]
				laUnitNeeds[_CAVALRY_BRIGADE_] = laLandUnitNeed[7]
				
				-- Special Forces
				-- Calculate how many Special Forces are needed
				local liTotalSFUnits = GetUnitCount(_BERGSJAEGER_BRIGADE_, _PARATROOPER_BRIGADE_, prodArrayCounts, currentArrayCounts)
				local liTotalSFNeeded = math.max(0, math.ceil((liTotalLandUnits / laSpecialForcesRatio[1]) * laSpecialForcesRatio[2]) - liTotalSFUnits)

				if liTotalSFNeeded > 0 then
					local lbMo = loTechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("bergsjaeger_brigade"))
					local lbMa = loTechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("marine_brigade"))
					local lbPa = loTechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("paratrooper_brigade"))
					
					local liMountainTotal = prodArrayCounts[_BERGSJAEGER_BRIGADE_] + currentArrayCounts[_BERGSJAEGER_BRIGADE_]
					local liMarineTotal = prodArrayCounts[_MARINE_BRIGADE_] + currentArrayCounts[_MARINE_BRIGADE_]
					local liParaTotal = prodArrayCounts[_PARATROOPER_BRIGADE_] + currentArrayCounts[_PARATROOPER_BRIGADE_]

					-- Helps prevent the AI from mass build paratroopers
					local liParaMultiplier = 3
					local liParaShiftBalancer = ((liMountainTotal + liMarineTotal) - (liParaTotal * liParaMultiplier)) * 0.01
					local liMarineShiftBalancer = (liMountainTotal - liMarineTotal) * 0.01
					
					if lbMo and lbMa and lbPa then
						-- Elastic random makes it more than likely mountain units will get build
						local liParasNeeded = ((liMountainTotal + liMarineTotal) - (liParaTotal * liParaMultiplier)) / liParaMultiplier
						liParasNeeded = math.min(liParasNeeded, liTotalSFNeeded)
					
						if liParasNeeded > liParaMultiplier then
							laUnitNeeds[_PARATROOPER_BRIGADE_] = Utils.Round(liParasNeeded)
							liTotalSFNeeded = liTotalSFNeeded - liParasNeeded
						end
						
						if liTotalSFNeeded > 0 then
							-- Elastic random makes it more than likely mountain units will get build
							local liShift = ((math.random(40, 60)) * 0.01) - liMarineShiftBalancer
							laUnitNeeds[_BERGSJAEGER_BRIGADE_] = Utils.Round(liTotalSFNeeded * liShift)
							laUnitNeeds[_MARINE_BRIGADE_] = Utils.Round(liTotalSFNeeded * (1 - liShift))
						end
					elseif lbMo and lbMa then
						-- Elastic random makes it more than likely mountain units will get build
						local liShift = ((math.random(40, 60)) * 0.01) - liMarineShiftBalancer
						laUnitNeeds[_BERGSJAEGER_BRIGADE_] = Utils.Round(liTotalSFNeeded * liShift)
						laUnitNeeds[_MARINE_BRIGADE_] = Utils.Round(liTotalSFNeeded * (1 - liShift))
					elseif lbMo and lbPa then
						-- Elastic random makes it more than likely mountain units will get build
						local liShift = ((math.random(40, 90)) * 0.01) - liParaShiftBalancer
						laUnitNeeds[_BERGSJAEGER_BRIGADE_] = Utils.Round(liTotalSFNeeded * liShift)
						laUnitNeeds[_PARATROOPER_BRIGADE_] = Utils.Round(liTotalSFNeeded * (1 - liShift))
					elseif lbMa and lbPa then
						-- Elastic random makes it more than likely marines will get build
						local liShift = ((math.random(40, 90)) * 0.01) - liParaShiftBalancer
						laUnitNeeds[_MARINE_BRIGADE_] = Utils.Round(liTotalSFNeeded * liShift)
						laUnitNeeds[_PARATROOPER_BRIGADE_] = Utils.Round(liTotalSFNeeded * (1 - liShift))
					elseif lbMo then
						laUnitNeeds[_BERGSJAEGER_BRIGADE_] = liTotalSFNeeded
					elseif lbMa then
						laUnitNeeds[_MARINE_BRIGADE_] = liTotalSFNeeded
					elseif lbPa then
						laUnitNeeds[_PARATROOPER_BRIGADE_] = liTotalSFNeeded
					end
				end	
			end
		end
		
		-- Process Air Units
		--    PERFORMANCE: only process if IC has been allocated
		if liNeededAirIC > 0 then
			--    Array order Fighter, CAS, Tactical, Naval Bomber, Strategic
			local laAirUnitCount = {}
			laAirUnitCount[1] = GetUnitCount(_INTERCEPTOR_, _ROCKET_INTERCEPTOR_, prodArrayCounts, currentArrayCounts)
			laAirUnitCount[2] = prodArrayCounts[_CAS_] + currentArrayCounts[_CAS_]
			laAirUnitCount[3] = prodArrayCounts[_TACTICAL_BOMBER_] + currentArrayCounts[_TACTICAL_BOMBER_]
			laAirUnitCount[4] = prodArrayCounts[_NAVAL_BOMBER_] + currentArrayCounts[_NAVAL_BOMBER_]
			laAirUnitCount[5] = prodArrayCounts[_STRATEGIC_BOMBER_] + currentArrayCounts[_STRATEGIC_BOMBER_]
			
			local laAirUnitRatio = {}
			laAirUnitRatio[1] = CalculateRatio(laAirUnitCount[1], laAirRatio[1])
			laAirUnitRatio[2] = CalculateRatio(laAirUnitCount[2], laAirRatio[2])
			laAirUnitRatio[3] = CalculateRatio(laAirUnitCount[3], laAirRatio[3])
			laAirUnitRatio[4] = CalculateRatio(laAirUnitCount[4], laAirRatio[4])
			laAirUnitRatio[5] = CalculateRatio(laAirUnitCount[5], laAirRatio[5])

			liMultiplier = GetMultiplier(laAirUnitRatio, laAirRatio)

			local laAirUnitNeed = {}
			laAirUnitNeed[1] = (laAirRatio[1] * liMultiplier) - laAirUnitCount[1]
			laAirUnitNeed[2] = (laAirRatio[2] * liMultiplier) - laAirUnitCount[2]
			laAirUnitNeed[3] = (laAirRatio[3] * liMultiplier) - laAirUnitCount[3]
			laAirUnitNeed[4] = (laAirRatio[4] * liMultiplier) - laAirUnitCount[4]
			laAirUnitNeed[5] = (laAirRatio[5] * liMultiplier) - laAirUnitCount[5]
			
			-- Fighters/Interceptors
			if laAirUnitNeed[1] > 0 then
				local lbIn = loTechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("interceptor"))
				local lbMf = loTechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("multi_role"))
				local lbRIn = loTechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("rocket_interceptor"))
				
				local liUnitType
			
				if lbIn and lbMf and lbRIn then
					for i = 1, laAirUnitNeed[1] do
						liUnitType = math.random(_INTERCEPTOR_, _ROCKET_INTERCEPTOR_)
						laUnitNeeds[liUnitType] = laUnitNeeds[liUnitType] + 1
					end	
				elseif lbIn and lbMf then
					for i = 1, laAirUnitNeed[1] do
						liUnitType = math.random(_INTERCEPTOR_, _MULTI_ROLE_)
						laUnitNeeds[liUnitType] = laUnitNeeds[liUnitType] + 1
					end	
				elseif lbIn then
					laUnitNeeds[_INTERCEPTOR_] = laAirUnitNeed[1]
				elseif lbMf then
					laUnitNeeds[_MULTI_ROLE_] = laAirUnitNeed[1]
				end
			end
			laUnitNeeds[_CAS_] = laAirUnitNeed[2]
			laUnitNeeds[_TACTICAL_BOMBER_] = laAirUnitNeed[3]
			laUnitNeeds[_NAVAL_BOMBER_] = laAirUnitNeed[4]
			laUnitNeeds[_STRATEGIC_BOMBER_] = laAirUnitNeed[5]
			
			-- Do we need Air Transports?
			local liTotalParas = prodArrayCounts[_PARATROOPER_BRIGADE_] + currentArrayCounts[_PARATROOPER_BRIGADE_]
			
			if liTotalParas > 0 then
				local liTotalAirTrans = prodArrayCounts[_TRANSPORT_PLANE_] + currentArrayCounts[_TRANSPORT_PLANE_]
				local liTotalAirTransNeeded = math.floor(liTotalParas / 3)
				
				if liTotalAirTransNeeded > liTotalAirTrans then
					laUnitNeeds[_TRANSPORT_PLANE_] = liTotalAirTransNeeded - liTotalAirTrans
				end
			end
			
			local loFlyingBomb = CSubUnitDataBase.GetSubUnit("flying_bomb")
			local loFlyingRocket = CSubUnitDataBase.GetSubUnit("flying_rocket")
			
			local lbFlyingBomb = loTechStatus:IsUnitAvailable(loFlyingBomb)
			local lbFlyingRocket = loTechStatus:IsUnitAvailable(loFlyingRocket)

			-- Calculate how many Flying Weapons are needed			
			if lbFlyingBomb or lbFlyingRocket then
				local liTotalAirUnits = GetUnitCount(_CAS_, _TRANSPORT_PLANE_, prodArrayCounts, currentArrayCounts)
				local liTotalFlyingWeapons = GetUnitCount(_FLYING_BOMB_, _FLYING_ROCKET_, prodArrayCounts, currentArrayCounts)
				
				local liUnitIndex = _FLYING_BOMB_
				
				if lbFlyingRocket then
					liUnitIndex = _FLYING_ROCKET_
				end
				
				laUnitNeeds[liUnitIndex] = math.max(0, math.ceil((liTotalAirUnits / laRocketRatio[1]) * laRocketRatio[2]) - liTotalFlyingWeapons)
			end
		end
			
		-- Process Naval Units
		--    PERFORMANCE: only process if IC has been allocated
		if liNeededNavalIC > 0 then
			--    Array order Destroyers, Submarines, Cruisers, Capital, Escort Carrier, Carrier, Transport
			local laNavalUnitCount = {}
			laNavalUnitCount[1] = prodArrayCounts[_DESTROYER_] + currentArrayCounts[_DESTROYER_]
			laNavalUnitCount[2] = GetUnitCount(_SUBMARINE_, _NUCLEAR_SUBMARINE_, prodArrayCounts, currentArrayCounts)
			laNavalUnitCount[3] = GetUnitCount(_LIGHT_CRUISER_, _HEAVY_CRUISER_, prodArrayCounts, currentArrayCounts)
			laNavalUnitCount[4] = GetUnitCount(_BATTLECRUISER_, _SUPER_HEAVY_BATTLESHIP_, prodArrayCounts, currentArrayCounts)
			laNavalUnitCount[5] = prodArrayCounts[_ESCORT_CARRIER_] + currentArrayCounts[_ESCORT_CARRIER_]
			laNavalUnitCount[6] = prodArrayCounts[_CARRIER_] + currentArrayCounts[_CARRIER_]
			
			local laNavalUnitRatio = {}
			laNavalUnitRatio[1] = CalculateRatio(laNavalUnitCount[1], laNavalRatio[1])
			laNavalUnitRatio[2] = CalculateRatio(laNavalUnitCount[2], laNavalRatio[2])
			laNavalUnitRatio[3] = CalculateRatio(laNavalUnitCount[3], laNavalRatio[3])
			laNavalUnitRatio[4] = CalculateRatio(laNavalUnitCount[4], laNavalRatio[4])
			laNavalUnitRatio[5] = CalculateRatio(laNavalUnitCount[5], laNavalRatio[5])
			laNavalUnitRatio[6] = CalculateRatio(laNavalUnitCount[6], laNavalRatio[6])
			
			liMultiplier = GetMultiplier(laNavalUnitRatio, laNavalRatio)

			local laNavalUnitNeed = {}
			laNavalUnitNeed[1] = (laNavalRatio[1] * liMultiplier) - laNavalUnitCount[1]
			laNavalUnitNeed[2] = (laNavalRatio[2] * liMultiplier) - laNavalUnitCount[2]
			laNavalUnitNeed[3] = (laNavalRatio[3] * liMultiplier) - laNavalUnitCount[3]
			laNavalUnitNeed[4] = (laNavalRatio[4] * liMultiplier) - laNavalUnitCount[4]
			laNavalUnitNeed[5] = (laNavalRatio[5] * liMultiplier) - laNavalUnitCount[5]
			laNavalUnitNeed[6] = (laNavalRatio[6] * liMultiplier) - laNavalUnitCount[6]
			
			laUnitNeeds[_DESTROYER_] = laNavalUnitNeed[1]
			-- Submarine, if you can do nuke shift everthing into Nuclear
			if laNavalUnitNeed[2] > 0 then
				if loTechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("nuclear_submarine")) then
					laUnitNeeds[_NUCLEAR_SUBMARINE_] = laNavalUnitNeed[2]
				else
					laUnitNeeds[_SUBMARINE_] = laNavalUnitNeed[2]
				end			
			end
			-- Cruisers Elastic Random for Light and Heavy but leaning to Light
			if laNavalUnitNeed[3] > 0 then
				local lbCL = loTechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("light_cruiser"))
				local lbCH = loTechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("heavy_cruiser"))
			
				if lbCL and lbCH then
					local liShift = (math.random(30, 80)) * 0.01
					laUnitNeeds[_LIGHT_CRUISER_] = Utils.Round(laNavalUnitNeed[3] * liShift)
					laUnitNeeds[_HEAVY_CRUISER_] = Utils.Round(laNavalUnitNeed[3] * (1 - liShift))
				elseif lbCL then
					laUnitNeeds[_LIGHT_CRUISER_] = laNavalUnitNeed[3]
				elseif lbCH then
					laUnitNeeds[_HEAVY_CRUISER_] = laNavalUnitNeed[3]
				end
			end
			-- Capital ships, process one a time if need be
			if laNavalUnitNeed[4] > 0 then
				local lbBC = loTechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("battlecruiser"))
				local lbBB = loTechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("battleship"))
				local lbSBB = loTechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit("super_heavy_battleship"))
				local liUnitType
			
				if lbBC and lbBB and lbSBB then
					for i = 1, laNavalUnitNeed[4] do
						liUnitType = math.random(_BATTLECRUISER_, _SUPER_HEAVY_BATTLESHIP_)
						laUnitNeeds[liUnitType] = laUnitNeeds[liUnitType] + 1
					end	
				elseif lbBC and lbBB then
					for i = 1, Utils.Round(laNavalUnitNeed[4]) do
						liUnitType = math.random(_BATTLECRUISER_, _BATTLESHIP_)
						laUnitNeeds[liUnitType] = laUnitNeeds[liUnitType] + 1
					end	
				elseif lbBB and lbSBB then
					for i = 1, laNavalUnitNeed[4] do
						liUnitType = math.random(_BATTLESHIP_, _SUPER_HEAVY_BATTLESHIP_)
						laUnitNeeds[liUnitType] = laUnitNeeds[liUnitType] + 1
					end	
				elseif lbBC then
					laUnitNeeds[_BATTLECRUISER_] = laNavalUnitNeed[4]
				elseif lbBB then
					laUnitNeeds[_BATTLESHIP_] = laNavalUnitNeed[4]
				elseif lbSBB then
					laUnitNeeds[_SUPER_HEAVY_BATTLESHIP_] = laNavalUnitNeed[4]
				end
			end
			laUnitNeeds[_ESCORT_CARRIER_] = laNavalUnitNeed[5]
			laUnitNeeds[_CARRIER_] = laNavalUnitNeed[6]
			
			
			-- Calculate how many Transports are needed
			local liTotalTransports = (prodArrayCounts[_TRANSPORT_SHIP_] + currentArrayCounts[_TRANSPORT_SHIP_])
			local liTotalTransportsNeeded = math.ceil((liTotalLandUnits / laTransportLandRatio[1]) * laTransportLandRatio[2]) - liTotalTransports
			laUnitNeeds[_TRANSPORT_SHIP_] = math.max(0, liTotalTransportsNeeded)
			
			-- Figure out if we need any CAGs
			local liCAGsNeeded = prodArrayCounts[_ESCORT_CARRIER_] + currentArrayCounts[_ESCORT_CARRIER_]
			liCAGsNeeded = liCAGsNeeded +((prodArrayCounts[_CARRIER_] + currentArrayCounts[_CARRIER_]) * 2)
			local liCAGsCount = prodArrayCounts[_CAG_] + currentArrayCounts[_CAG_]
			
			if liCAGsNeeded > liCAGsCount then
				laUnitNeeds[_CAG_] = liCAGsNeeded - liCAGsCount
			end
		end
		
		-- Used in each area to calculate local costs
		local liNewICCount
		
		-- Build Land Units
		if liNeededLandIC > 0 then
			liNewICCount = BuildLandUnits(liNeededLandIC, minister, false)
			ic = ic - (liNeededLandIC - liNewICCount)
			liNeededLandIC = liNewICCount
		end
		
		-- Build Air Units
		if liNeededAirIC > 0 then
			liNewICCount = BuildAirUnits(liNeededAirIC, minister, false)
			ic = ic - (liNeededAirIC - liNewICCount)
			liNeededAirIC = liNewICCount
		end
		
		-- Build Naval Units
		if liNeededNavalIC > 0 then
			liNewICCount = BuildNavalUnits(liNeededNavalIC, minister, false)
			ic = ic - (liNeededNavalIC - liNewICCount)
			liNeededNavalIC = liNewICCount
		end

		-- Build Other (Convoys and Buildings)
		if liNeededOtherIC > 0 then
			liNewICCount = BuildOtherUnits(liNeededOtherIC, ai, minister, ministerTag, ministerCountry, false)
			ic = ic - (liNeededOtherIC - liNewICCount)
			liNeededOtherIC = liNewICCount
		end
		
		-- Now if we have IC still left try and find someplace to use it
		if ic > 1 then
			if liNeededOtherIC > liNeededAirIC and liNeededOtherIC > liNeededNavalIC and liNeededOtherIC > liNeededLandIC then			
				ic = BuildOtherUnits(ic, ai, minister, ministerTag, ministerCountry, true)
			elseif liNeededNavalIC > liNeededAirIC and liNeededNavalIC > liNeededLandIC and liNeededNavalIC > liNeededOtherIC then			
				ic = BuildNavalUnits(ic, minister, true)
			elseif liNeededAirIC > liNeededLandIC and liNeededAirIC > liNeededNavalIC and liNeededAirIC > liNeededOtherIC then
				ic = BuildAirUnits(ic, minister, true)
			elseif liNeededLandIC > liNeededAirIC and liNeededLandIC > liNeededNavalIC and liNeededLandIC > liNeededOtherIC then
				ic = BuildLandUnits(ic, minister, true)
			end
			
			-- Last chance to use the IC
			if ic > 1 then
				ic = BuildLandUnits(ic, minister, true)
				ic = BuildAirUnits(ic, minister, true)
				ic = BuildNavalUnits(ic, minister, true)
				ic = BuildOtherUnits(ic, ai, minister, ministerTag, ministerCountry, true)
			end
		end
	else
		-- AI did not have enough manpower to build any units so just do buildings and Convoys
		ic = ConstructConvoys(ai, minister, ministerTag, ministerCountry, ic )
		ic = ConstructBuildings(ai, minister, ministerTag, ministerCountry, ic, true)
	end
	
	if math.mod( CCurrentGameState.GetAIRand(), 7) == 0 then
		minister:PrioritizeBuildQueue()
	end
end

-- #######################
-- Helper Build Methods
-- #######################
function BuildLandUnits(ic, minister, vbGoOver)
	-- Setup Attachment Brigade arrays
	local ministerCountry = minister:GetCountry()
	local GarrisonUnitArray = Utils.BuildGarrisonUnitArray(ministerCountry)
	local LegUnitArray = Utils.BuildLegUnitArray(ministerCountry)
	local MotorizedUnitArray = Utils.BuildMotorizedUnitArray(ministerCountry)
	local ArmorUnitArray = Utils.BuildArmorUnitArray(ministerCountry)

	-- Build Special Forces Units
	ic = BuildUnit(ic, minister, _BERGSJAEGER_BRIGADE_, 4, "bergsjaeger_brigade", 3, nil, 0, "Build_Mountain", vbGoOver)
	ic = BuildUnit(ic, minister, _PARATROOPER_BRIGADE_, 3, "paratrooper_brigade", 3, nil, 0, "Build_Paratrooper", vbGoOver)
	ic = BuildUnit(ic, minister, _MARINE_BRIGADE_, 3, "marine_brigade", 3, nil, 1, "Build_Marine", vbGoOver)

	ic = BuildUnit(ic, minister, _SUPER_HEAVY_ARMOR_BRIGADE_, 2, "super_heavy_armor_brigade", 2, ArmorUnitArray, 1, "Build_HeavyArmor", vbGoOver)
	ic = BuildUnit(ic, minister, _HEAVY_ARMOR_BRIGADE_, 2, "heavy_armor_brigade", 2, ArmorUnitArray, 1, "Build_HeavyArmor", vbGoOver)
	ic = BuildUnit(ic, minister, _ARMOR_BRIGADE_, 2, "armor_brigade", 2, ArmorUnitArray, 1, "Build_Armor", vbGoOver)
	ic = BuildUnit(ic, minister, _LIGHT_ARMOR_BRIGADE_, 2, "light_armor_brigade", 2, ArmorUnitArray, 1, "Build_LightArmor", vbGoOver)
	ic = BuildUnit(ic, minister, _MECHANIZED_BRIGADE_, 2, "mechanized_brigade", 2, MotorizedUnitArray, 1, "Build_Mechanized", vbGoOver)
	ic = BuildUnit(ic, minister, _MOTORIZED_BRIGADE_, 2, "motorized_brigade", 3, MotorizedUnitArray, 1, "Build_Motorized", vbGoOver)
	ic = BuildUnit(ic, minister, _CAVALRY_BRIGADE_, 2, "cavalry_brigade", 2, nil, 0, "Build_Cavalry", vbGoOver)
	
	if math.random(100) > 50 then
		ic = BuildUnit(ic, minister, _GARRISON_BRIGADE_, 4, "garrison_brigade", 2, GarrisonUnitArray, 1, "Build_Garrison", vbGoOver)
	else
		ic = BuildUnit(ic, minister, _GARRISON_BRIGADE_, 4, "garrison_brigade", 2, LegUnitArray, 1, "Build_Garrison", vbGoOver)
	end

	-- Handles Superior Firepower and give some variation to infantry division sizes
	if table.getn(LegUnitArray) > 0 then
		local loTech = CTechnologyDataBase.GetTechnology("superior_firepower")
		local liLevel = minister:GetCountry():GetTechnologyStatus():GetLevel(loTech)

		if liLevel > 0 then
			-- 3 infantry and 2 Support
			ic = BuildUnit(ic, minister, _INFANTRY_BRIGADE_, 4, "infantry_brigade", 3, LegUnitArray, 2, "Build_Infantry", vbGoOver)
		else
			-- 2 infantry and 2 Support
			ic = BuildUnit(ic, minister, _INFANTRY_BRIGADE_, 4, "infantry_brigade", 2, LegUnitArray, 2, "Build_Infantry", vbGoOver)
		end
	else
		-- 3 infantry and 0 Support
		ic = BuildUnit(ic, minister, _INFANTRY_BRIGADE_, 4, "infantry_brigade", 3, LegUnitArray, 1, "Build_Infantry", vbGoOver)
	end
	
	ic = BuildUnit(ic, minister, _MILITIA_BRIGADE_, 4, "militia_brigade", 3, LegUnitArray, 1, "Build_Militia", vbGoOver)
	
	return ic
end

function BuildAirUnits(ic, minister, vbGoOver)
	ic = BuildUnit(ic, minister, _TRANSPORT_PLANE_, 4, "transport_plane", 1, nil, 0, "Build_TransportPlane", vbGoOver)
	ic = BuildUnit(ic, minister, _STRATEGIC_BOMBER_, 4, "strategic_bomber", 1, nil, 0, "Build_StrategicBomber", vbGoOver)
	ic = BuildUnit(ic, minister, _TACTICAL_BOMBER_, 4, "tactical_bomber", 1, nil, 0, "Build_TacBomber", vbGoOver)
	ic = BuildUnit(ic, minister, _NAVAL_BOMBER_, 4, "naval_bomber", 1, nil, 0, "Build_NavBomber", vbGoOver)
	ic = BuildUnit(ic, minister, _INTERCEPTOR_, 4, "interceptor", 1, nil, 0, "Build_Interceptor", vbGoOver)
	ic = BuildUnit(ic, minister, _CAS_, 4, "cas", 1, nil, 0, "Build_CAS", vbGoOver)
	ic = BuildUnit(ic, minister, _MULTI_ROLE_, 4, "multi_role", 1, nil, 0, "Build_MultiRole", vbGoOver)
	ic = BuildUnit(ic, minister, _FLYING_BOMB_, 4, "flying_bomb", 1, nil, 0, "Build_FlyingBomb", vbGoOver)
	ic = BuildUnit(ic, minister, _FLYING_ROCKET_, 4, "flying_rocket", 1, nil, 0, "Build_FlyingRocket", vbGoOver)
	
	return ic
end

function BuildNavalUnits(ic, minister, vbGoOver)
	-- Alwasy build Transports and CAGs first
	ic = BuildUnit(ic, minister, _TRANSPORT_SHIP_, 3, "transport_ship", 1, nil, 0, "Build_Transport", vbGoOver)
	ic = BuildUnit(ic, minister, _CAG_, 4, "cag", 1, nil, 0, "Build_CAG", vbGoOver)

	ic = BuildUnit(ic, minister, _CARRIER_, 1, "carrier", 1, nil, 0, "Build_Carrier", vbGoOver)
	ic = BuildUnit(ic, minister, _SUPER_HEAVY_BATTLESHIP_, 1, "super_heavy_battleship", 1, nil, 0, "Build_SuperBattleship", vbGoOver)
	ic = BuildUnit(ic, minister, _BATTLESHIP_, 1, "battleship", 1, nil, 0, "Build_Battleship", vbGoOver)
	ic = BuildUnit(ic, minister, _BATTLECRUISER_, 1, "battlecruiser", 1, nil, 0, "Build_Battlecruiser", vbGoOver)
	ic = BuildUnit(ic, minister, _ESCORT_CARRIER_, 2, "escort_carrier", 1, nil, 0, "Build_EscortCarrier", vbGoOver)
	ic = BuildUnit(ic, minister, _HEAVY_CRUISER_, 2, "heavy_cruiser", 1, nil, 0, "Build_HeavyCruiser", vbGoOver)
	ic = BuildUnit(ic, minister, _LIGHT_CRUISER_, 2, "light_cruiser", 1, nil, 0, "Build_LightCruiser", vbGoOver)
	ic = BuildUnit(ic, minister, _DESTROYER_, 3, "destroyer", 1, nil, 0, "Build_Destroyer", vbGoOver)
	ic = BuildUnit(ic, minister, _NUCLEAR_SUBMARINE_, 2, "nuclear_submarine", 1, nil, 0, "Build_NuclearSubmarine", vbGoOver)
	ic = BuildUnit(ic, minister, _SUBMARINE_, 2, "submarine", 1, nil, 0, "Build_Submarine", vbGoOver)
	
	return ic
end

function BuildOtherUnits(ic, ai, minister, ministerTag, ministerCountry, vbGoOver)
	ic = ConstructConvoys(ai, minister, ministerTag, ministerCountry, ic )
	ic = ConstructBuildings(ai, minister, ministerTag, ministerCountry, ic, vbGoOver )

	return ic
end

function BuildUnit(ic, minister, viUnitIndex, viMaxSerial, vsType, viDivSize, voAttachUnitArray, viBrigadeCount, vsMethodOveride, vbGoOver)
	if ic > 1 and laUnitNeeds[viUnitIndex] > 0 then 

		-- Check to see if the Country AI file has an overide
		if Utils.HasCountryAIFunction(minister:GetCountryTag(), vsMethodOveride) then
			ic, laUnitNeeds[viUnitIndex] = Utils.CallCountryAI(minister:GetCountryTag(), vsMethodOveride, ic, minister, laUnitNeeds[viUnitIndex], vbGoOver)				
		elseif laUnitNeeds[viUnitIndex] >= viDivSize then
			if voAttachUnitArray == nil then
				ic, laUnitNeeds[viUnitIndex] = Utils.CreateDivision_nominor(minister, vsType, viMaxSerial, ic, laUnitNeeds[viUnitIndex], viDivSize, vbGoOver)
			else
				ic, laUnitNeeds[viUnitIndex] = Utils.CreateDivision(minister, vsType, viMaxSerial, ic, laUnitNeeds[viUnitIndex], viDivSize, voAttachUnitArray, viBrigadeCount, vbGoOver)
			end
		end
	end
	
	return ic
end
-- Determines how many units are there within the given range
function GetUnitCount(viStart, viEnd, vaProdCounts, vaCurrentCounts)
	local UnitCount = 0
	-- math.max is used cause its possible an item can be nil
	while viStart <= viEnd do
		UnitCount = UnitCount + vaProdCounts[viStart] + vaCurrentCounts[viStart]
		viStart = viStart + 1
	end
	return UnitCount
end
-- Converts the Unit ratio to a % based number. If there
--   are 0 units but a Ratio exists then it will set it to 1.
 function CalculateRatio(viUnitCount, viUnitRatio)
	local rValue
	
	if viUnitRatio == 0 then
		rValue = 0
	elseif viUnitCount == 0 then
		rValue = 1
	else
		rValue = viUnitCount / viUnitRatio
	end
	
	return rValue
end
-- Returns the correctly build ratio array
function GetBuildRatio(minister, ministerTag, vbNaval, vsType)
	if Utils.HasCountryAIFunction(ministerTag, vsType) then
		return Utils.CallCountryAI(ministerTag, vsType, minister)
	else
		if vbNaval then
			return DefaultProdMix[vsType](minister)
		else
			return DefaultProdLand[vsType](minister)	
		end					
	end		
end
function GetMultiplier(vaUnitMultiplier, vaRatio)
	local i = 2
	local liMultiplier = vaUnitMultiplier[1]
	local liAddToMultiplier = 2
	
	while i <= table.getn(vaUnitMultiplier) do
		if vaRatio[i] > 0 then
			if liAddToMultiplier > 0 and liMultiplier > 0 then
				if math.max((liMultiplier - vaUnitMultiplier[i]), (vaUnitMultiplier[i] - liMultiplier)) > liAddToMultiplier then
					liAddToMultiplier = 0
				end
			end
			
			if liMultiplier < vaUnitMultiplier[i] then
				liMultiplier = vaUnitMultiplier[i]
			end
		end
		
		i = i + 1
	end
	
	return liMultiplier + liAddToMultiplier
end

-- Goes through the ratios and sets them to 0 if the country can't build any of those units
function VerifyRatio(voTechStatus, vaRatio, vaType)
	for i = 1, table.getn(vaRatio) do
		if vaRatio[i] > 0 then
			local lbCanBuild = false
			local laUnits = Utils.Split(vaType[i], '|')
			
			for x = 1, table.getn(laUnits) do
				if voTechStatus:IsUnitAvailable(CSubUnitDataBase.GetSubUnit(laUnits[x])) then
					lbCanBuild = true
					break
				end
			end
			
			if not(lbCanBuild) then
				vaRatio[i] = 0
			end
		end
	end
	
	return vaRatio
end


-- #######################
-- End of Helper Build Methods
-- #######################

-- #######################
-- Building Construction
-- #######################
function ConstructBuildings(ai, minister, ministerTag, ministerCountry, ic, vbGoOver)
	-- Buildings
	if ic > 0.2 then
		local lbProvinceCheck = false
		local laCorePrv = {}
		local liRocketCap = 1
		local liReactorCap = 2
		local loTechStatus = ministerCountry:GetTechnologyStatus()

		-- Set Province Checker
		-- PERFORMANCE: Only 20% chance the AI will look at his home provinces unless he is short on manpower then 50%
		if ministerCountry:HasExtraManpowerLeft() then
			if (math.random(100) > 80) then
				lbProvinceCheck = true
				laCorePrv = CoreProvincesLoop(ministerCountry, loTechStatus, liRocketCap, liReactorCap)
			end
		else
			if (math.random(100) > 50) then
				lbProvinceCheck = true
				laCorePrv = CoreProvincesLoop(ministerCountry, loTechStatus, liRocketCap, liReactorCap)
			end
		end
		
		-- Produce buildings until your out of IC that has been allocated
		--   Never have more than 1 rocket sites
		local lbExit = false
		local liLoopCheck = 0
		
		while not(lbExit) do
			local coastal_fort = CBuildingDataBase.GetBuilding("coastal_fort" )
			local land_fort = CBuildingDataBase.GetBuilding( "land_fort" )
			local anti_air = CBuildingDataBase.GetBuilding("anti_air" )
			local industry = CBuildingDataBase.GetBuilding("industry" )
			local radar_station = CBuildingDataBase.GetBuilding("radar_station" )
			local nuclear_reactor = CBuildingDataBase.GetBuilding("nuclear_reactor" )
			local rocket_test = CBuildingDataBase.GetBuilding("rocket_test" )
			local infra = CBuildingDataBase.GetBuilding("infra")
			local air_base = CBuildingDataBase.GetBuilding("air_base")

			-- Nuclear Reactors stations
			if ic > 0.2 and loTechStatus:IsBuildingAvailable(nuclear_reactor) and lbProvinceCheck then
				if Utils.HasCountryAIFunction(ministerTag, "Build_NuclearReactor") then
					ic = Utils.CallCountryAI(ministerTag, "Build_NuclearReactor", ic, minister, vbGoOver)				
				else
					if laCorePrv[2] < liReactorCap then
						local nuclear_reactorCost = ministerCountry:GetBuildCost(nuclear_reactor):Get()
						
						if (ic - nuclear_reactorCost) >= 0 or vbGoOver then
							if table.getn(laCorePrv[5]) > 0 and not(laCorePrv[2] >= liReactorCap) then
								local constructCommand = CConstructBuildingCommand(ministerTag, nuclear_reactor, laCorePrv[5][math.random(table.getn(laCorePrv[5]))], 1 )

								if constructCommand:IsValid() then
									ai:Post( constructCommand )
									ic = ic - nuclear_reactorCost -- Upodate IC total	
								end
							end
						end
					end
				end
			end

			-- Rocket Test Site stations
			if ic > 0.2 and loTechStatus:IsBuildingAvailable(rocket_test) and lbProvinceCheck and not(lbBuiltRocketSite) then
				if Utils.HasCountryAIFunction(ministerTag, "Build_RocketTest") then
					ic = Utils.CallCountryAI(ministerTag, "Build_RocketTest", ic, minister, vbGoOver)				
				else
					if laCorePrv[1] < liRocketCap then
						local rocket_testCost = ministerCountry:GetBuildCost(rocket_test):Get()
						
						if (ic - rocket_testCost) >= 0 or vbGoOver then
							if table.getn(laCorePrv[5]) > 0 and not(laCorePrv[1] >= liRocketCap) then
								local constructCommand = CConstructBuildingCommand(ministerTag, rocket_test, laCorePrv[5][math.random(table.getn(laCorePrv[5]))], 1 )

								if constructCommand:IsValid() then
									ai:Post( constructCommand )
									ic = ic - rocket_testCost -- Upodate IC total	
									lbBuiltRocketSite = true
								end
							end
						end
					end
				end
			end
			
			-- Industry
			if ic > 0.2 and loTechStatus:IsBuildingAvailable(industry) and lbProvinceCheck then
				if Utils.HasCountryAIFunction(ministerTag, "Build_Industry") then
					ic = Utils.CallCountryAI(ministerTag, "Build_Industry", ic, minister, vbGoOver)				
				else
					local industryCost = ministerCountry:GetBuildCost(industry):Get()
					
					if (ic - industryCost) >= 0 or vbGoOver then
						if table.getn(laCorePrv[6]) > 0 then
							local constructCommand = CConstructBuildingCommand(ministerTag, industry, laCorePrv[6][math.random(table.getn(laCorePrv[6]))], 1 )

							if constructCommand:IsValid() then
								ai:Post( constructCommand )
								ic = ic - industryCost -- Upodate IC total	
							end
						end
					end
				end
			end						
			
			-- Build Forts
			--   Since there is no practical way to teach the AI to build forts just allow hooks for country specific stuff
			if ic > 0.2 and loTechStatus:IsBuildingAvailable(land_fort) then
				if Utils.HasCountryAIFunction(ministerTag, "Build_Fort") then
					ic = Utils.CallCountryAI(ministerTag, "Build_Fort", ic, minister, vbGoOver)				
				end
			end
			
			-- Build Coastal Forts
			if ic > 0.2 and loTechStatus:IsBuildingAvailable(coastal_fort) then
				if Utils.HasCountryAIFunction(ministerTag, "Build_CoastalFort") then
					ic = Utils.CallCountryAI(ministerTag, "Build_CoastalFort", ic, minister, vbGoOver)				
				else
					-- Get Costal Fort information
					local coastal_fortCost = ministerCountry:GetBuildCost(coastal_fort):Get()
					
					--Make sure you wont go into the negative (Performance helper)
					if (ic - coastal_fortCost) >= 0 or vbGoOver then
						for navalBaseProvince in ministerCountry:GetNavalBases() do
							if tostring(navalBaseProvince:GetOwner()) == tostring(ministerTag) then
								local provinceBuilding = navalBaseProvince:GetBuilding(coastal_fort)
								
								-- Never put more than 2 coastal forts in a hex
								--    and make sure one is not being built already
								if provinceBuilding:GetMax():Get() < 2 and navalBaseProvince:GetCurrentConstructionLevel(coastal_fort) == 0 then
									-- Make sure the hex does not have a fort already (Example: Konigsberg for Germany)
									if not navalBaseProvince:HasBuilding(land_fort) then
										if ministerCountry:IsBuildingAllowed(coastal_fort, navalBaseProvince) then
											local constructCommand = CConstructBuildingCommand( ministerTag, coastal_fort, navalBaseProvince:GetProvinceID(), 1 )

											if constructCommand:IsValid() then
												ai:Post( constructCommand )
												ic = ic - coastal_fortCost -- Upodate IC total
												break 
											end
										end
									end
								end
							end
						end
					end
				end
			end
			
			-- Build Anti Air
			if ic > 0.2 and loTechStatus:IsBuildingAvailable(anti_air) then
				if Utils.HasCountryAIFunction(ministerTag, "Build_AntiAir") then
					ic = Utils.CallCountryAI(ministerTag, "Build_AntiAir", ic, minister, vbGoOver)				
				else
					local industryCost = ministerCountry:GetBuildCost(industry):Get()
					local anti_airCost = ministerCountry:GetBuildCost(anti_air):Get()

					if (ic - anti_airCost) >= 0 or vbGoOver then
						local totalbuilt = 0
						
						for provinceId in ministerCountry:GetOwnedProvinces() do
							local province = CCurrentGameState.GetProvince(provinceId)
							local provinceBuilding = province:GetBuilding(anti_air)

							-- First make sure the province has Industry (performance reasons done first)
							if province:HasBuilding(industry) then
								-- Check to see if it has less than 5 AA and nothing is being constructed.
								--    Also make sure its not on the front. If everythign is good then go ahead and build some
								if provinceBuilding:GetMax():Get() < 5 and province:GetCurrentConstructionLevel(anti_air) == 0 and not province:IsFrontProvince(false) then
									local constructCommand = CConstructBuildingCommand(ministerTag, anti_air, provinceId, 1 )

									if constructCommand:IsValid() then
										ai:Post( constructCommand )
										totalbuilt = totalbuilt + 1
										ic = ic - anti_airCost -- Upodate IC total	

										-- Have two building max
										--   or Do not make the second pass your at max ic
										if totalbuilt >= 2 or (ic - anti_airCost) <= 0 then
											break 
										end
									end
								end
							end
						end
					end
				end
			end
			
			-- Radar stations
			if ic > 0.2 and loTechStatus:IsBuildingAvailable(radar_station) then
				if Utils.HasCountryAIFunction(ministerTag, "Build_Radar") then
					ic = Utils.CallCountryAI(ministerTag, "Build_Radar", ic, minister, vbGoOver)				
				else
					local radar_stationCost = ministerCountry:GetBuildCost(radar_station):Get()
					
					if (ic - radar_stationCost) >= 0 or vbGoOver then
						for province in ministerCountry:GetAirBases() do
							-- Check to make sure the province has factories
							-- Do this check first before any others (performance reasons)
							if province:HasBuilding(industry) and tostring(province:GetOwner()) == tostring(ministerTag) then
								local provinceBuilding = province:GetBuilding(radar_station)
								
								-- Make sure it is not a front province and that the province does not have 2 or more already.
								if provinceBuilding:GetMax():Get() < 2 and not province:IsFrontProvince(false) then
									if ministerCountry:IsBuildingAllowed(radar_station, province) then
										if not (province:GetCurrentConstructionLevel(radar_station) > 0) then
											local constructCommand = CConstructBuildingCommand(ministerTag, radar_station, province:GetProvinceID(), 1)

											if constructCommand:IsValid() then
												ai:Post( constructCommand )
												ic = ic - radar_stationCost -- Upodate IC total	
												break 
											end
										end
									end
								end
							end
						end
					end
				end
			end

			-- Build Airfields
			--   Since there is no practical way to teach the AI to build forts just allow hooks for country specific stuff
			if ic > 0.2 and loTechStatus:IsBuildingAvailable(air_base) then
				if Utils.HasCountryAIFunction(ministerTag, "Build_AirBase") then
					ic = Utils.CallCountryAI(ministerTag, "Build_AirBase", ic, minister, vbGoOver)
					
				-- This country has no airfields so try and build one in its capital
				elseif ministerCountry:GetNumOfAirfields() == 0 then
					ic = Support.Build_AirBase(ic, minister, ministerCountry:GetActingCapitalLocation():GetProvinceID(), 1, vbGoOver) -- Cooktown
				end
			end
			
			-- Infrastructure
			if ic > 0.2 and loTechStatus:IsBuildingAvailable(infra) and lbProvinceCheck then
				if Utils.HasCountryAIFunction(ministerTag, "Build_Infrastructure") then
					ic = Utils.CallCountryAI(ministerTag, "Build_Infrastructure", ic, minister, vbGoOver)				
				else
					local infraCost = ministerCountry:GetBuildCost(infra):Get()
					
					if (ic - infraCost) >= 0 or vbGoOver then
						local liRandomIndex
						
						-- Limit it to three provinces at a time
						for i = 1, 3 do
							if table.getn(laCorePrv[3]) > 0 then
								liRandomIndex = math.random(table.getn(laCorePrv[3]))
								local constructCommand = CConstructBuildingCommand(ministerTag, infra, laCorePrv[3][liRandomIndex], 1 )

								if constructCommand:IsValid() then
									if (ic - infraCost) >= 0 or vbGoOver then
										ai:Post( constructCommand )
										ic = ic - infraCost -- Upodate IC total	
										table.remove(laCorePrv[3], liRandomIndex)
									else
										break
									end
								end
							elseif table.getn(laCorePrv[4]) > 0 then
								liRandomIndex = math.random(table.getn(laCorePrv[4]))
								local constructCommand = CConstructBuildingCommand(ministerTag, infra, laCorePrv[4][liRandomIndex], 1 )

								if constructCommand:IsValid() then
									if (ic - infraCost) >= 0 or vbGoOver then
										ai:Post( constructCommand )
										ic = ic - infraCost -- Upodate IC total	
										table.remove(laCorePrv[4], liRandomIndex)
									else
										break
									end
								end
							end
							
							-- If there is no IC left do not loop another time
							if ic <= 0.2 then
								break
							end
						end
					end
				end
			end	
			
			-- Loop Check Exit after 4 passes means we cant build any buildings
			if ic <= 1 or liLoopCheck >= 4 then
				lbExit = true
			else
				liLoopCheck = liLoopCheck + 1
			end
		end
	end
	
	return ic
end

function CoreProvincesLoop(ministerCountry, voTechStatus, viRocketCap, viReactorCap)
	local liExpenseFactor = 0
	local liHomeFactor = 0
	local lbBuildIndustry = false
	local laCorePrv = {}
	
	local loEnergy = CResourceValues()
	local loMetal = CResourceValues()
	local loRare = CResourceValues()
	
	loEnergy:GetResourceValues( ministerCountry, CGoodsPool._ENERGY_ )
	loMetal:GetResourceValues( ministerCountry, CGoodsPool._METAL_ )
	loRare:GetResourceValues( ministerCountry, CGoodsPool._RARE_MATERIALS_ )
	
	liExpenseFactor = loEnergy.vDailyExpense * 0.5
	liExpenseFactor = liExpenseFactor + loMetal.vDailyExpense
	liExpenseFactor = liExpenseFactor + (loRare.vDailyExpense * 2)
	
	liHomeFactor = Utils.CalculateHomeProduced(loEnergy) * 0.5
	liHomeFactor = liHomeFactor + Utils.CalculateHomeProduced(loMetal)
	liHomeFactor = liHomeFactor + (Utils.CalculateHomeProduced(loRare) * 2)
	
	-- We produce more than what we use so build more industry
	if liHomeFactor > liExpenseFactor then
		lbBuildIndustry = true
	end
	
	local nuclear_reactor = CBuildingDataBase.GetBuilding("nuclear_reactor" )
	local rocket_test = CBuildingDataBase.GetBuilding("rocket_test" )
	local infra = CBuildingDataBase.GetBuilding("infra" )
	local industry = CBuildingDataBase.GetBuilding("industry" )

	-- The GetTotalCoreBuildingLevels counts on map and in the production que together
	local liRocketSiteCount = ministerCountry:GetTotalCoreBuildingLevels(rocket_test:GetIndex()):Get()
	local liReactorSiteCount = ministerCountry:GetTotalCoreBuildingLevels(nuclear_reactor:GetIndex()):Get()
	local laCorePrvLowInfra69 = {}
	local laCorePrvLowInfra99 = {}
	local laCorePrvIndustry = {}
	local laCorePrvBuildIndustry = {}

	for provinceId in ministerCountry:GetCoreProvinces() do
		local province = CCurrentGameState.GetProvince(provinceId)
		local provinceBuilding = province:GetBuilding(infra)
		local isFrontProvince = province:IsFrontProvince(false)
		
		-- Infrastructure
		local liConstructionLevel = province:GetCurrentConstructionLevel(infra)
		local liBuildingSize = provinceBuilding:GetMax():Get()
		
		if liBuildingSize < 7 and not(liConstructionLevel > 0) and not(isFrontProvince) then
			table.insert(laCorePrvLowInfra69, provinceId)
		elseif liBuildingSize < 10 and not(liConstructionLevel > 0) and not(isFrontProvince) then
			table.insert(laCorePrvLowInfra99, provinceId)
		end
		
		-- Rocket Test Site
		provinceBuilding = province:GetBuilding(rocket_test)
		liConstructionLevel = province:GetCurrentConstructionLevel(rocket_test)
		
		-- First make sure the province has Industry (performance reasons done first)
		if province:HasBuilding(industry) and not(isFrontProvince) then
			-- Check to see if it has less than 5 Reactors and nothing is being constructed.
			--    Also make sure its not on the front. If everythign is good then go ahead and build some
			
			if (voTechStatus:IsBuildingAvailable(rocket_test) and liRocketSiteCount < viRocketCap) or (voTechStatus:IsBuildingAvailable(rocket_test) and liReactorSiteCount < viReactorCap) then
				if not(province:GetCurrentConstructionLevel(rocket_test) > 0) and not(province:GetCurrentConstructionLevel(nuclear_reactor) > 0) then
					table.insert(laCorePrvIndustry, provinceId)
				end
			end
			
			if lbBuildIndustry then
				if province:GetBuilding(industry):GetMax():Get() < 9 and not(province:GetCurrentConstructionLevel(industry) > 0) then
					table.insert(laCorePrvBuildIndustry, provinceId)
				end
			end
		end		
	end
	
	table.insert(laCorePrv, liRocketSiteCount)
	table.insert(laCorePrv, liReactorSiteCount)
	table.insert(laCorePrv, laCorePrvLowInfra69)
	table.insert(laCorePrv, laCorePrvLowInfra99)
	table.insert(laCorePrv, laCorePrvIndustry)
	table.insert(laCorePrv, laCorePrvBuildIndustry)
	
	return laCorePrv
end
-- #######################
-- End Building Construction
-- #######################


-- #######################
-- Convoy Building
-- #######################
function ConstructConvoys(ai, minister, ministerTag, ministerCountry, ic)
	if ic > 0 then
		local PortCount = ministerCountry:GetNumOfPorts()
		
		if PortCount > 0 then
			local liNeeded = ministerCountry:GetTotalNeededConvoyTransports()
			local liCurrent = ministerCountry:GetTotalConvoyTransports()
			local liConstruction = minister:CountTransportsUnderConstruction()
			local liActuallyNeeded
			local maxSerial = 2
			
			-- Majors build 30% more than you need
			if (ministerCountry:IsMajor()) then
				liActuallyNeeded = Utils.Round((liNeeded * 1.30) - liCurrent - liConstruction )

			-- Minors just build exactly what you need or close to it
			--   - they also do shorter runs since they needed resources more than majors
			else
				liActuallyNeeded = liNeeded - liCurrent - liConstruction
			end
			
			-- Make sure they always have a buffer of atleast 4
			if liActuallyNeeded >= -1 and liActuallyNeeded <= 1 then
				liActuallyNeeded = (math.max(0, liActuallyNeeded) + 4)
			end
			
			if liActuallyNeeded > 0 then
				local cost = ministerCountry:GetConvoyBuildCost():Get()
				local buildRequestCount = liActuallyNeeded / defines.economy.CONVOY_CONSTRUCTION_SIZE
				buildRequestCount = math.ceil( math.max( buildRequestCount, 1) )
				ic = BuildTransportOrEscort(ai, ministerTag, buildRequestCount, maxSerial, false, cost, ic)
			end
	
			-- Now Process Escorts Check
			--   Performance check make sure they have IC to actually work with
			local liENeeded = minister:CountTotalDesiredEscorts()
			local liECurrent = ministerCountry:GetEscorts()

			if liENeeded > liECurrent then
				local liEConstruction = minister:CountEscortsUnderConstruction()
				local lEActuallyNeeded = liENeeded - liECurrent - liEConstruction

				if lEActuallyNeeded > 0 then
					local cost = ministerCountry:GetEscortBuildCost():Get()
					local buildRequestCount = lEActuallyNeeded / defines.economy.CONVOY_CONSTRUCTION_SIZE
					buildRequestCount = math.ceil( math.max( buildRequestCount, 1) )
					ic = BuildTransportOrEscort(ai, ministerTag, buildRequestCount, 4, true, cost, ic)
				end 
			end
		end
	end
	
	return ic
end
--ConvoyOrEscort = is a boolean (true = escort, false = convoy)
function BuildTransportOrEscort(ai, ministerTag, total_transports, maxSerial, ConvoyOrEscort, cost, ic)
	local i = 0 -- Counter for amount of units built
	
	while i < total_transports do
		-- Need to add method call here to call brigades processing using the Array
		----  which needs to return a unitType object to be appended
		local buildcount
		
		if 	total_transports >= (i + maxSerial) then
			buildcount = maxSerial
			i = i + maxSerial
		else
			buildcount = total_transports - i
			i = total_transports
		end
		
		local res = ic - cost

		if res > 0 then
			local buildCommand = CConstructConvoyCommand(ministerTag, ConvoyOrEscort, buildcount)
			ai:Post(buildCommand)
			
			ic = ic - cost
		end
	end
	
	return ic
end
-- #######################
-- END Convoy Building
-- #######################
	