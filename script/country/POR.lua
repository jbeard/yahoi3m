-----------------------------------------------------------
-- LUA Hearts of Iron 3 Portugal File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 5/12/2010
-----------------------------------------------------------
local P = {}
AI_POR = P

function P.DiploScore_InviteToFaction( score, ai, actor, recipient, observer)
	local ministerCountry = recipient:GetCountry()
	local spaTag = CCountryDataBase.GetTag("SPA")
	local sprTag = CCountryDataBase.GetTag("SPR")
	
	-- If Spanish Civil was is going on don't join any alliance
	if sprTag:GetCountry():GetRelation(spaTag):HasWar() then
		score = 0 -- not interested in factions until we sorted out things at home
	
	-- Do not get involved as long as we are isolated (to easy for allies to get us)
	elseif tostring(actor:GetCountry():GetFaction():GetTag()) == "axis" then
		local ministerContinent = ministerCountry:GetActingCapitalLocation():GetContinent()
		
		-- If they are our neighbor and their capital is on the same
		--   continent as ours then consider joining if not do not get involved with the Axis
		for loNeighborTag in ministerCountry:GetNeighbours() do
			loNeighborCountry = loNeighborTag:GetCountry()
			
			if not(ministerContinent == loNeighborCountry:GetActingCapitalLocation():GetContinent()
			and loNeighborCountry:HasFaction()
			and tostring(loNeighborCountry:GetFaction():GetTag()) == "axis") then
				score = 0
			end
		end		
		score = 0
	end
	
	return score
end

function P.DiploScore_Alliance(score, ai, actor, recipient, observer, action)
	-- Just process the invite to faction code
	return P.DiploScore_InviteToFaction( score, ai, actor, recipient, observer)	
end

return AI_POR
