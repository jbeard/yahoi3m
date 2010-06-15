-----------------------------------------------------------
-- LUA Hearts of Iron 3 Italy File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 5/22/2010
-----------------------------------------------------------

local P = {}
AI_ITA = P

-- Tech weights
--   1.0 = 100% the total needs to equal 1.0
function P.TechWeights(minister)
	local laTechWeights = {
		0.18, -- landBasedWeight
		0.09, -- landDoctrinesWeight
		0.12, -- airBasedWeight
		0.15, -- airDoctrinesWeight
		0.18, -- navalBasedWeight
		0.10, -- navalDoctrinesWeight
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
		"cavalry_support|3",
		"cavalry_guns|3", 
		"cavalry_at|3",
		"marine_infantry|0",
		"armored_car_armour|0",
		"armored_car_gun|0",
		"heavy_tank_brigade|0",
		"heavy_tank_gun|0",
		"heavy_tank_engine|0",
		"heavy_tank_armour|0",
		"heavy_tank_reliability|0",
		"super_heavy_tank_brigade|0",
		"super_heavy_tank_gun|0",
		"super_heavy_tank_engine|0",
		"super_heavy_tank_armour|0",
		"super_heavy_tank_reliability|0",
		"rocket_art|0",
		"rocket_art_ammo|0",
		"rocket_carriage_sights|0"};
		
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
	local ignoreTech = {"all"}
	
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

-- Production Weights
--   1.0 = 100% the total needs to equal 1.0
function P.ProductionWeights(minister)
	local rValue
	
	if minister:GetCountry():IsAtWar() then
		local laArray = {
			0.35, -- Land
			0.25, -- Air
			0.35, -- Sea
			0.05}; -- Other
		
		rValue = laArray	
	else
		local laArray = {
			0.30, -- Land
			0.25, -- Air
			0.30, -- Sea
			0.15}; -- Other
		
		rValue = laArray
	end
	
	return rValue
end
-- Land ratio distribution
function P.LandRatio(minister)
	local laArray = {
		5, -- Garrison
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
		25, -- Land
		1}; -- Special Forces Unit
	
	return laArray
end
-- Air ratio distribution
function P.AirRatio(minister)
	local laArray = {
		5, -- Fighter
		1, -- CAS
		2, -- Tactical
		2, -- Naval Bomber
		0}; -- Strategic
	
	return laArray
end
-- Naval ratio distribution
function P.NavalRatio(minister)
	local laArray = {
		4, -- Destroyers
		5, -- Submarines
		3, -- Cruisers
		1, -- Capital
		0, -- Escort Carrier
		0}; -- Carrier
	
	return laArray
end
-- Transport to Land unit distribution
function P.TransportLandRatio(minister)
	local laArray = {
		40, -- Land
		1}; -- Transport
	
	return laArray
end

-- Build Armor
function P.Build_Armor(ic, minister, armor_brigade, vbGoOver)
	return Support.Build_Standard_Armor(ic, minister, armor_brigade, vbGoOver)
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

-- Do not build Rocket Sites
function P.Build_RocketTest(ic, minister, vbGoOver)
	return ic
end


-- END OF PRODUTION OVERIDES
-- #######################################

-- #######################################
-- Intelligence Hooks

-- Home_Spies(minister)
-- #######################################

function P.Home_Spies(minister)
	return Support.Home_Spies_Interventionist(minister)
end

function P.HandlePuppets(minister)
	local ministerCountry = minister:GetCountry()
	for loPuppetTag in ministerCountry:GetPossiblePuppets() do
		if tostring(loPuppetTag) == "ETH" then
			minister:GetOwnerAI():Post(CCreateVassalCommand(loPuppetTag, minister:GetCountryTag()))
		end
	end
end

-- End of Intelligence Hooks
-- #######################################
function P.ForeignMinister_EvaluateDecision(score, agent, decision, scope)
	local lsDecision = decision:GetKey():GetString()
	
	if lsDecision == "the_future_of_greece" then
		score = 0 -- ai will select decision when we are ready for war
		
		local fraTag = CCountryDataBase.GetTag("FRA")
		local vicTag = CCountryDataBase.GetTag("VIC")
		local loVicCountry = vicTag:GetCountry()
		
		
		-- Vichy exists go for Greece
		if loVicCountry:Exists() then
			agent:GetCountry():GetStrategy():PrepareWarDecision(CCountryDataBase.GetTag("GRE"), 100, decision, false)
		
		-- 10% random Chance and Check to see if France no longer controls Paris		
		elseif not(CCurrentGameState.GetProvince(2613):GetController() == fraTag)
		and math.random(100) <= 10 then
			agent:GetCountry():GetStrategy():PrepareWarDecision(CCountryDataBase.GetTag("GRE"), 100, decision, false)
		end
		
	elseif lsDecision == "annexation_of_albania" then
		agent:GetCountry():GetStrategy():PrepareWarDecision(CCountryDataBase.GetTag("ALB"), 100, decision, false)
		score = 0 -- ai will select decision when we are ready for war
	end
	
	return score
end

function P.ProposeDeclareWar( minister )
	local ai = minister:GetOwnerAI()
	local ministerCountry = minister:GetCountry()
	local loStrategy = ministerCountry:GetStrategy()
	local year = ai:GetCurrentDate():GetYear()
	local month = ai:GetCurrentDate():GetMonthOfYear()

	local gerTag = CCountryDataBase.GetTag('GER')
	local fraTag = CCountryDataBase.GetTag('FRA')
	local greTag = CCountryDataBase.GetTag('GRE')
	local vicTag = CCountryDataBase.GetTag('VIC')
	
	-- If Italy is leaning to the Axis Faction and Greece is not atwar
	if ministerCountry:GetFaction() == gerTag:GetCountry():GetFaction()
	and not(ministerCountry:GetRelation(greTag):HasWar()) then
		local loFraTagCountry = fraTag:GetCountry()
		
		-- Is France in Exile, Vichy Exist or is France gone?
		if loFraTagCountry:IsGovernmentInExile() 
		or vicTag:GetCountry():Exists()
		or not(loFraTagCountry:Exists())then
			-- Check to make sure Paris is not controlled by France
			if not(CCurrentGameState.GetProvince(2613):GetOwner() == fraTag) then
				loStrategy:PrepareWar(greTag, 100)
			end
		end
	end
end

function P.DiploScore_InfluenceNation( score, ai, actor, recipient, observer )
	local lsRepTag = tostring(recipient)
	local lsFaction = tostring(actor:GetCountry():GetFaction():GetTag())
	
	if lsFaction == "axis" then
		if lsRepTag == "AUS" or lsRepTag == "CZE" or lsRepTag == "SCH" then
			score = 0 -- we get them anyway
		elseif lsRepTag == "HUN" or lsRepTag == "ROM" or lsRepTag == "BUL" or lsRepTag == "FIN" or lsRepTag == "ITA" or lsRepTag == "JAP" then
			score = score + 70
		elseif lsRepTag == "AST" or lsRepTag == "CAN" or lsRepTag == "SAF" or lsRepTag == "NZL" then
			score = score - 20
		end
	end

	return score
end

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	if tostring(actor) == "GER" or tostring(actor) == "SPA" then
		score = score + 15
	end
	
	return score
end

return AI_ITA
