-----------------------------------------------------------
-- LUA Hearts of Iron 3 Auto EXE File
-- Modified By: Lothos
-- Date Last Modified: 6/9/2010
--
-- NOTES: This file is run on app start after exports are done inside 
-- 		  the engine (once per context created)
-----------------------------------------------------------

-- check for user mod files
if CAI.HasUserExtension() then
	local modDir = tostring(CAI.GetModDirectory())
	package.path = package.path .. ";" .. modDir .. "\\?.lua;" .. modDir .. "\\country\\?.lua"
end

package.path = package.path .. ";script\\?.lua;script\\country\\?.lua"

if CAI.HasCommonExtension() then
	local modDir = tostring(CAI.GetCommonModDirectory())
	package.path = package.path .. ";" .. modDir .. "\\?.lua"
end

package.path = package.path .. ";common\\?.lua"

--require('hoi') -- already imported by game, contains all exported classes
require('utils')
require('defines')
require('ai_country')
require('ai_foreign_minister')
require('ai_intelligence_minister')
require('ai_politics_minister')
require('ai_production_minister')
require('ai_support_functions')
require('ai_tech_minister')
require('ai_trade')


-- load country specific AI modules.
-- Majors
require('GER')
require('ENG')
require('SOV')
require('USA')
require('ITA')
require('JAP')
require('FRA')

-- Minors (Alphabetized)
require('AST')
require('BEL')
require('BUL')
require('CAN')
require('CGX')
require('CHC')
require('CHI')
require('CSX')
require('CXB')
require('CYN')
require('FIN')
require('HOL')
require('MAN')
require('MEN')
require('NZL')
require('POR')
require('ROM')
require('SAF')
require('SCH')
require('SIA')
require('SIK')
require('SPA')
require('SPR')
require('SWE')
require('TUR')
require('VIC')