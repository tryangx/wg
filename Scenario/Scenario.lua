require "Scenario/DefaultDefine"
require "Scenario/DefaultData"
require "Scenario/DefaultCombatData"

--scenario
require "Scenario/scenario_threekindoms"
require "Scenario/scenario_chuhan"

Test_CityData = 
{
	[1000] = 
	{
		name = "Test City",
		coordinate = { x = 66, y = 6 },
		level = 10,
		money    = 10000,
		material = 10000,
		--adjacents = { 101 },
		defenses = { 15000, 10000, 15000 },
		charas = { 100, 101, 102, 103 },
	},
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
	CHARA_PROMOTE_DATA   = DefaultJobPromoteData,
	CHARA_PROMOTE_METHOD = DefaultCharaPromoteMethod,

	--Params
	CITY_POPUSTRUCTURE_PARAMS = DefaultCityPopuStructureParams,
	CORPS_PARAMS              = DefaultCorpsParams,
	TROOP_PARAMS              = DefaultTroopParams,

	TACTIC_DATA      = DefaultTacticData,
	BATTLEFIELD_DATA = DefaultBattlefieldData,

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
end


function Scenario_GetData( dataName )
	return _Scenario[dataName]
end