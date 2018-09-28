--
-- Global Settings
--
-- Chara Level 1~20
-- Troop Level 1~20
-- City  Level 1~20
--
--

--scenario
require "scenario_test"
require "scenario_threekindoms"
require "scenario_chuhan"


FeatureOption =
{
	DISABLE_FOOD_SUPPLY = nil,
	DISABLE_GOAL        = nil,
	DISABLE_CONQUER     = nil,
}

ScenarioData = 
{
	--Standard
	RESOURCE_DATA     = DefaultResourceData,
	DISTRICT_DATA     = DefaultBuildingData,	

	--Plot Datas
	PLOT_BONUS_DATA   = DefaultPlotBonus,
	PLOT_TERRAIN_DATA = DefaultPlotTerrainBonus,
	PLOT_FEATURE_DATA = DefaultPlotFeatureBonus,
	PLOT_TABLE_DATA   = DefaultPlotTableData,

	--Name Datas
	CHARA_FAMILYNAME_DATA = DefaultCharaFamilyName,
	CHARA_GIVENNAME_DATA  = DefaultCharaGivenName,

	--datas
	CHARA_PROMOTE_DATA    = DefaultJobPromoteData,
	CHARA_PROMOTE_METHOD  = DefaultCharaPromoteMethod,
	CHARA_TRAIT_DATA      = DefaultCharaTrait,
	CHARA_TRAIT_CONGENIALITY = DefaultCharaTraitCongeniality,

	RELATION_OPINION      = DefaultRelationOpinion,
	RELATION_PACT         = DefaultPactCond,	

	--Params
	CITY_POPUSTRUCTURE_PARAMS    = DefaultCityPopuStructureParams,
	CITY_DEVELOP_RESULT          = DefaultCityDevelopResult,
	CITY_DEVELOPMENT_VARY_RESULT = DefaultCityDevelopmentVaryResult,
	
	CITY_CONSCRIPT_PARAMS        = DefaultCityConscript,
	CITY_RECRUIT_PARAMS          = DefaultCityRecruit,
	CITY_HIREGUARD_PARAMS        = DefaultCityHireGuard,
	
	CITY_JOB_PARAMS              = DefaultCityJobProb,
	CORPS_PARAMS                 = DefaultCorpsParams,
	TROOP_PARAMS                 = DefaultTroopParams,

	CITY_CONSTR_DATA             = Default_CityBuildingData,

	TASK_STEP_DATA   = DefaultTaskSteps,
	TASK_BONUS_DATA  = DefaultTaskBonus,
	TASK_ACTION_DATA = DefaultTaskAP,

	TACTIC_DATA      = DefaultTacticData,
	BATTLEFIELD_DATA = DefaultBattlefieldData,
	TECH_DATA        = DefaultTechData,

	--Scenario 
	CHARA_SKILL_DATA = DefaultCharaSkill,		

	TROOP_DATA       = DefaultTroopTable,
	WEAPON_DATA      = DefaultWeaponTable,
	CORPS_TEMPLATE   = DefaultCorpsTemplate,

	--single city
	--[[
	BASE_DATA     = TEST_BaseData,
	MAP_DATA      = TEST_MapData,

	GROUP_DATA    = TEST_GroupData,	
	CITY_DATA     = TEST_CityData,
	CHARA_DATA    = TEST_CharaData,	
	--]]

	--[[
	BASE_DATA     = RTK_BaseData,
	MAP_DATA      = RTK_MapData,

	GROUP_DATA    = RTK_GroupData,
	CITY_DATA     = RTK_CityData,
	CHARA_DATA    = RTK_CharaData,	

	CORPS_DATA    = nil,
	EVENT_DATA    = RTK_EventData,
	--]]

	--[[]]
	BASE_DATA     = CHUHAN_BaseData,
	MAP_DATA      = CHUHAN_MapData,

	GROUP_DATA    = CHUHAN_GroupData,
	CITY_DATA     = CHUHAN_CityData,
	CHARA_DATA    = CHUHAN_CharaData,

	EVENT_DATA    = CHUHAN_EventData,
	CORPS_DATA    = nil,	
	--]]
}

------------------------------------------------------

local _Scenario = ScenarioData

--do the work like convert string to number
function Scenario_InitData()
	--global datas
	for id, datas in pairs( CombatStepData ) do
		CombatStepData[id] = MathUtil_ConvertDataStringToID( CombatStepType, datas )
	end	

	_Scenario.CHARA_PROMOTE_DATA   = MathUtil_ConvertKeyToID( CharaJob, _Scenario.CHARA_PROMOTE_DATA )
	_Scenario.CHARA_PROMOTE_METHOD = MathUtil_ConvertKeyToID( CharaJob, _Scenario.CHARA_PROMOTE_METHOD )
	for id, method in pairs( _Scenario.CHARA_PROMOTE_METHOD ) do
		_Scenario.CHARA_PROMOTE_METHOD[id] = MathUtil_ConvertDataStringToID( CharaJob, method )
	end

	--trait key2id
	_Scenario.CHARA_TRAIT_DATA = MathUtil_ConvertKeyToID( CharaTraitType, _Scenario.CHARA_TRAIT_DATA )
	_Scenario.CHARA_TRAIT_CONGENIALITY = MathUtil_ConvertKeyToID( CharaTraitType, _Scenario.CHARA_TRAIT_CONGENIALITY )

	--skill key2id
	for id, skill in pairs( _Scenario.CHARA_SKILL_DATA ) do
		--skill.effects = MathUtil_ConvertKeyToID( CharaSkillEffect, skill.effects )
		skill.consume = MathUtil_ConvertKeyToID( CharaActionPoint, skill.consume )
	end

	_Scenario.TASK_STEP_DATA = MathUtil_ConvertKeyToID( TaskType, _Scenario.TASK_STEP_DATA )
	for id, list in pairs( _Scenario.TASK_STEP_DATA ) do
		_Scenario.TASK_STEP_DATA[id] = MathUtil_ConvertDataStringToID( TaskStep, list )
	end

	_Scenario.TASK_BONUS_DATA = MathUtil_ConvertKeyToID( TaskType, _Scenario.TASK_BONUS_DATA )

	--_Scenario.TASK_AP_DATA = MathUtil_ConvertKeyToID( TaskType, _Scenario.TASK_AP_DATA )

	_Scenario.RELATION_OPINION = MathUtil_ConvertKeyToID( RelationOpinion, _Scenario.RELATION_OPINION )

	CombatPurposeParam = MathUtil_ConvertKey2ID( CombatPurposeParam, CombatPurpose )	
	
	--MathUtil_Dump( Scenario_GetData( "TASK_STEP_DATA" ) )
end


function Scenario_GetData( dataName, id )
	if not id then
		return _Scenario[dataName]
	end
	local datas = _Scenario[dataName]
	return datas[id]
end
