-----------------------------------------------------------
-- LUA Hearts of Iron 3 Diplomacy File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 5/2/2010
-----------------------------------------------------------
require('utils')


function CalculateAlignmentFactor(ai, country1, country2)
	local dist = ai:GetCountryAlignmentDistance( country1, country2 ):Get()
	return math.min(dist / 400.0, 1.0)
end

function DiploScore_InviteToFaction(ai, actor, recipient, observer)
	if observer == actor then -- are recipient worth inviting
		local recipientCountry = recipient:GetCountry()
		if recipientCountry:IsAtWar() then
			-- is our war target at war with the faction
			for diploStatus in recipientCountry:GetDiplomacy() do
				local target = diploStatus:GetTarget()
				if target:IsValid() and diploStatus:HasWar() then
					if actor:GetCountry():GetRelation(target):HasWar() then
						return 100 -- at war with our enemies
					elseif target:GetCountry():IsFactionLeader() then
						return 0 -- dont pull us into war against another faction we arent already
					end
				end					
			end
			return 100 -- at war with someone is no problem
		else
			return 100 -- if they can, let the,
		end
	else -- do we, recipient want to accept invite to faction
		local score = 100
		--Utils.LUA_DEBUGOUT("-------------------------------------")
		--Utils.LUA_DEBUGOUT("DiploScore_InviteToFaction (" .. tostring( actor )  .. "->" .. tostring( recipient ) .. ")")
		local faction = actor:GetCountry():GetFaction()
		
		if recipient:GetCountry():IsNeighbourToFactionHostile(faction, true) 
		and (not recipient:GetCountry():HasNeighborInFaction(faction))
		then
			score = 0 -- need some backup bro
		end
		
		return Utils.CallScoredCountryAI(recipient, 'DiploScore_InviteToFaction', score, ai, actor, recipient, observer)
	end
end

function DiploScore_NonAgression(ai, actor, recipient, observer)
	if observer == actor then -- we demand nap with recipient
		return DiploScore_NonAgression(ai, recipient, actor, observer)
	else -- actor demands nap with us
		local score = 0
		local rel = ai:GetRelation(recipient, actor)
		local relation = 100 + rel:GetValue():GetTruncated()
		
		if relation > 150 then -- we like them
			score = score + (relation - 150)
		elseif ai:GetNumberOfOwnedProvinces(actor) / 2 >
		       ai:GetNumberOfOwnedProvinces(recipient) then -- much bigger than us
			score = score + 5 + relation / 5
		end
		
		local recipientCountry = recipient:GetCountry()
		local strategy = recipientCountry:GetStrategy()
		score = score + strategy:GetFriendliness(actor) / 4
		score = score - strategy:GetAntagonism(actor) / 4
		--score = score + strategy:GetThreat(actor) / 4
		
		if not recipientCountry:IsNeighbour( actor ) then
			score = score / 2
		end

		score = score - recipientCountry:GetDiplomaticDistance(actor):GetTruncated() 
		--if score > 0 then
			--Utils.LUA_DEBUGOUT("NAP score: " .. score .. " for " .. tostring(actor) .. " - " .. tostring(recipient) )
			--Utils.LUA_DEBUGOUT("friendlyness: " .. strategy:GetFriendliness(actor) ) 
			--Utils.LUA_DEBUGOUT("antagonism: " .. strategy:GetAntagonism(actor) ) 
			--Utils.LUA_DEBUGOUT("threat: " .. strategy:GetThreat(actor) ) 
			--Utils.LUA_DEBUGOUT("d. dist: " ..  recipientCountry:GetDiplomaticDistance(actor):GetTruncated() ) 
			--Utils.LUA_DEBUGOUT("------------------------")
		--end

		return Utils.CallScoredCountryAI(recipient, 'DiploScore_NonAgression', score, ai, actor, recipient, observer)
	end
end

