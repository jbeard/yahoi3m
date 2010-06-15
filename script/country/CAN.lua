-----------------------------------------------------------
-- LUA Hearts of Iron 3 Canada File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 5/5/2010
-----------------------------------------------------------

local P = {}
AI_CAN = P

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	local lsActorTag = tostring(actor)
	
	if lsActorTag == "AST" 
	or lsActorTag == "ENG" 
	or lsActorTag == "SAF" 
	or lsActorTag == "NZL" 
	or lsActorTag == "FRA" then
		score = score + 20
	end
	
	return score
end

return AI_CAN

