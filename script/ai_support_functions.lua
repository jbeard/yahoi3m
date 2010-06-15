local P = {}
Support = P

function P.Home_Spies_Interventionist(minister)
	local ministerTag = minister:GetCountryTag()
	local ministerCountry = minister:GetCountry()
	local liNationalUnity = ministerCountry:GetNationalUnity():Get()
	local liNeutrality = ministerCountry:GetNeutrality():Get()
	local liPartyPopularity = ministerCountry:AccessIdeologyPopularity():GetValue(ministerCountry:GetRulingIdeology()):Get()

	local newMission
	local command
	local lbHasBadSpies = false
	
	-- Calculate spies in country
	for loCountry in ministerCountry:GetSpyingOnUs() do
		local loSpyPresence = loCountry:GetCountry():GetSpyPresence(ministerTag)
		local loSpyMission = loSpyPresence:GetMission()
		
		if loSpyMission == SpyMission.SPYMISSION_LOWER_NATIONAL_UNITY  
			or loSpyMission == SpyMission.SPYMISSION_DISRUPT_RESEARCH
			or loSpyMission == SpyMission.SPYMISSION_DISRUPT_PRODUCTION
			or loSpyMission == SpyMission.SPYMISSION_SUPPORT_RESISTANCE then
			
			lbHasBadSpies = true
			break
		end
	end	

	if not(ministerCountry:IsAtWar()) then
		-- Counter Espionage check
		if lbHasBadSpies then 
			newMission = SpyMission.SPYMISSION_COUNTER_ESPIONAGE
		
		-- First Law Pass
		elseif liNeutrality > 65 then
			newMission = SpyMission.SPYMISSION_LOWER_NEUTRALITY
		elseif liNationalUnity < 60 then
			newMission = SpyMission.SPYMISSION_RAISE_NATIONAL_UNITY
			
		-- Second Law Pass
		elseif liNeutrality > 60 then
			newMission = SpyMission.SPYMISSION_LOWER_NEUTRALITY
		elseif liNationalUnity < 70 then
			newMission = SpyMission.SPYMISSION_RAISE_NATIONAL_UNITY

		-- Final Law
		elseif liNeutrality > 55 then
			newMission = SpyMission.SPYMISSION_LOWER_NEUTRALITY
			
		-- Support for our party is diminishing so raise it
		elseif liPartyPopularity < 35 then
			newMission = SpyMission.SPYMISSION_BOOST_RULING_PARTY
		
		else
			newMission = SpyMission.SPYMISSION_COUNTER_ESPIONAGE
		end
	else
		-- Make sure we are not close to surrendering
		if ( liNationalUnity < 70) then
			newMission = SpyMission.SPYMISSION_RAISE_NATIONAL_UNITY
		
		-- Bad Spies present so get rid of them
		elseif lbHasBadSpies then 
			newMission = SpyMission.SPYMISSION_COUNTER_ESPIONAGE

		-- Support for our party is diminishing so raise it
		elseif liPartyPopularity < 35 then
			newMission = SpyMission.SPYMISSION_BOOST_RULING_PARTY
			
		-- Having nothing else better to do
		elseif ( liNationalUnity < 90) then
			newMission = SpyMission.SPYMISSION_RAISE_NATIONAL_UNITY
			
		-- Nothing to do so Counter
		else
			newMission = SpyMission.SPYMISSION_COUNTER_ESPIONAGE
		end	
	end
	
	return newMission
end