function DiploScore_DemandMilitaryAccess(ai, actor, recipient, observer)
	local score = 0
	
	if observer == actor then -- we demand access of recipient
		local actorCountry = actor:GetCountry()
		local strategy = actorCountry:GetStrategy()
		score = strategy:GetAccessScore(recipient)
		
	else -- actor demands access from us
		--Utils.LUA_DEBUGOUT("DiploScore_DemandMilitaryAccess_________________")

		local rel = ai:GetRelation(recipient, actor)
		if rel:HasWar() then
			return 0
		end
        
		-- much bigger than us and bordering
        local actorCountry = actor:GetCountry()
		if ( ai:GetNumberOfOwnedProvinces(actor) / 5 > ai:GetNumberOfOwnedProvinces(recipient) )
        and actorCountry:IsNeighbour( recipient )
        then 
			-- if we are not in faction and they are at war
            if actorCountry:IsAtWar() 
            and not (recipient:GetCountry():HasFaction())
            then
                score = 50
            end
		end

		if rel:HasAlliance() then
			score = 80
		end

		score = Utils.CallScoredCountryAI(recipient, "DiploScore_DemandMilitaryAccess", score,ai, actor, recipient, observer)
	end
	
	return score
end

function DiploScore_OfferMilitaryAccess(ai, actor, recipient, observer, action)
	local score = 0
	if observer == actor then --should we offer access to recipient
		local rel = ai:GetRelation(actor, recipient)
		if rel:HasWar() then
			return 0
		end
		if actor:GetCountry():HasFaction() then
			return 0
		end
		if actor:GetCountry():GetEffectiveNeutrality():Get() > 70 then
			return	0
		end

		local recipientCountry = recipient:GetCountry()
		if recipientCountry:IsNeighbour( actor ) then -- only for neighbors
			local strategy = actor:GetCountry():GetStrategy()
			score = ( rel:GetValue():GetTruncated()) / 4
			score = score + strategy:GetFriendliness(recipient) / 4
			score = score - strategy:GetAntagonism(recipient) / 4
			score = score - rel:GetThreat():Get()

			if not recipientCountry:IsAtWar() then
				score = score / 4 -- why would we if they dont need it
			end
		end
	else
		score = 100
 	end

	score = Utils.CallScoredCountryAI(recipient, 'DiploScore_OfferMilitaryAccess', score, ai, actor, recipient, observer, action)
	return score
end

function DiploScore_Alliance(ai, actor, recipient, observer, action)
	if observer == actor then 
       		local recipientCountry = recipient:GetCountry()
		local actorCountry = actor:GetCountry()
		local strategy = actorCountry:GetStrategy()
		
		if recipientCountry:IsFactionLeader() then -- as a faction leader we dont want alliances, we want faction members
			return 0
		end

		
		return strategy:GetFriendliness(recipient)
	else 
		local rel = ai:GetRelation(recipient, actor)
		local relation = 200 + rel:GetValue():GetTruncated()
		
		if relation < 100 then
			return 0
		end
		
		local recipientCountry = recipient:GetCountry()
		local actorCountry = actor:GetCountry()
		
		local score = relation / 12.0
		
				
		if actorCountry:IsFactionLeader() then -- as a faction leader we dont want alliances, we want faction members
			return 0
		end
		
		-- check location
		if not recipientCountry:IsNeighbour(actor) then
			-- check if on same continent first
			local recipientContinent = recipientCountry:GetActingCapitalLocation():GetContinent()
			local actorContinent = actorCountry:GetActingCapitalLocation():GetContinent()
			if not (recipientContinent == actorContinent) then
				score = score / 2
			end
		end
		
		-- check their wars
		if actorCountry:IsAtWar() then
			local bMutualEnemies = false
			for enemy in actorCountry:GetCurrentAtWarWith() do
				if recipientCountry:IsEnemy(enemy) then -- use threat as well?
					bMutualEnemies = true
				elseif recipientCountry:IsFriend(enemy, false) then
					return 0 -- fighting our friends
				end
			end
			
			if bMutualEnemies then
				score = score + 20
			else
				score = score / 2 -- better wait until they sorted their problems
			end
		end

		score = score - recipientCountry:GetDiplomaticDistance(actor):GetTruncated() / 10

		local strategy = recipientCountry:GetStrategy()
		score = score + strategy:GetFriendliness(actor) / 2
		score = score - strategy:GetAntagonism(actor) / 2
		score = score - rel:GetThreat():Get() / 2
	

		return Utils.CallScoredCountryAI(recipient, 'DiploScore_Alliance', score, ai, actor, recipient, observer, action)
	end
end

