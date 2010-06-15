-----------------------------------------------------------
-- LUA Hearts of Iron 3 Netherlands File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 5/22/2010
-----------------------------------------------------------

local P = {}
AI_HOL = P

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	if tostring(actor) == "JAP" then
		score = score + 30
	end
	
	return score
end

function P.DiploScore_InviteToFaction(score, ai, actor, recipient, observer)
	-- Whatever their chance is lower it by 10 makes it harder to get them in
	return (score - 10)
end

return AI_HOL

