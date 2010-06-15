-----------------------------
-- Custom AI by Maclane
-- Version 1.3
-----------------------------
-- Modified for AI Improvement Pack

require('helper_functions')

local P = {}
Custom_AI = P

function P.CustomFactionInviteRules( score, ai, actor, recipient, observer)
	--Utils.LUA_DEBUGOUT("Enter the CustomFactionInviteRules -->>")
	local actorCountry = actor:GetCountry()
	local recipientCountry = recipient:GetCountry()
	local actorName = tostring(actor)
	local recipientName = tostring(recipient)

	local year = ai:GetCurrentDate():GetYear()
	local month = ai:GetCurrentDate():GetMonthOfYear()

	local engTag = CCountryDataBase.GetTag('ENG')
	local usaTag = CCountryDataBase.GetTag('USA')
	local gerTag = CCountryDataBase.GetTag('GER')
	local sovTag = CCountryDataBase.GetTag('SOV')
	local japTag = CCountryDataBase.GetTag('JAP')

	if actorName == 'GER' then		-- AXIS
		--Utils.LUA_DEBUGOUT("Axis invitation rules")
		if recipientName == 'AUS' then			-- AUSTRIA		
			return 0 -- we got better plans for you...
		elseif recipientName == 'ITA' then		-- ITALY
			--Utils.LUA_DEBUGOUT("Recipient is ITA...")
			if CCurrentGameState.GetProvince( 1928 ):GetController() == actor or CCurrentGameState.GetProvince( 2613 ):GetController() == actor then
				return 100	-- Warsaw or Paris is controlled by Germany
			elseif actorCountry:GetRelation(sovTag):HasWar() then
				return 100 -- Germany is at war with SOV
			else
				return 0
			end
		elseif recipientName == 'SPA' then		-- NATIONALIST SPAIN
			--Utils.LUA_DEBUGOUT("Recipient is SPA...")
			if CCurrentGameState.GetProvince( 2613 ):GetController() == actor then
				return 100	-- Paris is controlled by Germany
			else
				return 0
			end
		elseif recipientName == 'JAP' then		-- JAPAN
			--Utils.LUA_DEBUGOUT("Recipient is JAP...")
			if CCurrentGameState.GetProvince( 2613 ):GetController() == actor then
				return 100 --Japan is invited if Paris has been conquered
			elseif recipientCountry:GetRelation(usaTag):HasWar() then
				return 100 --Invite Japan if they are at war with USA
			else
				return 0
			end
		elseif recipientName == 'CHI' or recipientName == 'CGX' or recipientName == 'CSX' then	-- CHINA
			--Utils.LUA_DEBUGOUT("Recipient is CHI, CGX or CSX...")
			if recipientCountry:GetRelation(japTag):HasWar() and not actorCountry:GetRelation(japTag):HasWar() then
				return 0	-- If China is at war with Japan and Germany is not
			end
		else
			if CCurrentGameState.GetProvince( 2613 ):GetController() == actor and CCurrentGameState.GetProvince( 1928 ):GetController() == actor then
				return 100	-- Paris is controlled by Germany
			elseif actorCountry:GetRelation(sovTag):HasWar() then
				return 100 -- Germany is at war with SOV		
			elseif actorCountry:GetRelation(engTag):HasWar() then
				--Utils.LUA_DEBUGOUT("GER is at war with ENG")
				local warMonths = GetWarRunningTime(actor, engTag)
				--Utils.LUA_DEBUGOUT(warMonths)
				if warMonths >= 12 then
					return 100
				else
					return 0
				end
			else
				--Utils.LUA_DEBUGOUT("Condition is false -> return 100")
				return 0
			end		
			--Utils.LUA_DEBUGOUT("None of the mentioned recipients -> return score")
			return score
		end
	elseif actorName == 'ENG' or actorName == 'USA' then	-- ALLIES
		--Utils.LUA_DEBUGOUT("Allies invitation rules")
		if actorCountry:GetRelation(gerTag):HasWar() then
			--Utils.LUA_DEBUGOUT("Actor is at war with GER")
			if recipientCountry:GetRelation(gerTag):HasWar() then
				--Utils.LUA_DEBUGOUT("Recipient is at war with GER too -> return 100")
				return 100 --each country that is at war with GER will be invited to the Allies if the Allies are at war with Germany too
			end
			--Utils.LUA_DEBUGOUT("Recipient is not at war with GER -> proceed")
		else
			--Utils.LUA_DEBUGOUT("Actor is not at war with GER -> proceed")
		end
		if actorCountry:GetRelation(sovTag):HasWar() then
			--Utils.LUA_DEBUGOUT("Actor is at war with SOV")
			if recipientCountry:GetRelation(sovTag):HasWar() then
				--Utils.LUA_DEBUGOUT("Recipient is at war with SOV too -> return 100")
				return 100 --each country that is at war with SOV will be invited to the Allies if the Allies are at war with Soviet Union too
			end
			--Utils.LUA_DEBUGOUT("Recipient is not at war with SOV -> proceed")
		else
			--Utils.LUA_DEBUGOUT("Actor is not at war with SOV -> proceed")
		end
		if recipientName == 'USA' then	-- USA
			--Utils.LUA_DEBUGOUT("Recipient is USA")
			if recipientCountry:GetRelation(japTag):HasWar() or CCurrentGameState.GetProvince( 2613 ):GetController() == gerTag then
				return 100 --USA will be invited if they are at war with Japan or after 1941
			end
		else
			--Utils.LUA_DEBUGOUT("Recipient is not USA -> return score")
			return score
		end
	elseif actorName == 'SOV' then
	   --Utils.LUA_DEBUGOUT("Yep getting in the SOV custom script")
	   if recipientName == 'CHC' then
	      --Utils.LUA_DEBUGOUT("Recipient is CHC...")
	      if year >= 1940
		  and not gerTag:GetCountry():IsAtWar() --WW2 is over
	      and not recipientCountry:GetRelation(japTag):HasWar() --sino-japanese war is over too
          then
                --Utils.LUA_DEBUGOUT("WW2 is over -> return 100")
		    	return 100 --Communist China can join after world war is over
	      elseif actorCountry:GetRelation(japtag):HasWar() and recipientCountry:GetRelation(japTag):HasWar() then
	            --Utils.LUA_DEBUGOUT("SOV and CHC at war with JAP -> return 100")
	        	return 100 --Communist China can also join if both countries are at war with Japan
	      else
	            --Utils.LUA_DEBUGOUT("no conditions met -> return 0")
	        	return 0  --Communist China cannot join in other cases
		 end
	   end
	else
		--Utils.LUA_DEBUGOUT("Actor is neither GER nor ENG nor USA nor SOV -> return score")
		return score
	end
	--Utils.LUA_DEBUGOUT("We are after the If-Block -> return score (should not happen!)")
	return score
