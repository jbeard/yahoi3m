-----------------------------------------------------------
-- LUA Hearts of Iron 3 Fscist Spain File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 5/12/2010
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
	
	-- Do not get involved as long as Gibralatar is own by England
	elseif tostring(actor:GetCountry():GetFaction():GetTag()) == "axis" 
	and CCurrentGameState.GetProvince(5191):GetController() == engTag then -- Gibraltar check
		score = 0
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
