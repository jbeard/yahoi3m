-----------------------------------------------------------
-- LUA Hearts of Iron 3 Vichy File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 4/27/2010
-----------------------------------------------------------

local P = {}
AI_VIC = P

function P.HandleMobilization(minister)
	-- Do not do anything as we never want to mobilize
end

function P.DiploScore_InviteToFaction(score, ai, actor, recipient, observer)
	-- Stay out of the war, we do not care whats happening around us
	if not(recipient:GetCountry():IsAtWar()) then
		score = 0
	end
	
	return score
end

function P.DiploScore_Alliance(score, ai, actor, recipient, observer, action)
	-- Stay out of the war, we do not care whats happening around us
	if not(recipient:GetCountry():IsAtWar()) then
		score = 0
	end
	
	return score	
end

return AI_VIC
