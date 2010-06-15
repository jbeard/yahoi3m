-----------------------------------------------------------
-- LUA Hearts of Iron 3 USA File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 5/13/2010
-----------------------------------------------------------

local P = {}
AI_USA = P

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
	local ignoreTech = {"mass_assault|0",
		"large_front|3",
		"guerilla_warfare|0",
		"peoples_army|0",
		"large_formations|0"};
		
	return ignoreTech
end

function P.AirTechs(minister)
	local ignoreTech = {};

	return ignoreTech
end

function P.AirDoctrineTechs(minister)
	local ignoreTech = {"forward_air_control|0",
		"battlefield_interdiction|0",
		"bomber_targerting_focus|0",
		"fighter_targerting_focus|0"};

	return ignoreTech
end
		
function P.NavalTechs(minister)
	local ignoreTech = {"battlecruiser_technology|0",
		"battlecruiser_antiaircraft|0",
		"battlecruiser_engine|0",
		"battlecruiser_armour|0",
		"super_heavy_battleship_technology|0"};

	return ignoreTech
end
		
function P.NavalDoctrineTechs(minister)
	local ignoreTech = {};

	return ignoreTech
end

function P.IndustrialTechs(minister)
	local ignoreTech = {};

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

-- Production Weights
--   1.0 = 100% the total needs to equal 1.0
function P.ProductionWeights(minister)
	local rValue
	
	if CCurrentGameState.GetCurrentDate():GetYear() <= 1940 and not(minister:GetCountry():IsAtWar()) then
		local laArray = {
			0.15, -- Land
			0.25, -- Air
			0.45, -- Sea
			0.15}; -- Other
		
		rValue = laArray	
	else
		local laArray = {
			0.40, -- Land
			0.25, -- Air
			0.30, -- Sea
			0.05}; -- Other
		
		rValue = laArray
	end
	
	return rValue
end
-- Land ratio distribution
function P.LandRatio(minister)
	local laArray = {
		2, -- Garrison
		10, -- Infantry
		4, -- Motorized
		3, -- Mechanized
		3, -- Armor
		0, -- Militia
		0}; -- Cavalry
	
	return laArray
end
-- Special Forces ratio distribution
function P.SpecialForcesRatio(minister)
	local laArray = {
		5, -- Land
		1}; -- Special Forces Unit
	
	return laArray
end
-- Air ratio distribution
function P.AirRatio(minister)
	local laArray = {
		5, -- Fighter
		1, -- CAS
		3, -- Tactical
		1, -- Naval Bomber
		2}; -- Strategic
	
	return laArray
end
-- Naval ratio distribution
function P.NavalRatio(minister)
	local laArray = {
		6, -- Destroyers
		4, -- Submarines
		4, -- Cruisers
		1, -- Capital
		2, -- Escort Carrier
		1}; -- Carrier
	
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
		
-- END OF PRODUTION OVERIDES
-- #######################################

function P.DiploScore_InfluenceNation( score, ai, actor, recipient, observer )
	local lsRepTag = tostring(recipient)
	
	if lsRepTag == "AUS" or lsRepTag == "CZE" or lsRepTag == "SCH" then
		score = 0
	end

	return score
end

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	if tostring(actor) == "JAP"
	or lsActorTag == "CHI"
	or lsActorTag == "CHC" 
	or lsActorTag == "CGX" 
	or lsActorTag == "CSX" 
	or lsActorTag == "CXB"
	or lsActorTag == "CYN" 
	or lsActorTag == "SIK"
	or lsActorTag == "ENG" 
	or lsActorTag == "FRA" then
		score = score + 20
	elseif tostring(actor) == "GER" or tostring(actor) == "ITA" then
		score = score - 20
	end
	
	return score
end

function P.DiploScore_Guarantee( score, ai, actor, recipient, observer)

	local recipientCountry = recipient:GetCountry()
	if not recipientCountry:HasFaction() then
		local continent = tostring( recipientCountry:GetCapitalLocation():GetContinent():GetTag() )
		if (continent == "north_america" or continent == "south_america")
		and not (tostring(recipient) == 'CAN') then
			return 100
		end
	end
	
	return score
end

-- Produce slightly better trained troops
function P.CallLaw_training_laws(minister, voCurrentLaw)
	local _ADVANCED_TRAINING_ = 29
	return CLawDataBase.GetLaw(_ADVANCED_TRAINING_)
end

return AI_USA

