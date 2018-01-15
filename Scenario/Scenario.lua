require "Scenario/DefaultDefine"
require "Scenario/DefaultData"
require "Scenario/DefaultCombatData"
require "Scenario/scenario_threekindoms"

Test_CityData = 
{
	[1000] = 
	{
		name = "Test City",
		coordinate = { x = 66, y = 6 },
		level = 10,
		money    = 10000,
		material = 10000,
		adjacents = { 101 },
		defenses = { 15000, 10000, 15000 },
		charas = { 100 },
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

	--Scenario 
	BASE_DATA     = RTK_BaseData,
	MAP_DATA      = RTK_MapData,

	GROUP_DATA    = RTK_GroupData,
	CITY_DATA     = Test_CityData,--RTK_CityData,
	CHARA_DATA    = RTK_CharaData,	
	CORPS_DATA    = nil,
	TROOP_DATA    = RTK_TroopTable,
	WEAPON_DATA   = RTK_WeaponTable,
	CORPS_TEMPLATE = RTK_CorpsTemplate,

	TACTIC_DATA      = DefaultTacticData,
	BATTLEFIELD_DATA = DefaultBattlefieldData,

	EVENT_DATA    = RTK_EventData,

	--Params
	CITY_POPUSTRUCTURE_PARAMS = DefaultCityPopuStructureParams,
}

------------------------------------------------------

local _Scenario = ScenarioData

function GetScenarioData( dataName )
	return _Scenario[dataName]
end