function CalculateWarDesirability(ai, country, target)
	local score = 0
	local countryTag = country:GetCountryTag()
	local targetCountry = target:GetCountry()
	local strategy = country:GetStrategy()

	-- can we even declare war?
	if not ai:CanDeclareWar( countryTag, target ) then
	  return 0
	end

	--Utils.LUA_DEBUGOUT("we can declare war: " .. tostring(minister:GetCountryTag()) .. " -> " .. tostring(target) )


	local antagonism = strategy:GetAntagonism(target);
	local friendliness = strategy:GetFriendliness(target);

	-- dont declare war on people we like
	if friendliness > 0 and antagonism < 1 then
		return 0
	end

	-- no suicide :S
	if country:GetNumberOfControlledProvinces() < targetCountry:GetNumberOfControlledProvinces() / 4 then
		return 0
	end

	-- watch out if we have bad intel, should be infiltrating more
	local intel = CAIIntel(countryTag, target)
	if intel:GetFactor() < 0.1 then
		return 0
	end

	-- compare military power
	local theirStrength = intel:CalculateTheirPercievedMilitaryStrengh()
	local ourStrength = intel:CalculateOurMilitaryStrength()
	local strengthFactor = ourStrength / theirStrength

	if strengthFactor < 1.0 then
		score = score - 75 * (1.0 - strengthFactor)
	else
		score = score + 20 * (strengthFactor - 1.0)
	end

	-- personality
	if strategy:IsMilitarist() then
		score = score * 1.3
	end
	
	return Utils.CallScoredCountryAI(countryTag, 'CalculateWarDesirability', score, ai, country, target)

end

function DiploScore_PeaceAction(ai, actor, recipient, observer, action)
	if observer == actor then
		return 0
	else
		score = 0
		
		-- intel first
		--Utils.LUA_DEBUGOUT("----------")
		local intel = CAIIntel(recipient, actor)
		if intel:GetFactor() > 0.1 then
			local recipientStrength = intel:CalculateTheirPercievedMilitaryStrengh()
			local actorStrength = intel:CalculateOurMilitaryStrength()
			local strengthFactor = actorStrength / recipientStrength - 0.5
			score = 100 * strengthFactor
		end
		--Utils.LUA_DEBUGOUT("score: " .. score )
		
		local sizeFactor = actor:GetCountry():GetNumberOfControlledProvinces() / recipient:GetCountry():GetNumberOfControlledProvinces()
		--Utils.LUA_DEBUGOUT("sizeFactor: " .. sizeFactor )
		sizeFactor = (sizeFactor - 1) * 100
				
		score = score + math.min(sizeFactor, 100)
		
		score = score + recipient:GetCountry():GetSurrenderLevel():Get() * 100
		--Utils.LUA_DEBUGOUT("score: " .. score )
		score = score - actor:GetCountry():GetSurrenderLevel():Get() * 100
		--Utils.LUA_DEBUGOUT("score: " .. score )
		
		local strategy = recipient:GetCountry():GetStrategy()
		score = score + strategy:GetFriendliness(actor) / 2
		score = score - strategy:GetAntagonism(actor) / 2
		--score = score + strategy:GetThreat(actor) / 2
		--Utils.LUA_DEBUGOUT("score: " .. score )
		return score
	end
end

function DiploScore_SendExpeditionaryForce(ai, actor, recipient, observer, action)
	if observer == actor then
		return 0 
	else
		-- do we want to accept?
		local recipientCountry = recipient:GetCountry()
		if recipientCountry:GetDailyBalance( CGoodsPool._SUPPLIES_ ):Get() > 1.0 then
			local  score = 0
			-- maybe we have enough stockpiles
			local supplyStockpile = recipientCountry:GetPool():Get( CGoodsPool._SUPPLIES_ ):Get()
			local weeksSupplyUse = recipientCountry:GetDailyExpense( CGoodsPool._SUPPLIES_ ):Get() * 7
			if supplyStockpile > weeksSupplyUse * 20.0 then
				score = score + 70
			elseif supplyStockpile > weeksSupplyUse * 10.0 then
				score = score + 40
			end
			
			if recipientCountry:IsAtWar() then
				score = score + 20
			else
				score = 0 -- no war, no need for troops
			end
			
			return score
		else
			local score = 0
			-- maybe we have enough stockpiles
			local supplyStockpile = recipientCountry:GetPool():Get( CGoodsPool._SUPPLIES_ ):Get()
			local weeksSupplyUse = recipientCountry:GetDailyExpense( CGoodsPool._SUPPLIES_ ):Get() * 7
			if supplyStockpile > weeksSupplyUse * 24.0 then
				score = score + 70
			elseif supplyStockpile > weeksSupplyUse * 12.0 then
				score = score + 40
			end

			if recipientCountry:IsAtWar() then
				score = score + 20
			else
				score = 0 -- no war, no need for troops
			end
			
		end
		return 0
	end
