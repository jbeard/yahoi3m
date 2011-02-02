-----------------------------------------------------------
-- LUA Hearts of Iron 3 Turkey File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 6/9/2010
-----------------------------------------------------------

local P = {}
AI_TUR = P

function P.DiploScore_InviteToFaction(score, ai, actor, recipient, observer)
	local sovTag = CCountryDataBase.GetTag("SOV")
	
	-- If Russia looses Moscow or border provinces with Turkey
	--    then remove the -50 penalty for them being willing to join the war
	if tostring(actor:GetCountry():GetFaction():GetTag()) == "axis" then
		if CCurrentGameState.GetProvince(1409):GetController() == sovTag -- Moscow check
		-- Following provinces are on the Turkey/Russian border
		and CCurrentGameState.GetProvince(4059):GetController() == sovTag
		and CCurrentGameState.GetProvince(3991):GetController() == sovTag
		and CCurrentGameState.GetProvince(4060):GetController() == sovTag
		and CCurrentGameState.GetProvince(7149):GetController() == sovTag
		and CCurrentGameState.GetProvince(7173):GetController() == sovTag then
			score = score - 50
		end
	end
	
	return score
end

function P.DiploScore_Alliance(score, ai, actor, recipient, observer, action)
	-- Just process the invite to faction code
	return P.DiploScore_InviteToFaction( score, ai, actor, recipient, observer)	
end

function P.DiploScore_OfferTrade(score, ai, actor, recipient, observer, voTradedFrom, voTradedTo)
	if tostring(actor) == "GER" then
		score = score + 15
	end
	
	return score
end

return AI_TUR
