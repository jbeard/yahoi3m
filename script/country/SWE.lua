-----------------------------------------------------------
-- LUA Hearts of Iron 3 Sweden File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 5/22/2010
-----------------------------------------------------------

local P = {}
AI_SWE = P

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	if tostring(actor) == "GER" then
		score = score + 20
	end
	
	return score
end

function P.ForeignMinister_EvaluateDecision( score, agent, decision, scope )
	
	if decision:GetKey():GetString() == 'finnish_winter_war_swedish_intervention' then
		score = 100 	-- lets help
	elseif decision:GetKey():GetString() == 'finnish_winter_war_swedish_direct_intervention' then
		score = 0 -- but not too much
	end

	return score
end


function P.DiploScore_InviteToFaction(score, ai, actor, recipient, observer)
	-- If the Axis control Oslo and Conpenhagen don't get involved in the war at all.
	if not(tostring(actor:GetCountry():GetFaction():GetTag()) == "axis") then
		local loOsloContTag = CCurrentGameState.GetProvince(812):GetController():GetCountry():GetFaction():GetTag() -- Oslo
		local loCopenhagenContTag = CCurrentGameState.GetProvince(1482):GetController():GetCountry():GetFaction():GetTag() -- Copenhagen
		
		if tostring(loOsloContTag) == "axis" and tostring(loCopenhagenContTag) == "axis" then
			score = 0
		end
	end
	
	-- Whatever their chance is lower it by 20 makes it harder to get them in
	return (score - 20)
end

function P.DiploScore_Alliance(score, ai, actor, recipient, observer, action)
	-- Just process the invite to faction code
	return P.DiploScore_InviteToFaction(score, ai, actor, recipient, observer)	
end

return AI_SWE

