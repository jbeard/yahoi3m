-----------------------------------------------------------
-- LUA Hearts of Iron 3 Romania File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 4/23/2010
-----------------------------------------------------------

local P = {}
AI_ROM = P

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	if tostring(actor) == "GER" or tostring(actor) == "ITA" then
		score = score + 10
	elseif tostring(actor) == "SOV" then
		score = score - 10
	end
	
	return score
end

return AI_ROM

