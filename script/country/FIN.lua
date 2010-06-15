-----------------------------------------------------------
-- LUA Hearts of Iron 3 Finland File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 5/10/2010
-----------------------------------------------------------

local P = {}
AI_FIN = P



function P.HandleMobilization( minister )
	
	local ministerTag = minister:GetCountryTag()
	local ministerCountry = minister:GetCountry()
	local ai = minister:GetOwnerAI()

	-- mobilize before winter war
	local sovTag = CCountryDataBase.GetTag('SOV')
	local estTag = CCountryDataBase.GetTag('EST')
	
	--if (not sovTag:GetCountry():IsAtWar())
	--and
	if ((not estTag:GetCountry():Exists()) or estTag:GetCountry():IsGovernmentInExile())	     
	then
		local command = CToggleMobilizationCommand( ministerTag, true )
		ai:Post( command )
		return
	end
	
	
	local year = ai:GetCurrentDate():GetYear()
	local month = ai:GetCurrentDate():GetMonthOfYear()
	local gerTag = CCountryDataBase.GetTag('GER')
	
	local warTime = ( year >= 1940 ) or ( year == 1939 and month >= 6 )

	if warTime
	and ( not ministerCountry:HasFaction() )
	and ( not ministerCountry:IsFriend( sovTag, false ) )
	and ( not ministerCountry:IsFriend( gerTag, false ) )
	then
		local finnishBorder = { [0] = 377, 353, 329, 286, 268, 253, 237, 210, 183 }
		local troupCount = 0
		for tmpIndex, provID in pairs(finnishBorder) do
			local province = CCurrentGameState.GetProvince( provID )
			troupCount = troupCount + province:GetNumberOfUnits()
		end
				
		if troupCount > 5
		then
			local command = CToggleMobilizationCommand( ministerTag, true )
			ai:Post( command )
			return
		end
	end
	
	-- general check of neighbors
	for neighborCountry in ministerCountry:GetNeighbours() do
		local threat = ministerCountry:GetRelation(neighborCountry):GetThreat():Get()
		if  threat > 30 then 
			--Utils.LUA_DEBUGOUT( "MOBILIZE " .. tostring(ministerTag) .. " " .. tostring(threat) .. "towards" .. tostring(neighborCountry) )
			local warDesirability = CalculateWarDesirability( ai, neighborCountry:GetCountry(), ministerTag )
			if warDesirability > 70 then
				local command = CToggleMobilizationCommand( ministerTag, true )
				ai:Post( command )
				return
			end
		end
	end
end

-- Finland has very highly trained forces
function P.CallLaw_training_laws(minister, voCurrentLaw)
	local _SPECIALIST_TRAINING_ = 30
	return CLawDataBase.GetLaw(_SPECIALIST_TRAINING_)
end

return AI_FIN
