-----------------------------------------------------------
-- LUA Hearts of Iron 3 Foreign Minister File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 7/12/2010
-----------------------------------------------------------

require('ai_diplomacy')

-- ##############################
-- Methods Called by the EXE

function ForeignMinister_OnWar( agent, countryTag1, countryTag2, war )
	--if war:IsLimited() then
		-- dont pull anything else right now, lets wait until we need it
	--end
end

function ForeignMinister_EvaluateDecision(agent, decision, scope) 
	-- default we approve any decision we can take, override in country specific ai if wanted
	-- also some random to spread out the decisions
	local score = math.mod( CCurrentGameState.GetAIRand(), 100)

	score = Utils.CallScoredCountryAI(agent:GetCountryTag(), 'ForeignMinister_EvaluateDecision', score, agent, decision, scope)

	if score < 25 then
		score = 0
	end
	return score
end

function ForeignMinister_Tick(minister)
	-- run any decisions available
	minister:ExecuteDiploDecisions()

	-- Call for special AI Political checks
    if math.mod( CCurrentGameState.GetAIRand(), 12) == 0 then
		if Utils.HasCountryAIFunction( minister:GetCountryTag(), "Call_ForeignMinister") then
			Utils.CallCountryAI(minister:GetCountryTag(), "Call_ForeignMinister", minister)							
		end
	end
	
	
	if math.mod( CCurrentGameState.GetAIRand(), 7) == 0 then
		Utils.CallCountryAI( minister:GetCountryTag(), "ProposeDeclareWar", minister )
		ForeignMinister_HandlePeace(minister)
	end
		
	if minister:GetCountry():IsAtWar() then
		if math.mod( CCurrentGameState.GetAIRand(), 7) == 0 then
			ForeignMinister_HandleWar(minister)
		end
	end
end

-- End of Methods Called by the EXE
-- ##############################



function ForeignMinister_HandleWar(minister)
	local ministerTag = minister:GetCountryTag()
	local ministerCountry = minister:GetCountry()
	local ai = minister:GetOwnerAI()
	local lbIsMajor = ministerCountry:IsMajor()

	-- Request for Military Access
	--  Only major powers will request military access
	if Utils.HasCountryAIFunction( ministerTag, "Call_MilitaryAccess") then
		Utils.CallCountryAI(ministerTag, "Call_MilitaryAccess", minister)							
	elseif lbIsMajor then
		for loCountryTag in ministerCountry:GetNeighbours() do
			local loCountry = loCountryTag:GetCountry()
			
			-- Do not bother asking major powers for military access
			if not(loCountry:IsMajor()) then
				-- If they are already in a faction do not bother them
				-- If they are in a war already do not bother them
				if not(loCountry:HasFaction()) and not(loCountry:IsAtWar()) then
					local loRelation = ai:GetRelation(ministerTag, loCountryTag)

					-- Make sure we do not already have military access
					if not(loRelation:HasMilitaryAccess()) then
						local lbAsk = false
						
						-- Now check their neighbors to see if they touch an enemy
						for loCountryTag2 in loCountry:GetNeighbours() do
							if not(loCountryTag2 == ministerTag) then
								local loRelation2 = ai:GetRelation(ministerTag, loCountryTag2)
							
								if loRelation2:HasWar() then
									lbAsk = true
									break
								end
							end
						end
						
						if lbAsk then
							local loAction = CMilitaryAccessAction(ministerTag, loCountryTag)

							if loAction:IsSelectable() then
								local liScore = DiploScore_DemandMilitaryAccess(ai, ministerTag, loCountryTag, ministerTag)

								if liScore > 50 then
									minister:Propose(loAction, liScore)
								end
							end
						end
					end
				end
			end
		end
	end

	
	-- Call our Allies in
	if Utils.HasCountryAIFunction( ministerTag, "Call_Ally") then
		Utils.CallCountryAI(ministerTag, "Call_Ally", minister)							
	else
		for loDiploStatus in ministerCountry:GetDiplomacy() do
			local loTargetTag = loDiploStatus:GetTarget()
			
			if loTargetTag:IsValid() and loDiploStatus:HasWar() then
				local loWar = loDiploStatus:GetWar()
				
				-- Call in Puppets
				for loPuppetTag in ministerCountry:GetVassals() do
					if not(loPuppetTag:GetCountry():GetRelation(loTargetTag):HasWar()) then
						local loAction = CCallAllyAction( ministerTag, loPuppetTag, loTargetTag )
						loAction:SetValue( true ) -- limited
						
						if loAction:IsSelectable() then
							ai:PostAction( loAction )
						end
					end
				end
					
				if loWar:IsLimited() then
					-- do we want to call in help?
					if loWar:GetCurrentRunningTimeInMonths() > 5 then
						if ministerCountry:CalcDesperation():Get() > 0.4 then --strengthFactor < 1.4 then
							for loAllyTag in ministerCountry:GetAllies() do
								if not(loAllyTag:GetCountry():GetRelation(loTargetTag):HasWar()) then
									local loAction = CCallAllyAction( ministerTag, loAllyTag, loTargetTag )
									loAction:SetValue( true ) -- limited
									
									if loAction:IsSelectable() then
										ai:PostAction( loAction )
									end
								end
							end
						end
					end
				else -- not-limited, call in any faction members not there:
					-- Call in Allies
					for loAllyTag in ministerCountry:GetAllies() do
						if not(loAllyTag:GetCountry():GetRelation(loTargetTag):HasWar()) then
							local loAction = CCallAllyAction( ministerTag, loAllyTag, loTargetTag )
							loAction:SetValue( true ) -- limited
							
							if loAction:IsSelectable() then
								ai:PostAction( loAction )
							end
						end
					end
				end
			end
		end
	end
