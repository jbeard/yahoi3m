function LoadRestrictions(minister, ministerCountry)
	--Utils.LUA_DEBUGOUT( "ENTER LoadRestrictions function" )
	local ministerTag = tostring(minister:GetCountryTag())
	local ic_total = ministerCountry:GetTotalIC()
	local year = CCurrentGameState.GetCurrentDate():GetYear()
	local prod_restrictions = { }
	
	local battlecruiser = CSubUnitDataBase.GetSubUnit("battlecruiser")
	local battleship = CSubUnitDataBase.GetSubUnit("battleship")
	local carrier = CSubUnitDataBase.GetSubUnit("carrier")
	local destroyer = CSubUnitDataBase.GetSubUnit("destroyer")
	local escort_carrier = CSubUnitDataBase.GetSubUnit("escort_carrier")
	local heavy_cruiser = CSubUnitDataBase.GetSubUnit("heavy_cruiser")
	local light_cruiser = CSubUnitDataBase.GetSubUnit("light_cruiser")
	local nuclear_submarine = CSubUnitDataBase.GetSubUnit("nuclear_submarine")	
	local submarine = CSubUnitDataBase.GetSubUnit("submarine")
	local super_heavy_battleship = CSubUnitDataBase.GetSubUnit("super_heavy_battleship")
	local transport_ship = CSubUnitDataBase.GetSubUnit("transport_ship")
	
	local cag = CSubUnitDataBase.GetSubUnit("cag")
	local cas = CSubUnitDataBase.GetSubUnit("cas")
	local flying_bomb = CSubUnitDataBase.GetSubUnit("flying_bomb")
	local flying_rocket = CSubUnitDataBase.GetSubUnit("flying_rocket")
	local interceptor = CSubUnitDataBase.GetSubUnit("interceptor")
	local multi_role = CSubUnitDataBase.GetSubUnit("multi_role")	
	local naval_bomber = CSubUnitDataBase.GetSubUnit("naval_bomber")
	local rocket_interceptor = CSubUnitDataBase.GetSubUnit("rocket_interceptor")
	local strategic_bomber = CSubUnitDataBase.GetSubUnit("strategic_bomber")
	local tactical_bomber = CSubUnitDataBase.GetSubUnit("tactical_bomber")
	local transport_plane = CSubUnitDataBase.GetSubUnit("transport_plane")		
	----------------------------------------------------------------------------------------------------
	-- EXPLICATIONS
	
	-- prod_restrictions["battlecruiser"] = { 100, battlecruiser }
	-- prod_restrictions["what AI want to build"] = { % of chance to be built, name of the unit to build }
	
	-- You can add unit, for example:
	-- prod_restrictions["tactical_bomber"] = { 50, tactical_bomber, 50, cas }
	-- When it want to build a tactical bomber, AI will build 50% of time CAS instead
	
	-- You can restrict the construction of a unit too:
	-- prod_restrictions["transport_ship"] = { 10, transport_ship }
	-- AI will build only 10% of transport ship it wants

	----------------------------------------------------------------------------------------------------
	-- DEFAULT RESTRICTIONS
	-- Naval Restrictions
	prod_restrictions["battlecruiser"] = { 100, battlecruiser }
	prod_restrictions["battleship"] = { 100, battleship }
	prod_restrictions["carrier"] = { 100, carrier }
	prod_restrictions["destroyer"] = { 100, destroyer }
	prod_restrictions["escort_carrier"] = { 100, escort_carrier }
	prod_restrictions["heavy_cruiser"] = { 100, heavy_cruiser }
	prod_restrictions["light_cruiser"] = { 100, light_cruiser }
	prod_restrictions["nuclear_submarine"] = { 100, nuclear_submarine }
	prod_restrictions["submarine"] = { 100, submarine }
	prod_restrictions["super_heavy_battleship"] = { 100, super_heavy_battleship }
	prod_restrictions["transport_ship"] = { 100, transport_ship }
	
	-- Air Restrictions
	prod_restrictions["cag"] = { 100, cag }
	prod_restrictions["cas"] = { 100, cas }
	prod_restrictions["flying_bomb"] = { 100, flying_bomb }
	prod_restrictions["flying_rocket"] = { 100, flying_rocket }
	prod_restrictions["interceptor"] = { 100, interceptor }
	prod_restrictions["multi_role"] = { 100, multi_role }
	prod_restrictions["naval_bomber"] = { 100, naval_bomber }
	prod_restrictions["rocket_interceptor"] = { 100, rocket_interceptor }
	prod_restrictions["strategic_bomber"] = { 100, strategic_bomber}
	prod_restrictions["tactical_bomber"] = { 100, tactical_bomber }
	prod_restrictions["transport_plane"] = { 100, transport_plane }	
	
	-- SPECIFIC RESTRICTIONS
	------------------------------------------GERMANY---------------------------------------------------
	if ministerTag == 'GER' then
		--Utils.LUA_DEBUGOUT( "GERMANY" )
		
		-- More submarine for GER
		-- prod_restrictions["destroyer"] = { 50, destroyer, 50, submarine }
		-- prod_restrictions["heavy_cruiser"] = { 50, heavy_cruiser, 50, submarine }
		-- prod_restrictions["light_cruiser"] = { 50, light_cruiser, 50, submarine }
	
		prod_restrictions["naval_bomber"] = { 0, naval_bomber }					-- No need Naval Bomber until victory against SOV
		prod_restrictions["strategic_bomber"] = { 0, strategic_bomber} 			-- No need Strat. Bomber until victory against SOV
		prod_restrictions["tactical_bomber"] = { 50, cas, 50, tactical_bomber } -- Builds some CAS when GER needs Tac. Bombers
		
		-- If Germany conquer Soviet Union
		if  tostring(CCurrentGameState.GetProvince( 2613 ):GetController()) == 'GER'	--Controls Paris
		and tostring(CCurrentGameState.GetProvince( 1861 ):GetController()) == 'GER'	--Controls Berlin
		and tostring(CCurrentGameState.GetProvince( 1409 ):GetController()) == 'GER'	--Controls Moskva
		and tostring(CCurrentGameState.GetProvince( 2857 ):GetController()) == 'GER'	--Controls Stalingrad
		and tostring(CCurrentGameState.GetProvince( 782 ):GetController()) ~= 'SOV'		--SOV not controls Leningrad
		then
			prod_restrictions["naval_bomber"] = { 100, naval_bomber }					
			prod_restrictions["strategic_bomber"] = { 100, strategic_bomber} 			
		end	
	------------------------------------------SOVIET UNION---------------------------------------------------
	elseif ministerTag == 'SOV' then
		--Utils.LUA_DEBUGOUT( "SOVIET UNION" )
		
		prod_restrictions["naval_bomber"] = { 0, naval_bomber }					-- No need Naval Bomber until victory against GER
		prod_restrictions["strategic_bomber"] = { 0, strategic_bomber} 			-- No need Strat. Bomber until victory against GER
	
		-- If Germany is no more a problem		
		if  tostring(CCurrentGameState.GetProvince( 2613 ):GetController()) ~= 'GER'		--GER not controls Paris
		and tostring(CCurrentGameState.GetProvince( 1928 ):GetController()) ~= 'SOV'		--GER not controls Warsaw
		and tostring(CCurrentGameState.GetProvince( 1409 ):GetController()) == 'SOV'		--Controls Moskva
		and tostring(CCurrentGameState.GetProvince( 2857 ):GetController()) == 'SOV'		--Controls Stalingrad
		and tostring(CCurrentGameState.GetProvince( 782 ):GetController()) == 'SOV'			--Controls Leningrad
		and tostring(CCurrentGameState.GetProvince( 4390 ):GetController()) == 'SOV'		--Controls Vladivostok
		and year >= 1943																	-- After 1943
		then
			prod_restrictions["naval_bomber"] = { 100, naval_bomber }					
			prod_restrictions["strategic_bomber"] = { 100, strategic_bomber} 		
		end
	------------------------------------------JAPAN---------------------------------------------------
	elseif ministerTag == 'JAP' then
		--Utils.LUA_DEBUGOUT( "JAPAN" )
		local mix = { 5, multi_role, 7, interceptor, 6, naval_bomber, 7, tactical_bomber, -- 25% Air
		14, cag, 7, carrier, 2, super_heavy_battleship, 6, battleship, 8, heavy_cruiser, 12, light_cruiser, 12, destroyer, 14, submarine  -- 75& naval
		}
		prod_restrictions["transport_ship"] = { 100, transport_ship }
		prod_restrictions["nuclear_submarine"] = { 100, nuclear_submarine }
		
		prod_restrictions["super_heavy_battleship"] = mix		
		prod_restrictions["battlecruiser"] = mix
		prod_restrictions["battleship"] = mix
		prod_restrictions["carrier"] = mix
		prod_restrictions["destroyer"] = mix
		prod_restrictions["escort_carrier"] = mix
		prod_restrictions["heavy_cruiser"] = mix
		prod_restrictions["light_cruiser"] = mix
		prod_restrictions["submarine"] = mix
		prod_restrictions["cag"] = mix
		prod_restrictions["cas"] = mix
		prod_restrictions["flying_bomb"] = mix
		prod_restrictions["flying_rocket"] = mix
		prod_restrictions["interceptor"] = mix
		prod_restrictions["multi_role"] = mix
		prod_restrictions["naval_bomber"] = mix
		prod_restrictions["rocket_interceptor"] = mix
		prod_restrictions["strategic_bomber"] = mix
		prod_restrictions["tactical_bomber"] = mix
		prod_restrictions["transport_plane"] = mix
	------------------------------------------UNITED KINGDOM---------------------------------------------------
	elseif ministerTag == 'ENG' then
		--Utils.LUA_DEBUGOUT( "UNITED KINGDOM" )
		
		prod_restrictions["transport_ship"] = { 10, transport_ship }			-- UK builds only 1/10 transport ship
	
	------------------------------------------FRANCE---------------------------------------------------
	elseif ministerTag == 'FRA' then
		--Utils.LUA_DEBUGOUT( "FRANCE" )
		
		prod_restrictions["transport_ship"] = { 33, transport_ship }			-- FRA builds only 1/3 transport ship			
	
	end	
	------------------------------------------COUNTRY WITH LESS THAN 40 IC---------------------------------------------------
	if ic_total <= 40 then
		--Utils.LUA_DEBUGOUT( "COUNTRY WITH 40- IC" )
		
		-- No need of Bombers for minor countries
		prod_restrictions["naval_bomber"] = { 0, naval_bomber }
		prod_restrictions["strategic_bomber"] = { 0, strategic_bomber}
		prod_restrictions["tactical_bomber"] = { 0, tactical_bomber }

	end
	---------------------------------------------------------------------------------------------------
	
	--Utils.LUA_DEBUGOUT( "EXIT LoadRestrictions function" )
	--Utils.LUA_DEBUGOUT("\n")
	return prod_restrictions
end

-- Darkzodiak