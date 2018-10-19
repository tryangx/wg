require "Table/TableGlobal"

require "Table/PlotTable"
require "Table/ResourceTable"
require "Table/DistrictTable"
require "Table/TroopTable"
require "Table/TroopMedalTable"
require "Table/TacticTable"
require "Table/BattlefieldTable"
require "Table/WeaponTable"
require "Table/SkillTable"
require "Table/TraitTable"
require "Table/ConstructionTable"
require "Table/CharaTitleTable"
require "Table/CharaCareerTable"

function Table_SetTroop( entity, id, value )
	return TroopTable_Get( value ) or value
end

function Table_SetBattlefield( entity, id, value )
	return BattlefieldTable_Get( value ) or value
end