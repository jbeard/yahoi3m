-----------------------------------------------------------
-- LUA Hearts of Iron 3 Research File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 4/23/2010
-----------------------------------------------------------

-- Techs that are used in the main file to be ignored
--   techname|level (level must be 1-9 a 0 means ignore all
--   these local variables can be overiden in the country specific files
--   use as the first tech name the word "all" and it will cause the AI to ignore all the techs


-- Countries with a port and 20+ IC or is a Major
local DefaultMixTechs = {}

function DefaultMixTechs.LandTechs()
	local ignoreTech = {"cavalry_smallarms|3", 
		"cavalry_support|3",
		"cavalry_guns|3", 
		"cavalry_at|3",
		"militia_smallarms|0",
		"militia_support|0",
		"militia_guns|0",
		"militia_at|0",
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
		
function DefaultMixTechs.LandDoctrinesTechs()
	local ignoreTech = {"mobile_warfare|0",
		"elastic_defence|0",
		"spearhead_doctrine|0",
		"schwerpunkt|0",
		"blitzkrieg|0",
		"operational_level_command_structure|0",
		"tactical_command_structure|0",
		"delay_doctrine|0",
		"integrated_support_doctrine|0",
		"superior_firepower|0",
		"mechanized_offensive|0",
		"combined_arms_warfare|0",
		"grand_battle_plan|3",
		"large_front|3",
		"guerilla_warfare|0",
		"peoples_army|0",
		"large_formations|0"};

	return ignoreTech
end

function DefaultMixTechs.AirTechs()
	local ignoreTech = {"basic_four_engine_airframe|0",
		"basic_strategic_bomber|0",
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

function DefaultMixTechs.AirDoctrineTechs()
	local ignoreTech = {"forward_air_control|0",
		"battlefield_interdiction|0",
		"bomber_targerting_focus|0",
		"fighter_targerting_focus|0", 
		"heavy_bomber_pilot_training|0",
		"heavy_bomber_groundcrew_training|0",
		"strategic_bombardment_tactics|0",
		"airborne_assault_tactics|0",
		"strategic_air_command|0"};
		
	return ignoreTech
end

function DefaultMixTechs.NavalTechs()
	local ignoreTech = {"heavycruiser_technology|0",
		"heavycruiser_armament|0",
		"heavycruiser_antiaircraft|0",
		"heavycruiser_engine|0",
		"heavycruiser_armour|0",
		"battlecruiser_technology|0",
		"battleship_technology|0",
		"capitalship_armament|0",
		"battlecruiser_antiaircraft|0",
		"battlecruiser_engine|0",
		"battlecruiser_armour|0",
		"battleship_antiaircraft|0",
		"battleship_engine|0",
		"battleship_armour|0",
		"super_heavy_battleship_technology|0",
		"cag_development|0",
		"escort_carrier_technology|0",
		"carrier_technology|0",
		"carrier_antiaircraft|0",
		"carrier_engine|0",
		"carrier_armour|0",
		"carrier_hanger|0",
		"largewarship_radar|0"};
		
	return ignoreTech
end

function DefaultMixTechs.NavalDoctrineTechs()
	local ignoreTech = {"carrier_group_doctrine|0",
		"carrier_crew_training|0",
		"carrier_task_force|0",
		"naval_underway_repleshment|0",
		"radar_training|0",
		"battlefleet_concentration_doctrine|0",
		"battleship_crew_training|0",
		"cruiser_warfare|0",
		"cruiser_crew_training|0",
		"basing|0"};
		
	return ignoreTech
end

function DefaultMixTechs.IndustrialTechs()
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

function DefaultMixTechs.SecretWeaponTechs()
	local ignoreTech = {"all"};
		
	return ignoreTech
end

function DefaultMixTechs.OtherTechs()
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
		
			
			
			
-- Land based countries
local DefaultLandTechs = {}

function DefaultLandTechs.LandTechs()
	local ignoreTech = {"cavalry_smallarms|3", 
		"cavalry_support|3",
		"cavalry_guns|3", 
		"cavalry_at|3",
		"militia_smallarms|0",
		"militia_support|0",
		"militia_guns|0",
		"militia_at|0",
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

function DefaultLandTechs.LandDoctrinesTechs()
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
		"large_formations|0"};

	return ignoreTech
end

function DefaultLandTechs.AirTechs()
	local ignoreTech = {"nav_development|0",
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

function DefaultLandTechs.AirDoctrineTechs()
	local ignoreTech = {"forward_air_control|0",
		"battlefield_interdiction|0",
		"bomber_targerting_focus|0",
		"fighter_targerting_focus|0", 
		"nav_pilot_training|0",
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

function DefaultLandTechs.NavalTechs()
	local ignoreTech = {"all"};
		
	return ignoreTech
end

function DefaultLandTechs.NavalDoctrineTechs()
	local ignoreTech = {"all"};
		
	return ignoreTech
end

function DefaultLandTechs.IndustrialTechs()
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

function DefaultLandTechs.SecretWeaponTechs()
	local ignoreTech = {"all"};
		
	return ignoreTech
end

function DefaultLandTechs.OtherTechs()
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

--- END OF TECH IGNORE DEFAULTS



-- ###################################
-- # Main Method called by the EXE
-- #####################################
function TechMinister_Tick(minister, set_sliders, set_research)
	local ministerTag = minister:GetCountryTag()
	local ai = minister:GetOwnerAI()
	local ministerCountry = minister:GetCountry()

	local ResearchSlotsAllowed
	
	if set_sliders then
		-- Calling balance sliders like this allows me to get what the new Research slot count would be
		--    once the sliders are shifted
		ResearchSlotsAllowed = ministerCountry:GetTotalLeadership() * BalanceLeadershipSliders(ai, ministerCountry)
	else
		-- Sliders already set by player
		ResearchSlotsAllowed = ministerCountry:GetAllowedResearchSlots()
	end
	
	if set_research then
		-- This command is needed incase it gets convereted by LUA
		--  into userdata do to being a float!
		local ResearchSlotsNeeded = tonumber(tostring(ResearchSlotsAllowed - ministerCountry:GetNumberOfCurrentResearch()))
		
		Process_Tech((CCurrentGameState.GetCurrentDate():GetYear()), ResearchSlotsAllowed, ResearchSlotsNeeded, ai, minister, ministerCountry)
	end
end

-- Balances the research sliders	
-- NOTE: * If you adjust the percentage for LEADERSHIP_DIPLOMACY 
--    you must up the influence LUA code!
function BalanceLeadershipSliders(ai, ministerCountry)
	-- Setup default sliders
	local currentDiplomats = ministerCountry:GetDiplomaticInfluence():Get()
	local isMajor =  ministerCountry:IsMajor()

	local LEADERSHIP_RESEARCH
	local LEADERSHIP_ESPIONAGE = 0.08
	local LEADERSHIP_DIPLOMACY = 0.15 -- * review NOTE
	local LEADERSHIP_NCO = 0.1
	
	-- Officer ratio.
	local officer_ratio = ministerCountry:GetOfficerRatio():Get()
		
	-- Checks to see if you are loosing officers
	--   if so take them from research
	if  officer_ratio < 0.7 then
		LEADERSHIP_NCO = 0.5
	elseif  officer_ratio < 0.9 then
		LEADERSHIP_NCO = 0.3
	elseif officer_ratio  < 1.2 then
		LEADERSHIP_NCO = 0.2
	
	-- Check to see if you have to many officers
	--    if so increase research
	elseif officer_ratio > 1.4 then
		LEADERSHIP_NCO = 0.0
	end
	
	-- If the AI has to many diplomats then set it to 0 (100 is max you can have)
	if isMajor == true and currentDiplomats >= 50 or isMajor == false and currentDiplomats >= 25 then
		LEADERSHIP_DIPLOMACY = 0
	-- AI is loosing to many diplomats double what the default is
	elseif currentDiplomats == 0 then
		LEADERSHIP_DIPLOMACY = LEADERSHIP_DIPLOMACY + LEADERSHIP_DIPLOMACY
	end

	-- Research is whatever is left over
	LEADERSHIP_RESEARCH = (((1 - LEADERSHIP_ESPIONAGE) - LEADERSHIP_DIPLOMACY) - LEADERSHIP_NCO)
	
	local command = CChangeLeadershipCommand( ministerCountry:GetCountryTag(), LEADERSHIP_NCO, LEADERSHIP_DIPLOMACY, LEADERSHIP_ESPIONAGE, LEADERSHIP_RESEARCH)
	ai:Post( command )
	
	return LEADERSHIP_RESEARCH
end

-- Processes the main tech reasearch for the specified country
--   designed to be a recursive call in case the AI needs to research in the future
function Process_Tech(pYear, ResearchSlotsAllowed, ResearchSlotsNeeded, ai, minister, ministerCountry)
	-- Performance check, exit if there are no slots available
	if ResearchSlotsNeeded < 0.01 then
		return
	end
	
	local ministerTag = minister:GetCountryTag()
	local techStatus = ministerCountry:GetTechnologyStatus()
		
	--Utils.LUA_DEBUGOUT("Country: " .. tostring(ministerTag))
		
	-- List of Arrays to hold the techs the AI can research
	local landBased = {}
	local landDoctrines = {}
	local airBased = {}
	local airDoctrines = {}
	local navalBased = {}
	local navalDoctrines = {}
	local industrial = {}
	local secretWeapons = {}
	local other = {}
	
	-- Counts to hold what the AI is currently researching
	local landBasedCount = 0
	local landDoctrinesCount = 0
	local airBasedCount = 0
	local airDoctrinesCount = 0
	local navalBasedCount = 0
	local navalDoctrinesCount = 0
	local industrialCount = 0
	local secretWeaponsCount = 0
	local otherCount = 0
		
	-- Weight system % based 1.0 = 100%
	local landBasedWeight
	local landDoctrinesWeight
	local airBasedWeight
	local airDoctrinesWeight
	local navalBasedWeight
	local navalDoctrinesWeight
	local industrialWeight
	local secretWeaponsWeight
	local otherWeight
	
	-- If true it will use Default Land if nothing is specified in the country specific files
	--     if set to false it will use the mixed default settings
	local lbLandBased = true

	-- First determine research weights
	--    does the country have country specific weights
	if Utils.HasCountryAIFunction(ministerTag, "TechWeights") then
		local laTechWeights = Utils.CallCountryAI(ministerTag, "TechWeights", minister)

		-- Move specialized weights to local variables
		landBasedWeight = laTechWeights[1]
		landDoctrinesWeight = laTechWeights[2]
		airBasedWeight = laTechWeights[3]
		airDoctrinesWeight = laTechWeights[4]
		navalBasedWeight = laTechWeights[5]
		navalDoctrinesWeight = laTechWeights[6]
		industrialWeight = laTechWeights[7]
		secretWeaponsWeight = laTechWeights[8]
		otherWeight = laTechWeights[9]
		
		-- In case they did not specified ignore lists this tells it which 
		--    default list to use
		lbLandBased =  laTechWeights[10]
		
	-- Country does not have country specific weights so use defaults
	else
		-- Just in case new Major Powers get declared
		if ministerCountry:IsMajor() then
			-- All Majors powers can do land and naval defaults
			lbLandBased = false
	
			landBasedWeight = 0.26
			landDoctrinesWeight = 0.10
			airBasedWeight = 0.20
			airDoctrinesWeight = 0.15
			navalBasedWeight = 0.06
			navalDoctrinesWeight = 0.05
			industrialWeight = 0.10
			secretWeaponsWeight = 0.04
			otherWeight = 0.04
			
		-- Check to see if the minor has any ports and if it has more than 20 IC
		elseif ministerCountry:GetNumOfPorts() > 0 and ministerCountry:GetTotalIC() >= 20 then
			lbLandBased = false
			
			landBasedWeight = 0.20
			landDoctrinesWeight = 0.09
			airBasedWeight = 0.12
			airDoctrinesWeight = 0.15
			navalBasedWeight = 0.18
			navalDoctrinesWeight = 0.10
			industrialWeight = 0.14
			secretWeaponsWeight = 0.00
			otherWeight = 0.02
		
		-- If the minor has no ports and less than 20 IC then concentrate on land techs
		else
			landBasedWeight = 0.30
			landDoctrinesWeight = 0.15
			airBasedWeight = 0.20
			airDoctrinesWeight = 0.15
			navalBasedWeight = 0.0
			navalDoctrinesWeight = 0.0
			industrialWeight = 0.15
			secretWeaponsWeight = 0.00
			otherWeight = 0.05		

		end	
	end
	
	-- Figure out what the AI currently is researching
	local techFolder
	
	for tech in ministerCountry:GetCurrentResearch() do
		techFolder = tostring(tech:GetFolder():GetKey())
		
		if techFolder == "infantry_folder" or techFolder == "armour_folder" then
			landBasedCount = landBasedCount + 1
		elseif techFolder == "land_doctrine_folder" then
			landDoctrinesCount = landDoctrinesCount + 1
		elseif techFolder == "fighter_folder" or techFolder == "bomber_folder" then
			airBasedCount = airBasedCount + 1
		elseif techFolder == "air_doctrine_folder" then
			airDoctrinesCount = airDoctrinesCount + 1
		elseif techFolder == "smallship_folder" or techFolder == "capitalship_folder" then
			navalBasedCount = navalBasedCount + 1
		elseif techFolder == "naval_doctrine_folder" then
			tnavalDoctrinesCount = navalDoctrinesCount + 1
		elseif techFolder == "industry_folder" then
			industrialCount = industrialCount + 1
		elseif techFolder == "secretweapon_folder" then
			secretWeaponsCount = secretWeaponsCount + 1
		else
			otherCount = otherCount + 1
		end		
	end
	
	-- Store the Ignore lists in local arrays
	local laLandTechsIgnore = GetTechIgnoreList(ministerTag, "LandTechs")
	local laLandDoctrinesTechsIgnore = GetTechIgnoreList(ministerTag, "LandDoctrinesTechs")
	local laAirTechsIgnore = GetTechIgnoreList(ministerTag, "AirTechs")
	local laAirDoctrineTechsIgnore = GetTechIgnoreList(ministerTag, "AirDoctrineTechs")
	local laNavalTechsIgnore = GetTechIgnoreList(ministerTag, "NavalTechs")
	local laNavalDoctrineTechsIgnore = GetTechIgnoreList(ministerTag, "NavalDoctrineTechs")
	local laIndustrialTechsIgnore = GetTechIgnoreList(ministerTag, "IndustrialTechs")
	local laSecretWeaponTechsIgnore = GetTechIgnoreList(ministerTag, "SecretWeaponTechs")
	local laOtherTechsTechsIgnore = GetTechIgnoreList(ministerTag, "OtherTechs")
	
	-- Figure out what the AI can research
	for tech in CTechnologyDataBase.GetTechnologies() do
		if  minister:CanResearch(tech) and tech:IsValid() then
			local nYear = techStatus:GetYear(tech, (techStatus:GetLevel(tech) + 1))
			
			-- Concentrate only on techs for the year requested or less
			--- Penalties are way to high to go into the future
			if nYear <= pYear then
				techFolder = tostring(tech:GetFolder():GetKey())
				
				if techFolder == "infantry_folder" or techFolder == "armour_folder" then
					-- The tech is good so add it to research list
					if TechIgnore(techStatus:GetLevel(tech), tostring(tech:GetKey()), lbLandBased, laLandTechsIgnore) == false then
						table.insert( landBased, tech )
					end

				elseif techFolder == "land_doctrine_folder" then
					-- The tech is good so add it to research list
					if TechIgnore(techStatus:GetLevel(tech), tostring(tech:GetKey()), lbLandBased, laLandDoctrinesTechsIgnore) == false then
						table.insert( landDoctrines, tech )
					end
				
				elseif techFolder == "fighter_folder" or techFolder == "bomber_folder" then
					-- The tech is good so add it to research list
					if TechIgnore(techStatus:GetLevel(tech), tostring(tech:GetKey()), lbLandBased, laAirTechsIgnore) == false then
						table.insert( airBased, tech )
					end
				
				elseif techFolder == "air_doctrine_folder" then
					-- The tech is good so add it to research list
					if TechIgnore(techStatus:GetLevel(tech), tostring(tech:GetKey()), lbLandBased, laAirDoctrineTechsIgnore) == false then
						table.insert( airDoctrines, tech )
					end
					
				elseif techFolder == "smallship_folder" or techFolder == "capitalship_folder" then
					-- The tech is good so add it to research list
					if TechIgnore(techStatus:GetLevel(tech), tostring(tech:GetKey()), lbLandBased, laNavalTechsIgnore) == false then
						table.insert( navalBased, tech )
					end			
					
				elseif techFolder == "naval_doctrine_folder" then
					-- The tech is good so add it to research list
					if TechIgnore(techStatus:GetLevel(tech), tostring(tech:GetKey()), lbLandBased, laNavalDoctrineTechsIgnore) == false then
						table.insert( navalDoctrines, tech )
					end				
					
				elseif techFolder == "industry_folder" then
					-- The tech is good so add it to research list
					if TechIgnore(techStatus:GetLevel(tech), tostring(tech:GetKey()), lbLandBased, laIndustrialTechsIgnore) == false then
						table.insert( industrial, tech )
					end					
					
				elseif techFolder == "secretweapon_folder" then
					-- The tech is good so add it to research list
					if TechIgnore(techStatus:GetLevel(tech), tostring(tech:GetKey()), lbLandBased, laSecretWeaponTechsIgnore) == false then
						table.insert( secretWeapons, tech )
					end
				
				-- Theory Folder gets droped in here and anything else not recognized
				else
					-- The tech is good so add it to research list
					if TechIgnore(techStatus:GetLevel(tech), tostring(tech:GetKey()), lbLandBased, laOtherTechsTechsIgnore) == false then
						table.insert( other, tech )
					end
				end
			end
		end
	end
	
	-- Calculate what the AI wants to research in each category based on the weights
	---  AI may put more slots in that it can research but thats no big deal
	local _landBased = math.max(0, Utils.Round((ResearchSlotsAllowed * landBasedWeight) - landBasedCount))
	local _landDoctrines = math.max(0, Utils.Round((ResearchSlotsAllowed * landDoctrinesWeight) - landDoctrinesCount))
	local _airBased = math.max(0, Utils.Round((ResearchSlotsAllowed * airBasedWeight) - airBasedCount))
	local _airDoctrines = math.max(0, Utils.Round((ResearchSlotsAllowed * airDoctrinesWeight) - airDoctrinesCount))
	local _navalBased = math.max(0, Utils.Round((ResearchSlotsAllowed * navalBasedWeight) - navalBasedCount))
	local _navalDoctrines = math.max(0, Utils.Round((ResearchSlotsAllowed * navalDoctrinesWeight) - navalDoctrinesCount))
	local _industrial = math.max(0, Utils.Round((ResearchSlotsAllowed * industrialWeight) - industrialCount))
	local _secretWeapons = math.max(0, Utils.Round((ResearchSlotsAllowed * secretWeaponsWeight) - secretWeaponsCount))
	local _other = math.max(0, Utils.Round((ResearchSlotsAllowed * otherWeight) - otherCount))

	-- Get Table Lengths of Research we can do
	local liLandTechLength = table.getn(landBased)
	local liLandDocTechLength = table.getn(landDoctrines)
	local liAirTechLength = table.getn(airBased)
	local liAirDocTechLength = table.getn(airDoctrines)
	local liNavalTechLength = table.getn(navalBased)
	local liNavalDocTechLength = table.getn(navalDoctrines)
	local liIndustrialTechLength = table.getn(industrial)
	local liSecretTechLength = table.getn(secretWeapons)
	local liOtherTechLength = table.getn(other)

	
	-- Holds extra research slots that the AI is unable to use
	local ExtraSlots = ResearchSlotsNeeded - _landBased - _landDoctrines - _airBased - _airDoctrines - _navalBased - _navalDoctrines - _industrial - _secretWeapons - _other
	
	-- First figure out if there are any Extra slots going to be left
	ExtraSlots = GetExtraSlots(ExtraSlots, _landBased, liLandTechLength)
	ExtraSlots = GetExtraSlots(ExtraSlots, _landDoctrines, liLandDocTechLength)
	ExtraSlots = GetExtraSlots(ExtraSlots, _airBased, liAirTechLength)
	ExtraSlots = GetExtraSlots(ExtraSlots, _airDoctrines, liAirDocTechLength)
	ExtraSlots = GetExtraSlots(ExtraSlots, _navalBased, liNavalTechLength)
	ExtraSlots = GetExtraSlots(ExtraSlots, _navalDoctrines, liNavalDocTechLength)
	ExtraSlots = GetExtraSlots(ExtraSlots, _industrial, liIndustrialTechLength)
	ExtraSlots = GetExtraSlots(ExtraSlots, _secretWeapons, liSecretTechLength)
	ExtraSlots = GetExtraSlots(ExtraSlots, _other, liOtherTechLength)

	-- Now Reseach each
	-- Performance check 
	--    Perform checks here since LUA copies everything and does not use reference pointing.
	if _landBased > 0 and liLandTechLength > 0 then
		landBased = ResearchTech(ai, ministerTag, _landBased, landBased)
	end
	if _landDoctrines > 0 and liLandDocTechLength > 0 then
		landDoctrines = ResearchTech(ai, ministerTag, _landDoctrines, landDoctrines)
	end
	if _airBased > 0 and liAirTechLength > 0 then
		airBased = ResearchTech(ai, ministerTag, _airBased, airBased)
	end
	if _airDoctrines > 0 and liAirDocTechLength > 0 then
		airDoctrines = ResearchTech(ai, ministerTag, _airDoctrines, airDoctrines)
	end
	if _navalBased > 0 and liNavalTechLength > 0 then
		navalBased = ResearchTech(ai, ministerTag, _navalBased, navalBased)
	end
	if _navalDoctrines > 0 and liNavalDocTechLength > 0 then
		navalDoctrines = ResearchTech(ai, ministerTag, _navalDoctrines, navalDoctrines)
	end
	if _industrial > 0 and liIndustrialTechLength > 0 then
		industrial = ResearchTech(ai, ministerTag, _industrial, industrial)
	end
	if _secretWeapons > 0 and liSecretTechLength > 0 then
		secretWeapons = ResearchTech(ai, ministerTag, _secretWeapons, secretWeapons)
	end
	if _other > 0 and liOtherTechLength > 0 then
		other = ResearchTech(ai, ministerTag, _other, other)
	end
	
	-- Now process the extra slots
	if ExtraSlots > 0 and liIndustrialTechLength > 0 then
		ExtraSlots = ResearchTechExtraSlots(ai, ministerTag, ExtraSlots, industrial)
	end
	if ExtraSlots > 0 and liLandTechLength > 0 then
		ExtraSlots = ResearchTechExtraSlots(ai, ministerTag, ExtraSlots, landBased)
	end
	if ExtraSlots > 0 and liAirTechLength > 0 then
		ExtraSlots = ResearchTechExtraSlots(ai, ministerTag, ExtraSlots, airBased)
	end
	if ExtraSlots > 0 and liNavalTechLength > 0 then
		ExtraSlots = ResearchTechExtraSlots(ai, ministerTag, ExtraSlots, navalBased)
	end
	if ExtraSlots > 0 and liLandDocTechLength > 0 then
		ExtraSlots = ResearchTechExtraSlots(ai, ministerTag, ExtraSlots, landDoctrines)
	end
	if ExtraSlots > 0 and liAirDocTechLength > 0 then
		ExtraSlots = ResearchTechExtraSlots(ai, ministerTag, ExtraSlots, airDoctrines)
	end
	if ExtraSlots > 0 and liNavalDocTechLength > 0 then
		ExtraSlots = ResearchTechExtraSlots(ai, ministerTag, ExtraSlots, navalDoctrines)
	end
	if ExtraSlots > 0 and liSecretTechLength > 0 then
		ExtraSlots = ResearchTechExtraSlots(ai, ministerTag, ExtraSlots, secretWeapons)
	end
	if ExtraSlots > 0 and liOtherTechLength > 0 then
		ExtraSlots = ResearchTechExtraSlots(ai, ministerTag, ExtraSlots, other)
	end
	
	if ExtraSlots > 0 then
		-- We have extra slots and no techs to research so go ahead and look into the future.
		Process_Tech((pYear + 1), ResearchSlotsAllowed, ExtraSlots, ai, minister, ministerCountry)
	end
end

function GetTechIgnoreList(ministerTag, vsTechType)
	-- Grab the correct ignore array to work with
	--    if country specific does not exist grab the default
	if Utils.HasCountryAIFunction(ministerTag, vsTechType) then
		return Utils.CallCountryAI(ministerTag, vsTechType, minister)
	else
		if vbLandBased == true then
			return DefaultLandTechs[vsTechType]()
		else
			return DefaultMixTechs[vsTechType]()
		end
	end
end

-- Decide if the tech is to be ignored or not
function TechIgnore(viTechLevel, vsTechName, vbLandBased, vaIgnoreTechs)
	local lbIgnoreTech = false
	
	local i = 1
	local TableLength = table.getn(vaIgnoreTechs)
	
	-- Performance check
	if TableLength > 0 then
		-- Ignores every tech in teh category if set to "all"
		if vaIgnoreTechs[1] == "all" then
			lbIgnoreTech = true
		else
			-- Loop through the ignore list see if the tech is on it
			while i <= TableLength do
				local liTechName =  string.sub(vaIgnoreTechs[i], 0, string.len(vaIgnoreTechs[i]) - 2)
				
				if vsTechName == liTechName then
					local TechLevel = tonumber(string.sub(vaIgnoreTechs[i], string.len(vaIgnoreTechs[i])))
					
					-- If the tech is the level specified or has it been marked for all levels
					---   then ignore it
					if viTechLevel == TechLevel or TechLevel == 0 then
						lbIgnoreTech = true
						i = TableLength
					end
				end
				
				i = i + 1
			end						
		end
	end
	
	return lbIgnoreTech
end

-- Select a random tech from the array
function ResearchTech(ai, ministerTag, ResearchCount, TechArray)
	local TableLength = table.getn(TechArray)
	local TechSelected
	
	-- Just makes sure it can loop with no issues, the GetExtraSlots already account for it being larger
	if ResearchCount > TableLength then
		ResearchCount = TableLength
	end
	
	local i = 0
	while i < ResearchCount do
		TechSelected = math.random(TableLength - i)
		ai:Post( CStartResearchCommand( ministerTag, TechArray[TechSelected] ) )
		-- Remove the tech from the array
		table.remove(TechArray, TechSelected)
		
		i = i + 1
	end
	
	return TechArray
end

-- Same as ResearchTech except it returns the ExtraSlots value after executing a research
function ResearchTechExtraSlots(ai, ministerTag, ExtraSlots, TechArray)
	local TableLength = table.getn(TechArray)
	local ResearchCount
	local TechSelected
	
	-- Just makes sure it can loop with no issues, the GetExtraSlots already account for it being larger
	if ExtraSlots >= TableLength then
		ResearchCount = TableLength
		ExtraSlots = ExtraSlots - TableLength
	else
		ResearchCount = ExtraSlots
		ExtraSlots = 0
	end
	
	local i = 0
	while i < ResearchCount do
		TechSelected = math.random(TableLength - i)
		ai:Post(CStartResearchCommand( ministerTag, TechArray[TechSelected]))
		-- Remove the tech from the array
		table.remove(TechArray, TechSelected)
		
		i = i + 1
	end
	
	return ExtraSlots
end

-- Figures out if there are more slots available than techs
--   this would occur if there are more slots than techs the AI can research in the category area
function GetExtraSlots(ExtraSlots, viResearchCount, viTechArrayLength)
	if viResearchCount > 0 then
		if viResearchCount > viTechArrayLength then
			ExtraSlots = ExtraSlots + (viResearchCount - viTechArrayLength)
		end
	end
	
	return ExtraSlots
end

