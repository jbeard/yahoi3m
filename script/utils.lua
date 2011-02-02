-----------------------------------------------------------
-- LUA Hearts of Iron 3 Utility7 File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 6/30/2010
-----------------------------------------------------------

local P = {}
Utils = P

function P.LUA_DEBUGOUT(s)
	-- Uncomment to see debug logging
	local f = io.open("lua_output.txt", "a")
	f:write("LUA_DEBUG '" .. s .. "' \n")
	f:close()
end

-----------------------------------------------------------------------------
-- calls specified function in country specific AI module if it exists
--
-- tag: country tag to load library for
-- funName: name of function to call if exists
-- currentScore - current score, returned if no module found
-- rest of args are passed to resolved funName and currentScore appended.
-----------------------------------------------------------------------------
function P.CallScoredCountryAI(tag, funName, currentScore, ...)
	local funRef = P.HasCountryAIFunction(tag, funName)
	if funRef then
		return funRef(currentScore, ...)
	end
	return currentScore
end

function P.CallCountryAI(tag, funName, ...)
	local funRef = P.HasCountryAIFunction(tag, funName)
	if funRef then
		return funRef(...)
	end
end

-- returns function ref if one exists, otherwise null
function P.HasCountryAIFunction(tag, funName)
	local countryModule = _G['AI_' .. tostring(tag)]
	if countryModule then
		local funRef = countryModule[funName]
		return funRef
	end
	return nil
end

-- returns list of files in a directory matching pattern
function P.ScanDir(dirname, pattern )
	local callit = os.tmpname()
	os.execute("dir /A-D /B "..dirname .. " >"..callit)
	local f = io.open(callit,"r")
	local rv = f:read("*all")
	f:close()
	os.remove(callit)

	tabby = {}
	local from  = 1
	local delim_from, delim_to = string.find( rv, "\n", from  )
	while delim_from do
		local subs = string.sub( rv, from , delim_from-1 )
		if string.match(subs, pattern) then
			table.insert( tabby, subs )
		end
		from  = delim_to + 1
		delim_from, delim_to = string.find( rv, "\n", from  )
	end
	return tabby
end

-- Create Unit with NO attachments
--    Used to create naval, air and land divisions with no special needs.
function P.CreateDivision_nominor(minister, vsType, viMaxSerial, ic, viUnitQuantity, viMaxPerDiv, vbGoOver)
	local ministerCountry = minister:GetCountry()
	local unitType = CSubUnitDataBase.GetSubUnit(vsType)	
	local liTotalDivisions = math.floor(viUnitQuantity / viMaxPerDiv)
	
	if ic > 0.2 and ministerCountry:GetTechnologyStatus():IsUnitAvailable(unitType) then	
		local capitalProvId = ministerCountry:GetActingCapitalLocation():GetProvinceID()
		local bBuildReserve = (not ministerCountry:IsAtWar()) and unitType:IsRegiment()
		local i = 0 -- Counter for amount of units built
		local unitcost = ministerCountry:GetBuildCostIC( unitType, 1, bBuildReserve ):Get()
		
		while i < liTotalDivisions do
			local buildcount
			
			if 	liTotalDivisions >= (i + viMaxSerial) then
				buildcount = viMaxSerial
				i = i + viMaxSerial
			else
				buildcount = liTotalDivisions - i
				i = liTotalDivisions
			end
			
			local res = ic - (unitcost * viMaxPerDiv)
			if res > 0.2 or vbGoOver then
				ic = res
				
				local orderlist = SubUnitList()
				-- Add the amount of brigades requested of the main type
				if viMaxPerDiv == 1 then
					SubUnitList.Append( orderlist, unitType )
				else
					for m = 1, viMaxPerDiv, 1 do
						SubUnitList.Append( orderlist, unitType )
					end
				end
				viUnitQuantity = viUnitQuantity - (viMaxPerDiv * buildcount)
				minister:GetOwnerAI():Post(CConstructUnitCommand(minister:GetCountryTag(), orderlist, capitalProvId, buildcount, bBuildReserve, CNullTag(), CID()))
				
				if ic < 0.2 then
					i = liTotalDivisions --Causes it to exit loop
				end
			else
				i = liTotalDivisions --Causes it to exit loop
			end
		end
	end
	
	return ic, viUnitQuantity
end

