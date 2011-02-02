-----------------------------------------------------------
-- LUA Hearts of Iron 3 Portugal File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 6/10/2010
-----------------------------------------------------------
local P = {}
AI_POR = P

function P.DiploScore_InviteToFaction( score, ai, actor, recipient, observer)
	local ministerCountry = recipient:GetCountry()
	local spaTag = CCountryDataBase.GetTag("SPA")
	local sprTag = CCountryDataBase.GetTag("SPR")
	
	-- If Spanish Civil War is going on don't join any alliance
	if sprTag:GetCountry():GetRelation(spaTag):HasWar() then
		score = 0 -- not interested in factions until we sorted out things at home
	
	-- Do not get involved as long as we are isolated (to easy for allies to get us)
	elseif tostring(actor:GetCountry():GetFaction():GetTag()) == "axis" then
		local ministerContinent = ministerCountry:GetActingCapitalLocation():GetContinent()
		
		local liAxisPenalty = 50
		
		-- If we have a neighbor that is Axis with their capital in Europe 
		--    then consider joining the Axis if not give a -50 penalty since its easy
		--    for the allies to take us out.
		for loNeighborTag in ministerCountry:GetNeighbours() do
			loNeighborCountry = loNeighborTag:GetCountry()
			
			if ministerContinent == loNeighborCountry:GetActingCapitalLocation():GetContinent()
			and loNeighborCountry:HasFaction()
			and tostring(loNeighborCountry:GetFaction():GetTag()) == "axis" then
				liAxisPenalty = 0
				break
			end
		end	
		
		score = score - liAxisPenalty
	end
	
	return score
end

function P.DiploScore_Alliance(score, ai, actor, recipient, observer, action)
	-- Just process the invite to faction code
	return P.DiploScore_InviteToFaction( score, ai, actor, recipient, observer)	
end

return AI_POR