end

function DiploScore_LicenceTechnology(ai, actor, recipient, observer, action)
	if observer == actor then
		return 0 
	else
		--Utils.LUA_DEBUGOUT("LICENS ------------------------------")
		if not action:GetSubunit() then
			return 0
		end
	
		local score = 0
		local actorCountry = actor:GetCountry()
		local recipientCountry = recipient:GetCountry()
		local rel = ai:GetRelation(recipient, actor)
		
		if rel:GetValue():GetTruncated() < 0 then
			return 0
		end
		
		if rel:HasWar() then
			return 0
		end
		--Utils.LUA_DEBUGOUT("1 LICENS " .. tostring(actor) .. " -> " ..  tostring(recipient) .. " = " .. score)
		-- we can give tech to
		-- - people in faction
		-- - people in alliance
		-- - people fighting our enemies
		-- - people close in triangle (not far away! scale price here too)
		local allied = false
		if ( recipientCountry:HasFaction() and recipientCountry:GetFaction() == actorCountry:GetFaction() ) then
			score = score + 70
			allied = true
		elseif rel:HasAlliance() then
			score = score + 60
			allied = true
		end
		--Utils.LUA_DEBUGOUT("2 LICENS " .. tostring(actor) .. " -> " ..  tostring(recipient) .. " = " .. score)
		local fightingFriend = false
		local fightingEnemy = false
		if actorCountry:IsAtWar() then
			for enemy in actorCountry:GetCurrentAtWarWith() do
				if recipientCountry:IsEnemy(enemy) then
					--Utils.LUA_DEBUGOUT("mutual enemy: " .. tostring(enemy) .. " for " ..  tostring(actor) .. " and " . .tostring(recipient))
					fightingEnemy = true
					--Utils.LUA_DEBUGOUT("mutual enemy")
				elseif recipientCountry:IsFriend(enemy, true)
				and ai:GetRelation(enemy, actor):GetValue():GetTruncated() > 20
				then
					fightingFriend = true
				end
			end
		end
		
		if fightingFriend then
			return 0
		end
		--Utils.LUA_DEBUGOUT("3 LICENS " .. tostring(actor) .. " -> " ..  tostring(recipient) .. " = " .. score)
		if fightingEnemy then
			if not allied then
				score = 20 -- need some base
			end
			score = score + 30
			--Utils.LUA_DEBUGOUT("fightingenemy")
		else
			--Utils.LUA_DEBUGOUT("factor: " .. CalculateAlignmentFactor(ai, actorCountry, recipientCountry) * 50)
			score = score - CalculateAlignmentFactor(ai, actorCountry, recipientCountry) * 50
			
		end
		--Utils.LUA_DEBUGOUT("4 LICENS " .. tostring(actor) .. " -> " ..  tostring(recipient) .. " = " .. score)
		local threat = rel:GetThreat():Get()
		score = score - threat * CalculateAlignmentFactor(ai, actorCountry, recipientCountry)
		--Utils.LUA_DEBUGOUT("5 LICENS " .. tostring(actor) .. " -> " ..  tostring(recipient) .. " = " .. score)
		-- consider the money
		local offeredMoney = action:GetMoney():Get()
		local moneyPile = math.max( recipientCountry:GetPool():Get( CGoodsPool._MONEY_ ):Get(), 100.0)
		if offeredMoney > moneyPile * 0.3 then
			score = score + 30
		elseif offeredMoney > moneyPile * 0.2 then
			score = score + 20
		elseif offeredMoney > moneyPile * 0.1 then
			score = score + 10
		elseif offeredMoney < moneyPile * 0.03 then
			score = score - 30
		else
			score = score - 15
		end
		
		--Utils.LUA_DEBUGOUT("6 LICENS " .. tostring(actor) .. " -> " ..  tostring(recipient) .. " = " .. score)
		--Utils.LUA_DEBUGOUT("LICENS ------------------------------")
		return score
	end
