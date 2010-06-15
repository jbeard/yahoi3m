-----------------------------------------------------------
-- LUA Hearts of Iron 3 Australia File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 5/7/2010
-----------------------------------------------------------

local P = {}
AI_AST = P

-- Have Germany Fortify the French Line
function P.Build_AirBase(ic, minister, vbGoOver)
	-- Only build the airbases if its 1940 or less
	if minister:GetOwnerAI():GetCurrentDate():GetYear() <= 1940 then
		ic = Support.Build_AirBase(ic, minister, 7823, 2, vbGoOver) -- Cooktown
		ic = Support.Build_AirBase(ic, minister, 7842, 4, vbGoOver) -- Townsville
	end
	
	return ic
end

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	local lsActorTag = tostring(actor)
	
	if lsActorTag == "ENG" 
	or lsActorTag == "CAN" 
	or lsActorTag == "SAF" 
	or lsActorTag == "NZL" 
	or lsActorTag == "FRA" then
		score = score + 20
	end
	
	return score
end

return AI_AST