-- Create Divisions with minor attachments
--    Used only for land untis and adding artillery etc....
function P.CreateDivision(minister, vsType, viMaxSerial, ic, viUnitQuantity, viMaxPerDiv, vaMinorUnitArray, viAttachments, vbGoOver)
	local ministerCountry = minister:GetCountry()
	local unitType = CSubUnitDataBase.GetSubUnit(vsType)
	local liTotalDivisions = math.floor(viUnitQuantity / viMaxPerDiv)
	
	if ic > 0.2 and ministerCountry:GetTechnologyStatus():IsUnitAvailable(unitType) then
		local capitalProvId = ministerCountry:GetActingCapitalLocation():GetProvinceID()
		local bBuildReserve = (not ministerCountry:IsAtWar()) and unitType:IsRegiment()
		local i = 0 -- Counter for amount of units built
		local unitcost = ministerCountry:GetBuildCostIC( unitType, 1, bBuildReserve ):Get()

		while i < liTotalDivisions do
			local buildcount
			
			if 	liTotalDivisions >= (i + viMaxSerial) then
				buildcount = viMaxSerial
				i = i + viMaxSerial
			else
				buildcount = liTotalDivisions - i
				i = liTotalDivisions
			end
			
			local res = ic - (unitcost * viMaxPerDiv)
			if res > 0.2 or vbGoOver then
				ic = res
				
				local orderlist = SubUnitList()
				-- Add the amount of brigades requested of the main type
				if viMaxPerDiv == 1 then
					SubUnitList.Append( orderlist, unitType )
				else
					for m = 1, viMaxPerDiv, 1 do
						SubUnitList.Append( orderlist, unitType )
					end
				end

				-- Attach a minor brigade if one can be attached
				--   updated the ic total for the minor unit being attached
				for i = 1, viAttachments do
					local TotalMinors = table.getn(vaMinorUnitArray)
					if TotalMinors == 1 then
						SubUnitList.Append( orderlist, vaMinorUnitArray[1] )
						ic = ic - (ministerCountry:GetBuildCostIC( vaMinorUnitArray[1], 1, bBuildReserve ):Get())
					elseif TotalMinors > 1 then
						local minorSelected = (math.random(TotalMinors))
						SubUnitList.Append( orderlist, vaMinorUnitArray[minorSelected] )
						ic = ic - (ministerCountry:GetBuildCostIC( vaMinorUnitArray[minorSelected], 1, bBuildReserve ):Get())
					end
				end
				
				viUnitQuantity = viUnitQuantity - (viMaxPerDiv * buildcount)
				minister:GetOwnerAI():Post(CConstructUnitCommand(minister:GetCountryTag(), orderlist, capitalProvId, buildcount, bBuildReserve, CNullTag(), CID()))

				if ic < 0.2 then
					i = liTotalDivisions --Causes it to exit loop
				end
			else
				i = liTotalDivisions --Causes it to exit loop
			end
		end
	end

	return ic, viUnitQuantity
end

-- Setup Potential brigade attachments
-- ARMORED CARS
--    Not going to let the AI build armor cars

--- Build Leg Unit Array
function P.BuildLegUnitArray(ministerCountry)
	-- Leg Brigades
	local LegUnitArray = {}
	local anti_air_brigade = CSubUnitDataBase.GetSubUnit("anti_air_brigade")
	local anti_tank_brigade = CSubUnitDataBase.GetSubUnit("anti_tank_brigade")
	local artillery_brigade = CSubUnitDataBase.GetSubUnit("artillery_brigade")
	local engineer_brigade = CSubUnitDataBase.GetSubUnit("engineer_brigade")
	local rocket_artillery_brigade = CSubUnitDataBase.GetSubUnit("rocket_artillery_brigade")
	
	--Setup potential leg UNIT minor brigades
	-- #############################################
	--Check to see if they can actually build anti_air_brigade
	if ministerCountry:GetTechnologyStatus():IsUnitAvailable(anti_air_brigade) then
		table.insert( LegUnitArray, anti_air_brigade )
	end
	--Check to see if they can actually build anti_tank_brigade
	if ministerCountry:GetTechnologyStatus():IsUnitAvailable(anti_tank_brigade) then
		table.insert( LegUnitArray, anti_tank_brigade )
	end
	--Check to see if they can actually build artillery_brigade
	if ministerCountry:GetTechnologyStatus():IsUnitAvailable(artillery_brigade) then
		table.insert( LegUnitArray, artillery_brigade )
	end
	--Check to see if they can actually build engineer_brigade
	if ministerCountry:GetTechnologyStatus():IsUnitAvailable(engineer_brigade) then
		table.insert( LegUnitArray, engineer_brigade )
	end		
	--Check to see if they can actually build rocket_artillery_brigade
	if ministerCountry:GetTechnologyStatus():IsUnitAvailable(rocket_artillery_brigade) then
		table.insert( LegUnitArray, rocket_artillery_brigade )
	end	
	
	return LegUnitArray