end

function DiploScore_CallAlly(ai, actor, recipient, observer, action)
	if observer == actor then
		return 100
	else
		local actorCountry = actor:GetCountry()
		local recipientCountry = recipient:GetCountry()
		local liScore = 0
		
		if actorCountry:GetFaction() == recipientCountry:GetFaction() then
			liScore = 100
		elseif recipientCountry:GetOverlord() == actor then
			liScore = 100
		else
			if DiploScore_Alliance(ai, actor, recipient, observer, nil) < 50 then
				liScore = 40
			else
				liScore = 100
			end
		end
		
		return Utils.CallScoredCountryAI(actor, "DiploScore_CallAlly", liScore, ai, actor, recipient, observer)
	end
end


-- ############################
--  Methods that do not use the GetAIAcceptance()
-- ############################
function DiploScore_InfluenceNation(ai, actor, recipient, observer)
	if observer == actor then
		local liScore = 500
	
		local recipientCountry = recipient:GetCountry()
		local actorCountry = actor:GetCountry()
		local actorFaction = actorCountry:GetFaction()
		
		-- Calculate Importance based on IC
		---   Remember on Majors can Influence
		local maxIC = recipientCountry:GetMaxIC()
		local ourMaxIC = actorCountry:GetMaxIC()
		if maxIC > ourMaxIC then
			liScore = liScore + 70
		elseif maxIC > ourMaxIC * 0.5 then
			liScore = liScore + 40
		elseif maxIC > ourMaxIC * 0.3 then
			liScore = liScore + 30
		elseif maxIC > ourMaxIC * 0.2 then
			liScore = liScore + 20
		elseif maxIC > ourMaxIC * 0.1 then
			liScore = liScore + 10
		elseif maxIC > ourMaxIC * 0.05 then
			liScore = liScore + 5
		end
		
		-- factor neutrality
		if actorCountry:IsAtWar() then
			local effectiveNeutrality = recipientCountry:GetEffectiveNeutrality():Get()
			if effectiveNeutrality > 90 then
				liScore = liScore - 100
			elseif effectiveNeutrality > 80 then
				liScore = liScore - 70
			elseif effectiveNeutrality > 70 then
				liScore = liScore - 10
			elseif effectiveNeutrality < defines.diplomacy.JOIN_FACTION_NEUTRALITY + 10 then
				liScore = liScore + 50
			end
		end
		
		-- Political checks
		local loRelation = ai:GetRelation(actor, recipient)
		--local loStrategy = recipient:GetCountry():GetStrategy()
		
		--liScore = liScore - loStrategy:GetAntagonism(actor) / 15			
		--liScore = liScore + loStrategy:GetFriendliness(actor) / 10
		liScore = liScore - loRelation:GetThreat():Get() / 5
		liScore = liScore + loRelation:GetValue():GetTruncated() / 3
		
		if loRelation:IsGuaranteed() then
			liScore = liScore + 10
		end
		if loRelation:HasFriendlyAgreement() then
			liScore = liScore + 10
		end
		if loRelation:AllowDebts() then
			liScore = liScore + 5
		end
		if actorCountry:IsNeighbour(recipient) then
			liScore = liScore + 50
		elseif recipientCountry:GetActingCapitalLocation():GetContinent() == actorCountry:GetActingCapitalLocation():GetContinent() then
			liScore = liScore + 40
		end
		if Utils.IsFriend(ai, actorCountry:GetFaction(), recipientCountry) then
			liScore = liScore + 20
		else
			liScore = liScore - 20
		end
		if recipientCountry:IsMajor() then
			liScore = liScore + 10
		end
		if recipientCountry:HasNeighborInFaction(actorFaction) then
			liScore = liScore + 20
		end
		
		return Utils.CallScoredCountryAI(actor, 'DiploScore_InfluenceNation', liScore, ai, actor, recipient, observer)
	else
		return 100 -- we cant respond to this
	end
