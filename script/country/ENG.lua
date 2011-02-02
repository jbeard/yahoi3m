-----------------------------------------------------------
-- LUA Hearts of Iron 3 United Kingdom File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 6/30/2010
-----------------------------------------------------------

local P = {}
AI_ENG = P

-- #######################################
-- Static Production Variables overide
function P.LandToAirRatio(minister)
	local laArray = {
		5, -- Land Briages
		1}; -- Air
	
	return laArray
end

function P._LandRatio_Units_(minister)
	local laLandRatioUnits = {
		'garrison_brigade', -- Garrison
		'infantry_brigade', -- Infantry
		'motorized_brigade', -- Motorized
		'mechanized_brigade', -- Mechanized
		'armor_brigade|heavy_armor_brigade|super_heavy_armor_brigade', -- Armor
		'militia_brigade', -- Militia
		'cavalry_brigade'}; -- Cavalry
	
	return laLandRatioUnits
end
-- #######################################

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
	local ignoreTech = {"steel_production|0",
		"raremetal_refinning_techniques|0",
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

-- Production Weights
--   1.0 = 100% the total needs to equal 1.0
function P.ProductionWeights(minister)
	local rValue
	local lbAtWar = minister:GetCountry():IsAtWar()
	
	if CCurrentGameState.GetCurrentDate():GetYear() <= 1938 and not(lbAtWar) then
		local laArray = {
			0.20, -- Land
			0.25, -- Air
			0.40, -- Sea
			0.15}; -- Other
		
		rValue = laArray
	elseif lbAtWar then
		local laArray = {
			0.50, -- Land
			0.20, -- Air
			0.25, -- Sea
			0.05}; -- Other
		
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
		10, -- Land
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
		9, -- Destroyers
		3, -- Submarines
		6, -- Cruisers
		3, -- Capital
		1, -- Escort Carrier
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
		return P.Build_Armor(ic, minister, light_armor_brigade)
	else
		return ic, 0
	end
end

-- Do not build cavalry
function P.Build_Cavalry(ic, minister, cavalry_brigade, vbGoOver)
	return ic, 0
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

-- #######################################
-- Intelligence Hooks

-- Home_Spies(minister)
-- #######################################

function P.Home_Spies(minister)
	return Support.Home_Spies_Interventionist(minister)
end

-- End of Intelligence Hooks
-- #######################################

function P.ProposeDeclareWar(minister)
	local ai = minister:GetOwnerAI()
	local ministerCountry = minister:GetCountry()
	local year = ai:GetCurrentDate():GetYear()
	
	local axisFaction = CCurrentGameState.GetFaction("axis")
	local alliesFaction = CCurrentGameState.GetFaction("allies")
	local axisLeaderTag = axisFaction:GetFactionLeader()
	
	local loStrategy = ministerCountry:GetStrategy()
	
	-- Make sure UK is part of the allies
	if ministerCountry:GetFaction() == alliesFaction
	and not(loStrategy:IsPreparingWar()) then
		local loMinisterCapital = ministerCountry:GetCapitalLocation():GetContinent()
	
		-- Generic DOW for countries not part of the same faction
		for loTargetCountry in CCurrentGameState.GetCountries() do
			local loTargetTag = loTargetCountry:GetCountryTag()
			
			if not(loTargetCountry:GetFaction() == ministerCountry:GetFaction()) then
				if loTargetCountry:Exists() 
				and loTargetCountry:GetCapitalLocation():GetContinent() == loMinisterCapital then
					if ministerCountry:GetRelation(loTargetTag):GetThreat():Get() > ministerCountry:GetMaxNeutralityForWarWith(loTargetTag):Get()  then
						loStrategy:PrepareWar( loTargetTag, 100 )
					end
				end
			end
		end

		if not(ministerCountry:IsAtWar()) then
			local gerTag = CCountryDataBase.GetTag("GER")
			local itaTag = CCountryDataBase.GetTag("ITA")
			
			local loGerCountry = gerTag:GetCountry()
			local loItaCountry = itaTag:GetCountry()
		
			-- Generic test in case Germany is not the axis leader
			if year > 1939 
			and not(ministerCountry:GetRelation(axisLeaderTag):HasWar()) then
				loStrategy:PrepareWar(axisLeaderTag, 100)
			end
			
			-- Check for UK to keep an eye on Germany
			if not(ministerCountry:GetRelation(gerTag):HasWar())
			and loGerCountry:GetFaction() == axisFaction
			and loGerCountry:IsAtWar() then
				loStrategy:PrepareWar( gerTag, 100 )
			end
			
			-- Check for UK to keep an eye on Italy
			if not(ministerCountry:GetRelation(itaTag):HasWar())
			and loItaCountry:GetFaction() == axisFaction
			and loItaCountry:IsAtWar() then
				loStrategy:PrepareWar( itaTag, 100 )
			end
			
		-- If we are atwar with the leader of the Axis then look for Vichy
		elseif ministerCountry:GetRelation(axisLeaderTag):HasWar() then
			-- Vichy Check and allied with USA
			local usaTag = CCountryDataBase.GetTag("USA")
			local vicTag = CCountryDataBase.GetTag("VIC")
			
			local loVicCountry = vicTag:GetCountry()
			local loUsaCountry = usaTag:GetCountry()
			
			local loRelation = ministerCountry:GetRelation(vicTag)
			
			if loVicCountry:Exists()
			and not(loRelation:HasAlliance())
			and not(loVicCountry:HasFaction())
			and not(loRelation:HasWar()) then
				if ministerCountry:GetFaction() == loUsaCountry:GetFaction()
				and loUsaCountry:HasFaction() then
					loStrategy:PrepareWar(vicTag, 100)
				end
			end
		end
	end
end

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	local lsActorTag = tostring(actor)
	
	if lsActorTag == "AST" 
	or lsActorTag == "CAN" 
	or lsActorTag == "SAF" 
	or lsActorTag == "NZL" 
	or lsActorTag == "FRA" 
	or lsActorTag == "USA" then
		score = score + 20
	end
	
	return score
end

-- Influence Ignore list
function P.InfluenceIgnore(minister)
	-- Ignore Afghanistan as they are not worth our time
	-- Ignore Ethiopia as they are going to get hammered by Italy
	-- Ignore Austria, Czechoslovakia as we will loose them
	-- Ignore Switzerland as there is no chance of them joining
	-- Ignore Vichy, they wont join anyone unles DOWed
	local laIgnoreList = {
		"SIK",
		"AFG",
		"ETH",
		"AUS",
		"CZE",
		"SCH",
		"VIC",
		"JAP",
		"ITA"};
	
	return laIgnoreList
end

-- Influence Monitor list
function P.InfluenceMonitor(minister)
	local laMonitorList = {
		"TUR", -- Europe
		"SPA",
		"SPR",
		"POR",
		"SWE",
		"YUG",
		"ARG", -- South America
		"BOL",
		"BRA",
		"CHL",
		"COL",
		"ECU",
		"GUY",
		"PAR",
		"PRU",
		"URU",
		"VEN",
		"CUB", -- Central America
		"COS",
		"DOM",
		"GUA",
		"HAI",
		"HON",
		"MEX",
		"NIC",
		"PAN",
		"SAL"};
	
	return laMonitorList
end

function P.DiploScore_InfluenceNation( score, ai, actor, recipient, observer )
	local lsRepTag = tostring(recipient)
	
	if lsRepTag == "HUN" or lsRepTag == "ROM" or lsRepTag == "BUL" or lsRepTag == "FIN" then
		score = score - 20
	elseif lsRepTag == "AST" or lsRepTag == "CAN" or lsRepTag == "SAF" or lsRepTag == "NZL" or lsRepTag == "USA" then
		score = score + 70
	end

	return score
end


-- Produce slightly better trained troops
function P.CallLaw_training_laws(minister, voCurrentLaw)
	local _ADVANCED_TRAINING_ = 29
	return CLawDataBase.GetLaw(_ADVANCED_TRAINING_)
end

return AI_ENG