function P.Build_Standard_Armor(ic, minister, armor_brigade, vbGoOver)
	if armor_brigade >= 2 and (ic > 5 or vbGoOver) then
		local ministerTag = minister:GetCountryTag()
		local ministerCountry = minister:GetCountry()
		local bBuildReserve = not ministerCountry:IsAtWar()
		local capitalProvId =  ministerCountry:GetActingCapitalLocation():GetProvinceID()

		local MainUnitType = CSubUnitDataBase.GetSubUnit("armor_brigade")
		local Motorized = CSubUnitDataBase.GetSubUnit("motorized_brigade")
		local TankDestroyer = CSubUnitDataBase.GetSubUnit("tank_destroyer_brigade")
		
		local lbMotorized = ministerCountry:GetTechnologyStatus():IsUnitAvailable(Motorized)
		local lbTD = ministerCountry:GetTechnologyStatus():IsUnitAvailable(TankDestroyer)

		local liMainUnitCost = ministerCountry:GetBuildCostIC( MainUnitType, 1, bBuildReserve):Get()
		local liMotorized = ministerCountry:GetBuildCostIC( Motorized, 1, bBuildReserve):Get()		
		local liTDCost = ministerCountry:GetBuildCostIC( TankDestroyer, 1, bBuildReserve):Get()
		
		local maxSerial = 2
		local countPerUnit = 2
		
		while armor_brigade > 0 do
			local bIC = ic - (liMainUnitCost * countPerUnit)

			-- Performance Check
			if bIC < 0 and not(vbGoOver) then
				break
			elseif ic < 0 then
				break
			end

			local buildcount
			
			if 	math.floor(armor_brigade / countPerUnit) >= maxSerial then
				buildcount = maxSerial
				armor_brigade = armor_brigade - (countPerUnit * maxSerial)
			else
				buildcount = math.floor(armor_brigade / countPerUnit)
				armor_brigade = 0
			end			
			
			if buildcount > 0 then
				local orderlist = SubUnitList()
				
				-- Add the amount of brigades requested of the main type
				SubUnitList.Append( orderlist, MainUnitType )
				SubUnitList.Append( orderlist, MainUnitType )
				
				-- Figure out what minor attachments to add
				if lbMotorized then
					SubUnitList.Append( orderlist, Motorized )
					bIC = bIC - liMotorized
				end
				if lbTD then
					SubUnitList.Append( orderlist, TankDestroyer )
					bIC = bIC - liTDCost
				end

				-- Performance Check
				if bIC < 0 and not(vbGoOver) then
					-- Exit the loop
					break
				else
					ic = bIC
					armor_brigade = armor_brigade - (countPerUnit * buildcount)
					minister:GetOwnerAI():Post(CConstructUnitCommand(ministerTag, orderlist, capitalProvId, buildcount, bBuildReserve, CNullTag(), CID()))
				end
			end
		end
	end
	
	return ic, armor_brigade
end

function P.Build_Standard_Motorized(ic, minister, motorized_brigade, vbGoOver)
	if motorized_brigade >= 2 and (ic > 5 or vbGoOver) then
		local ministerTag = minister:GetCountryTag()
		local ministerCountry = minister:GetCountry()
		local bBuildReserve = not ministerCountry:IsAtWar()
		local capitalProvId =  ministerCountry:GetActingCapitalLocation():GetProvinceID()

		local MainUnitType = CSubUnitDataBase.GetSubUnit("motorized_brigade")
		local TankDestroyer = CSubUnitDataBase.GetSubUnit("tank_destroyer_brigade")
		local SPArtillery = CSubUnitDataBase.GetSubUnit("sp_artillery_brigade")
		local SPRocket = CSubUnitDataBase.GetSubUnit("sp_rct_artillery_brigade")
		
		local lbTD = ministerCountry:GetTechnologyStatus():IsUnitAvailable(TankDestroyer)
		local lbSPArt = ministerCountry:GetTechnologyStatus():IsUnitAvailable(SPArtillery)
		local lbSPRoc = ministerCountry:GetTechnologyStatus():IsUnitAvailable(SPRocket)

		local liMainUnitCost = ministerCountry:GetBuildCostIC( MainUnitType, 1, bBuildReserve):Get()
		local liTDCost = ministerCountry:GetBuildCostIC( TankDestroyer, 1, bBuildReserve):Get()
		local liSPArtCost = ministerCountry:GetBuildCostIC( SPArtillery, 1, bBuildReserve):Get()		
		local liSPRocCost = ministerCountry:GetBuildCostIC( SPRocket, 1, bBuildReserve):Get()		
		
		local maxSerial = 4
		local countPerUnit = 2
		
		while motorized_brigade > 0 do
			local bIC = ic - (liMainUnitCost * countPerUnit)

			-- Performance Check
			if bIC < 0 and not(vbGoOver) then
				break
			elseif ic < 0 then
				break
			end

			local buildcount
			
			if 	math.floor(motorized_brigade / countPerUnit) >= maxSerial then
				buildcount = maxSerial
				motorized_brigade = motorized_brigade - (countPerUnit * maxSerial)
			else
				buildcount = math.floor(motorized_brigade / countPerUnit)
				motorized_brigade = 0
			end			
			
			if buildcount > 0 then
				local orderlist = SubUnitList()
				
				-- Add the amount of brigades requested of the main type
				SubUnitList.Append( orderlist, MainUnitType )
				SubUnitList.Append( orderlist, MainUnitType )
				
				-- See if you can attach and artillery unit
				if lbSPArt and lbSPRoc and lbTD then
					local liItemSelect = math.random(3)
					
					if liItemSelect == 1 then
						SubUnitList.Append( orderlist, TankDestroyer )
						bIC = bIC - liTDCost
						
					elseif liItemSelect == 2 then
						SubUnitList.Append( orderlist, SPRocket )
						bIC = bIC - liSPRocCost
					else
						SubUnitList.Append( orderlist, SPArtillery )
						bIC = bIC - liSPArtCost
					end
				elseif lbSPArt and lbTD then
					if math.random(2) == 2 then
						SubUnitList.Append( orderlist, TankDestroyer )
						bIC = bIC - liTDCost
					else
						SubUnitList.Append( orderlist, SPArtillery )
						bIC = bIC - liSPArtCost
					end	
				elseif lbSPRoc and lbTD then
					if math.random(2) == 2 then
						SubUnitList.Append( orderlist, TankDestroyer )
						bIC = bIC - liTDCost
					else
						SubUnitList.Append( orderlist, SPRocket )
						bIC = bIC - liSPRocCost
					end	
					
				elseif lbSPArt and lbSPRoc then
					if math.random(2) == 2 then
						SubUnitList.Append( orderlist, SPRocket )
						bIC = bIC - liSPRocCost
					else
						SubUnitList.Append( orderlist, SPArtillery )
						bIC = bIC - liSPArtCost
					end				
				elseif lbSPArt then
					SubUnitList.Append( orderlist, SPArtillery )
					bIC = bIC - liSPArtCost
				elseif lbSPRoc then
					SubUnitList.Append( orderlist, SPRocket )
					bIC = bIC - liSPRocCost
				elseif lbTD then
					SubUnitList.Append( orderlist, TankDestroyer )
					bIC = bIC - liTDCost
				-- No support exist just attach another motor
				--   yes this is additional to the count (WAD)
				else
					SubUnitList.Append( orderlist, MainUnitType )
					bIC = bIC - liMainUnitCost
				end

				-- Pontentially have 2 TDs attached for Combined Arms bonus
				if lbTD then
					SubUnitList.Append( orderlist, TankDestroyer )
					bIC = bIC - liTDCost
				end
				
				-- Performance Check
				if bIC < 0 and not(vbGoOver) then
					-- Exit the loop
					break
				else
					ic = bIC
					motorized_brigade = motorized_brigade - (countPerUnit * buildcount)
					minister:GetOwnerAI():Post(CConstructUnitCommand(ministerTag, orderlist, capitalProvId, buildcount, bBuildReserve, CNullTag(), CID()))
				end
			end
		end
	end

	return ic, motorized_brigade
