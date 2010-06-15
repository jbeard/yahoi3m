-----------------------------------------------------------
-- LUA Hearts of Iron 3 Germany File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 5/20/2010
-----------------------------------------------------------

local P = {}
AI_GER = P

-- #######################################
-- Start of Tech Research

-- Tech weights
--   1.0 = 100% the total needs to equal 1.0
function P.TechWeights(minister)
	local laTechWeights = {
		0.24, -- landBasedWeight
		0.18, -- landDoctrinesWeight
		0.11, -- airBasedWeight
		0.18, -- airDoctrinesWeight
		0.06, -- navalBasedWeight
		0.05, -- navalDoctrinesWeight
		0.10, -- industrialWeight
		0.04, -- secretWeaponsWeight
		0.04, -- otherWeight
		false}; -- lbLandBased
	
	return laTechWeights
end

-- Techs that are used in the main file to be ignored
--   techname|level (level must be 1-9 a 0 means ignore all levels
--   use as the first tech name the word "all" and it will cause the AI to ignore all the techs
function P.LandTechs(minister)
	local ignoreTech = {"cavalry_smallarms|3", 
		"cavalry_guns|3", 
		"cavalry_at|3",
		"marine_infantry|0",
		"jungle_warfare_equipment|0",
		"amphibious_warfare_equipment|0",
		"armored_car_armour|0",
		"armored_car_gun|0"};
		
	return ignoreTech
end

function P.LandDoctrinesTechs(minister)
	local ignoreTech = {"special_forces|4",
		"mass_assault|0",
		"large_front|3",
		"guerilla_warfare|0",
		"peoples_army|0",
		"large_formations|0"};
		
	return ignoreTech
end

function P.AirTechs(minister)
	local ignoreTech = {"basic_strategic_bomber|0",
		"large_fueltank|0",
		"four_engine_airframe|0",
		"strategic_bomber_armament|0",
		"large_bomb|0",
		"large_airsearch_radar|0",
		"large_navagation_radar|0"};

	return ignoreTech
end

function P.AirDoctrineTechs(minister)
	local ignoreTech = {"forward_air_control|0",
		"battlefield_interdiction|0",
		"bomber_targerting_focus|0",
		"fighter_targerting_focus|0", 
		"heavy_bomber_pilot_training|0",
		"heavy_bomber_groundcrew_training|0",
		"strategic_bombardment_tactics|0",
		"strategic_air_command|0"};

	return ignoreTech
end
		
function P.NavalTechs(minister)
	local ignoreTech = {"battlecruiser_technology|0",
		"battlecruiser_antiaircraft|0",
		"battlecruiser_engine|0",
		"battlecruiser_armour|0",
		"super_heavy_battleship_technology|0",
		"cag_development|0",
		"escort_carrier_technology|0",
		"carrier_technology|0",
		"carrier_antiaircraft|0",
		"carrier_engine|0",
		"carrier_armour|0",
		"carrier_hanger|0"};

	return ignoreTech
end
		
function P.NavalDoctrineTechs(minister)
	local ignoreTech = {"carrier_group_doctrine|0",
		"carrier_crew_training|0",
		"carrier_task_force|0",
		"naval_underway_repleshment|0",
		"radar_training|0"};

	return ignoreTech
end

function P.IndustrialTechs(minister)
	local ignoreTech = {"steel_production|0",
		"coal_processing_technologies|0"};

	return ignoreTech
end
		
function P.SecretWeaponTechs(minister)
	local ignoreTech = {}
	return ignoreTech
end

function P.OtherTechs(minister)
	local ignoreTech = {"naval_engineering_research|0",
		"submarine_engineering_research|0",
		"aeronautic_engineering_research|0",
		"rocket_science_research|0",
		"chemical_engineering_research|0",
		"nuclear_physics_research|0",
		"jetengine_research|0",
		"mechanicalengineering_research|0",
		"automotive_research|0",
		"electornicegineering_research|0",
		"artillery_research|0",
		"mobile_research|0",
		"militia_research|0",
		"infantry_research|0"};

	return ignoreTech
end

-- END OF TECH RESEARCH OVERIDES
-- #######################################

-- #######################################
-- Production Overides the main LUA with country specific ones

-- Build_Mountain(ic, minister, bergsjaeger_brigade, vbGoOver)
-- Build_Paratrooper(ic, minister, paratrooper_brigade, vbGoOver)
-- Build_Marine(ic, minister, marine_brigade, vbGoOver)
-- Build_Militia(ic, minister, militia_brigade, vbGoOver)
-- Build_Infantry(ic, minister, infantry_brigade, vbGoOver)
-- Build_Garrison(ic, minister, garrison_brigade, vbGoOver)
-- Build_Cavalry(ic, minister, cavalry_brigade, vbGoOver)
-- Build_Motorized(ic, minister, motorized_brigade, vbGoOver)
-- Build_Mechanized(ic, minister, mechanized_brigade, vbGoOver)
-- Build_LightArmor(ic, minister, light_armor_brigade, vbGoOver)
-- Build_Armor(ic, minister, armor_brigade, vbGoOver)
-- Build_HeavyArmor(ic, minister, armor_brigade, vbGoOver)
-- Build_SuperHeavyArmor(ic, minister, armor_brigade, vbGoOver)

-- Build_CAG(ic, minister, cag, vbGoOver)
-- Build_Interceptor(ic, minister, interceptor, vbGoOver)
-- Build_TacBomber(ic, minister, tactical_bomber, vbGoOver)
-- Build_NavBomber(ic, minister, naval_bomber, vbGoOver)
-- Build_CAS(ic, minister, cas, vbGoOver)
-- Build_MultiRole(ic, minister, multi_role, vbGoOver)
-- Build_StrategicBomber(ic, minister, strategic_bomber, vbGoOver)
-- Build_TransportPlane(ic, minister, transport_plane, vbGoOver)
-- Build_FlyingBomb(ic, minister, transport_plane, vbGoOver)
-- Build_FlyingRocket(ic, minister, transport_plane, vbGoOver)

-- Build_Transport(ic, minister, transport, vbGoOver)
-- Build_Destroyer(ic, minister, destroyer, vbGoOver)
-- Build_LightCruiser(ic, minister, light_cruiser, vbGoOver)
-- Build_HeavyCruiser(ic, minister, heavy_cruiser, vbGoOver)
-- Build_EscortCarrier(ic, minister, escort_carrier, vbGoOver)
-- Build_Carrier(ic, minister, carrier, vbGoOver)
-- Build_Battlecruiser(ic, minister, battlecruiser, vbGoOver)
-- Build_Battleship(ic, minister, battleship, vbGoOver)
-- Build_SuperBattleship(ic, minister, super_heavy_battleship, vbGoOver)
-- Build_Submarine(ic, minister, submarine, vbGoOver)
-- Build_NuclearSubmarine(ic, minister, nuclear_submarine, vbGoOver)

-- Build_NuclearReactor(ic, minister, vbGoOver)
-- Build_RocketTest(ic, minister, vbGoOver)
-- Build_Industry(ic, minister, vbGoOver)
-- Build_CoastalFort(ic, minister, vbGoOver)
-- Build_Fort(ic, minister, vbGoOver)
-- Build_AntiAir(ic, minister, vbGoOver)
-- Build_Radar(ic, minister, vbGoOver)
-- Build_Infrastructure(ic, minister, vbGoOver)
-- Build_AirBase(ic, minister, vbGoOver)

-- must return how much IC is left

-- Production Weights
--   1.0 = 100% the total needs to equal 1.0
function P.ProductionWeights(minister)
	local laArray
	local ministerCountry = minister:GetCountry()
	
	if ministerCountry:IsAtWar() then
		-- Desperation check and if so heavy production of land forces
		if ministerCountry:CalcDesperation():Get() > 0.4 then
			laArray = {
				0.65, -- Land
				0.30, -- Air
				0.05, -- Sea
				0.0}; -- Other
		else
			laArray = {
				0.50, -- Land
				0.25, -- Air
				0.20, -- Sea
				0.05}; -- Other
		end
	else
		laArray = {
			0.40, -- Land
			0.25, -- Air
			0.25, -- Sea
			0.10}; -- Other
	end
	
	return laArray
end
-- Land ratio distribution
function P.LandRatio(minister)
	local laArray = {
		2, -- Garrison
		13, -- Infantry
		2, -- Motorized
		1, -- Mechanized
		1, -- Armor
		0, -- Militia
		0}; -- Cavalry
	
	return laArray
end
-- Special Forces ratio distribution
function P.SpecialForcesRatio(minister)
	local laArray = {
		10, -- Land
		1}; -- Special Forces Unit
	
	return laArray
end
-- Air ratio distribution
function P.AirRatio(minister)
	local laArray = {
		8, -- Fighter
		3, -- CAS
		4, -- Tactical
		1, -- Naval Bomber
		0}; -- Strategic
	
	return laArray
end
-- Naval ratio distribution
function P.NavalRatio(minister)
	local laArray = {
		4, -- Destroyers
		4, -- Submarines
		3, -- Cruisers
		1, -- Capital
		0, -- Escort Carrier
		0}; -- Carrier
	
	return laArray
end
-- Transport to Land unit distribution
function P.TransportLandRatio(minister)
	local norTag = CCountryDataBase.GetTag('NOR')
	local loNorwayCountry = norTag:GetCountry()
	local laArray
	
	-- If Norway is present build more transports to invade it with
	if loNorwayCountry:Exists()
	and not(minister:GetCountry():GetRelation(norTag):HasAlliance()) then
		laArray = {
			60, -- Land
			1}; -- Transport	
	else
		laArray = {
			120, -- Land
			1}; -- Transport	
	end
	
	return laArray
end

-- Build Motorized
function P.Build_Motorized(ic, minister, motorized_brigade, vbGoOver)
	return Support.Build_Standard_Motorized(ic, minister, motorized_brigade, vbGoOver)
end

-- Build Armor
function P.Build_Armor(ic, minister, armor_brigade, vbGoOver)
	return Support.Build_Standard_Armor(ic, minister, armor_brigade, vbGoOver)
end

-- Do not build light armor (wait till you have armor or better)
function P.Build_LightArmor(ic, minister, light_armor_brigade, vbGoOver)
	-- Replace Ligth Armor request with Armor
	if minister:GetCountry():GetTechnologyStatus():IsUnitAvailable(CSubUnitDataBase.GetSubUnit("armor_brigade")) then
		return P.Build_Armor(ic, minister, light_armor_brigade, vbGoOver)
	else
		return ic, 0
	end
end
-- Do not build battle cruisers
function P.Build_Battlecruiser(ic, minister, battlecruiser, vbGoOver)
	-- Replace Battlecruiser request with a Battleship
	if minister:GetCountry():GetTechnologyStatus():IsUnitAvailable(CSubUnitDataBase.GetSubUnit("battleship")) then
		return Utils.CreateDivision_nominor(minister, "battleship", 1, ic, battlecruiser, 1, vbGoOver)
	else
		return ic, 0
	end
end
		
-- Have Germany Fortify the French Line
function P.Build_Fort(ic, minister, vbGoOver)
	-- Only build the forts if its 1938 or less
	if minister:GetOwnerAI():GetCurrentDate():GetYear() <= 1938 then
		ic = Support.Build_Fort(ic, minister, 3084, 1, vbGoOver) -- Todtmoos
		ic = Support.Build_Fort(ic, minister, 3016, 1, vbGoOver) -- Hinterzarten
		ic = Support.Build_Fort(ic, minister, 2948, 1, vbGoOver) -- Baden
		ic = Support.Build_Fort(ic, minister, 2882, 1, vbGoOver) -- Donaueschingen
		ic = Support.Build_Fort(ic, minister, 2751, 1, vbGoOver) -- Villingen
		ic = Support.Build_Fort(ic, minister, 2685, 1, vbGoOver) -- Achern
		
		ic = Support.Build_Fort(ic, minister, 2619, 1, vbGoOver) -- Pirmasens
		ic = Support.Build_Fort(ic, minister, 2553, 1, vbGoOver) -- Saarbrücken
		ic = Support.Build_Fort(ic, minister, 2490, 1, vbGoOver) -- Saarlouis
	end
	
	return ic
end

-- END OF PRODUTION OVERIDES
-- #######################################

-- #######################################
-- Intelligence Hooks
-- Home_Spies(minister)


function P.Home_Spies(minister)
	return Support.Home_Spies_Interventionist(minister)
end

-- End of Intelligence Hooks
-- #######################################


-- #######################################
-- Diplomacy Hooks

-- These all must return a numeric score (100 being 100% chance of success)

-- DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
-- DiploScore_Alliance(score, ai, actor, recipient, observer, action)
-- DiploScore_InviteToFaction(score, ai, actor, recipient, observer)
-- DiploScore_JoinFaction(score, minister, faction)
-- DiploScore_InfluenceNation( score, ai, actor, recipient, observer )
-- DiploScore_Guarantee(score, ai, actor, recipient, observer)
-- DiploScore_Embargo(score, ai, actor, recipient, observer)
-- DiploScore_NonAgression(score, ai, actor, recipient, observer)
-- DiploScore_DemandMilitaryAccess(score,ai, actor, recipient, observer)
-- DiploScore_OfferMilitaryAccess(score, ai, actor, recipient, observer, action)
-- DiploScore_CallAlly(liScore, ai, actor, recipient, observer)
-- EvaluateLimitedWar(score, minister, target, warDesirability)

-- Scripted items no return value

function P.DiploScore_InfluenceNation( score, ai, actor, recipient, observer )
	local lsRepTag = tostring(recipient)
	
	if lsRepTag == "AUS" or lsRepTag == "CZE" or lsRepTag == "SCH" then
		score = 0 -- we get them anyway
	elseif lsRepTag == "HUN" or lsRepTag == "ROM" or lsRepTag == "BUL" or lsRepTag == "FIN" or lsRepTag == "ITA" or lsRepTag == "JAP" then
		score = score + 70
	elseif lsRepTag == "AST" or lsRepTag == "CAN" or lsRepTag == "SAF" or lsRepTag == "NZL" then
		score = score - 20
	end

	return score
end

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	local lsActorTag = tostring(actor)
	
	if lsActorTag == "SOV" or lsActorTag == "SWE" or lsActorTag == "ITA" or lsActorTag == "SPA" then
		score = score + 15
	end
	
	return score
end

function P.DiploScore_InviteToFaction( score, ai, actor, recipient, observer)
	if tostring(recipient) == 'AUS' then -- we got better plans for you...
		return 0
	end
	
	return score
end

function P.DiploScore_Alliance( score, ai, actor, recipient, observer)
	if tostring(recipient) == 'AUS' then -- we got better plans for you...
		return 0
	end
	
	return score
end

function P.DiploScore_DemandMilitaryAccess( score, ai, actor, recipient, observer )
	local lsTarget = tostring(recipient)
	local ministerCountry = actor:GetCountry()

	-- If Sweeden is the target
    if lsTarget == "SWE" then
        local norTag = CCountryDataBase.GetTag("NOR")
		local loNorwayCountry = norTag:GetCountry()
        local loRelation = ministerCountry:GetRelation(norTag)
        
		-- Is Norway atwar with us, gone or allied with us?
        if loRelation:HasWar() 
		or (loNorwayCountry:IsPuppet() and loRelation:HasAlliance())
		or not(loNorwayCountry:Exists()) then
			-- Are we allied with Finland to even need this?
			if ministerCountry:GetRelation(CCountryDataBase.GetTag("FIN")):HasAlliance() then
				score = score + 70
			end
        end
    end
    
    return score
end

--##########################
-- Foreign Minister Hooks

-- ForeignMinister_EvaluateDecision(score, agent, decision, scope)
-- CallAlly(minister)
-- ProposeDeclareWar(minister)

function P.ForeignMinister_EvaluateDecision(score, agent, decision, scope)
	local lsDecision = tostring(decision:GetKey())
	local liYear = CCurrentGameState.GetCurrentDate():GetYear()
	local liMonth = CCurrentGameState.GetCurrentDate():GetMonthOfYear()
	local liDay = CCurrentGameState.GetCurrentDate():GetDayOfMonth()
	
	if lsDecision == "molotov_ribbentrop_pact" then
		if liYear == 1939 then
			if (liMonth == 7 and liDay > 10) or	liMonth > 7 then
				return 100
			end
		end
		
		score = 0
		
	elseif lsDecision == "danzig_or_war" then
		if liYear == 1939 then
			if (liMonth == 7 and liDay > 20) or	liMonth > 7 then
				agent:GetCountry():GetStrategy():PrepareWarDecision(CCountryDataBase.GetTag("POL"), 100, decision, false)
			end
		end
		
		score = 0
		
	elseif lsDecision == "anschluss_of_austria" then
		if liYear == 1938 then
			if (liMonth == 2 and liDay > 8) or	liMonth > 2 then
				return 100
			end
		end
		
		score = 0
	
	elseif lsDecision == "the_treaty_of_munich" then
		if liYear == 1938 then
			if (liMonth == 8 and liDay > 25) or	liMonth > 8 then
				return 100
			end
		end
		
		score = 0	
		
	elseif lsDecision == "first_vienna_award" or lsDecision == "the_first_vienna_award" then
		if liYear == 1939 then
			if (liMonth == 2 and liDay > 25) or	liMonth > 2 then
				return 100
			end
		end
		
		score = 0		
	end
	
	return score
end

function P.CallAlly(minister)
	local ministerCountry = minister:GetCountry()
	local ministerTag = minister:GetCountryTag()
	local ministerContinent = ministerCountry:GetActingCapitalLocation():GetContinent()
	local ai = minister:GetOwnerAI() 
	
	-- Loop through all wars
	for loDiploStatus in ministerCountry:GetDiplomacy() do
		local loTargetTag = loDiploStatus:GetTarget()
		local lsTargetTag = tostring(loTargetTag)
		
		if loTargetTag:IsValid() and loDiploStatus:HasWar() then
			local loWar = loDiploStatus:GetWar()
			if loWar:IsLimited() then
				local loTargetCountry = loTargetTag:GetCountry()
				
				-- Call in Puppets
				for loPuppetTag in ministerCountry:GetVassals() do	
					if not loWar:IsPartOfWar(loPuppetTag) then
						local loAction = CCallAllyAction( ministerTag, loPuppetTag, loTargetTag )
						loAction:SetValue( true ) -- limited
						if loAction:IsSelectable() then
							ai:PostAction(loAction)
						end
					end
				end					
				
				-- Call in all potential allies
				for loAllyTag in ministerCountry:GetAllies() do
					local loAllyCountry = loAllyTag:GetCountry()
					
					--Utils.LUA_DEBUGOUT("lsAllyTag: " .. tostring(tostring(loAllyTag)))
					
					-- Check to see if the two are already at war?
					if not(loAllyCountry:GetRelation(loTargetTag):HasWar()) then
						local lsAllyTag = tostring(loAllyTag)					
						
						-- Best guess as to potential Pacific Allies no point in bothering them
						--   Puppet check is added cause it means they are someone elses puppet and
						--   they should be called by that countries AI.
						if not(lsAllyTag == "SIA")
						and not(lsAllyTag == "JAP")
						and not(lsAllyTag == "MAN") then
						
							-- We are desperate so overide all else statements
							if ministerCountry:CalcDesperation():Get() > 0.4
							or lsTargetTag == "SOV" then
								-- Call in Allies that are neighbors to our enemy or on same cotinent
								if loTargetCountry:IsNeighbour(loAllyTag)
								or ministerContinent == loAllyCountry:GetActingCapitalLocation():GetContinent() then
									P.ExecuteCallAlly(ai, ministerTag, loAllyTag, loTargetTag)
								end
								
							-- When to Call Italy into the war
							elseif lsAllyTag == "ITA" or lsAllyTag == "ETH" then
								local fraTag = CCountryDataBase.GetTag("FRA")
								local belTag = CCountryDataBase.GetTag("BEL")
								local liMonth = CCurrentGameState.GetCurrentDate():GetMonthOfYear()
								local belCountry = belTag:GetCountry()
								
								-- Do not call in Italy to early as they may take unecessary losses
								--   to their fleet against the French Navy!
								--   if Belgium is gone or Paris is no longer controled by France
								if not(CCurrentGameState.GetProvince(2613):GetController() == fraTag)
								or not(CCurrentGameState.GetProvince(2311):GetController() == belTag) 
								or belCountry:IsGovernmentInExile()
								or not(belCountry:Exists()) then
									P.ExecuteCallAlly(ai, ministerTag, loAllyTag, loTargetTag)
								
								-- Or the month is between July and September and Germany is atwar with Belgium
								elseif liMonth > 5
								and liMonth < 9
								and ministerCountry:GetRelation(belTag):HasWar() then
									P.ExecuteCallAlly(ai, ministerTag, loAllyTag, loTargetTag)
								end
							
							-- Standard catch all call anyone on our enemies border
							elseif not(lsTargetTag == "POL") then
								-- Call in Allies that are neighbors to our enemy
								if loTargetCountry:IsNeighbour(loAllyTag) then
									P.ExecuteCallAlly(ai, ministerTag, loAllyTag, loTargetTag)
								end
							end
						end
					end
				end
			end
		end
	end
end
function P.ExecuteCallAlly(ai, ministerTag, voAllyTag, voTargetTag)
	local loAction = CCallAllyAction( ministerTag, voAllyTag, voTargetTag)
	loAction:SetValue( true ) -- limited
	if loAction:IsSelectable() then
		ai:PostAction(loAction)
	end
end

function P.ProposeDeclareWar(minister)
	local ministerCountry = minister:GetCountry()
	local loStrategy = ministerCountry:GetStrategy()
	
	if not(loStrategy:IsPreparingWar()) then
		if ministerCountry:GetFaction() == CCurrentGameState.GetFaction('axis') then	
			local ai = minister:GetOwnerAI()		
			local year = ai:GetCurrentDate():GetYear()
			local month = ai:GetCurrentDate():GetMonthOfYear()
			
			if ministerCountry:IsAtWar() or year >= 1940 then
				local fraTag = CCountryDataBase.GetTag("FRA")
				local norTag = CCountryDataBase.GetTag("NOR")
				local liTotalNeighborWars = 0
				local lbNorwayNeighbor = false
				
				for neighborTag in ministerCountry:GetNeighbours() do
					if ministerCountry:GetRelation(neighborTag):HasWar() then
						
						-- Do not count Norway as we are invading them
						if not(norTag == neighborTag) then
							liTotalNeighborWars = liTotalNeighborWars + 1
						end
					end
				end
			
				if ministerCountry:GetRelation(fraTag):HasWar() and ministerCountry:IsNeighbour(fraTag) then
					if liTotalNeighborWars == 1 then
						P.DenmarkCheck(ai, ministerCountry, loStrategy)
						
						-- Try to time this first
						if month >= 1 and month <= 6 then
							P.NorwayCheck(ai, ministerCountry, loStrategy)
						end
						
						-- Wait for good weather months to attack
						if month >= 3 and month <= 7 then
							P.LowCountriesCheck(ai, ministerCountry, loStrategy)
						end
					end
				
				-- Make sure its always in clear weather turns
				elseif not ministerCountry:IsAtWar() and month >= 3 and month <= 7 then
					-- Potential Wars with neighbors
					local laPotentialWars = {}
					
					for neighborTag in ministerCountry:GetNeighbours() do
						if not(Utils.IsFriend(ai, ministerCountry:GetFaction(), neighborTag))
						and not(ministerCountry:GetRelation(neighborTag):HasAlliance()) then
							table.insert(laPotentialWars, neighborTag)
						end
					end

					-- Pick a random country that is not friend to go to war with
					if table.getn(laPotentialWars) > 0 then
						-- Limited War
						loStrategy:PrepareLimitedWar(laPotentialWars[math.random(table.getn(laPotentialWars))], 100)
					end
				else
					P.DenmarkCheck(ai, ministerCountry, loStrategy)
					P.NorwayCheck(ai, ministerCountry, loStrategy)
					
					if not(P.LowCountriesCheck(ai, ministerCountry, loStrategy)) then
						-- If the Low Countries are gone then go ahead and look at other targets
						local lbGreeceCheck = false
						
						if month >= 1 and month <= 6 then
							lbGreeceCheck = P.GreeceCheck(ai, ministerCountry, loStrategy)
						end 
						
						if month >= 2 and month <= 6 then
							if not(lbGreeceCheck) and liTotalNeighborWars == 0 then
								-- Potential Wars with neighbors
								local laPotentialWars = {}
								
								for loTargetTag in ministerCountry:GetNeighbours() do
									-- Make sure Vichy is not part of this list!
									local lsTargetTag = tostring(loTargetTag)
									
									if not(lsTargetTag == "VIC")
									and not(lsTargetTag == "SCH") then
										if not(Utils.IsFriend(ai, ministerCountry:GetFaction(), loTargetTag:GetCountry()))
										and not(ministerCountry:GetRelation(loTargetTag):HasAlliance()) then
											table.insert(laPotentialWars, loTargetTag)
										end
									end
								end

								-- Pick a random country that is not friend to go to war with
								if table.getn(laPotentialWars) > 0 then
									-- Limited War
									loStrategy:PrepareLimitedWar(laPotentialWars[math.random(table.getn(laPotentialWars))], 100)
								end			
							end
						end
					end
				end
			end
		end
	end
end
function P.DenmarkCheck(ai, ministerCountry, voStrategy)
	local denTag = CCountryDataBase.GetTag("DEN")
	local loDenmarkCountry = denTag:GetCountry()
	local rValue = false
	
	if loDenmarkCountry:Exists()
	and not(ministerCountry:GetRelation(denTag):HasAlliance())
	and not(loDenmarkCountry:HasFaction())
	and ministerCountry:IsNeighbour(denTag)
	and not(ministerCountry:GetRelation(denTag):HasWar()) then
		-- Limited War
		voStrategy:PrepareLimitedWar(denTag, 100)
		rValue = true
	end
	
	return rValue
end
function P.NorwayCheck(ai, ministerCountry, voStrategy)
	local denTag = CCountryDataBase.GetTag("DEN")
	local loDenmarkCountry = denTag:GetCountry()
	local rValue = false
	
	-- Check to see if Denmark is gone
	if not(loDenmarkCountry:Exists())
	or ministerCountry:GetRelation(denTag):HasAlliance()
	or loDenmarkCountry:IsGovernmentInExile()
	or loDenmarkCountry:IsPuppet() then
	
		-- Denmark does not exist so prepare for war with Norway
		local norTag = CCountryDataBase.GetTag("NOR")
		local loNorwayCountry = norTag:GetCountry()	
		
		if loNorwayCountry:Exists()
		and not(ministerCountry:GetRelation(norTag):HasAlliance())
		and not(loNorwayCountry:HasFaction())
		and not(ministerCountry:GetRelation(norTag):HasWar()) then
			if not(Utils.IsFriend(ai, ministerCountry:GetFaction(), loNorwayCountry)) then
				-- Limited War
				voStrategy:PrepareLimitedWar(norTag, 100)
				rValue = true
			end
		end
	end
	
	return rValue
end
function P.LowCountriesCheck(ai, ministerCountry, voStrategy)
	local belTag = CCountryDataBase.GetTag('BEL')
	local holTag = CCountryDataBase.GetTag('HOL')
	local luxTag = CCountryDataBase.GetTag('LUX')	

	local belCountry = belTag:GetCountry()
	local holCountry = holTag:GetCountry()
	local luxCountry = luxTag:GetCountry()
	
	local rValue = false
	
	-- Secondary checks to make sure they are gone!
	if belCountry:Exists()
	or holCountry:Exists()
	or luxCountry:Exists() then
		if not(ministerCountry:GetRelation(belTag):HasAlliance())
		and not(belCountry:HasFaction())
		and ministerCountry:IsNeighbour(belTag)
		and not(ministerCountry:GetRelation(belTag):HasWar())
		and not(belCountry:IsGovernmentInExile()) then
			-- Limited War
			voStrategy:PrepareLimitedWar(belTag, 100)
			rValue = true
		end
		if not(ministerCountry:GetRelation(holTag):HasAlliance())
		and not(holCountry:HasFaction())
		and ministerCountry:IsNeighbour(holTag)
		and not(ministerCountry:GetRelation(holTag):HasWar())
		and not(holCountry:IsGovernmentInExile()) then
			-- Limited War
			voStrategy:PrepareLimitedWar(holTag, 100)
			rValue = true
		end
		if not(ministerCountry:GetRelation(luxTag):HasAlliance())
		and not(luxCountry:HasFaction())
		and ministerCountry:IsNeighbour(luxTag)
		and not(ministerCountry:GetRelation(luxTag):HasWar())
		and not(luxCountry:IsGovernmentInExile()) then
			-- Limited War
			voStrategy:PrepareLimitedWar(luxTag, 100)
			rValue = true
		end
	end
	
	return rValue
end
function P.GreeceCheck(ai, ministerCountry, voStrategy)
	local itaTag = CCountryDataBase.GetTag('ITA')
	local greTag = CCountryDataBase.GetTag('GRE')
	local yugTag = CCountryDataBase.GetTag('YUG')

	local loItalyCountry = itaTag:GetCountry()
	local loGreeceCountry = greTag:GetCountry()
	local loYugoslaviaCountry = yugTag:GetCountry()
	
	local rValue = false

	if not(loGreeceCountry:IsGovernmentInExile())
	and loGreeceCountry:Exists()
	and ministerCountry:GetRelation(itaTag):HasAlliance() then
		if loItalyCountry:GetRelation(greTag):HasWar() 
		and not(ministerCountry:GetCountry():GetRelation(yugTag):HasWar())
		and loItalyCountry:GetCountry():GetRelation(greTag):HasWar()
		and loYugoslaviaCountry:Exists()
		and ministerCountry:IsNeighbour(yugTag)
		and not(ministerCountry:GetRelation(yugTag):HasAlliance())
		and not(loYugoslaviaCountry:HasFaction()) then
			-- Limited War
			voStrategy:PrepareLimitedWar(yugTag, 100)
			rValue = true
		end
	end
	
	return rValue
end

--##########################
-- Politics Minister Hooks

-- HandleMobilization(minister)
-- HandlePuppets(minister)

-- Handle special Law cases, the @@@ is the law group name in string format
-- CallLaw_@@@@@(minister, loCurrentLaw)

-- Changing of Ministers
--    Each method is passed an array of ministers that can be put into the position
-- Call_ChiefOfAir(ministerCountry, vaMinisters)
-- Call_ChiefOfNavy(ministerCountry, vaMinisters)
-- Call_ChiefOfArmy(ministerCountry, vaMinisters)
-- Call_MinisterOfIntelligence(ministerCountry, vaMinisters)
-- Call_ChiefOfStaff(ministerCountry, vaMinisters)
-- Call_ForeignMinister(ministerCountry, vaMinisters)
-- Call_ArmamentMinister(ministerCountry, vaMinisters)
-- Call_MinisterOfSecurity(ministerCountry, vaMinisters)

-- Create very highly trained troops
function P.CallLaw_training_laws(minister, voCurrentLaw)
	local _SPECIALIST_TRAINING_ = 30
	return CLawDataBase.GetLaw(_SPECIALIST_TRAINING_)
end

return AI_GER