end
function ForeignMinister_HandlePeace(minister)
	-- Invite to Faction
	-- Influence
	-- NAP (Non Aggression Pact)
	-- Guarantee 
	-- Allow Debt
	-- Alliance (Forming)
	-- Alliance (Breaking)
	-- Embargo (Making and Cancelling)	
	-- Offer Military Access

	-- Join Faction (or exit)

	local ai = minister:GetOwnerAI()
	local ministerCountry = minister:GetCountry()
	local ministerTag = minister:GetCountryTag()
	local lbIsMajor = ministerCountry:IsMajor()
	local loFaction = ministerCountry:GetFaction()

	-- 0.15 is the default parm on ai_tech_minister.lua LEADERSHIP_DIPLOMACY
	local liDailyDiplomatic = math.floor((ministerCountry:GetTotalLeadership():Get() * 0.15) / 2)
	local liDailyActive = ministerCountry:CalculateNumberOfActiveInfluences()
	local liInfluenceLeft = liDailyDiplomatic - liDailyActive
	
	-- Best Country to influece to join us
	local loInfluenceAction = nil
	local loInfluenceActionScore = 0
	local loInfluenceActionWorstScore = 9999
	
	-- Worst Neighbor to Influence to join us
	local loInfluenceActionWorst = nil
	
	local loInfluenceCountry = {}
	local loInfluenceScore = {}
	local laInfluenceIgnore = {}
	local laInfluenceMonitor = {}

	-- Major power only parameter loading
	if lbIsMajor then
		-- Retrieve the influence ignore list if your a major power
		if Utils.HasCountryAIFunction(ministerTag, "InfluenceIgnore") then
			laInfluenceIgnore = Utils.CallCountryAI(ministerTag, "InfluenceIgnore", minister)
		end

		-- Retrieve the list of countries to monitor in case they start joining our enemies
		if Utils.HasCountryAIFunction(ministerTag, "InfluenceMonitor") then
			laInfluenceMonitor = Utils.CallCountryAI(ministerTag, "InfluenceMonitor", minister)
		end		
	end
	
	-- Main Country processing loop
	for loTargetCountry in CCurrentGameState.GetCountries() do
		local loTargetCountryTag = loTargetCountry:GetCountryTag()

		if not(ministerCountry:HasDiplomatEnroute(loTargetCountryTag))
		and not(loTargetCountryTag == ministerTag) 
		and loTargetCountry:Exists()
		and loTargetCountryTag:IsReal()
		and loTargetCountryTag:IsValid() then
		
			local loRelation = ai:GetRelation(ministerTag, loTargetCountryTag)
			
			-- ONLY MAJOR POWERS CAN DO
			if lbIsMajor then
				-- Calls in here Require Major be in a faction and target is not in a faction
				if ministerCountry:HasFaction() and not(loTargetCountry:HasFaction()) then
					local lsTargetCountryTag = tostring(loTargetCountryTag)
					
					-- Invite into faction
					local loAction = CFactionAction(ministerTag, loTargetCountryTag)
					loAction:SetValue(false)

					if loAction:IsSelectable() then
						local liScore = DiploScore_InviteToFaction(ai, ministerTag, loTargetCountryTag, ministerTag)
						
						if liScore > 50 then
							if liScore > 50 then
								minister:Propose(loAction, liScore)
							end
						end
					end			

					-- Make sure the country is not on my ignore list
					if not(CheckInfluenceParameter(laInfluenceIgnore, lsTargetCountryTag)) then
						-- Influence a country
						local lbIsInfluencing = ai:IsInfluencing(ministerTag, loTargetCountryTag)
						
						-- Do we have any slots actually open
						--   Only do one influence per tick
						if liInfluenceLeft > 0 and not(lbIsInfluencing) then
							local liScore = DiploScore_InfluenceNation(ai, ministerTag, loTargetCountryTag, ministerTag)
							
							if liScore > loInfluenceActionScore then
								loInfluenceActionScore = liScore
								loInfluenceAction = CInfluenceNation(ministerTag, loTargetCountryTag)
							
							-- Help try and keep neighbors from joining my enemies
							elseif ministerCountry:IsNeighbour(loTargetCountryTag)
							or CheckInfluenceParameter(laInfluenceMonitor, lsTargetCountryTag) then
								if not(Utils.IsFriend(ai, loFaction, loTargetCountry)) then
									if liScore < loInfluenceActionWorstScore then
										loInfluenceActionWorstScore = liScore
										loInfluenceActionWorst = CInfluenceNation(ministerTag, loTargetCountryTag)
									end
								end
							end
							
						-- Track who we are currently influencing
						elseif lbIsInfluencing then
							table.insert(loInfluenceCountry, loTargetCountryTag)
							table.insert(loInfluenceScore, DiploScore_InfluenceNation( ai, ministerTag, loTargetCountryTag, ministerTag ))
							
						-- Help try and keep neighbors from joining my enemies
						elseif ministerCountry:IsNeighbour(loTargetCountryTag)
						or CheckInfluenceParameter(laInfluenceMonitor, lsTargetCountryTag) then
							if not(Utils.IsFriend(ai, loFaction, loTargetCountry)) then
								local liScore = DiploScore_InfluenceNation( ai, ministerTag, loTargetCountryTag, ministerTag )
								
								if liScore < loInfluenceActionWorstScore then
									loInfluenceActionWorstScore = liScore
									loInfluenceActionWorst = CInfluenceNation(ministerTag, loTargetCountryTag)
									
								-- Check to see if they have a higher prio than our current influencing country
								elseif liScore > loInfluenceActionScore then
									loInfluenceActionScore = liScore
									loInfluenceAction = CInfluenceNation(ministerTag, loTargetCountryTag)
								end
							end
						
						-- Check to see if they have a higher prio than our current influencing country
						else
							local liScore = DiploScore_InfluenceNation( ai, ministerTag, loTargetCountryTag, ministerTag )
							
							if liScore > loInfluenceActionScore then
								loInfluenceActionScore = liScore
								loInfluenceAction = CInfluenceNation(ministerTag, loTargetCountryTag)
							end
						end
					end
				end

				-- Form Alliance
				--    note: only countries that are not part of a faction will offer alliances
				if not(ministerCountry:HasFaction()) then
					if not(loRelation:HasAlliance()) and tonumber(tostring(loRelation:GetValue():GetTruncated())) > 0 then
						local loAction = CAllianceAction(ministerTag, loTargetCountryTag)	
						
						if loAction:IsSelectable() then
							local liScore = loAction:GetAIAcceptance()
							
							if liScore > 50 then
								ai:PostAction(loAction)
							end
						end
					end	
				end
			end
			-- END OF MAJOR POWER ONLY

			-- Offer Military Access
			if ministerCountry:IsNeighbour(loTargetCountryTag) then
				if not(loRelation:HasMilitaryAccess()) and loTargetCountry:IsAtWar() then
					-- Make sure they are the same Ideology Group
					if loMinisterGroup == loTargetGroup then
						local loAction = COfferMilitaryAccessAction(ministerTag, loTargetCountryTag)

						if loAction:IsSelectable() then
							local liScore = DiploScore_OfferMilitaryAccess(ai, ministerTag, loTargetCountryTag, ministerTag)
							
							if liScore > 50 then
								minister:Propose(loAction, liScore)
							end
						end
					end
				end
			end
			
			-- NAP-ing
			--   note: if the two have an alliance or part of the same faction (or aligning to the same side) dont bother with a NAP
			if not(loRelation:HasNap()) 
			and not(loRelation:HasAlliance())
			and not(ministerCountry:GetFaction() == loTargetCountry:GetFaction())then
				local loAction = CNapAction(ministerTag, loTargetCountryTag)	
				
				if loAction:IsSelectable() then
					local liScore = loAction:GetAIAcceptance()
					
					if liScore > 50 then
						ai:PostAction(loAction)
					end
				end
			end

			-- Guarantee
			if not(loRelation:IsGuaranting()) then
				local loAction = CGuaranteeAction(ministerTag, loTargetCountryTag)	
				
				if loAction:IsSelectable() then
					local liScore = DiploScore_Guarantee(ai, ministerTag, loTargetCountryTag, ministerTag)
					
					if liScore > 50 then
						minister:Propose(loAction, liScore)
					end
				end
			end

			-- Allow Debt
			if not(loRelation:AllowDebts()) then
				local loAction = CDebtAction(ministerTag, loTargetCountryTag)	
				
				if loAction:IsSelectable() then
					local liScore = DiploScore_Debt( ai, ministerTag, loTargetCountryTag, ministerTag )

					if liScore > 50 then
						minister:Propose(loAction, liScore)
					end
				end
			end		

			-- Embargo
			local loAction = CEmbargoAction(ministerTag, loTargetCountryTag)
			
			if loRelation:HasEmbargo() then
				-- do we want to stop embargoing?
				loAction:SetValue(false)
				
				if loAction:IsSelectable() then
					local liScore = DiploScore_Embargo(ai, ministerTag, loTargetCountryTag, ministerTag)

					if liScore < 40 then
						minister:Propose(loAction, 100)
					end
				end
				
			else
				if loAction:IsSelectable() then
					local liScore = DiploScore_Embargo(ai, ministerTag, loTargetCountryTag, ministerTag)

					if liScore > 50 then
						minister:Propose(loAction, liScore )
					end
				end
			end
		end
	end
	-- END OF MAIN LOOP
	
	-- Break Alliance
	if ministerCountry:HasFaction() then
		-- You are in a faction so break all your alliances and stay true to just your faction
		for loTargetCountryTag in ministerCountry:GetAllies() do
			local loAction = CAllianceAction(ministerTag, loTargetCountryTag)
			loAction:SetValue(false) -- cancel
			
			if loAction:IsSelectable() then
				minister:Propose(loAction, 100)
			end
		end		
	else
		for loTargetCountryTag in ministerCountry:GetAllies() do
			local liScore = DiploScore_BreakAlliance(ai, ministerTag, loTargetCountryTag, ministerTag)

			if liScore >= 100 then
				local loAction = CAllianceAction(ministerTag, loTargetCountryTag)
				loAction:SetValue(false) -- cancel
				
				if loAction:IsSelectable() then
					minister:Propose(loAction, liScore )
				end
			end
		end		
	end
	
	-- Decide what to do with the Influence setup from main loop
	if lbIsMajor then
		local liInfluenceCount = table.getn(loInfluenceCountry)
	
		if liInfluenceCount > 0 then
			local lbNeighborCheck = false -- Make sure atleast 1 influence is to prevent someone joining enemy
			
			for i = 1, table.getn(loInfluenceCountry) do
				if ministerCountry:IsNeighbour(loInfluenceCountry[i]) then
					if not(Utils.IsFriend(ai, loFaction, loInfluenceCountry[i]:GetCountry())) then
						-- Check the score of it to see if you have a new one that is better to influence
						if loInfluenceScore[i] < loInfluenceActionWorstScore and not(loInfluenceActionWorst == nil) then
							-- Cancel old Influence
							local loInfluenceActionCancel = CInfluenceNation(ministerTag, loInfluenceCountry[i])
							loInfluenceActionCancel:SetValue(false)
							minister:Propose(loInfluenceActionCancel , 1000 )
							
							-- Create new influence
							minister:Propose(loInfluenceActionWorst , 1000 )
						end
					
						-- Remove it now from the table in case we need to re-check influences as this
						--    one counts as our negative check
						--    only remove it from the table if things are ok. If we are in the negative
						--    leave it there so it gets deleted below
						if liInfluenceLeft >= 0 then
							table.remove(loInfluenceCountry, i)
							table.remove(loInfluenceScore, i)
							liInfluenceCount = liInfluenceCount - 1
						end
						
						lbNeighborCheck = true
						break;
					end
				end
			end
			
			-- We have a slot open and we have a bad neighbor and no influence is going 
			--   to another bad neighbor
			if not(lbNeighborCheck) and not(loInfluenceActionWorst == nil) and liInfluenceLeft > 0 then
				ai:PostAction(loInfluenceActionWorst)
			
			-- Cancel a random influence to effect one of our bad neighbors
			elseif not(lbNeighborCheck) and not(loInfluenceActionWorst == nil) and liInfluenceLeft <= 0 then
				-- Cancel our lowest score influence to effect one of our neighbors
				local liScore = 9999
				local loInfluenceActionCancel = nil
				
				-- Check your current influence scores and compare them to the ones you have
				for i = 1, table.getn(loInfluenceScore) do
					if loInfluenceScore[i] < liScore then
						-- Cancel old Influence
						liScore = loInfluenceScore[i]
						loInfluenceActionCancel = CInfluenceNation(ministerTag, loInfluenceCountry[i])
					end
				end
				
				-- Cancel the influence
				loInfluenceActionCancel:SetValue(false)
				minister:Propose(loInfluenceActionCancel , 1000 )
				
				-- Send up the neighbor one
				minister:Propose(loInfluenceActionWorst , 1000 )
				
			-- We are already influencing one bad neigbor (or dont have one) so do a regular influence
			elseif not(loInfluenceAction == nil) and liInfluenceLeft > 0 then
				ai:PostAction(loInfluenceAction)
			
			-- We are influencing more than we can afford
			elseif liInfluenceLeft < 0 and liInfluenceCount > 0  then
				local liScore = 9999
				local loInfluenceActionCancel = nil
				
				-- Check your current influence scores and compare them to the ones you have
				for i = 1, table.getn(loInfluenceScore) do
					if loInfluenceScore[i] < liScore then
						-- Cancel old Influence
						liScore = loInfluenceScore[i]
						loInfluenceActionCancel = CInfluenceNation(ministerTag, loInfluenceCountry[i])
					end
				end
				
				-- Cancel the influence
				loInfluenceActionCancel:SetValue(false)
				minister:Propose(loInfluenceActionCancel , 1000 )
				
			-- Verify Current Influences make sure they are ok
			elseif liInfluenceCount > 0 and not(loInfluenceAction == nil) then
				-- Check your current influence scores and compare them to the ones you have
				for i = 1, table.getn(loInfluenceScore) do
					if loInfluenceActionScore > loInfluenceScore[i] then
						-- Cancel old Influence
						local loInfluenceActionCancel = CInfluenceNation(ministerTag, loInfluenceCountry[i])
						loInfluenceActionCancel:SetValue(false)
						minister:Propose(loInfluenceActionCancel , 1000 )
						
						-- Create new influence
						minister:Propose(loInfluenceAction , 1000 )
						break
					end
				end
				
			-- Something strange going on, if I do not terminate it causes the top score not to be used
			--    no error is being reported but you can see it happen cause in 36 Germany always influences Belgium instead of Italy.
			else
				loInfluenceAction = nil
				loInfluenceActionWorst = nil
			end
			
		elseif not(loInfluenceActionWorst == nil) and liInfluenceLeft > 0  then
			minister:Propose(loInfluenceActionWorst , 1000 )

		elseif not(loInfluenceAction == nil) and liInfluenceLeft > 0  then
			ai:PostAction(loInfluenceAction)
		else
			loInfluenceAction = nil
			loInfluenceActionWorst = nil
		end
	end
end

function CheckInfluenceParameter(vaInfluenceParameter, vsCountryTag)
	local lbValue = false
	local liTableLength = table.getn(vaInfluenceParameter)
	
	if liTableLength > 0 then
		for i = 1, liTableLength do
			if vaInfluenceParameter[i] == vsCountryTag then
				lbValue = true
				break
			end
		end
	end
	
	return lbValue
end