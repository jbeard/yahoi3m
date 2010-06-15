-----------------------------------------------------------
-- LUA Hearts of Iron 3 South Africa File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 5/5/2010
-----------------------------------------------------------

local P = {}
AI_SAF = P

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	local lsActorTag = tostring(actor)
	
	if lsActorTag == "AST" 
	or lsActorTag == "CAN" 
	or lsActorTag == "ENG" 
	or lsActorTag == "NZL" 
	or lsActorTag == "FRA" then
		score = score + 20
	end
	
	return score
end

return AI_SAF