end

--- Build Motorized Unit Array
function P.BuildMotorizedUnitArray(ministerCountry)
	-- Motorized Brigades
	local MotorizedUnitArray = {}
	local sp_artillery_brigade = CSubUnitDataBase.GetSubUnit("sp_artillery_brigade")
	local sp_rct_artillery_brigade = CSubUnitDataBase.GetSubUnit("sp_rct_artillery_brigade")
	local tank_destroyer_brigade = CSubUnitDataBase.GetSubUnit("tank_destroyer_brigade")

	--Setup potential Motorized UNIT minor brigades
	-- #############################################
	--Check to see if they can actually build sp_artillery_brigade
	if ministerCountry:GetTechnologyStatus():IsUnitAvailable(sp_artillery_brigade) then
		table.insert( MotorizedUnitArray, sp_artillery_brigade )
	end		
	--Check to see if they can actually build sp_rct_artillery_brigade
	if ministerCountry:GetTechnologyStatus():IsUnitAvailable(sp_rct_artillery_brigade) then
		table.insert( MotorizedUnitArray, sp_rct_artillery_brigade )
	end		
	--Check to see if they can actually build motorized_brigade
	if ministerCountry:GetTechnologyStatus():IsUnitAvailable(tank_destroyer_brigade) then
		table.insert( MotorizedUnitArray, tank_destroyer_brigade )
	end	
	
	return MotorizedUnitArray
end

--- Build Armor Unit Array
function P.BuildArmorUnitArray(ministerCountry)
	-- Mechanized/Armor Brigades
	local ArmorUnitArray = {}
	local minor_motorized_brigade = CSubUnitDataBase.GetSubUnit("motorized_brigade")
	
	--Setup potential Armor UNIT minor brigades
	-- #############################################
	--Check to see if they can actually build motorized_brigade
	if ministerCountry:GetTechnologyStatus():IsUnitAvailable(minor_motorized_brigade) then
		table.insert( ArmorUnitArray, minor_motorized_brigade )
	end	
	
	return ArmorUnitArray
end

function P.BuildGarrisonUnitArray(ministerCountry)
	-- Garrison Brigades
	local GarrisonUnitArray = {}
	local police_brigade = CSubUnitDataBase.GetSubUnit("police_brigade")
	
	--Setup potential Garrison UNIT minor brigades
	-- #############################################
	--Check to see if they can actually build police_brigade
	if ministerCountry:GetTechnologyStatus():IsUnitAvailable(police_brigade) then
		table.insert( GarrisonUnitArray, police_brigade )
	end
	
	return GarrisonUnitArray
end		

function P.Round(viNumber)
	-- In case of floating point issue
	viNumber = tonumber(tostring(viNumber))

	if (viNumber - math.floor(viNumber)) >= 0.5 then
		return math.ceil(viNumber)
	else
		return math.floor(viNumber)
	end
end

function P.IsFriend(ai, voFaction, voCountry)
	-- If they are a less than 70 toward another faction consider them a potential enemy
	local rValue = true
	
	for loFaction in CCurrentGameState.GetFactions() do
		if not(loFaction == voFaction) then
			-- They are aligning with another faction
			if ai:GetCountryAlignmentDistance(voCountry, loFaction:GetFactionLeader():GetCountry()):Get() < 70 then
			--if ai:GetNormalizedAlignmentDistance(voCountry, loFaction):Get() < 10 then
				rValue = false
				break
			end
		end
	end
	
	return rValue
end

function P.Split(str, delim, maxNb)
    -- Eliminate bad cases...
    if string.find(str, delim) == nil then
        return { str }
    end
    if maxNb == nil or maxNb < 1 then
        maxNb = 0    -- No limit
    end
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in string.gfind(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
        if nb == maxNb then break end
    end
    -- Handle the last field
    if nb ~= maxNb then
        result[nb + 1] = string.sub(str, lastPos)
    end
    return result
end

function P.CalculateHomeProduced(loResource)
	local liDailyHome = loResource.vDailyHome
	
	if loResource.vConvoyedIn > 0 then
		-- If the Convoy in exceeds Home Produced by 10% it means they have a glutten coming in or
		--   are a sea bearing country like ENG or JAP
		--   so go ahead and count this as home produced up to 80% of it just in case something happens!
		if liDailyHome > loResource.vDailyExpense then
			liDailyHome = liDailyHome + loResource.vConvoyedIn
		elseif loResource.vConvoyedIn > (liDailyHome * 0.1) then
			liDailyHome = liDailyHome + (loResource.vConvoyedIn * 0.9)
		end
	end	
	
	return liDailyHome
end

return Utils