end

function P.CustomFactionAcceptRules( score, ai, actor, recipient, observer)
	--Utils.LUA_DEBUGOUT("Enter the CustomFactionAcceptRules -->>")
	local actorCountry = actor:GetCountry()
	local recipientCountry = recipient:GetCountry()
	local actorName = tostring(actor)
	local recipientName = tostring(recipient)
	
	local year = ai:GetCurrentDate():GetYear()
	local month = ai:GetCurrentDate():GetMonthOfYear()

	local gerTag = CCountryDataBase.GetTag('GER')
	local japTag = CCountryDataBase.GetTag('JAP')
	local sovTag = CCountryDataBase.GetTag('SOV')
	local itaTag = CCountryDataBase.GetTag('ITA')
	local engTag = CCountryDataBase.GetTag('ENG')
	local usaTag = CCountryDataBase.GetTag('USA')
	local usaCountry = usaTag:GetCountry()

	if recipientName == 'SCH' or recipientName == 'SWE' or recipientName == 'TIB' then
		--Utils.LUA_DEBUGOUT("Recipient is SCH or SWE or TIB")
		if recipientCountry:IsAtWar() then
			--Utils.LUA_DEBUGOUT("Recipient is at war -> return 100")
			return 100
		else
			--Utils.LUA_DEBUGOUT("Recipient is not at war -> return 0")
			return 0 --Switzerland, Sweden and Tibet will only join a faction to protect themselves if they are at war
		end
	elseif recipientName == 'FIN' then		--FIN
		--Utils.LUA_DEBUGOUT("Recipient is FIN")
		if recipientCountry:IsAtWar() and not recipientCountry:GetRelation(sovTag):HasWar() then
			--Utils.LUA_DEBUGOUT("Recipient is at war")
			return 100
		elseif actorCountry:GetRelation(sovTag):HasWar() and CCurrentGameState.GetProvince( 698 ):GetController() ~= recipient then
			--Utils.LUA_DEBUGOUT("Faction at war with SOV")
			return 100 -- faction is at war with SOV and FIN lost Winter War
		else
			--Utils.LUA_DEBUGOUT("No conditions met")
			return 0
		end
	end

	if actorName == 'ENG' or actorName == 'USA' then	-- ALLIES
		--Utils.LUA_DEBUGOUT("Actor is ENG or USA")
		if recipientCountry:GetRelation(gerTag):HasWar() then
			--Utils.LUA_DEBUGOUT("Recipient is at war with GER -> return 100")
			return 100 --each country at war with GER will accept invitation
		end

		if recipientName == 'USA' then			--USA
			--Utils.LUA_DEBUGOUT("Recipient is USA...")
			if recipientCountry:GetRelation(japTag):HasWar() or recipientCountry:GetRelation(sovTag):HasWar() then
				return 100 --USA will accept if at war with Japan or Soviet Union
			elseif CCurrentGameState.GetProvince( 1964 ):GetController() ~= actor then
				return 100 --USA will accept if London has been conquered
			elseif actorCountry:GetRelation(gerTag):HasWar() then
				--Utils.LUA_DEBUGOUT("GER is at war with ENG")
				local warMonths = GetWarRunningTime(actor, engTag)
				--Utils.LUA_DEBUGOUT(warMonths)
				if warMonths >= 12 then
					return 100
				else
					return 0
				end
			else
				return 0 -- Conditions not met
			end
		elseif recipientName == 'CAN'			--COMMONWEALTH
			or recipientName == 'AST'
			or recipientName == 'NZL'
			or recipientName == 'SAF'
			then
				--Utils.LUA_DEBUGOUT("Recipient is Commonwealth Country")
				return 100 --Commonwealth countries will always accept invitation by ENG
		elseif recipientName == 'GRE' then		--GREECE
			--Utils.LUA_DEBUGOUT("Recipient is GRE...")
			if recipientCountry:GetRelation(itaTag):HasWar() then
				--Utils.LUA_DEBUGOUT("Recipient is at war with ITA -> return 100")
				return 100 --Greece will accept invitation if at war with Italy
			else
				--Utils.LUA_DEBUGOUT("Recipient is not at war with ITA -> return 0")
				return 0 --Greece won't accept if not at war with ITA
			end
		elseif recipientName == 'CHI' then		--CHINA
			--Utils.LUA_DEBUGOUT("Recipient is CHI...")
			if recipientCountry:GetRelation(japTag):HasWar() and actorCountry:GetRelation(japTag):HasWar() then
				--Utils.LUA_DEBUGOUT("Actor and Recipient are at war with JAP -> return 100")
				return 100 -- If both are at war with Japan 
			else
				return 0 
			end
		elseif recipientName == 'VIC' then		--VIC
			return 0
		elseif usaCountry:HasFaction() then
		    return 100  --every country will accept if USA is member of a faction
		else
			--Utils.LUA_DEBUGOUT("none of the mentioned recipients -> return 0")
			return 0 --every other Minor won't accept invitation (unless USA is member of the Allies)
		end
	end

	if actorName == 'GER' then		-- AXIS
		--Utils.LUA_DEBUGOUT("Actor is GER...")
		if recipientName == 'JAP' then			-- JAPAN
			--Utils.LUA_DEBUGOUT("Recipient is JAP...")
			if CCurrentGameState.GetProvince( 1409 ):GetController() == actor and CCurrentGameState.GetProvince( 2857 ):GetController() == actor then
				return 100 --Japan will accept if Moscow and Stalingrad has been conquered by Germany
			elseif recipientCountry:GetRelation(engTag):HasWar() or recipientCountry:GetRelation(usaTag):HasWar() then
				return 100 --Japan will accept if it is at war with ENG or USA
			elseif actorCountry:GetRelation(engTag):HasWar() then
				--Utils.LUA_DEBUGOUT("GER is at war with ENG")
				local warMonths = GetWarRunningTime(actor, engTag)
				--Utils.LUA_DEBUGOUT(warMonths)
				if warMonths >= 12 then
					return 100
				else
					return 0
				end
			else
				return 0 --don't accept in others cases
			end
		elseif recipientName == 'ITA' then		-- ITALY
			--Utils.LUA_DEBUGOUT("Recipient is ITA...")
			if CCurrentGameState.GetProvince( 1928 ):GetController() == actor or CCurrentGameState.GetProvince( 2613 ):GetController() == actor then
				return 100 -- Germany controls Warsaw or Paris
			elseif actorCountry:GetRelation(sovTag):HasWar() then
				return 100 -- Germany is at war with SOV
			else
				return 0
			end
		elseif recipientName == 'SPA' then		-- NATIONALIST SPAIN
			--Utils.LUA_DEBUGOUT("Recipient is SPA...")
			if CCurrentGameState.GetProvince( 2613 ):GetController() == actor and CCurrentGameState.GetProvince( 1928 ):GetController() == actor  then
				return 100 --Germany controls Paris and Warsaw
			else
				return 0
			end
		elseif recipientName == 'CHI' or recipientName == 'CGX' or recipientName == 'CSX' then	-- CHINA
			--Utils.LUA_DEBUGOUT("Recipient is CHI, CGX or CSX...")
			if recipientCountry:GetRelation(japTag):HasWar() and not actorCountry:GetRelation(japTag):HasWar() then
				return 0	-- China is at war with Japan and Germany is not
			end
		elseif recipientName == 'CAN'			--COMMONWEALTH
			or recipientName == 'AST'
			or recipientName == 'NZL'
			or recipientName == 'SAF'
		then
				--Utils.LUA_DEBUGOUT("Recipient is Commonwealth Country")
				return 0 --Commonwealth never accept invitation from Axis
		else
			if CCurrentGameState.GetProvince( 2613 ):GetController() == actor then
				return 100 -- If Paris is controlled by Germany
			elseif actorCountry:GetRelation(sovTag):HasWar() or actorCountry:GetRelation(usaTag):HasWar() then
				return 100 --If GER at war with USA or SOV, return 100			
			elseif actorCountry:GetRelation(engTag):HasWar() then
				--Utils.LUA_DEBUGOUT("GER is at war with ENG")
				local warMonths = GetWarRunningTime(actor, engTag)
				--Utils.LUA_DEBUGOUT(warMonths)
				if warMonths >= 12 then
					return 100
				else
					return 0
				end
			else
				--Utils.LUA_DEBUGOUT("Condition is false -> return 100")
				return 0
			end	
		end
	end

	--Utils.LUA_DEBUGOUT("Last line, no conditions met -> return score")
	return score
end

function P.CustomAllianceRules( ai, actor, recipient, observer)
	--Utils.LUA_DEBUGOUT("Enter CustomAllianceRules function")
	local actorCountry = actor:GetCountry()
	local recipientCountry = recipient:GetCountry()
	local actorName = tostring(actor)
	local recipientName = tostring(recipient)
	
	--Utils.LUA_DEBUGOUT("Actor: " .. tostring(actor))
	--Utils.LUA_DEBUGOUT("Recipient: " .. tostring(recipient))
	
	if recipientCountry:HasFaction() or actorCountry:HasFaction() then
		--Utils.LUA_DEBUGOUT("NO ALLIANCE: Faction members")
		return 0	-- No separate alliance for faction members
	elseif (actorName == 'POL' or recipientName == 'POL') and (actorName == 'ITA' or recipientName == 'ITA') then
		--Utils.LUA_DEBUGOUT("NO ALLIANCE: Poland & Italy")
		return 0	-- No alliance for Poland and Italy
	end	
	--Utils.LUA_DEBUGOUT("No objection for an alliance")
	return 1
end

return Custom_AI