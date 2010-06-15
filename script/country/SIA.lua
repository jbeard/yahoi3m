-----------------------------------------------------------
-- LUA Hearts of Iron 3 Siam File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 4/20/2010
-----------------------------------------------------------

local P = {}
AI_SIA = P

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	if tostring(actor) == "JAP" then
		score = score + 20
	end
	
	return score
end

function P.DiploScore_Alliance( score, ai, actor, recipient, observer, action)
	local lsActorTag = tostring(actor)
	-- We like Japan so a small bonus to joining an alliance with them
	if lsActorTag == "JAP" then
		score = score + 20
	elseif lsActorTag == "CHI"
	or lsActorTag == "CHC" 
	or lsActorTag == "CGX" 
	or lsActorTag == "CSX" 
	or lsActorTag == "CXB"
	or lsActorTag == "CYN" 
	or lsActorTag == "SIK"
	or lsActorTag == "ENG" 
	or lsActorTag == "FRA" then
		score = score - 20
	end
	
	return score
end

-- Want more troops, let them learn on the battlefield.
--   helps them produce troops faster
function P.CallLaw_training_laws(minister, voCurrentLaw)
	local _MINIMAL_TRAINING_ = 27
	return CLawDataBase.GetLaw(_MINIMAL_TRAINING_)
end

return AI_SIA
