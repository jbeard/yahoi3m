-----------------------------------------------------------
-- LUA Hearts of Iron 3 Fscist Spain File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 6/7/2010
-----------------------------------------------------------

local P = {}
AI_SPA = P

function P.DiploScore_InviteToFaction(score, ai, actor, recipient, observer)
	local ministerCountry = recipient:GetCountry()
	local sprTag = CCountryDataBase.GetTag("SPR")
	local engTag = CCountryDataBase.GetTag("ENG")
	
	-- Is Spanish Civil War still going on?
	if ministerCountry:GetRelation(sprTag):HasWar() then
		score = 0 -- not interested in factions until we sorted out things at home
	
	-- Penalty hit if Gibraltar and London are both controlled by the UK
	--   Make sure UK is not part of the Axis as well in the check in case they are a puppet
	elseif tostring(actor:GetCountry():GetFaction():GetTag()) == "axis"
	and not(tostring(engTag:GetCountry():GetFaction():GetTag()) == "axis") then
		if CCurrentGameState.GetProvince(1964):GetController() == engTag -- London check
		and CCurrentGameState.GetProvince(5191):GetController() == engTag then -- Gibraltar check
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
	if tostring(actor) == "GER" or tostring(actor) == "SPA" then
		score = score + 15
	end
	
	return score
end

return AI_SPA