end

function P.Build_Fort(ic, minister, viProvinceID, viMax, vbGoOver)
	local ministerTag = minister:GetCountryTag()
	local land_fort = CBuildingDataBase.GetBuilding( "land_fort" )
	local loProvince = CCurrentGameState.GetProvince(viProvinceID)
	local loBuilding = loProvince:GetBuilding(land_fort)

	if loBuilding:GetMax():Get() <= viMax and loProvince:GetCurrentConstructionLevel(land_fort) == 0 then
		local land_fortCost = ministerTag:GetCountry():GetBuildCost(land_fort):Get()
		
		if (ic - land_fortCost) >= 0 or vbGoOver then
			local constructCommand = CConstructBuildingCommand( ministerTag, land_fort, viProvinceID, 1 )
			
			if constructCommand:IsValid() then
				minister:GetOwnerAI():Post( constructCommand )
				ic = ic - land_fortCost -- Upodate IC total
			end
		end
	end
	
	return ic
end

function P.Build_AirBase(ic, minister, viProvinceID, viMax, vbGoOver)
	local ministerTag = minister:GetCountryTag()
	local air_base = CBuildingDataBase.GetBuilding("air_base")
	local loProvince = CCurrentGameState.GetProvince(viProvinceID)
	local loBuilding = loProvince:GetBuilding(air_base)

	if loBuilding:GetMax():Get() <= viMax and loProvince:GetCurrentConstructionLevel(air_base) == 0 then
		local land_fortCost = ministerTag:GetCountry():GetBuildCost(air_base):Get()
		
		if (ic - land_fortCost) >= 0 or vbGoOver then
			local constructCommand = CConstructBuildingCommand( ministerTag, air_base, viProvinceID, 1 )
			
			if constructCommand:IsValid() then
				minister:GetOwnerAI():Post( constructCommand )
				ic = ic - land_fortCost -- Upodate IC total
			end
		end
	end
	
	return ic
end

return Support