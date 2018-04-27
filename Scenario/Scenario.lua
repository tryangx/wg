require "DefaultDefine"
require "DefaultData"
require "DefaultCombatData"

--scenario
require "scenario_test"
require "scenario_threekindoms"
require "scenario_chuhan"

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

	RELATION_OPINION      = DefaultRelationOpinion,

	--Params
	CITY_POPUSTRUCTURE_PARAMS    = DefaultCityPopuStructureParams,
	CITY_DEVELOP_PARAMS          = DefaultCityDevelopParams,
	CITY_DEVELOPMENT_VARY_PARAMS = DefaultCityDevelopmentVaryParams,
	CITY_CONSCRIPT_PARAMS        = DefaultCityConscript,
	CITY_RECRUIT_PARAMS          = DefaultCityRecruit,
	CORPS_PARAMS                 = DefaultCorpsParams,
	TROOP_PARAMS                 = DefaultTroopParams,

	TASK_STEP_DATA   = DefaultTaskSteps,
	TACTIC_DATA      = DefaultTacticData,
	BATTLEFIELD_DATA = DefaultBattlefieldData,
	TECH_DATA        = DefaultTechData,

	--Scenario 
	--[[
	BASE_DATA     = RTK_BaseData,
	MAP_DATA      = RTK_MapData,

	GROUP_DATA    = RTK_GroupData,
	CITY_DATA     = Test_CityData,
	--CITY_DATA     = RTK_CityData,
	CHARA_DATA    = RTK_CharaData,	
	CORPS_DATA    = nil,
	TROOP_DATA    = RTK_TroopTable,
	WEAPON_DATA   = RTK_WeaponTable,
	CORPS_TEMPLATE = RTK_CorpsTemplate,

	EVENT_DATA    = RTK_EventData,
	]]
	BASE_DATA     = CHUHAN_BaseData,
	MAP_DATA      = CHUHAN_MapData,

	GROUP_DATA    = CHUHAN_GroupData,
	CITY_DATA     = CHUHAN_CityData,
	CHARA_DATA    = CHUHAN_CharaData,	
	CORPS_DATA    = nil,
	TROOP_DATA    = CHUHAN_TroopTable,
	WEAPON_DATA   = CHUHAN_WeaponTable,
	CORPS_TEMPLATE = CHUHAN_CorpsTemplate,

	EVENT_DATA    = CHUHAN_EventData,
}

------------------------------------------------------

local _Scenario = ScenarioData

--do the work like convert string to number
function Scenario_InitData()
	_Scenario.CHARA_PROMOTE_DATA   = MathUtil_ConvertKeyToID( CharaJob, _Scenario.CHARA_PROMOTE_DATA )
	_Scenario.CHARA_PROMOTE_METHOD = MathUtil_ConvertKeyToID( CharaJob, _Scenario.CHARA_PROMOTE_METHOD )
	for id, method in pairs( _Scenario.CHARA_PROMOTE_METHOD ) do
		_Scenario.CHARA_PROMOTE_METHOD[id] = MathUtil_ConvertDataStringToID( CharaJob, method )
	end

	_Scenario.TASK_STEP_DATA = MathUtil_ConvertKeyToID( TaskType, _Scenario.TASK_STEP_DATA )
	for id, list in pairs( _Scenario.TASK_STEP_DATA ) do
		_Scenario.TASK_STEP_DATA[id] = MathUtil_ConvertDataStringToID( TaskStep, list )
	end

	_Scenario.RELATION_OPINION = MathUtil_ConvertKeyToID( RelationOpinion, _Scenario.RELATION_OPINION )

	--MathUtil_Dump( Scenario_GetData( "TASK_STEP_DATA" ) )
end


function Scenario_GetData( dataName, id )
	if not id then
		return _Scenario[dataName]
	end
	local datas = _Scenario[dataName]
	return datas[id]
end