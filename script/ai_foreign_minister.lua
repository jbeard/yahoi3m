-----------------------------------------------------------
-- LUA Hearts of Iron 3 Foreign Minister File
-- Created By: Lothos
-- Modified By: Lothos
-- Date Last Modified: 5/19/2010
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

	-- Request for Military Access
	for neighborTag in ministerCountry:GetNeighbours() do
		local loRelation = ai:GetRelation(ministerTag, neighborTag)
		
		-- Process all Neighbors as we may just need access through them even though
		--   they are not a neighbor with any of our enemies (Germany with Sweden for example)
		if not(loRelation:HasMilitaryAccess())
		and not(loRelation:HasAlliance()) then
			local loAction = CMilitaryAccessAction(ministerTag, neighborTag)

			if loAction:IsSelectable() then
				local liScore = DiploScore_DemandMilitaryAccess(ai, ministerTag, neighborTag, ministerTag)

				if liScore > 50 then
					minister:Propose(loAction, liScore)
				end
			end
		end
	end

	
	-- Call our Allies in
	if Utils.HasCountryAIFunction( ministerTag, "CallAlly") then
		Utils.CallCountryAI(ministerTag, "CallAlly", minister)							
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
	
	-- Join Faction (or exit)
	-- Offer Military Access (Think this should be removed, should never offer it!)


	local ai = minister:GetOwnerAI()
	local ministerCountry = minister:GetCountry()
	local ministerTag = minister:GetCountryTag()
	local lbIsMajor = ministerCountry:IsMajor()
	local loFaction = ministerCountry:GetFaction()

	-- 0.15 is the default parm on ai_tech_minister.lua LEADERSHIP_DIPLOMACY
	local liDailyDiplomatic = math.floor((ministerCountry:GetTotalLeadership():Get() * 0.15) / 2)
	local liDailyActive = ministerCountry:CalculateNumberOfActiveInfluences()
	local liInfluenceLeft = math.max(0, (liDailyDiplomatic - liDailyActive))
	
	-- Best Country to influece to join us
	local loInfluenceAction = nil
	local loInfluenceActionScore = 0
	
	-- Worst Neighbot to Influence to join us
	local loInfluenceActionWorst = nil
	
	local loInfluenceCountry = {}
	local loInfluenceScore = {}
	
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
					-- Invite into faction
					local loAction = CFactionAction(ministerTag, loTargetCountryTag)
					loAction:SetValue(false)

					if loAction:IsSelectable() then
						local liScore = loAction:GetAIAcceptance()
						
						if liScore > 50 then
							if liScore > 50 then
								minister:Propose(loAction, liScore )
							end
						end
					end			

					-- Influence a country
					local lbIsInfluencing = ai:IsInfluencing(ministerTag, loTargetCountryTag)
					
					-- Do we have any slots actually open
					--   Only do one influence per tick
					if liInfluenceLeft > 0 and not(lbIsInfluencing) then
						local liScore = DiploScore_InfluenceNation( ai, ministerTag, loTargetCountryTag, ministerTag )
						
						if liScore > loInfluenceActionScore then
							loInfluenceActionScore = liScore
							loInfluenceAction = CInfluenceNation(ministerTag, loTargetCountryTag)
						
						-- Help try and keep neighbors from joining my enemies
						elseif ministerCountry:IsNeighbour(loTargetCountryTag) and loInfluenceActionWorst == nil then
							if not(Utils.IsFriend(ai, loFaction, loTargetCountry)) then
								loInfluenceActionWorst = CInfluenceNation(ministerTag, loTargetCountryTag)
							end
						end
						
					-- Track who we are currently influencing
					elseif lbIsInfluencing then
						table.insert(loInfluenceCountry, loTargetCountry)
						table.insert(loInfluenceScore, DiploScore_InfluenceNation( ai, ministerTag, loTargetCountryTag, ministerTag ))
						
					-- Help try and keep neighbors from joining my enemies
					elseif ministerCountry:IsNeighbour(loTargetCountryTag) and loInfluenceActionWorst == nil then
						if not(Utils.IsFriend(ai, loFaction, loTargetCountry)) then
							loInfluenceActionWorst = CInfluenceNation(ministerTag, loTargetCountryTag)
						end
					end
				end

				-- Form Alliance
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
			-- END OF MAJOR POWER ONLY

			-- NAP-ing
			if not(loRelation:HasNap()) then
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
	
	-- Decide what to do with the Influence setup from main loop
	if lbIsMajor then
		if table.getn(loInfluenceCountry) > 0 then
			local lbNeighborCheck = false -- Make sure atleast 1 influence is to prevent someone joining enemy
			
			for i = 1, table.getn(loInfluenceCountry) do
				if ministerCountry:IsNeighbour(loInfluenceCountry[i]:GetCountryTag()) then
					if not(Utils.IsFriend(ai, loFaction, loInfluenceCountry[i])) then
						lbNeighborCheck = true
					end
				end
			end
			
			-- We have a slot open and we have a bad neighbor and no influence is going 
			--   to another bad neighbor
			if not(lbNeighborCheck) and not(loInfluenceActionWorst == nil) and liInfluenceLeft > 0 then
				ai:PostAction(loInfluenceActionWorst)
			
			-- Cancel a random influence to effect one of our bad neighbors
			elseif not(lbNeighborCheck) and not(loInfluenceActionWorst == nil) and liInfluenceLeft <= 0 then
				loInfluenceAction = CInfluenceNation(ministerTag, loInfluenceCountry[math.random(table.getn(loInfluenceCountry))]:GetCountryTag())
				loInfluenceAction:SetValue(false)
				minister:Propose(loInfluenceAction , 1000 )
				
				-- Send up the neighbor one
				minister:Propose(loInfluenceActionWorst , 1000 )
				
			-- We are already influencing one bad neigbor (or dont have one) so do a regular influence
			elseif not(loInfluenceAction == nil) then
				ai:PostAction(loInfluenceAction)
			end
			
		elseif not(loInfluenceAction == nil) and liInfluenceLeft > 0  then
			ai:PostAction(loInfluenceAction)
			
		elseif not(loInfluenceActionWorst == nil) and liInfluenceLeft > 0  then
			minister:Propose(loInfluenceActionWorst , 1000 )
		end
	end
end
