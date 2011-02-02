-----------------------------------------------------------
-- LUA Hearts of Iron 3 Xibei San Ma File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 6/30/2010
-----------------------------------------------------------

local P = {}
AI_CXB = P

-- Tech weights
--   1.0 = 100% the total needs to equal 1.0
function P.TechWeights(minister)
	local laTechWeights = {
		0.30, -- landBasedWeight
		0.15, -- landDoctrinesWeight
		0.20, -- airBasedWeight
		0.15, -- airDoctrinesWeight
		0.0, -- navalBasedWeight
		0.0, -- navalDoctrinesWeight
		0.15, -- industrialWeight
		0.0, -- secretWeaponsWeight
		0.05, -- otherWeight
		true}; -- lbLandBased
	
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
		"armored_car_armour|0",
		"armored_car_gun|0",
		"paratrooper_infantry|0",
		"marine_infantry|0",
		"imporved_police_brigade|0",
		"desert_warfare_equipment|0",
		"jungle_warfare_equipment|0",
		"artic_warfare_equipment|0",
		"amphibious_warfare_equipment|0",
		"airborne_warfare_equipment|0",
		"lighttank_brigade|0",
		"lighttank_gun|0",
		"lighttank_engine|0",
		"lighttank_armour|0",
		"lighttank_reliability|0",
		"tank_brigade|0",
		"tank_gun|0",
		"tank_engine|0",
		"tank_armour|0",
		"tank_reliability|0",
		"heavy_tank_brigade|0",
		"heavy_tank_gun|0",
		"heavy_tank_engine|0",
		"heavy_tank_armour|0",
		"heavy_tank_reliability|0",
		"SP_brigade|0",
		"mechanised_infantry|0",
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
	local ignoreTech = {"mobile_warfare|0",
		"elastic_defence|0",
		"spearhead_doctrine|0",
		"schwerpunkt|0",
		"blitzkrieg|0",
		"operational_level_command_structure|0",
		"tactical_command_structure|0",
		"delay_doctrine|0",
		"integrated_support_doctrine|0",
		"mechanized_offensive|0",
		"combined_arms_warfare|0",
		"grand_battle_plan|3",
		"large_front|3",
		"guerilla_warfare|0",
		"peoples_army|0",
		"large_formations|0",
		"central_planning|0",
		"mass_assault|0"};
		
	return ignoreTech
end

function P.AirTechs(minister)
	local ignoreTech = {"forward_air_control|0",
		"battlefield_interdiction|0",
		"bomber_targerting_focus|0",
		"fighter_targerting_focus|0", 
		"nav_development|0",
		"basic_four_engine_airframe|0",
		"basic_strategic_bomber|0",
		"air_launched_torpedo|0",
		"large_fueltank|0",
		"four_engine_airframe|0",
		"strategic_bomber_armament|0",
		"cargo_hold|0",
		"large_bomb|0",
		"advanced_aircraft_design|0",
		"small_airsearch_radar|0",
		"medium_airsearch_radar|0",
		"large_airsearch_radar|0",
		"small_navagation_radar|0",
		"medium_navagation_radar|0",
		"large_navagation_radar|0",
		"rocket_interceptor_tech|0",
		"drop_tanks|0",
		"jet_engine|0"};

	return ignoreTech
end

function P.AirDoctrineTechs(minister)
	local ignoreTech = {"nav_pilot_training|0",
		"nav_groundcrew_training|0",
		"portstrike_tactics|0",
		"naval_air_targeting|0",
		"navalstrike_tactics|0",
		"naval_tactics|0",
		"heavy_bomber_pilot_training|0",
		"heavy_bomber_groundcrew_training|0",
		"strategic_bombardment_tactics|0",
		"airborne_assault_tactics|0",
		"strategic_air_command|0"};

	return ignoreTech
end
		
function P.NavalTechs(minister)
	local ignoreTech = {"all"}

	return ignoreTech
end
		
function P.NavalDoctrineTechs(minister)
	local ignoreTech = {"all"};

	return ignoreTech
end

function P.IndustrialTechs(minister)
	local ignoreTech = {"oil_to_coal_conversion|0",
		"heavy_aa_guns|0",
		"radio_detection_equipment|0",
		"radar|0",
		"decryption_machine|0",
		"encryption_machine|0",
		"rocket_tests|0",
		"rocket_engine|0",
		"theorical_jet_engine|0",
		"atomic_research|0",
		"nuclear_research|0",
		"isotope_seperation|0",
		"civil_nuclear_research|0",
		"oil_refinning|0",
		"steel_production|0",
		"raremetal_refinning_techniques|0",
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
		"infantry_research|0",
		"civil_defence|0"};

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
	local lbAtWar = minister:GetCountry():IsAtWar()
	local liCYear = CCurrentGameState.GetCurrentDate():GetYear()
		
	if liCYear <= 1938 and not(lbAtWar) then
		local laArray = {
			0.85, -- Land
			0.15, -- Air
			0.0, -- Sea
			0.0}; -- Other
		
		rValue = laArray
	elseif lbAtWar and liCYear <= 1942 then
		local laArray = {
			0.85, -- Land
			0.15, -- Air
			0.0, -- Sea
			0.0}; -- Other
		
		rValue = laArray		
	elseif minister:GetCountry():GetNumOfPorts() > 0 then
		local laArray = {
			0.40, -- Land
			0.25, -- Air
			0.25, -- Sea
			0.10}; -- Other
		
		rValue = laArray
	else
		local laArray = {
			0.50, -- Land
			0.35, -- Air
			0.0, -- Sea
			0.15}; -- Other
		
		rValue = laArray		
	end
	
	return rValue
end
-- Land ratio distribution
function P.LandRatio(minister)
	local laArray = {
		0, -- Garrison
		3, -- Infantry
		0, -- Motorized
		0, -- Mechanized
		0, -- Armor
		3, -- Militia
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
		3, -- Fighter
		1, -- CAS
		2, -- Tactical
		0, -- Naval Bomber
		0}; -- Strategic
	
	return laArray
end
-- Naval ratio distribution
function P.NavalRatio(minister)
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
function P.TransportLandRatio(minister)
	local laArray = {
		40, -- Land
		1}; -- Transport
	
	return laArray
end

-- Build Militia units (China builds smaller divisions)
function P.Build_Militia(ic, minister, militia_brigade, vbGoOver)
	if militia_brigade >= 3 and ic > 2 then
		ic, militia_brigade = Utils.CreateDivision(minister, "militia_brigade", 4, ic, militia_brigade, 3, Utils.BuildLegUnitArray(minister:GetCountry()), 1, vbGoOver)
	end

	return ic, militia_brigade
end

-- Build Strong Garrison units with no police
function P.Build_Garrison(ic, minister, garrison_brigade, vbGoOver)
	if garrison_brigade >= 3 and ic > 2 then
		ic, garrison_brigade = Utils.CreateDivision(minister, "garrison_brigade", 4, ic, garrison_brigade, 3, Utils.BuildLegUnitArray(minister:GetCountry()), 1, vbGoOver)
	end

	return ic, garrison_brigade
end

-- Do not build coastal forts
function P.Build_CoastalFort(ic, minister, vbGoOver)
	return ic
end

-- END OF PRODUTION OVERIDES
-- #######################################

-- Want more troops, let them learn on the battlefield.
--   helps them produce troops faster
function P.CallLaw_training_laws(minister, voCurrentLaw)
	local _MINIMAL_TRAINING_ = 27
	return CLawDataBase.GetLaw(_MINIMAL_TRAINING_)
end

return AI_CXB 