end
function DiploScore_Embargo(ai, actor, recipient, observer)
	if observer == actor then
		local score = 0
		local actorCountry = actor:GetCountry() 
		local recipientCountry = recipient:GetCountry() 

		if actorCountry:IsAtWar() then
			for enemy in actorCountry:GetCurrentAtWarWith() do
				if recipient:GetCountry():IsFriend(enemy, true) then
					--Utils.LUA_DEBUGOUT( "embargo score " .. tostring(actor) .. " -> " .. tostring(recipient) .. " = " .. 100 )
					return 80 -- fighting our friends
				end
			end
		end
		--Utils.LUA_DEBUGOUT( "embargo score " .. tostring(actor) .. " -> " .. tostring(recipient) .. " = " .. score )
		-- dont use up the last of our points for this
		if actorCountry:GetDiplomaticInfluence():Get() < (defines.diplomacy.EMBARGO_INFLUENCE_COST + 2) then
			score = score / 2 - 1
		end
		--Utils.LUA_DEBUGOUT( "embargo score " .. tostring(actor) .. " -> " .. tostring(recipient) .. " = " .. score )
		return Utils.CallScoredCountryAI(actor, 'DiploScore_Embargo', score, ai, actor, recipient, observer)
	else
		return 0 -- cant respond to this action
	end
end
function DiploScore_Guarantee(ai, actor, recipient, observer)
	local score = 0

	if observer == actor then
		local actorCountry = actor:GetCountry()
		local recipientCountry = recipient:GetCountry()
		if actorCountry:HasFaction() and actorCountry:GetFaction() == recipientCountry:GetFaction() then
			return 0 -- pointless
		end
		
		if actorCountry:IsGovernmentInExile() then
			return 0 -- pointless
		end
		
		local strategy = actor:GetCountry():GetStrategy()
		score = score + strategy:GetFriendliness(recipient) / 2
		score = score + strategy:GetProtectionism(recipient)
		score = score - strategy:GetAntagonism(recipient) / 2
		score = score - actor:GetCountry():GetDiplomaticDistance(recipient):GetTruncated() 
		
	end

	score = Utils.CallScoredCountryAI(actor, 'DiploScore_Guarantee', score, ai, actor, recipient, observer)
	return score
end
function DiploScore_Debt(ai, actor, recipient, observer)
	local actorCountry = actor:GetCountry()
	local recipientCountry = recipient:GetCountry()
	
	if observer == actor then
		if recipientCountry:IsAtWar() 
		and ( recipientCountry:HasFaction() and recipientCountry:GetFaction() == actorCountry:GetFaction() )
		then
			if actorCountry:GetPool():Get( CGoodsPool._MONEY_ ):Get() < 10 
			and actorCountry:GetDailyBalance(CGoodsPool._MONEY_):Get() < 0
			then 
				return 100
			else
				return 0
			end
		else
			return 0
		end
	else
		if recipientCountry:IsAtWar() 
		and ( recipientCountry:HasFaction() and recipientCountry:GetFaction() == actorCountry:GetFaction() )
		then
			local recipientMoney = recipientCountry:GetPool():Get( CGoodsPool._MONEY_ ):Get()
			local actorMoney = actorCountry:GetPool():Get( CGoodsPool._MONEY_ ):Get()
			if (recipientMoney * 5 > actorMoney) 
			and (recipientMoney > 200) then 
				return 100
			else
				return 0
			end
		else
			return 0
		end
	end
end
function DiploScore_BreakAlliance(ai, actor, recipient, observer)
	local liScore = 0

	if actor == observer then
		local actorCountry = actor:GetCountry()
		local recipientCountry = recipient:GetCountry()
		local loStrategy = actorCountry:GetStrategy()

		local loRealtions = actorCountry:GetRelation(recipient)
		local liRealtionValue = loRealtions:GetValue():GetTruncated()

		local liThreat = loRealtions:GetThreat():Get() * CalculateAlignmentFactor(ai, actorCountry, recipientCountry)
		local liAntagonism = loStrategy:GetAntagonism(recipient) / 4
		local liFriendliness = loStrategy:GetFriendliness(recipient) / 4

		liScore = ((liAntagonism + liThreat) / 2.0) - liFriendliness
		liScore = liScore - liRealtionValue / 2.0
	end
	
	return liScore
end