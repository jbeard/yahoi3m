
gProdRatio = { }

function LoadProductionRatio(minister, ministerCountry)
	local ministerTag = tostring(minister:GetCountryTag())
	--Utils.LUA_DEBUGOUT( "ENTER LoadProductionRatio function" )
	-- buffered entry and is already mechanized...done
	if gProdRatio[ministerTag] and gProdRatio[ministerTag]['mechanized']  == true then
		return gProdRatio[ministerTag]
	end

	local infantry = CSubUnitDataBase.GetSubUnit("infantry_brigade")
	local mountain = CSubUnitDataBase.GetSubUnit("bergsjaeger_brigade")
	local marine = CSubUnitDataBase.GetSubUnit("marine_brigade")
	local paratrooper = CSubUnitDataBase.GetSubUnit("paratrooper_brigade")
	local cavalry = CSubUnitDataBase.GetSubUnit("cavalry_brigade")
	local garrison = CSubUnitDataBase.GetSubUnit("garrison_brigade")
	local militia = CSubUnitDataBase.GetSubUnit("militia_brigade")

	local light_armor = CSubUnitDataBase.GetSubUnit("light_armor_brigade")
	local armor = CSubUnitDataBase.GetSubUnit("armor_brigade")
	local mechanized = CSubUnitDataBase.GetSubUnit("mechanized_brigade")
	local motorized = CSubUnitDataBase.GetSubUnit("motorized_brigade")

	local artillery = CSubUnitDataBase.GetSubUnit("artillery_brigade")
	local anti_tank = CSubUnitDataBase.GetSubUnit("anti_tank_brigade")
	local anti_air = CSubUnitDataBase.GetSubUnit("anti_air_brigade")
	local engineer = CSubUnitDataBase.GetSubUnit("engineer_brigade")
	local police = CSubUnitDataBase.GetSubUnit("police_brigade")
	local rocket_artillery = CSubUnitDataBase.GetSubUnit("rocket_artillery_brigade")
	local heavy_armor = CSubUnitDataBase.GetSubUnit("heavy_armor_brigade")
	local sh_armor = CSubUnitDataBase.GetSubUnit("super_heavy_armor_brigade")

	local armored_car = CSubUnitDataBase.GetSubUnit("armored_car_brigade")
	local sp_artillery = CSubUnitDataBase.GetSubUnit("sp_artillery_brigade")
	local sp_rct_artillery = CSubUnitDataBase.GetSubUnit("sp_rct_artillery_brigade")
	local tank_destroyer = CSubUnitDataBase.GetSubUnit("tank_destroyer_brigade")

	------------------------------------------GERMANY---------------------------------------------------
		--Utils.LUA_DEBUGOUT( "GERMANY" )
		-- First number is the % of chance to build this template when AI wants to build this type of division
		-- Be sure to have a total of 100%, no more no less
		-- CAUTION: if a brigade is not available in the choosen template, the first template will be build
		-- So, be sure that the first template of a type is the most basic template
		-- Next, you define the brigades of a template
		if ministerTag == 'GER' then
			if not gProdRatio['GER'] then
				gProdRatio['GER'] = {}
				gProdRatio['GER']['infantry_brigade'] = { 	-- Infantry
													{ 10, infantry, infantry, infantry };
													{ 30, infantry, infantry, infantry, artillery };
													{ 20, infantry, infantry, infantry, anti_tank };
													{ 10, infantry, infantry, infantry, anti_air };
													{ 15, infantry, infantry, infantry, rocket_artillery };
													{ 10, infantry, infantry, heavy_armor };
													{ 5, infantry, infantry, sh_armor }
												}
				gProdRatio['GER']['marine_brigade'] = {		-- Marine
													{ 100, marine, marine, marine }
												}
				gProdRatio['GER']['militia_brigade'] = {		-- Militia
													{ 100, militia, militia }
												}
				gProdRatio['GER']['garrison_brigade'] = {		-- Garrison
													{ 100, garrison, garrison }
												}
				gProdRatio['GER']['cavalry_brigade'] = {		-- Cavalry
													{ 100, cavalry, cavalry }
												}
				gProdRatio['GER']['bergsjaeger_brigade'] = {		-- Mountain
													{ 100, mountain, mountain, mountain }
												}
				gProdRatio['GER']['paratrooper_brigade'] = {	-- Paratrooper
													{ 100, paratrooper, paratrooper, paratrooper }
												}
				gProdRatio['GER']['light_armor_brigade'] = {	-- Light Armor
													{ 80, light_armor, light_armor, motorized };
													{ 10, light_armor, light_armor, motorized, engineer };
													{ 10, light_armor, light_armor, motorized, armored_car }
												}
				gProdRatio['GER']['motorized_brigade'] = {	-- Motorized
													{ 10, motorized, motorized };
													{ 15, motorized, motorized, armored_car };
													{ 15, motorized, motorized, engineer };
													{ 40, motorized, motorized, sp_artillery };
													{ 20, motorized, motorized, tank_destroyer }
												}
				gProdRatio['GER']['mechanized_brigade'] = {	-- mechanized
													{ 30, mechanized, mechanized, motorized };
													{ 30, mechanized, mechanized, sp_artillery };
													{ 20, mechanized, mechanized, tank_destroyer };
													{ 10, mechanized, mechanized, sp_rct_artillery };
													{ 10, mechanized, mechanized, engineer }
												}
			end

			if ministerCountry:GetTechnologyStatus():IsUnitAvailable(mechanized) then
				gProdRatio['GER']['armor_brigade'] = {		-- Armor with mechanized
													{ 35, armor, armor, mechanized };
													{ 30, armor, mechanized, sp_artillery };
													{ 25, armor, mechanized, tank_destroyer };
													{ 10, armor, mechanized, sp_rct_artillery }
												}
				gProdRatio['GER']['mechanized']  = true
			else
				gProdRatio['GER']['armor_brigade'] = {		-- Armor with motorized
													{ 50, armor, armor, motorized };
													{ 30, armor, motorized, sp_artillery };
													{ 20, armor, motorized, tank_destroyer }
												}
				gProdRatio['GER']['mechanized']  = false
			end
		end
		------------------------------------------SOVIET UNION---------------------------------------------------
		--Utils.LUA_DEBUGOUT( "SOVIET UNION" )
		-- First number is the % of chance to build this template when AI wants to build this type of division
		-- Be sure to have a total of 100%, no more no less
		-- CAUTION: if a brigade is not available in the choosen template, the first template will be build
		-- So, be sure that the first template of a type is the most basic template
		-- Next, you define the brigades of a template
		if ministerTag == 'SOV' then
			if not gProdRatio['SOV'] then
				gProdRatio['SOV'] = {}
				gProdRatio['SOV']['infantry_brigade'] = { 	-- Infantry
													{ 30, infantry, infantry, infantry };
													{ 25, infantry, infantry, infantry, artillery };
													{ 15, infantry, infantry, infantry, anti_tank };
													{ 10, infantry, infantry, infantry, anti_air };
													{ 10, infantry, infantry, heavy_armor };
													{ 5, infantry, infantry, sh_armor };
													{ 5, infantry, infantry, infantry, armored_car }
												}
				gProdRatio['SOV']['marine_brigade'] = {		-- Marine
													{ 100, marine, marine, marine }
												}
				gProdRatio['SOV']['militia_brigade'] = {		-- Militia
													{ 100, militia, militia, militia }
												}
				gProdRatio['SOV']['garrison_brigade'] = {		-- Garrison
													{ 100, garrison, garrison }
												}
				gProdRatio['SOV']['cavalry_brigade'] = {		-- Cavalry
													{ 100, cavalry, cavalry, cavalry }
												}
				gProdRatio['SOV']['bergsjaeger_brigade'] = {		-- Mountain
													{ 100, mountain, mountain, mountain }
												}
				gProdRatio['SOV']['paratrooper_brigade'] = {	-- Paratrooper
													{ 100, paratrooper, paratrooper, paratrooper }
												}
				gProdRatio['SOV']['light_armor_brigade'] = {	-- Light Armor
													{ 5, light_armor, light_armor, armored_car };
													{ 95, light_armor, light_armor, motorized }
												}
				gProdRatio['SOV']['motorized_brigade'] = {	-- Motorized
													{ 25, motorized, motorized };
													{ 15, motorized, motorized, armored_car };
													{ 35, motorized, motorized, sp_artillery };
													{ 25, motorized, motorized, tank_destroyer }
												}
				gProdRatio['SOV']['mechanized_brigade'] = {	-- mechanized
													{ 30, mechanized, mechanized, motorized };
													{ 35, mechanized, mechanized, sp_artillery };
													{ 15, mechanized, mechanized, tank_destroyer };
													{ 15, mechanized, mechanized, sp_rct_artillery };
													{ 5, mechanized, mechanized, engineer }

							}
			end

			if ministerCountry:GetTechnologyStatus():IsUnitAvailable(mechanized) then
				gProdRatio['SOV']['armor_brigade'] = {		-- Armor with mechanized
													{ 30, armor, armor, mechanized };
													{ 25, armor, armor, mechanized, sp_artillery };
													{ 25, armor, armor, mechanized, tank_destroyer };
													{ 20, armor, armor, mechanized, sp_rct_artillery }
												}
				gProdRatio['SOV']['mechanized']  = true
			else
				gProdRatio['SOV']['armor_brigade'] = {		-- Armor with motorized
													{ 40, armor, armor, motorized };
													{ 35, armor, armor, motorized, sp_artillery };
													{ 25, armor, armor, motorized, tank_destroyer }
												}
				gProdRatio['SOV']['mechanized']  = false
			end
		end
		------------------------------------------UNITED STATES OF AMERICA---------------------------------------------------
		--Utils.LUA_DEBUGOUT( "USA" )
		-- First number is the % of chance to build this template when AI wants to build this type of division
		-- Be sure to have a total of 100%, no more no less
		-- CAUTION: if a brigade is not available in the choosen template, the first template will be build
		-- So, be sure that the first template of a type is the most basic template
		-- Next, you define the brigades of a template
		if ministerTag == 'USA' then
			if not gProdRatio['USA'] then
				gProdRatio['USA'] = {}
				gProdRatio['USA']['infantry_brigade'] = { 	-- Infantry
													{ 25, infantry, infantry, infantry };
													{ 30, infantry, infantry, infantry, artillery };
													{ 15, infantry, infantry, infantry, anti_tank };
													{ 10, infantry, infantry, infantry, anti_air };
													{ 5, infantry, infantry, heavy_armor };
													{ 5, infantry, infantry, sh_armor };
													{ 10, infantry, infantry, infantry, engineer }
												}
				gProdRatio['USA']['marine_brigade'] = {		-- Marine
													{ 100, marine, marine, marine }
												}
				gProdRatio['USA']['militia_brigade'] = {		-- Militia
													{ 100, militia, militia }
												}
				gProdRatio['USA']['garrison_brigade'] = {		-- Garrison
													{ 100, garrison, garrison }
												}
				gProdRatio['USA']['cavalry_brigade'] = {		-- Cavalry
													{ 100, cavalry, cavalry }
												}
				gProdRatio['USA']['bergsjaeger_brigade'] = {		-- Mountain
													{ 100, mountain, mountain, mountain }
												}
				gProdRatio['USA']['paratrooper_brigade'] = {	-- Paratrooper
													{ 100, paratrooper, paratrooper, paratrooper }
												}
				gProdRatio['USA']['light_armor_brigade'] = {	-- Light Armor
													{ 5, light_armor, light_armor, armored_car };
													{ 85, light_armor, light_armor, motorized };
													{ 10, light_armor, light_armor, motorized, engineer }
												}
				gProdRatio['USA']['motorized_brigade'] = {	-- Motorized
													{ 10, motorized, motorized };
													{ 20, motorized, motorized, armored_car };
													{ 10, motorized, motorized, engineer };
													{ 35, motorized, motorized, sp_artillery };
													{ 25, motorized, motorized, tank_destroyer }
												}
				gProdRatio['USA']['mechanized_brigade'] = {	-- mechanized
													{ 45, mechanized, mechanized, motorized };
													{ 25, mechanized, mechanized, sp_artillery };
													{ 20, mechanized, mechanized, tank_destroyer };
													{ 10, mechanized, mechanized, engineer }
												}
			end

			if ministerCountry:GetTechnologyStatus():IsUnitAvailable(mechanized) then
				gProdRatio['USA']['armor_brigade'] = {		-- Armor with mechanized
													{ 40, armor, armor, mechanized };
													{ 30, armor, mechanized, sp_artillery };
													{ 20, armor, mechanized, tank_destroyer };
													{ 10, armor, mechanized, engineer }
												}
				gProdRatio['USA']['mechanized']  = true
			else
				gProdRatio['USA']['armor_brigade'] = {		-- Armor with motorized
													{ 40, armor, armor, motorized };
													{ 30, armor, motorized, sp_artillery };
													{ 20, armor, motorized, tank_destroyer };
													{ 10, armor, motorized, engineer }
												}
				gProdRatio['USA']['mechanized']  = false
			end
		end
		------------------------------------------UNITED KINGDOM---------------------------------------------------
		--Utils.LUA_DEBUGOUT( "UNITED KINGDOM" )
		-- First number is the % of chance to build this template when AI wants to build this type of division
		-- Be sure to have a total of 100%, no more no less
		-- CAUTION: if a brigade is not available in the choosen template, the first template will be build
		-- So, be sure that the first template of a type is the most basic template
		-- Next, you define the brigades of a template
		if ministerTag == 'ENG' then
			if not gProdRatio['ENG'] then
				gProdRatio['ENG'] = {}
				gProdRatio['ENG']['infantry_brigade'] = { 	-- Infantry
													{ 35, infantry, infantry, infantry };
													{ 30, infantry, infantry, artillery };
													{ 10, infantry, infantry, anti_tank };
													{ 15, infantry, infantry, anti_air };
													{ 10, infantry, infantry, infantry, engineer }
												}
				gProdRatio['ENG']['marine_brigade'] = {		-- Marine
													{ 100, marine, marine, marine }	
											}
				gProdRatio['ENG']['militia_brigade'] = {		-- Militia
													{ 100, militia, militia, militia }
												}
				gProdRatio['ENG']['garrison_brigade'] = {		-- Garrison
													{ 100, garrison, garrison }
												}
				gProdRatio['ENG']['cavalry_brigade'] = {		-- Cavalry
													{ 100, cavalry, cavalry }
												}
				gProdRatio['ENG']['bergsjaeger_brigade'] = {		-- Mountain
													{ 100, mountain, mountain, mountain }
												}
				gProdRatio['ENG']['paratrooper_brigade'] = {	-- Paratrooper
													{ 100, paratrooper, paratrooper, paratrooper }
												}
				gProdRatio['ENG']['light_armor_brigade'] = {	-- Light Armor
													{ 5, light_armor, light_armor, armored_car };
													{ 85, light_armor, light_armor, motorized };
													{ 10, light_armor, light_armor, motorized, engineer }
												}
				gProdRatio['ENG']['motorized_brigade'] = {	-- Motorized
													{ 60, motorized, motorized };
													{ 10, motorized, motorized, engineer };
													{ 30, motorized, motorized, sp_artillery }
												}
				gProdRatio['ENG']['mechanized_brigade'] = {	-- mechanized
													{ 50, mechanized, mechanized, motorized };
													{ 30, mechanized, mechanized, sp_artillery };
													{ 10, mechanized, mechanized, tank_destroyer };
													{ 10, mechanized, mechanized, engineer }
												}
			end

			if ministerCountry:GetTechnologyStatus():IsUnitAvailable(mechanized) then
				gProdRatio['ENG']['armor_brigade'] = {		-- Armor with mechanized
													{ 40, armor, armor, mechanized };
													{ 40, armor, mechanized, sp_artillery };
													{ 15, armor, mechanized, tank_destroyer };
													{ 5, armor, mechanized, engineer }
												}
				gProdRatio['ENG']['mechanized']  = true
			else
				gProdRatio['ENG']['armor_brigade'] = {		-- Armor with motorized
													{ 40, armor, armor, motorized };
													{ 40, armor, motorized, sp_artillery };
													{ 15, armor, motorized, tank_destroyer };
													{ 10, armor, motorized, engineer }
												}
				gProdRatio['ENG']['mechanized']  = false
			end
		end
		------------------------------------------FRANCE---------------------------------------------------
		--Utils.LUA_DEBUGOUT( "FRANCE" )
		-- First number is the % of chance to build this template when AI wants to build this type of division
		-- Be sure to have a total of 100%, no more no less
		-- CAUTION: if a brigade is not available in the choosen template, the first template will be build
		-- So, be sure that the first template of a type is the most basic template
		-- Next, you define the brigades of a template
		if ministerTag == 'FRA' then
			if not gProdRatio['FRA'] then
				gProdRatio['FRA'] = {}
				gProdRatio['FRA']['infantry_brigade'] = { 	-- Infantry
													{ 35, infantry, infantry, infantry };
													{ 35, infantry, infantry, artillery };
													{ 20, infantry, infantry, anti_tank };
													{ 10, infantry, infantry, anti_air }
												}
				gProdRatio['FRA']['marine_brigade'] = {		-- Marine
													{ 100, marine, marine, marine }
												}
				gProdRatio['FRA']['militia_brigade'] = {		-- Militia
													{ 100, militia, militia, militia }
												}
				gProdRatio['FRA']['garrison_brigade'] = {		-- Garrison
													{ 100, garrison, garrison }
												}
				gProdRatio['FRA']['cavalry_brigade'] = {		-- Cavalry
													{ 100, cavalry, cavalry }
												}
				gProdRatio['FRA']['bergsjaeger_brigade'] = {		-- Mountain
													{ 100, mountain, mountain, mountain }
												}
				gProdRatio['FRA']['paratrooper_brigade'] = {	-- Paratrooper
													{ 100, paratrooper, paratrooper, paratrooper }
												}
				gProdRatio['FRA']['light_armor_brigade'] = {	-- Light Armor
													{ 5, light_armor, light_armor, armored_car };
													{ 95, light_armor, light_armor, motorized }
												}
				gProdRatio['FRA']['motorized_brigade'] = {	-- Motorized
													{ 40, motorized, motorized };
													{ 40, motorized, motorized, sp_artillery };
													{ 20, motorized, motorized, tank_destroyer }
												}
				gProdRatio['FRA']['mechanized_brigade'] = {	-- mechanized
													{ 50, mechanized, mechanized, motorized };
													{ 30, mechanized, mechanized, sp_artillery };
													{ 20, mechanized, mechanized, tank_destroyer }
												}
			end

			if ministerCountry:GetTechnologyStatus():IsUnitAvailable(mechanized) then
				gProdRatio['FRA']['armor_brigade'] = {		-- Armor with mechanized
													{ 50, armor, armor, mechanized };
													{ 30, armor, mechanized, sp_artillery };
													{ 20, armor, mechanized, tank_destroyer }
												}
				gProdRatio['FRA']['mechanized']  = true
			else
				gProdRatio['FRA']['armor_brigade'] = {		-- Armor with motorized
													{ 50, armor, armor, motorized };
													{ 30, armor, motorized, sp_artillery };
													{ 20, armor, motorized, tank_destroyer }
												}
				gProdRatio['FRA']['mechanized']  = false
			end
		end
		------------------------------------------ITALY---------------------------------------------------
		--Utils.LUA_DEBUGOUT( "ITALY" )
		-- First number is the % of chance to build this template when AI wants to build this type of division
		-- Be sure to have a total of 100%, no more no less
		-- CAUTION: if a brigade is not available in the choosen template, the first template will be build
		-- So, be sure that the first template of a type is the most basic template
		-- Next, you define the brigades of a template
		if ministerTag == 'ITA' then
			if not gProdRatio['ITA'] then
				gProdRatio['ITA'] = {}
				gProdRatio['ITA']['infantry_brigade'] = { 	-- Infantry
													{ 50, infantry, infantry, infantry };
													{ 25, infantry, infantry, artillery };
													{ 5, infantry, infantry, anti_tank };
													{ 10, infantry, infantry, anti_air };
													{ 10, infantry, infantry, armored_car }
												}
				gProdRatio['ITA']['marine_brigade'] = {		-- Marine
													{ 100, marine, marine, marine }
												}
				gProdRatio['ITA']['militia_brigade'] = {		-- Militia
													{ 100, militia, militia, militia }
												}
				gProdRatio['ITA']['garrison_brigade'] = {		-- Garrison
													{ 100, garrison, garrison }
												}
				gProdRatio['ITA']['cavalry_brigade'] = {		-- Cavalry
													{ 100, cavalry, cavalry }
												}
				gProdRatio['ITA']['bergsjaeger_brigade'] = {		-- Mountain
													{ 100, mountain, mountain, mountain }
												}
				gProdRatio['ITA']['paratrooper_brigade'] = {	-- Paratrooper
													{ 100, paratrooper, paratrooper, paratrooper }
												}
				gProdRatio['ITA']['light_armor_brigade'] = {	-- Light Armor
													{ 5, light_armor, light_armor, armored_car };
													{ 95, light_armor, light_armor, motorized }
												}
				gProdRatio['ITA']['motorized_brigade'] = {	-- Motorized
													{ 60, motorized, motorized };
													{ 5, motorized, motorized, engineer };
													{ 30, motorized, motorized, sp_artillery };
													{ 5, motorized, motorized, tank_destroyer }
												}
				gProdRatio['ITA']['mechanized_brigade'] = {	-- mechanized
													{ 60, mechanized, mechanized, motorized };
													{ 30, mechanized, mechanized, sp_artillery };
													{ 5, mechanized, mechanized, tank_destroyer };
													{ 5, mechanized, mechanized, engineer }
												}
			end

			if ministerCountry:GetTechnologyStatus():IsUnitAvailable(mechanized) then
				gProdRatio['ITA']['armor_brigade'] = {		-- Armor with mechanized
													{ 60, armor, armor, mechanized };
													{ 30, armor, mechanized, sp_artillery };
													{ 10, armor, mechanized, tank_destroyer }
												}
				gProdRatio['ITA']['mechanized']  = true
			else
				gProdRatio['ITA']['armor_brigade'] = {		-- Armor with motorized
													{ 60, armor, armor, motorized };
													{ 30, armor, motorized, sp_artillery };
													{ 10, armor, motorized, tank_destroyer }
												}
				gProdRatio['ITA']['mechanized']  = false
			end
		end
		------------------------------------------JAPAN---------------------------------------------------
		--Utils.LUA_DEBUGOUT( "JAPAN" )
		-- First number is the % of chance to build this template when AI wants to build this type of division
		-- Be sure to have a total of 100%, no more no less
		-- CAUTION: if a brigade is not available in the choosen template, the first template will be build
		-- So, be sure that the first template of a type is the most basic template
		-- Next, you define the brigades of a template
		if ministerTag == 'JAP' then
			if not gProdRatio['JAP'] then
				gProdRatio['JAP'] = {}
				gProdRatio['JAP']['infantry_brigade'] = { 	-- Infantry
													{ 50, infantry, infantry, infantry };
													{ 40, infantry, infantry, artillery };
													{ 5, infantry, infantry, anti_air };
													{ 5, infantry, infantry, engineer }
												}
				gProdRatio['JAP']['marine_brigade'] = {		-- Marine
													{ 100, marine, marine, marine }
												}
				gProdRatio['JAP']['militia_brigade'] = {		-- Militia
													{ 100, militia, militia, militia }
												}
				gProdRatio['JAP']['garrison_brigade'] = {		-- Garrison
													{ 100, garrison, garrison, garrison }
												}
				gProdRatio['JAP']['cavalry_brigade'] = {		-- Cavalry
													{ 100, cavalry, cavalry, cavalry }
												}
				gProdRatio['JAP']['bergsjaeger_brigade'] = {		-- Mountain
													{ 100, mountain, mountain, mountain }
												}
				gProdRatio['JAP']['paratrooper_brigade'] = {	-- Paratrooper
													{ 100, paratrooper, paratrooper, paratrooper }
												}
				gProdRatio['JAP']['light_armor_brigade'] = {	-- Light Armor
													{ 20, light_armor, light_armor, motorized };
													{ 80, infantry, infantry, infantry }
												}
				gProdRatio['JAP']['motorized_brigade'] = gProdRatio['JAP']['infantry_brigade']
				gProdRatio['JAP']['mechanized_brigade'] = gProdRatio['JAP']['marine_brigade']
			end

			if ministerCountry:GetTechnologyStatus():IsUnitAvailable(mechanized) then
				gProdRatio['JAP']['armor_brigade'] = {		-- Armor with mechanized
													{ 60, marine, marine, marine };
													{ 40, armor, mechanized, engineer }
												}
				gProdRatio['JAP']['mechanized']  = true
			else
				gProdRatio['JAP']['armor_brigade'] = {		-- Armor with motorized
													{ 60, marine, marine, marine };
													{ 40, armor, motorized, engineer }
												}
				gProdRatio['JAP']['mechanized']  = false
			end
		end
	------------------------------------------OTHERS---------------------------------------------------
	--Utils.LUA_DEBUGOUT( "GENERIC" )
	-- First number is the % of chance to build this template when AI wants to build this type of division
	-- Be sure to have a total of 100%, no more no less
	-- CAUTION: if a brigade is not available in the choosen template, the first template will be build
	-- So, be sure that the first template of a type is the most basic template
	-- Next, you define the brigades of a template
	if not gProdRatio[ministerTag] then
		gProdRatio[ministerTag] = {}
		gProdRatio[ministerTag]['infantry_brigade'] = { 	-- Infantry
											{ 50, infantry, infantry, infantry };
											{ 30, infantry, infantry, artillery };
											{ 5, infantry, infantry, anti_tank };
											{ 5, infantry, infantry, anti_air };
											{ 5, infantry, infantry, heavy_armor }
										}
		gProdRatio[ministerTag]['marine_brigade'] = {		-- Marine
											{ 100, marine, marine, marine }
										}
		gProdRatio[ministerTag]['militia_brigade'] = {		-- Militia
											{ 100, militia, militia, militia }
										}
		gProdRatio[ministerTag]['garrison_brigade'] = {		-- Garrison
											{ 100, garrison, garrison, garrison }
										}
		gProdRatio[ministerTag]['cavalry_brigade'] = {		-- Cavalry
											{ 100, cavalry, cavalry, cavalry }
										}
		gProdRatio[ministerTag]['bergsjaeger_brigade'] = {		-- Mountain
											{ 100, mountain, mountain, mountain }
										}
		gProdRatio[ministerTag]['paratrooper_brigade'] = {	-- Paratrooper
											{ 100, paratrooper, paratrooper, paratrooper }
										}
		gProdRatio[ministerTag]['light_armor_brigade'] = {	-- Light Armor
											{ 5, light_armor, light_armor, armored_car };
											{ 95, light_armor, light_armor, motorized }
										}
		gProdRatio[ministerTag]['motorized_brigade'] = {	-- Motorized
											{ 60, motorized, motorized };
											{ 10, motorized, motorized, armored_car };
											{ 30, motorized, motorized, sp_artillery }
										}
		gProdRatio[ministerTag]['mechanized_brigade'] = {	-- mechanized
											{ 70, mechanized, mechanized, motorized };
											{ 30, mechanized, mechanized, sp_artillery }
										}

		if ministerCountry:GetTechnologyStatus():IsUnitAvailable(mechanized) then
			gProdRatio[ministerTag]['armor_brigade'] = {		-- Armor with mechanized
												{ 60, armor, armor, mechanized };
												{ 30, armor, mechanized, sp_artillery };
												{ 10, armor, mechanized, tank_destroyer }
											}
			gProdRatio[ministerTag]['mechanized']  = true
		else
			gProdRatio[ministerTag]['armor_brigade'] = {		-- Armor with motorized
												{ 60, armor, armor, motorized };
												{ 30, armor, motorized, sp_artillery };
												{ 10, armor, motorized, tank_destroyer }
											}
			gProdRatio[ministerTag]['mechanized']  = false
		end
	end
	-----------------------------------------

	--Utils.LUA_DEBUGOUT( "EXIT LoadProductionRatio function" )
	return gProdRatio[ministerTag]
end

--Darkzodiak
