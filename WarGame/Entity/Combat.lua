---------------------------------------------------
--
--
-- Rule
--   #Order
--    1. Low morale lead to disobey order
--    2. Low org and Low mor and Low Loyality lead to betray
--  
--   #Morale
--    1. Reduce when been hit
--    2. Increase when gain advantage in duel
--    3. Increase when kill enemy
--
-- Troop Ability
--   Melee  : Determine FIGHT damage output
--   Charge : Determine CHARGE damage output
--   Shoot  : Determine SHOOT damage output
--   Siege  : Determine SIEGE damage output
--   Armor  : Reduce damage
--   Toughness : Reduce CHARGE damage, Increase SHOOT damage
--   Morale : Determine Critical Rate, Retreat 
--
-- Category Definition
--	Light Footman   : Common, Universal
--	Regular Footman : LF advanced
--  Heavy Footman   : No shoot ability, melee is strong, but mostly use to resist to heavy cavalry
--  Long bow        : Long Range
--  Cross bow       : Adavantage to charger
--  Scout           : Adavantage to collect intel
--  Regular cavalry : Advantage to flank
--  Heavy cavalry   : Strongest soldier, break the lineup easily
--
--
-- Battlefield
-- ---------->x+
-- |    DF
-- |
-- V    AT
-- y++
---------------------------------------------------

CombatAssetType = 
{
	BASE_ATTRIB      = 1,
	STATUS_ATTRIB    = 2,
}

CombatAssetID = 
{
	TYPE          = 10,
	ATK_STATUS    = 11,
	DEF_STATUS    = 12,

	PLOT           = 100,
	CITY           = 101,
	BATTLEFIELD    = 102,
	ATKCAMPFIELD   = 103,
	DEFCAMPFIELD   = 104,
	CORPS_LIST     = 110,
	ATK_CORPS_LIST = 111,
	DEF_CORPS_LIST = 112,
	TROOP_LIST    = 113,
	OFFICER_LIST  = 114,
	ATTACKER_LIST = 120,
	DEFENDER_LIST = 121,

	DAY           = 200,
	END_DAY       = 201,
	TIME          = 202,
	END_TIME      = 203,	
	RESULT        = 210,
	WINNER        = 211,
	TOTAL_VP      = 220,
	ATK_PURPOSE   = 221,
	DEF_PURPOSE   = 222,
	PRISONER      = 223,
}

CombatAssetAttrib = 
{
	type        = AssetAttrib_SetNumber     ( { id = CombatAssetID.TYPE,            type = CombatAssetType.BASE_ATTRIB } ),
	atkstatuses = AssetAttrib_SetList       ( { id = CombatAssetID.ATK_STATUS,      type = CombatAssetType.BASE_ATTRIB } ),
	defstatuses = AssetAttrib_SetList       ( { id = CombatAssetID.DEF_STATUS,      type = CombatAssetType.BASE_ATTRIB } ),

	plot        = AssetAttrib_SetPointer    ( { id = CombatAssetID.PLOT,            type = CombatAssetType.BASE_ATTRIB, setter = Entity_SetPlot } ),
	city        = AssetAttrib_SetPointer    ( { id = CombatAssetID.CITY,            type = CombatAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	battlefield = AssetAttrib_SetPointer    ( { id = CombatAssetID.BATTLEFIELD,     type = CombatAssetType.BASE_ATTRIB, setter = Table_SetBattlefield } ),
	atkcampfield= AssetAttrib_SetPointer    ( { id = CombatAssetID.ATKCAMPFIELD,    type = CombatAssetType.BASE_ATTRIB, setter = Table_SetBattlefield } ),
	defcampfield= AssetAttrib_SetPointer    ( { id = CombatAssetID.DEFCAMPFIELD,    type = CombatAssetType.BASE_ATTRIB, setter = Table_SetBattlefield } ),
	atkcorpses  = AssetAttrib_SetPointerList( { id = CombatAssetID.ATK_CORPS_LIST,  type = CombatAssetType.BASE_ATTRIB, setter = Entity_SetCorps } ),
	defcorpses  = AssetAttrib_SetPointerList( { id = CombatAssetID.DEF_CORPS_LIST,  type = CombatAssetType.BASE_ATTRIB, setter = Entity_SetCorps } ),
	corps       = AssetAttrib_SetPointerList( { id = CombatAssetID.CORPS_LIST,      type = CombatAssetType.BASE_ATTRIB, setter = Entity_SetCorps } ),
	troops      = AssetAttrib_SetPointerList( { id = CombatAssetID.TROOP_LIST,      type = CombatAssetType.BASE_ATTRIB, setter = Entity_SetTroop } ),
	leaders     = AssetAttrib_SetPointerList( { id = CombatAssetID.OFFICER_LIST,    type = CombatAssetType.BASE_ATTRIB, setter = Entity_SetChara } ),
	attackers   = AssetAttrib_SetPointerList( { id = CombatAssetID.ATTACKER_LIST,   type = CombatAssetType.BASE_ATTRIB, setter = Entity_SetTroop } ),
	defenders   = AssetAttrib_SetPointerList( { id = CombatAssetID.DEFENDER_LIST,   type = CombatAssetType.BASE_ATTRIB, setter = Entity_SetTroop } ),
	
	day         = AssetAttrib_SetNumber( { id = CombatAssetID.DAY,      type = CombatAssetType.STATUS_ATTRIB, default = 0 } ),
	endday      = AssetAttrib_SetNumber( { id = CombatAssetID.END_DAY,  type = CombatAssetType.STATUS_ATTRIB, default = 0 } ),
	time        = AssetAttrib_SetNumber( { id = CombatAssetID.TIME,     type = CombatAssetType.STATUS_ATTRIB, default = 0 } ),
	endtime     = AssetAttrib_SetNumber( { id = CombatAssetID.END_TIME, type = CombatAssetType.STATUS_ATTRIB, default = 0 } ),	
	result      = AssetAttrib_SetNumber( { id = CombatAssetID.RESULT,   type = CombatAssetType.STATUS_ATTRIB, default = CombatResult.UNKNOWN } ),	
	winner      = AssetAttrib_SetNumber( { id = CombatAssetID.WINNER,   type = CombatAssetType.STATUS_ATTRIB, default = CombatSide.UNKNOWN } ),	

	totalvp     = AssetAttrib_SetNumber( { id = CombatAssetID.TOTAL_VP, type = CombatAssetType.STATUS_ATTRIB, default = 0 } ),	
	atkpurpose  = AssetAttrib_SetNumber( { id = CombatAssetID.ATK_PURPOSE, type = CombatAssetType.STATUS_ATTRIB, default = CombatPurpose.CONSERVATIVE } ),	
	defpurpose  = AssetAttrib_SetNumber( { id = CombatAssetID.DEF_PURPOSE, type = CombatAssetType.STATUS_ATTRIB, default = CombatPurpose.CONSERVATIVE } ),	
	prisoner    = AssetAttrib_SetList( { id = CombatAssetID.PRISONER, type = CombatAssetType.STATUS_ATTRIB })
}


-------------------------------------------------------

local function QueryPosition( x, y )
	return y * 100 + x
end

local function ParsePosition( index )
	return math.floor( index / 100 ), index % 100
end

-------------------------------------------------------

CombatLog = 
{
	DEBUG        = 0,
	ERROR        = 1,
	DESC         = 2,
	CHANGE_VALUE = 3,
	INITIAL      = 4,
	MAP          = 5,
}

local function WriteCombatLog( type, ... )
	if type == CombatLog.DEBUG then return end
	if type == CombatLog.MAP then return end
	if type == CombatLog.DESC then return end
	if type == CombatLog.INITIAL then return end
	--print( ... )
	Log_Write( "combat",  ... )
end

local function DebugCombat( ... )
	WriteCombatLog( CombatLog.DEBUG, ... )
end

-------------------------------------------------------

CombatPurposeParam = 
{
	--power_comparison_ratio
	--  self.power / enemy.solder
	--
	--soldier_comparison_ratio
	--  self.soldier / enemy.soldier
	--
	--intense
	--	power_comparsion_ration
	--

	CONSERVATIVE = 
	{
		ATTEND_INTENSE   = 0.35,
		DECLINED_INTENSE = 0.7,
		FORCED_INTENSE   = 0.75,
		WITHDRAW = 
		{
			{ reason="danger", not_siege = 1, intense = 0.35 },
			{ reason="normal", not_siege = 1, intense = 0.35, morale = 30, casualty_ratio = 0.5 },
			{ reason="no food", food_supply_day = 15, is_atk = 1 },
		},
	},

	MODERATE = 
	{
		ATTEND_INTENSE   = 0.3,
		DECLINED_INTENSE = 0.6,
		FORCED_INTENSE   = 0.5,
		WITHDRAW =
		{
			{ reason="danger", not_siege = 1, intense = 0.3 },
			{ reason="normal", not_siege = 1, intense = 0.35, morale = 30, casualty_ratio = 1 },
			{ reason="no food", food_supply_day = 10, is_atk = 1 },
		},
	},

	AGGRESSIVE = 
	{
		ATTEND_INTENSE   = 0.2,
		DECLINED_INTENSE = 0.5,
		FORCED_INTENSE   = 0.35,
		WITHDRAW = 
		{
			{ reason="danger", not_siege = 1, intense = 0.2 },
			{ reason="normal", not_siege = 1, intense = 0.3, morale = 25, casualty_ratio = 1.5 },
			{ reason="no food", food_supply_day = 10, is_atk = 1 },
		},
	},
}

CombatPrepareResult = 
{
	BOTH_DECLINED     = 0,
	BOTH_ACCEPTED     = 1,
	ONLY_ATK_ACCEPTED = 2,
	ONLY_DEF_ACCEPTED = 3,
}

CombatTime = 
{
	NORMAL_END_TIME = 5,
	PURSUE_END_TIME = 7,
}

CombatVictoryPoint =
{
	RESULTS = 
	{
		CAMP_COMBAT = 
		{
			--result minimum condition, descending
			{ ratio = 50, atk = CombatResult.BRILLIANT_VICTORY, def = CombatResult.DISASTROUS_LOSE, winner = 1 },
			{ ratio = 30, atk = CombatResult.STRATEGIC_VICTORY, def = CombatResult.STRATEGIC_LOSE, winner = 0 },
		},

		SIEGE_COMBAT = 
		{
			--result minimum condition, descending
			{ ratio = 50, atk = CombatResult.BRILLIANT_VICTORY, def = CombatResult.DISASTROUS_LOSE, winner = 1 },
			{ ratio = 30, atk = CombatResult.STRATEGIC_VICTORY, def = CombatResult.STRATEGIC_LOSE, winner = 0 },
		},

		FIELD_COMBAT = 
		{
			--result minimum condition, descending
			{ ratio = 50, atk = CombatResult.BRILLIANT_VICTORY, def = CombatResult.DISASTROUS_LOSE, winner = 1 },
			{ ratio = 30, atk = CombatResult.STRATEGIC_VICTORY, def = CombatResult.STRATEGIC_LOSE, winner = 0 },
			--{ ratio = 15, atk = CombatResult.TACTICAL_VICTORY,  def = CombatResult.TACTICAL_LOSE, winner = 0 },
		},		
	},

	BONUS = 
	{
		ACE_MODULUS       = 2,
		
		REPEL_TROOP       = 1,
		NEUTRALIZE_TROOP  = 3,		

		BREAKTHROUGH      = 0.5,

		RETREAT           = 1,
	},
}

function Combat_Init()
	CombatPurposeParam = MathUtil_ConvertKey2ID( CombatPurposeParam, CombatPurpose )
end

-------------------------------------------------------

Combat = class()

function Combat:__init( ... )
	Entity_Init( self, EntityType.COMBAT, CombatAssetAttrib )

	--maybe in batltefield / camp field
	self._currentField = nil

	--grids
	self._grids = {}

	--statistics
	self._stat = {}
	self._stat[CombatSide.ALL] = {}	
	self._stat[CombatSide.ATTACKER] = {}
	self._stat[CombatSide.DEFENDER] = {}
end

function Combat:ToString( type )
	local content = "combatid=" .. self.id
	local city = Asset_Get( self, CombatAssetID.CITY )
	if city then
		content = content .. " @" .. String_ToStr( city, "name" )
	else
		content = content .. " pt=" .. Asset_Get( self, CombatAssetID.PLOT ):ToString()
	end
	content = content .. " typ=" .. MathUtil_FindName( CombatType, Asset_Get( self, CombatAssetID.TYPE ) )
	if type == "DEBUG_CORPS" then
		content = content .. " corps="
		Asset_Foreach( self, CombatAssetID.ATK_CORPS_LIST, function( corps )
			content = content .. corps:ToString( "SIMPLE" ) .. ","
		end )
		Asset_Foreach( self, CombatAssetID.DEF_CORPS_LIST, function ( corps )
			content = content .. corps:ToString( "SIMPLE" ) .. ","
		end )
		content = content .. " troops="
		Asset_Foreach( self, CombatAssetID.TROOP_LIST, function ( troop )
			content = content .. troop:ToString( "SIMPLE" ) .. ","
		end )
	elseif type == "RESULT" then
		content = content .. " rsult=" .. MathUtil_FindName( CombatResult, Asset_Get( self, CombatAssetID.RESULT ) )
		content = content .. " winner=" .. self:GetGroupName( self:GetWinner() )
		content = content .. " date=" .. g_Time:CreateCurrentDateDesc()
		content = content .. " day=" .. Asset_Get( self, CombatAssetID.DAY )
		content = content .. " atkkill=" .. self:GetStat( CombatSide.ATTACKER, CombatStatistic.KILL ) .. "/" .. self:GetStat( CombatSide.ATTACKER, CombatStatistic.TOTAL_SOLDIER )
		content = content .. " defkill=" .. self:GetStat( CombatSide.DEFENDER, CombatStatistic.KILL ) .. "/" .. self:GetStat( CombatSide.DEFENDER, CombatStatistic.TOTAL_SOLDIER )
	end
	return content
end

function Combat:Remove()
	self._currentField = nil
	self._grids = nil
	self._movements = nil

	self._stat[CombatSide.ALL] = nil
	self._stat[CombatSide.ATTACKER] = nil
	self._stat[CombatSide.DEFENDER] = nil	
	self._stat = nil
end

--Add single troop into Combat
function Combat:AddTroop( troop, side )
	--Debug_Log( "Add troop" .. troop:ToString() )

	--side data
	troop._combatSide = side

	troop._exposure = 0

	--default order
	if side == CombatSide.ATTACKER then
		troop._order = CombatOrder.ATTACK		
	elseif side == CombatSide.DEFENDER then
		troop._order = CombatOrder.DEFEND
	end

	--vp
	local soldier = Asset_Get( troop, TroopAssetID.SOLDIER )
	local attrib = Entity_GetAssetAttrib( troop, TroopAssetID.LEVEL )
	troop._vp = Asset_Get( troop, TroopAssetID.LEVEL ) + attrib.max
	Asset_Plus( self, CombatAssetID.TOTAL_VP, soldier * troop._vp )
	
	--all troop list
	Asset_AppendList( self, CombatAssetID.TROOP_LIST, troop )
	
	--at/df list
	local assetId = nil
	if side == CombatSide.ATTACKER then
		Asset_AppendList( self, CombatAssetID.ATTACKER_LIST, troop )
	elseif side == CombatSide.DEFENDER then
		Asset_AppendList( self, CombatAssetID.DEFENDER_LIST, troop )
	end
	
	--leader list
	local officer= Asset_Get( troop, TroopAssetID.OFFICER )	
	if officer then
		Asset_AppendList( self, CombatAssetID.OFFICER_LIST, officer )
	end
end

--Add single troop into Combat
function Combat:AddCorps( corps, side )	
	if Asset_HasItem( self, CombatAssetID.CORPS_LIST, corps ) == true then
		--InputUtil_Pause( corps:ToString(), "already" )
		return
	end

	if side == CombatSide.ATTACKER then
		Asset_AppendList( self, CombatAssetID.ATK_CORPS_LIST, corps )
	elseif side == CombatSide.DEFENDER then
		Asset_AppendList( self, CombatAssetID.DEF_CORPS_LIST, corps )
	end

	Asset_AppendList( self, CombatAssetID.CORPS_LIST, corps )

	Asset_Foreach( corps, CorpsAssetID.TROOP_LIST, function( troop )
		self:AddTroop( troop, side )
	end )

	Asset_SetDictItem( corps, CorpsAssetID.STATUSES, CorpsStatus.IN_COMBAT, true )
end

function Combat:RemoveTroopOfficer( troop, isKilled )
	local officer = Asset_Get( troop, TroopAssetID.OFFICER )
	Asset_Set( troop, TroopAssetID.OFFICER, nil )

	local corps  = Asset_Get( troop, TroopAssetID.CORPS )	
	local leader = corps and Asset_Get( corps, CorpsAssetID.LEADER ) or nil
	if isKilled then		
		if officer then
			InputUtil_Pause( "remove troop ld")
			if leader == officer then
				--all flee
				Corps_OfficerDie( corps, officer )

				--find new leader
				local charaList = Asset_GetList( corps, CorpsAssetID.OFFICER_LIST )
				leader = Chara_FindLeader( charaList )
				Asset_Set( corps, CorpsAssetID.LEADER, leader )

				--InputUtil_Pause( "leader killed" )
			else
				Corps_OfficerDie( corps, officer )
			end
		end
	else
		--process with leader		
		if Random_GetInt_Sync( 0, 100 ) < 20 then
			--captured
			--to do
		end
	end
end

function Combat:RemoveTroop( troop, isKilled )
	--remove from list
	Asset_RemoveListItem( self, CombatAssetID.TROOP_LIST, troop )

	--remove from positions
	self:RemoveGridTroop( troop._grid, troop )

	--remove from atk/def list
	local assetId = nil
	if troop._combatSide == CombatSide.ATTACKER then
		Asset_RemoveListItem( self, CombatAssetID.ATTACKER_LIST, troop )
	elseif troop._combatSide == CombatSide.DEFENDER then
		Asset_RemoveListItem( self, CombatAssetID.DEFENDER_LIST, troop )
	end

	--when troop is neutralized, leader should go back to staff or be captured
	self:RemoveTroopOfficer( troop, nil )-- isKilled )

	--clear combat datas
	troop._combatSide = nil
	troop._x = nil
	troop._y = nil
	troop._prepared = nil
	troop._attend   = nil
	troop._order    = nil
	troop._captured = nil
	troop._surrounded = nil
	troop._retreat  = nil
	troop._flee     = nil
	troop._moved    = nil
	troop._acted    = nil
	troop._target   = nil
	troop._attacked = nil
	troop._defended = nil
	troop._vp       = nil
	troop._exposure = nil
	troop._faceDir  = nil
	troop._grid     = nil

	--Debug_Log( "remove troop", troop:ToString() )
end

function Combat:RemoveCorps( corps )
	Asset_RemoveListItem( self, CombatAssetID.CORPS_LIST, corps )

	Asset_Foreach( corps, CorpsAssetID.TROOP_LIST, function( troop )
		self:TroopLeave( troop )
	end )

	Asset_SetDictItem( corps, CorpsAssetID.STATUSES, CorpsStatus.IN_COMBAT, nil )
end


-----------------------------------------------------
-- Grid

function Combat:InitGrid( x, y, data )
	local grid = self:GetGrid( x, y )
	grid.prot  = data.prot or 0
	grid.depth = data.depth or 1000
	grid.height = data.height or 0
	grid.defense = data.defense or 0
	grid.isWall  = data.isWall
	return grid
end

function Combat:GetGrid( x, y )
	local id = y*10 + x
	if not self._grids[id] then
		self._grids[id] = 
		{
			troops = {}, targets = {}, x = x, y = y, side = CombatSide.UNKNOWN, depth = 0, soldier = 0, organization = 0
		}
	end
	return self._grids[id]
end

function Combat:KillGridTroop( grid, troop )
	if not grid then return end
	MathUtil_Remove( grid.troops, troop )
	if #grid.troops == 0 then
		grid.side = CombatSide.UNKNOWN
		--mean ranks broken
		if troop._combatSide == CombatSide.ATTACKER then
			Asset_SetListItem( self, CombatAssetID.ATK_STATUS, CombatStatus.RANK_BROKEN, true )
		elseif troop._combatSide == CombatSide.DEFENDER then
			Asset_SetListItem( self, CombatAssetID.DEF_STATUS, CombatStatus.RANK_BROKEN, true )
		end
	end
end

function Combat:RemoveGridTroop( grid, troop )
	if not grid then return end
	MathUtil_Remove( grid.troops, troop )
	if #grid.troops == 0 then
		grid.side = CombatSide.UNKNOWN
	end
end

function Combat:AddGridTroop( grid, troop )
	if not grid then return end
	grid.side = troop._combatSide
	table.insert( grid.troops, troop )

	--mean ranks broken
	if troop._combatSide == CombatSide.ATTACKER then
		Asset_SetListItem( self, CombatAssetID.ATK_STATUS, CombatStatus.RANK_BROKEN, false )
	elseif troop._combatSide == CombatSide.DEFENDER then
		Asset_SetListItem( self, CombatAssetID.DEF_STATUS, CombatStatus.RANK_BROKEN, false )
	end
end

function Combat:GetFrontGrid( troop )
	local ox, oy = self:GetFaceDir( troop )
	return self:GetGrid( troop._x + ox, troop._y + oy )
end

function Combat:GetBackGrid( troop )
	local ox, oy = self:GetFaceDir( troop )
	return self:GetGrid( troop._x + ox, troop._y - oy )
end

function Combat:GetGroup( side )
	local corps
	if side == CombatSide.ATTACKER then
		corps = Asset_GetListByIndex( self, CombatAssetID.ATK_CORPS_LIST, 1 )
	elseif side == CombatSide.DEFENDER then
		corps = Asset_GetListByIndex( self, CombatAssetID.DEF_CORPS_LIST, 1 )
	end
	--maybe unknown side
	if not corps then return end

	local group = Asset_Get( corps, CorpsAssetID.GROUP )
	return group
end

function Combat:GetCorpsGroupName( corps )
	local group = corps and Asset_Get( corps, CorpsAssetID.GROUP ) or nil
	return group and group.name or "[UNKNOWN]"
end

function Combat:GetTroopGroupName( troop )
	local corps  = Asset_Get( troop, TroopAssetID.CORPS )
	if corps then return self:GetCorpsGroupName( corps ) end
	if Asset_GetDictItem( troop, TroopAssetID.STATUSES, TroopStatus.GUARD ) == true then
		return self:GetGroupName( CombatSide.DEFENDER )
	end
	return "[UNKNOWN]"
end

function Combat:GetGroupName( side )
	local group = self:GetGroup( side )
	return group and group.name or "[UNKNOWN]"
end

function Combat:GetCorpsList( side )
	if side == CombatSide.ATTACKER then
		return Asset_GetList( self, CombatAssetID.ATK_CORPS_LIST )
	elseif side == CombatSide.DEFENDER then
		return Asset_GetList( self, CombatAssetID.DEF_CORPS_LIST )
	end
	return nil
end

-----------------------------------------------------
-- Debug & Statistics

function Combat:DrawBattlefield()
	--if 1 then return end
	if not self._currentField then return end

	DebugCombat( "Field=" .. self._currentField.name )

	local battlefield = self._currentField
	local content = "     "
	for x = 1, battlefield.width do
		content = content .. ( x < 10 and "X=" .. x .. "  " or " X=" .. x .. " " )
	end
	WriteCombatLog( CombatLog.MAP, content )
	for y = 1, battlefield.height do
		content = ( y < 10 and "Y= " .. y or "Y=" .. y ) .. " "
		for x = 1, battlefield.width do
			local grid = self:GetGrid( x, y )
			local numoftroop = 0
			local side = CombatSide.UNKNOWN
			for _, troop in ipairs( grid.troops ) do
				if self:IsTroopValid( troop ) then
					numoftroop = numoftroop + 1
					side = troop._combatSide
				end
			end
			local troopDesc
			if side == CombatSide.ATTACKER then
				troopDesc = "A_" .. StringUtil_Abbreviate( numoftroop, 2 ) .. " "
			elseif side == CombatSide.DEFENDER then
				troopDesc = "D_" .. StringUtil_Abbreviate( numoftroop, 2 ) .. " "
			else
				troopDesc = string.rep( " ", 5 )
			end
			content = content .. troopDesc
		end
		WriteCombatLog( CombatLog.MAP, content )
	end
end

function Combat:Dump()
	self:UpdateStatistic()

	self:DumpStatistic()
end

function Combat:DumpStatistic()
	Asset_Foreach( self, CombatAssetID.TROOP_LIST, function ( troop )
		self:DumpTroop( troop )
	end )

	DebugCombat( "Type = " .. MathUtil_FindName( CombatType, Asset_Get( self, CombatAssetID.TYPE ) ) )
	DebugCombat( "Day  = " .. Asset_Get( self, CombatAssetID.DAY ) )
	DebugCombat( "Total VP = " .. Asset_Get( self, CombatAssetID.TOTAL_VP ) )

	function DumpStatus( side )
		local list
		if side == CombatSide.ATTACKER then
			DebugCombat( "ATK Status=" )
			list = Asset_GetList( self, CombatAssetID.ATK_STATUS )
		elseif side == CombatSide.DEFENDER then
			DebugCombat( "DEF Status=" )
			list = Asset_GetList( self, CombatAssetID.DEF_STATUS )
		end
		if list then
			for k, v in pairs( list ) do
				DebugCombat( "", k .. "=", v )
			end
		end
	end
	DumpStatus( CombatSide.ATTACKER )
	DumpStatus( CombatSide.DEFENDER )

	for k, v in pairs( CombatStatistic ) do
		if self._stat[CombatSide.ALL][v] ~= nil then
			DebugCombat( "Tot " .. k .. "=".. self._stat[CombatSide.ALL][v] )
		end
	end
	for k, v in pairs( CombatStatistic ) do
		if self._stat[CombatSide.ATTACKER][v] ~= nil then			
			DebugCombat( "Att " .. k .. "=".. self._stat[CombatSide.ATTACKER][v] )
		end
		if self._stat[CombatSide.DEFENDER][v] ~= nil then
			DebugCombat( "Def " .. k .. "=".. self._stat[CombatSide.DEFENDER][v] )
		end
	end
	for k, v in pairs( CombatStatistic ) do
		if v >= CombatStatistic.ACCUMULATE_TYPE then
			Asset_Foreach( self, CombatAssetID.TROOP_LIST, function ( troop )
				if self._stat[troop] and self._stat[troop][v] then
					DebugCombat( troop:ToString( "COMBAT" ) .. " " .. " " .. k .. "=" .. self._stat[troop][v] )
				end
			end )				
		end
	end
end

function Combat:GetStat( obj, statid )
	if not obj then return end
	local key = statid
	if not self._stat then return 0 end
	if not self._stat[obj] then return 0 end
	return self._stat[obj][key] or 0
end

function Combat:SetStat( obj, statid, value )
	if not obj then return end
	local key = statid
	if not self._stat[obj] then self._stat[obj] = {} end
	self._stat[obj][key] = value
	--InputUtil_Pause( "addstat obj=", obj .. " key=",key .. " STAT=", statid .. " val=",self._stat[obj][key] )
	return value
end

function Combat:AddStat( side, statid, value )
	if not side then return end
	local key = statid
	if not self._stat[side] then self._stat[side] = {} end
	if not self._stat[side][key] then self._stat[side][key] = value
	else self._stat[side][key] = self._stat[side][key] + value end
	if statid == CombatStatistic.DEAD and side == CombatSide.DEFENDER then 
	--	InputUtil_Pause( "addstat side=" .. MathUtil_FindName( CombatSide, side ) .. " key="..key .. " STAT="..statid .. " val="..self._stat[side][key] .."+" .. value )
	end
end

function Combat:ClearReferenceStats()
	for k, v in pairs( CombatStatistic ) do
		if v >= CombatStatistic.REFERENCE_TYPE then
			self._stat[CombatSide.ATTACKER][v] = 0
			self._stat[CombatSide.DEFENDER][v] = 0
		end
	end
end

function Combat:DumpTroop( troop )
	--if 1 then return end
	DebugCombat( "side=" .. MathUtil_FindName( CombatSide, troop._combatSide ) )
	if 1 then return end
	Entity_Dump( troop, function ( attrib )
		if 1 then return false end
		if attrib.id == TroopAssetID.ORGANIZATION then return true end
		if attrib.id == TroopAssetID.MORALE then return true end
		return attrib.type == TroopAssetType.COMBAT_ATTRIB and attrib.id <= TroopAssetID.ABILITY
	end)
end

-------------------------------------------------
-- Getter 

--Current winner, but dosen't means it wins the combat
function Combat:GetWinner()
	return Asset_Get( self, CombatAssetID.WINNER )
end

--Final result, means which side is winner
function Combat:GetResult()
	return Asset_Get( self, CombatAssetID.RESULT )
end

function Combat:GetOppSide( side )
	if side == CombatSide.ATTACKER then
		return CombatSide.DEFENDER
	elseif side == CombatSide.DEFENDER then
		return CombatSide.ATTACKER
	end
	return CombatSide.UNKNOWN
end

-------------------------------------------------
-- Checker

function Combat:IsEnd()	
	if Asset_Get( self, CombatAssetID.RESULT ) ~= CombatResult.UNKNOWN then return true end

	if Asset_Get( self, CombatAssetID.DAY ) > Asset_Get( self, CombatAssetID.END_DAY ) then return true end

	if Asset_Get( self, CombatAssetID.WINNER ) ~= CombatSide.UNKNOWN then return true end

	if Asset_Get( self, CombatAssetID.TIME ) > Asset_Get( self, CombatAssetID.END_TIME ) then return true end

	return false
end

function Combat:IsSameSide( troop, target )
	return troop._combatSide == target._combatSide
end

function Combat:IsTroopPrepared( troop )
	return troop and troop._prepared ~= nil
end

function Combat:IsTroopValid( troop )
	return troop and troop._attend ~= nil
end

function Combat:GetStatus( side, status )
	if side == CombatSide.ATTACKER then
		return Asset_GetListItem( self, CombatAssetID.ATK_STATUS, status )
	elseif side == CombatSide.DEFENDER then
		return Asset_GetListItem( self, CombatAssetID.DEF_STATUS, status )
	end
	return nil
end

-----------------------------------------------------
-- Embattle 
-- 
-- Put troops into battlefield 
--
function Combat:EmbattleTroop( troop )
	--posistion
	troop._x = nil
	troop._y = nil
	troop._attend   = true
	
	--status
	troop._retreat  = false
	troop._flee     = false
	troop._surrounded = false
end

function Combat:Embattle()
	self._grids = {}

	local battlefield = self._currentField
	for _, grid in pairs( battlefield.grids ) do
		self:InitGrid( grid.x, grid.y, grid )
	end	

	--no formation now, simply put as sequence	
	function EmbattleSide( side )
		local id
		local poslist
		local faceDir
		if side == CombatSide.ATTACKER then
			id       = CombatAssetID.ATTACKER_LIST
			postlist = battlefield.atkpos
			faceDir  = CombatDirection.UP
		elseif side == CombatSide.DEFENDER then
			id       = CombatAssetID.DEFENDER_LIST
			postlist = battlefield.defpos
			faceDir  = CombatDirection.DOWN
		end
		local list = Asset_GetList( self, id )
		table.sort( list, function ( l, r )
			return Asset_Get( l, TroopAssetID.SOLDIER ) > Asset_Get( r, TroopAssetID.SOLDIER )
		end )
		local index = 0
		for _, troop in ipairs( list ) do
			if troop._prepared then
				self:EmbattleTroop( troop )
				index = index + 1
				if index > #postlist then index = 1 end
				local posgrid = postlist[index]
				local x = posgrid.x
				local y = posgrid.y
				troop._x = x
				troop._y = y
				troop._faceDir = faceDir

				--add into grids				
				local grid = self:GetGrid( x, y )
				self:AddGridTroop( grid, troop )
				troop._grid = grid

				WriteCombatLog( CombatLog.INITIAL, "put", troop._x, troop._y, troop:ToString( "COMBAT" ), MathUtil_FindName( CombatSide, troop._combatSide ), Asset_Get( troop, TroopAssetID.SOLDIER ) )
			end
		end
	end
	--put attackers
	EmbattleSide( CombatSide.ATTACKER )
	EmbattleSide( CombatSide.DEFENDER )

	--statistics
	Asset_Foreach( self, CombatAssetID.CORPS_LIST, function ( corps )
		--Stat_Add( "Corps@Combat", g_Time:CreateCurrentDateDesc() .. " " .. corps:ToString(), StatType.LIST )
	end)

	self:DrawBattlefield()
end

-----------------------------------------------------
-- Main Procedure
--
-- When a troop is expose.
-- How many intel the opponent will knows depends on the ._exposure
--
-- Prepare has different result
-- ret 0 means no combat
-- ret 1 means both accept combat
-- ret 2 means atk accept combat but not def
-- ret 3 means def accept combat but not atk
--
-- Situation
--	 Combat Occur
--   One side Forced Attack
--   One Side Withdraw
--   Both Rest
--   Both Withdraw
--   One Side Surrender( ? )
--
function Combat:Prepare()
	local combatType = Asset_Get( self, CombatAssetID.TYPE )

	self:ClearReferenceStats()
	Asset_Foreach( self, CombatAssetID.TROOP_LIST, function ( troop )
		troop._prepared = nil
		if Combat_IsPrepared( troop ) then
			troop._prepared = true
			troop._exposure = math.min( 100, troop._exposure + 20 )
			self:SetStat( troop._combatSide, CombatStatistic.PREPARED, 1 )
		end	
		if not troop._exposure then
			error( troop:ToString() )
		end
		local exposure = 100 + Random_GetInt_Sync( ( troop._exposure - 100 ) * 0.25, ( 100 - troop._exposure ) * 0.25 )
		local soldier = Asset_Get( troop, TroopAssetID.SOLDIER )
		local troopTable = Asset_Get( troop, TroopAssetID.TABLEDATA )
		self:AddStat( troop._combatSide, CombatStatistic.TOTAL_SOLDIER, soldier )
		self:AddStat( troop._combatSide, CombatStatistic.AVERAGE_MORALE, soldier * Asset_Get( troop, TroopAssetID.MORALE ) )
		self:AddStat( troop._combatSide, CombatStatistic.TOTAL_POWER, soldier * TroopTable_GetPower( troop ) )
		self:AddStat( troop._combatSide, CombatStatistic.CONSUME_FOOD, soldier * troopTable.consume.FOOD )
		self:AddStat( troop._combatSide, CombatStatistic.EXPOSURE_POWER,  math.ceil( soldier * exposure * 0.01 ) * TroopTable_GetPower( troop ) )		
	end )

	Asset_Foreach( self, CombatAssetID.ATK_CORPS_LIST, function( corps )
		self:AddStat( CombatSide.ATTACKER, CombatStatistic.HAS_FOOD, Asset_Get( corps, CorpsAssetID.FOOD ) )
	end )
	Asset_Foreach( self, CombatAssetID.DEF_CORPS_LIST, function ( corps )
		self:AddStat( CombatSide.DEFENDER, CombatStatistic.HAS_FOOD, Asset_Get( corps, CorpsAssetID.FOOD ) )
	end )
	if combatType == CombatType.SIEGE_COMBAT then
		local city = Asset_Get( self, CombatAssetID.CITY )
		self:AddStat( CombatSide.DEFENDER, CombatStatistic.HAS_FOOD, Asset_Get( city, CityAssetID.FOOD ) )
		--InputUtil_Pause( "city food=" .. Asset_Get( city, CityAssetID.FOOD ) )
	end
	local atkFood = self:GetStat( CombatSide.ATTACKER, CombatStatistic.HAS_FOOD )
	local defFood = self:GetStat( CombatSide.DEFENDER, CombatStatistic.HAS_FOOD )
	local atkFoodConsume = self:GetStat( CombatSide.ATTACKER, CombatStatistic.CONSUME_FOOD )
	local defFoodConsume = self:GetStat( CombatSide.DEFENDER, CombatStatistic.CONSUME_FOOD )
	self:SetStat( CombatSide.ATTACKER, CombatStatistic.FOOD_SUPPLY_DAY, atkFood > 0 and math.ceil( atkFood / atkFoodConsume ) or 0 )
	self:SetStat( CombatSide.DEFENDER, CombatStatistic.FOOD_SUPPLY_DAY, defFood > 0 and math.ceil( defFood / defFoodConsume ) or 0 )
	--print( atkFood, defFood, atkFoodConsume, defFoodConsume )
	--print( "supply day=", self:GetStat( CombatSide.ATTACKER, CombatStatistic.FOOD_SUPPLY_DAY ), self:GetStat( CombatSide.DEFENDER, CombatStatistic.FOOD_SUPPLY_DAY ) )

	self:SetStat( CombatSide.ATTACKER, CombatStatistic.AVERAGE_MORALE, self:GetStat( CombatSide.ATTACKER, CombatStatistic.AVERAGE_MORALE ) / self:GetStat( CombatSide.ATTACKER, CombatStatistic.TOTAL_SOLDIER ) )
	self:SetStat( CombatSide.DEFENDER, CombatStatistic.AVERAGE_MORALE, self:GetStat( CombatSide.DEFENDER, CombatStatistic.AVERAGE_MORALE ) / self:GetStat( CombatSide.DEFENDER, CombatStatistic.TOTAL_SOLDIER ) )

	local atkPurpose = Asset_Get( self, CombatAssetID.ATK_PURPOSE )
	local defPurpose = Asset_Get( self, CombatAssetID.DEF_PURPOSE )	
	
	local defPowerRate = 1
	if combatType == CombatType.SIEGE_COMBAT then
		defPowerRate = 2
	end

	--Intense
	local atkPower = self:GetStat( CombatSide.ATTACKER, CombatStatistic.TOTAL_POWER )
	local defPower = self:GetStat( CombatSide.DEFENDER, CombatStatistic.TOTAL_POWER )
	local atkExposurePower = self:GetStat( CombatSide.ATTACKER, CombatStatistic.EXPOSURE_POWER )
	local defExposurePower = self:GetStat( CombatSide.DEFENDER, CombatStatistic.EXPOSURE_POWER )
	local atkIntense = atkPower / ( atkPower + defExposurePower )
	local defIntense = defPower / ( defPower + atkExposurePower )
	self:SetStat( CombatSide.ATTACKER, CombatStatistic.COMBAT_INTENSE, atkIntense )
	self:SetStat( CombatSide.DEFENDER, CombatStatistic.COMBAT_INTENSE, defIntense )
	self:SetStat( CombatSide.ATTACKER, CombatStatistic.CASUALTY_RATIO, self:GetStat( CombatSide.ATTACKER, CombatStatistic.DEAD ) / self:GetStat( CombatSide.ATTACKER, CombatStatistic.TOTAL_SOLDIER ) )
	self:SetStat( CombatSide.DEFENDER, CombatStatistic.CASUALTY_RATIO, self:GetStat( CombatSide.DEFENDER, CombatStatistic.DEAD ) / self:GetStat( CombatSide.DEFENDER, CombatStatistic.TOTAL_SOLDIER ) )

	--check surrounded
	function CheckSurrounded( params )
		if params.power == params.exposurePower then
			if params.ratio > 0.8 then
				--InputUtil_Pause( MathUtil_FindName( CombatSide, params.side ), "Surrounded")
				Asset_SetListItem( self, params.statuslist, CombatStatus.SURROUNDED, true )
			elseif params.ratio < 0.65 then
				Asset_SetListItem( self, params.statuslist, CombatStatus.SURROUNDED, false )
			end
		else
			Asset_SetListItem( self, params.statuslist, CombatStatus.SURROUNDED, false )
		end
	end
	CheckSurrounded( { side = CombatSide.DEFENDER, power = defPower, exposurePower = defExposurePower, ratio = atkPower / ( defPower + atkPower ), statuslist = CombatAssetID.DEF_STATUS } )
	CheckSurrounded( { side = CombatSide.ATTACKER, power = atkPower, exposurePower = atkExposurePower, ratio = defPower / ( defPower + atkPower ), statuslist = CombatAssetID.ATK_STATUS } )
	
	--check Withdraw
	local atkWithdraw = false
	local defWithdraw = false
	function NeedWithdraw( side, conditions )		
		for k, cond in pairs( conditions ) do
			local ret = true
			if cond.intense and self:GetStat( side, CombatStatistic.COMBAT_INTENSE ) > cond.intense then ret = false end

			if cond.morale and self:GetStat( side, CombatStatistic.AVERAGE_MORALE ) > cond.morale then ret = false end

			if cond.casualty_ratio and self:GetStat( side, CombatStatistic.CASUALTY_RATIO ) < cond.casualty_ratio then ret = false end

			if cond.not_siege and ( combatType == CombatType.SIEGE_COMBAT or combatType == CombatType.CAMP_COMBAT ) then ret = false end
			if cond.not_field and combatType == CombatType.FIELD_COMBAT then ret = false end
			if cond.is_field and combatType ~= CombatType.FIELD_COMBAT then ret = false end
			if cond.is_siege and combatType ~= CombatType.SIEGE_COMBAT and combatType ~= CombatType.CAMP_COMBAT then ret = false end			
			if cond.is_atk and side ~= CombatSide.ATTACKER then ret = false end			
			if cond.is_def and side ~= CombatSide.DEFENDER then ret = false end			

			if FeatureOption.DISABLE_FOOD_SUPPLY then
				ret = false				
			else
			 	if cond.food_supply_day and self:GetStat( side, CombatStatistic.FOOD_SUPPLY_DAY ) > cond.food_supply_day then ret = false end
			end


			
			--print( cond.reason, self:GetStat( side, CombatStatistic.COMBAT_INTENSE ), cond.intense, ret )
			if ret == true then
				DebugCombat( "withdraw reason=" .. ( cond.reason and cond.reason or "" ) )				
				DebugCombat( "intense="..self:GetStat( side, CombatStatistic.COMBAT_INTENSE ) )
				DebugCombat( "mor="..self:GetStat( side, CombatStatistic.AVERAGE_MORALE ) )
				DebugCombat( "casulaty="..self:GetStat( side, CombatStatistic.CASUALTY_RATIO ) )
				DebugCombat( "foodsup="..self:GetStat( side, CombatStatistic.FOOD_SUPPLY_DAY ) )
				local reason = cond.reason
				Stat_Add( "Withdraw@Reason", self:ToString() .. " " .. MathUtil_FindName( CombatSide, side ) .. " " .. reason .. " " .. self:ToString(), StatType.LIST )
				return ret
			end
		end
		return false
	end
	if NeedWithdraw( CombatSide.ATTACKER, CombatPurposeParam[atkPurpose].WITHDRAW ) == true then atkWithdraw = true end
	if NeedWithdraw( CombatSide.DEFENDER, CombatPurposeParam[defPurpose].WITHDRAW ) == true then defWithdraw = true end

	--Debug_Log( "wid atk=", atkWithdraw, self:GetStat( CombatSide.ATTACKER, CombatStatistic.COMBAT_INTENSE ) )
	--Debug_Log( "wid def=", defWithdraw, self:GetStat( CombatSide.DEFENDER, CombatStatistic.COMBAT_INTENSE ) )	

	if atkWithdraw ~= defWithdraw then
		--one side decide to withdraw
		local withdrawSide
		if atkWithdraw == true then
			withdrawSide = CombatSide.ATTACKER
		elseif defWithdraw == true then
			withdrawSide = CombatSide.DEFENDER
		end
		if self:GetStatus( withdrawSide, CombatStatus.SURROUNDED ) == true then
			local oppSide = self:GetOppSide( withdrawSide )
			Asset_Foreach( self, CombatAssetID.TROOP_LIST, function( troop )
				Asset_AppendList( self, CombatAssetID.PRISONER, { side = oppSide, prisoner = troop } )				
			end )
		end
		--print( "withdraw atk=", atkWithdraw, " def", defWithdraw )
		Asset_Set( self, CombatAssetID.RESULT, defWithdraw == true and CombatResult.STRATEGIC_VICTORY or CombatResult.STRATEGIC_LOSE )
		Asset_Set( self, CombatAssetID.WINNER, defWithdraw == true and CombatSide.ATTACKER or CombatSide.DEFENDER )
		return defWithdraw == true and CombatPrepareResult.ONLY_ATK_ACCEPTED or CombatPrepareResult.ONLY_DEF_ACCEPTED

	elseif atkWithdraw == true then
		Asset_Set( self, CombatAssetID.RESULT, CombatResult.DRAW )
		return CombatPrepareResult.BOTH_DECLINED
	end

	--determine rest
	local atkPrepared = self:GetStat( CombatSide.ATTACKER, CombatStatistic.PREPARED )
	local defPrepared = self:GetStat( CombatSide.DEFENDER, CombatStatistic.PREPARED )
	if atkPrepared == defPrepared and atkPrepared == false then
		if atkIntense < CombatPurposeParam[atkPurpose].DECLINED_INTENSE and defIntense < CombatPurposeParam[defPurpose].DECLINED_INTENSE then
			return CombatPrepareResult.BOTH_DECLINED
		end
	end
	
	local atkAttend = atkIntense > CombatPurposeParam[atkPurpose].ATTEND_INTENSE
	local defAttend = defIntense > CombatPurposeParam[defPurpose].ATTEND_INTENSE

	--both side agree to attend combat or not
	if atkAttend == defAttend then
		if atkAttend == true then
			return CombatPrepareResult.BOTH_ACCEPTED
		else
			local reason = "Intense="
			reason = reason .. PercentString( atkIntense ) .. "<" .. CombatPurposeParam[atkPurpose].ATTEND_INTENSE
			reason = reason .. PercentString( defIntense ) .. "<" .. CombatPurposeParam[defPurpose].ATTEND_INTENSE
			Stat_Add( "BothDeclined@Reason", self:ToString() .. " " .. reason, StatType.LIST )
			return CombatPrepareResult.BOTH_DECLINED
		end
	end

	--only one side agree to attend combat, so we should check FORCED ATTACK
	local agreedPurpose, declinedPurpose
	local agreedIntense, declinedIntense
	if atkAttend == false then
		declinedPurpose = atkPurpose
		agreedPurpose   = defPurpose
		agreedIntense   = defIntense
		declinedIntense = atkIntense
	elseif defAttend == false then
		declinedPurpose = defPurpose
		agreedPurpose   = atkPurpose
		agreedIntense   = atkIntense
		declinedIntense = defIntense
	end
	
	--determine agress side will forced attack
	local ret = agreedIntense >= CombatPurposeParam[agreedPurpose].FORCED_INTENSE	
	if ret == false then
		local reason = "AGREED_Intense="
		reason = reason .. agreedIntense .. "<" .. CombatPurposeParam[agreedPurpose].FORCED_INTENSE	
		Stat_Add( "BothDecliened@" .. self.id, self:ToString() .. " " .. reason, StatType.LIST )
		return CombatPrepareResult.BOTH_DECLINED
	end

	if atkAttend == true then
		return CombatPrepareResult.ONLY_ATK_ACCEPTED
	end

	local reason = "Atk_Intense="
	reason = reason .. PercentString( atkIntense ) .. "<" .. CombatPurposeParam[atkPurpose].ATTEND_INTENSE
	--Stat_Add( "Withdraw@Reason", self:ToString() .. " " .. reason, StatType.LIST )

	return CombatPrepareResult.ONLY_DEF_ACCEPTED
end

function Combat:PrepareDefense()
	if Asset_Get( self, CombatAssetID.TYPE ) ~= CombatType.SIEGE_COMBAT then
		return
	end

	if Asset_Get( self, CombatAssetID.DAY ) > 1 then
		return
	end

	local city = Asset_Get( self, CombatAssetID.CITY )
	if not city then return end
	--defence	
	local defenses = Asset_GetList( city, CityAssetID.DEFENSES )
	local index = 1
	for _, grid in pairs( self._grids ) do
		if grid.isWall then
			grid.defense = defenses[index]
			--InputUtil_Pause( "add defense=", grid.defense, index, defenses[index] )
			--WriteCombatLog( index .. "=" .. defenses[index] )
			index = index + 1
		end
	end
	--InputUtil_Pause()

	--guard
	local guardTable = TroopTable_Get( Scenario_GetData( "TROOP_PARAMS" ).GUARD_ID )
	local guard      = city:GetPopu( CityPopu.GUARD )
	local security   = Asset_Get( city, CityAssetID.SECURITY )
	
	--MathUtil_Dump( guardTable.requirement )
	local maxSoldier = 1000
	local numoftroop = math.ceil( guard / maxSoldier )
	local numpertroop = math.floor( guard / numoftroop )
	for n = 1, numoftroop do
		local troop = Entity_New( EntityType.TROOP )
		--Asset_Set( troop, TroopAssetID.ENCAMPMENT, city )
		Asset_Set( troop, TroopAssetID.SOLDIER, numpertroop )
		Asset_Set( troop, TroopAssetID.MAX_SOLDIER, numpertroop )
		Asset_Set( troop, TroopAssetID.ORGANIZATION, math.ceil( numpertroop * security * 0.01 ) )
		Asset_SetDictItem( troop, TroopAssetID.STATUSES, TroopStatus.GUARD, true )
		troop:LoadFromTable( guardTable )
		troop._prepared = true
		self:AddTroop( troop, CombatSide.DEFENDER )
		--InputUtil_Pause( "add guard", troop:ToString( "COMBAT" ), numpertroop )
	end
end

function Combat:PrepareSide( side )
	Asset_Foreach( self, CombatAssetID.TROOP_LIST, function ( troop )
		if troop._combatSide == side then
			troop._prepared = true
			troop._exposure = math.min( 100, troop._exposure + 20 )
		end
	end )
end

function Combat:CheckStatus()
	local type = Asset_Get( self, CombatAssetID.TYPE )
	if type == CombatType.SIEGE_COMBAT then
		Asset_Foreach( self, CombatAssetID.TROOP_LIST, function ( troop )
			if self:GetStatus( CombatSide.DEFENDER, CombatStatus.SURROUNDED ) == false then	
			end
		end )
	else
	end
	return true
end

--Return true means continue next step, return false not
function Combat:NextStep( step )
	if step == CombatStep.REST then
		if Asset_Get( self, CombatAssetID.DAY ) > 0 then
			self:Rest()
		end

	elseif step == CombatStep.PREPARE then
		--pass a day
		Asset_Plus( self, CombatAssetID.DAY, 1 )
		--reset states
		Asset_Set( self, CombatAssetID.RESULT, CombatResult.UNKNOWN )				
		--if self:CheckStatus() == false then return false end
		
		--check preparation
		local result = self:Prepare()
		if result == CombatPrepareResult.BOTH_DECLINED then
			if Asset_Get( self, CombatAssetID.RESULT ) == CombatResult.DRAW then
				--print( "both withdraw" )
			else
				self:AddStat( CombatSide.ALL, CombatStatistic.REST_DAY, 1 )
				--InputUtil_Pause( "Rest a day=".. Asset_Get( self, CombatAssetID.DAY ) )
			end
			Stat_Add( "Combat@BothWithdraw", 1, StatType.TIMES )
			return false
		end

		--one side withdraw
		if Asset_Get( self, CombatAssetID.RESULT ) ~= CombatResult.UNKNOWN then
			--print( "One side withdraw" )
			Stat_Add( "Combat@OneWithdraw", 1, StatType.TIMES )
			return false
		end

		--set combat type		
		local type = Asset_Get( self, CombatAssetID.TYPE )
		if type == CombatType.SIEGE_COMBAT then
			self._currentField = Asset_Get( self, CombatAssetID.DEFCAMPFIELD )
			if result == CombatPrepareResult.ONLY_DEF_ACCEPTED then
				--Debug_Log( self:ToString() .. " atk refused, should we occured a field combat?" )
				Stat_Add( "Siege@AtkWithdraw", 1, StatType.TIMES )
				return false
			end			
		else
			if result == CombatPrepareResult.ONLY_ATK_ACCEPTED then
				type = CombatType.CAMP_COMBAT
				self._currentField = Asset_Get( self, CombatAssetID.DEFCAMPFIELD )
			elseif result == CombatPrepareResult.ONLY_DEF_ACCEPTED then
				type = CombatType.CAMP_COMBAT
				self._currentField = Asset_Get( self, CombatAssetID.ATKCAMPFIELD )
			else
				type = CombatType.FIELD_COMBAT
				self._currentField = Asset_Get( self, CombatAssetID.BATTLEFIELD )				
				--no need to prepare for all
			end
			if type == CombatType.CAMP_COMBAT then
				self:AddStat( CombatSide.ALL, CombatStatistic.FORCED_ATK_DAY, 1 )
			end
			Asset_Set( self, CombatAssetID.TYPE, type )
		end
		self:PrepareSide( CombatSide.DEFENDER )
		self:PrepareSide( CombatSide.ATTACKER )

		self:AddStat( CombatSide.ALL, CombatStatistic.COMBAT_DAY, 1 )
		--set ai enviroment
		CombatAI_SetEnviroment( CombatAIEnviroment.COMBAT_INSTANCE, self )

	elseif step == CombatStep.EMBATTLE then
		self:Embattle()
		self:PrepareDefense()		

	elseif step == CombatStep.ORDER then
		self:Order()

	elseif step == CombatStep.INCOMBAT then
		--initialize time
		Asset_Set( self, CombatAssetID.TIME, 0 )
		Asset_Set( self, CombatAssetID.END_TIME, CombatTime.NORMAL_END_TIME )
		while self:IsEnd() == false do
			self:Update()
		end

	else
		return false
	end
	return true
end

function Combat:NextDay()
	Asset_Set( self, CombatAssetID.WINNER, CombatSide.UNKNOWN )
	Asset_Set( self, CombatAssetID.END_DAY, 30 )

	if Asset_Get( self, CombatAssetID.DAY ) >= Asset_Get( self, CombatAssetID.END_DAY ) then
		Asset_Set( self, CombatAssetID.RESULT, CombatResult.DRAW )
		Asset_Set( self, CombatAssetID.WINNER, CombatSide.UNKNOWN )
		Stat_Add( "Combat@Draw", 1, StatType.TIMES )
		return
	end

	local step = CombatStep.REST
	while self:NextStep( step ) do
		step = step + 1
	end

	if step == CombatStep.PREPARE then
		local atkPower = self:GetStat( CombatSide.ATTACKER, CombatStatistic.TOTAL_POWER )
		local defPower = self:GetStat( CombatSide.DEFENDER, CombatStatistic.TOTAL_POWER )
		local atkSoldier = self:GetStat( CombatSide.ATTACKER, CombatStatistic.TOTAL_SOLDIER )
		local defSoldier = self:GetStat( CombatSide.DEFENDER, CombatStatistic.TOTAL_SOLDIER )
		local atkIntense = self:GetStat( CombatSide.ATTACKER, CombatStatistic.COMBAT_INTENSE )
		local defIntense = self:GetStat( CombatSide.DEFENDER, CombatStatistic.COMBAT_INTENSE )
		local atk = atkIntense
		local def = defIntense
		DebugCombat( "combat prepared failed", atk, def, self:ToString() )
	end

	--Feedback
	self:Feedback()

	--update statistic
	self:UpdateStatistic()

	--Dump for debug
	--self:Dump()

	--InputUtil_Pause( "day end=" .. Asset_Get( self, CombatAssetID.DAY ), "winner=" .. Asset_Get( self, CombatAssetID.WINNER ) )

	--Stat_Add( "Combat" .. self.id .. "@DAY", 1, StatType.TIMES )
end

--no combat
function Combat:Rest()
	Asset_Foreach( self, CombatAssetID.TROOP_LIST, function ( troop )
		self:Reform( troop )
		self:Courage( troop )
	end )
end

function Combat:Order()
	--Each troop determine the order by them self
	Asset_Foreach( self, CombatAssetID.TROOP_LIST, function ( troop )
		CombatAI_Order( troop )
	end )
end

function Combat:Feedback()
	--defense
	if Asset_Get( self, CombatAssetID.TYPE ) == CombatType.SIEGE_COMBAT then
		local city = Asset_Get( self, CombatAssetID.CITY )
		for _, grid in pairs( self._grids ) do
			if grid.isWall == true then
				Asset_SetListItem( city, CityAssetID.DEFENSES, grid.x, grid.defense )
				DebugCombat( "DEFENSE-" .. grid.x .. "=" .. grid.defense )
			end
		end
	end
end

function Combat:UpdateRound()
	--Timer go on
	Asset_Plus( self, CombatAssetID.TIME, 1 )
	--DebugCombat( "#Day=" .. Asset_Get( self, CombatAssetID.DAY ), "Time=" .. Asset_Get( self, CombatAssetID.TIME ) )
end

function Combat:UpdateResult()
	if Asset_GetListSize( self, CombatAssetID.ATTACKER_LIST ) == 0 then
		Asset_Set( self, CombatAssetID.RESULT, CombatResult.DISASTROUS_LOSE )
		Asset_Set( self, CombatAssetID.WINNER, CombatSide.DEFENDER )
		return
	elseif Asset_GetListSize( self, CombatAssetID.DEFENDER_LIST ) == 0 then
		Asset_Set( self, CombatAssetID.RESULT, CombatResult.BRILLIANT_VICTORY )
		Asset_Set( self, CombatAssetID.WINNER, CombatSide.ATTACKER )
		return
	end

	function CheckAttendance( side )
		local attend = false
		local list = side == CombatSide.ATTACKER and CombatAssetID.ATTACKER_LIST or CombatAssetID.DEFENDER_LIST
		Asset_Foreach( self, list, function( troop )
			if troop._attend == true then
				attend = true
			end
		end )
		if attend == false then
			Asset_Set( self, CombatAssetID.WINNER, side == CombatSide.ATTACKER and CombatSide.DEFENDER or CombatSide.ATTACKER )
		end
		return attend
	end
	
	if CheckAttendance( CombatSide.ATTACKER ) == false or CheckAttendance( CombatSide.DEFENDER ) == false then
		--InputUtil_Pause( "winner attend=" .. Asset_Get( self, CombatAssetID.WINNER ) )
		return
	end

	local atkvp = self._stat[CombatSide.ATTACKER]["GAIN_VP"] or 0
	local defvp = self._stat[CombatSide.DEFENDER]["GAIN_VP"] or 0
	local vp = math.abs( atkvp - defvp )
	local totalvp = Asset_Get( self, CombatAssetID.TOTAL_VP )
	local ratio  = totalvp > 0 and vp * 100 / totalvp or 0
	local result = CombatResult.UNKNOWN
	local type = Asset_Get( self, CombatAssetID.TYPE )
	local typename = MathUtil_FindName( CombatType, type )
	local conditions = CombatVictoryPoint.RESULTS[typename]
	for _, items in ipairs( conditions ) do
		if ratio > items.ratio then
			if atkvp > defvp then
				result = items.atk
				if items.winner == 1 then
					InputUtil_Pause( "winner atk vp", result )
					Asset_Set( self, CombatAssetID.WINNER, CombatSide.ATTACKER )
				end
			else
				result = items.def
				if items.winner == 1 then
					InputUtil_Pause( "winner def vp", result )
					Asset_Set( self, CombatAssetID.WINNER, CombatSide.DEFENDER )
				end
			end
			break
		end
	end	
	self:SetStat( CombatSide.ATTACKER, CombatStatistic.VP_RATIO, ratio )
	self:SetStat( CombatSide.DEFENDER, CombatStatistic.VP_RATIO, -ratio )
	Asset_Set( self, CombatAssetID.RESULT, result )
	if result ~= CombatResult.UNKNOWN then
		InputUtil_Pause( "combat end result=" .. MathUtil_FindName( CombatResult, result ) )
	end
end

function Combat:Update( ... )	
	--Clear Variables
	self:UpdateRound()

	self:UpdateGrid()
	
	--shuffle troops, determine action sequence
	local list = MathUtil_Shuffle_Sync( Asset_GetList( self, CombatAssetID.TROOP_LIST )	)
	
	--check status
	self:UpdateStatus( list )

	--do action
	self:UpdateAction( list )

	--move
	self:UpdateMovement( list )

	--check result
	self:UpdateResult()

	--InputUtil_Pause()
end

function Combat:UpdateGrid()
	for _, grid in pairs( self._grids ) do
		grid.soldier = 0
		grid.organization = 0
		for _, troop in ipairs( grid.troops ) do
			grid.soldier = grid.soldier + Asset_Get( troop, TroopAssetID.SOLDIER )
			grid.organization = grid.organization + Asset_Get( troop, TroopAssetID.ORGANIZATION )
		end
		--print( "grid", grid.x, grid.y, grid.soldier, grid.organization, #grid.troops )
	end
end

function Combat:UpdateStatistic()
	for _, v in pairs( CombatStatistic ) do
		if v >= CombatStatistic.UPDATE_TYPE and v < CombatStatistic.REFERENCE_TYPE then
			--update everytime
			self._stat[CombatSide.ALL][v] = 0
			self._stat[CombatSide.ATTACKER][v] = 0
			self._stat[CombatSide.DEFENDER][v] = 0
		end
	end
	
	Asset_Foreach( self, CombatAssetID.TROOP_LIST, function( troop )
		local soldier = Asset_Get( troop, TroopAssetID.SOLDIER )
		self:AddStat( troop._combatSide, CombatStatistic.SOLDIER, soldier )
	end )
end

function Combat:UpdateStatus( list )
	local isAtkFlee, isDefFlee = true, true
	for _, troop in ipairs( list ) do
		if self:IsTroopValid( troop ) then
			--reset flags
			troop._target   = nil
			troop._attacked = false
			troop._defended = false
			troop._moved = false
			troop._acted = false

			if troop._surrounded == true then
				if self:FindNearbyFriendly( troop ) == nil then
					self:Surrounded( troop )
				else
					troop._surrounded = false
				end
			end

			CombatAI_CheckTroopStatus( troop )

			if troop._flee == true then
				if troop._combatSide == CombatSide.ATTACKER then
					isAtkFlee = false
				elseif troop._combatSide == CombatSide.DEFENDER then
					isDefFlee = false
				end
			end
		end
	end
	if isAtkFlee ~= isDefFlee then
		--InputUtil_Pause( "pursue flee" )
		Asset_Set( self, CombatAssetID.END_TIME, CombatTime.PURSUE_END_TIME )
	end
end

function Combat:UpdateMovement( list )
	self._movements = {}

	--determine movement tasks
	for _, troop in ipairs( list ) do
		if self:IsTroopValid( troop ) then
			self:ProcessMovement( CombatAI_DetermineTroopMove( troop ) )
		end
	end

	--execute movement tasks
	for _, task in ipairs( self._movements ) do
		self:ExecuteMovement( task )
	end	

	self._movements = nil
end

function Combat:UpdateAction( list )
	self._tasks = {}

	--determine action tasks
	for _, troop in ipairs( list ) do
		if self:IsTroopValid( troop ) then
			self:ProcessAction( CombatAI_DetermineTroopAttack( troop ) )
		end
	end

	function GetTaskPriority( task )
		if task.type == CombatTask.FIGHT then
			return 10
		elseif task.type == CombatTask.SHOOT then
			return 30
		elseif task.type == CombatTask.CHARGE then
			return 20
		elseif task.type == CombatTask.DEFEND then
			return 50			
		elseif task.type == CombatTask.DESTROY_DEFENSE then
			return 40
		else
			return 60
		end
	end

	table.sort( self._tasks, function ( l, r )
		return GetTaskPriority( l ) > GetTaskPriority( r )
	end)

	for _, task in  ipairs( self._tasks ) do
		if self:IsTroopValid( task.troop ) then
			self:DealAttack( task.troop, task.target, { type = task.type, weapon = task.weapon } )
		end
	end
end

-----------------------------------------
--
-- Finder
--   find targets
--

local _positionOffsets = 
{
	{ x =  0, y =  1,  distance = 1 },
	{ x =  0, y = -1,  distance = 1 },
	{ x = -1, y =  0,  distance = 1 },
	{ x =  1, y =  0,  distance = 1 },
}

function Combat:CalcDistance( sour, dest )
	--print( NIDString( sour ), NIDString( dest ) )
	if not dest._x then
		MathUtil_Dump( dest )
	end
	if not sour._x then
		--MathUtil_Dump( sour )
	end
	return math.abs( sour._x - dest._x ) + math.abs( sour._y - dest._y )
end

function Combat:CalcDistance2( x1, y1, x2, y2 )
	--print( NIDString( sour ), NIDString( dest ) )
	return math.abs( x1 - x2 ) + math.abs( y1 - y2 )
end

function Combat:GetFaceDir( troop )
	return troop._faceDir[2], troop._faceDir[3]
end

function Combat:FindContactGrid( troop )
	local oppSide = self:GetOppSide( troop._combatSide )
	local findGrid = nil
	local findDistance = 0
	for _, grid in pairs( self._grids ) do
		if grid.side == troop._combatSide then
			for _, of in ipairs( _positionOffsets ) do
				local nextGrid = self:GetGrid( grid.x + of.x, grid.y + of.y )
				if nextGrid and nextGrid.side == oppSide then
					local distance = self:CalcDistance2( grid.x, grid.y, troop._x, troop._y )
					if findGrid == nil or findDistance < distance then
						findGrid = grid
					elseif findDistance == distance then
						if Random_GetInt_Sync( 1, 100 ) < 50 then
							findGrid = grid
						end
					end
				end
			end
		end
	end
	return findGrid
end

function Combat:FindGridTarget( grid, side )
	if grid.side == side then return nil end	
	local num = #grid.targets
	if num == 0 then
		grid.targets = MathUtil_Shuffle_Sync( MathUtil_Copy( grid.troops ) )
		num = #grid.targets
	end
	if num == 0 then return nil end
	local tar = table.remove( grid.targets, 1 )
	return tar
end

-- Find an enmey target in front, maybe there are some BLOCK between self and target
function Combat:FindFrontTarget( troop )
	local x, y = troop._x, troop._y
	local ox, oy = self:GetFaceDir( troop )
	while x > 0 and x <= self._currentField.width and y > 0 and y <= self._currentField.height do
		x = x + ox
		y = y + oy
		return self:FindGridTarget( self:GetGrid( x, y ), troop._combatSide )
	end
	return nil
end

function Combat:FindBackTarget( troop )
	local x, y = troop._x, troop._y
	local ox, oy = self:GetFaceDir( troop )
	while x > 0 and x <= self._currentField.width and y > 0 and y <= self._currentField.height do
		x = x + ox
		y = y + oy
		return self:FindGridTarget( self:GetGrid( x, y ), troop._combatSide )
	end
	return nil
end

-- Use BFS to find the closest target filter by given fn
-- fn returns 1 means find target, returns 0 means not target, returns -1 means blocked
function Combat:FindBfsTarget( troop, fn )
	--WriteCombatLog( CombatLog.DEBUG, "current=", troop.name, troop._x, troop._y )
	local openList   = { { x = troop._x, y = troop._y, distance = 0 } }
	local closeList  = {}
	local targetList = {}
	local maxDistance = 9999
	local battlefield = self._currentField
	while #openList > 0 do
		local current = openList[1]
		local x = current.x
		local y = current.y
		table.remove( openList, 1 )

		for _, offset in ipairs( _positionOffsets ) do
			local tx = x + offset.x
			local ty = y + offset.y
			if tx > 0 and ty > 0 and tx <= battlefield.width and ty <= battlefield.height then
				local index = QueryPosition( tx, ty )
				local grid = self:GetGrid( tx, ty )
				for _, troop in ipairs( grid.troops ) do					
					local ret = fn( troop )
					if ret == 1 then
						if current.distance + offset.distance > maxDistance then
							break
						else
							maxDistance = current.distance + offset.distance
							table.insert( targetList, adja )
						end
					elseif ret == 0 then
						if not closeList[index] then
							--WriteCombatLog( CombatLog.DEBUG, "add", tx, ty, index, offset.x, offset.y, closeList[index] )
							table.insert( openList, { x = tx, y = ty, distance = current.distance + offset.distance } )
						end
					elseif ret == -1 then				
					end
				end
				closeList[index] = 1
			end
		end
	end
	if #targetList <= 0 then
		return nil
	end
	local target = targetList[Random_GetInt_Sync( 1, #targetList )]
	return target
end

--	Find one nearby target, up/down/left/right
function Combat:FindNearbyTarget( troop )
	--find target nearby
	for _, of in ipairs( _positionOffsets ) do
		local grid = self:GetGrid( troop._x + of.x, troop._y + of.y )
		local target = self:FindGridTarget( grid, troop._combatSide )		
		if target and self:IsTroopValid( target ) then
			--InputUtil_Pause( "find nearest target", troop:ToString( "COMBAT" ), troop._x, troop._y, grid.x, grid.y )
			return target
		end
	end	
	return nil
end

function Combat:FindLineTarget( troop )
	local battlefield = self._currentField

	function FindTarget( x, y, ox, oy )
		while y > 0 and y <= battlefield.height and x > 0 and x <= battlefield.width  do
			x = x + ox
			y = y + oy
			return self:FindGrid( self:GetGrid( x, y ), troop._combatSide )
		end
	end

	local xDelta, yDelta = self:GetFaceDir( troop )
	local x, y = troop._x, troop._y
	local findTar
	if xDelta == 0 then
		findTar = FindTarget( troop._x, troop._y, 0, yDelta )
		if findTar then return findTar end
		findTar = FindTarget( troop._x, troop._y, 0, -yDelta )
		if findTar then return findTar end	
	else
		findTar = FindTarget( troop._x, troop._y, xDelta, 0 )
		if findTar then return findTar end
		findTar = FindTarget( troop._x, troop._y, -xDelta, 0 )
		if findTar then return findTar end
	end
	return nil
end

function Combat:FindNearestTarget( troop )
	local list
	if troop._combatSide == CombatSide.ATTACKER then
		list = Asset_Get( self, CombatAssetID.DEFENDER_LIST )
	elseif troop._combatSide == CombatSide.DEFENDER then
		list = Asset_Get( self, CombatAssetID.ATTACKER_LIST )
	end

	local target = nil
	local distance = 0
	for _, tar in pairs( list ) do
		if self:IsTroopValid( tar ) then		
			local dis = self:CalcDistance( troop, tar )
			if target == nil then
				target = tar
				distance = dis
			elseif dis < distance then
				target = tar
				distance = dis
			end
		end
	end	

	--print( "nearest", troop.name, troop.id, target.name, target.id )
	return target
end

function Combat:FindSiegeTaget( troop )
	local ox, oy = self:GetFaceDir( troop )
	local x, y = troop._x, troop._y
	local oppSide = self:GetOppSide( troop )
	local battlefield = self._currentField
	while y > 0 and y <= battlefield.height and x > 0 and x <= battlefield.width do
		x = x + ox
		y = y + oy		
		local grid = self:GetGrid( x, y )		
		if grid and grid.side ~= troop._combatSide then
			if grid.isWall == true or grid.isGate == true then
				if grid.defense > 0 then
					--InputUtil_Pause( "find siege grid", grid.x, grid.y, grid.defense )
					return grid
				end
			end
		end
	end
	return nil
end

function Combat:FindNearbyFriendly( troop )
	--find target nearby
	for _, of in ipairs( _positionOffsets ) do
		local grid = self:GetGrid( troop._x + of.x, troop._y + of.y )
		local tar = self:FindGridTarget( grid, self:GetOppSide( troop._combatSide ) )
		if tar then return tar end
	end
	return nil
end

-----------------------------------------
-- Troop Action

function Combat:Courage( troop )
	--restore morale
	local level = Asset_Get( troop, TroopAssetID.LEVEL )
	local restore = math.floor( ( level + 5 ) * 0.5 )
	Asset_Plus( troop, TroopAssetID.MORALE, restore )
	self:AddStat( troop._combatSide, CombatStatistic.RESTORE_MORALE, restore )
end

function Combat:Reform( troop )
	--restore organization
	local level = Asset_Get( troop, TroopAssetID.LEVEL )
	local org = Asset_Get( troop, TroopAssetID.ORGANIZATION )
	local soldier = Asset_Get( troop, TroopAssetID.SOLDIER )
	org = math.min( soldier, math.ceil( org + soldier * ( level + 10 ) * 0.05 ) )
	Asset_Set( troop, TroopAssetID.ORGANIZATION, org )
	self:AddStat( troop._combatSide, CombatStatistic.RESTORE_ORG, org )
end

function Combat:Defend( troop )
end

function Combat:Surrounded( troop )
	local level = Asset_Get( troop, TroopAssetID.LEVEL )
	Asset_Reduce( troop, TroopAssetID.MORALE, math.ceil( 15 - level * 0.5 ) )

	local level = Asset_Get( troop, TroopAssetID.LEVEL )
	local org = Asset_Get( troop, TroopAssetID.ORGANIZATION )
	local soldier = Asset_Get( troop, TroopAssetID.SOLDIER )
	org = math.min( soldier, math.ceil( org + soldier * ( level + 10 ) * 0.01 ) )
	Asset_Reduce( troop, TroopAssetID.ORGANIZATION, org )
end

function Combat:InfluenceFriendlyMorale( side, troop )
	local list
	if side == CombatSide.ATTACKER then
		list = Asset_GetList( self, CombatAssetID.ATTACKER_LIST )
	elseif side == CombatSide.DEFENDER then
		list = Asset_GetList( self, CombatAssetID.DEFENDER_LIST )
	end
	if not list then return end
	for _, tar in ipairs( list ) do
		if tar ~= troop and self:IsTroopValid( tar ) then
			local morale = 12 - math.ceil( Asset_Get( tar, TroopAssetID.LEVEL ) * 0.5 )
			Asset_Reduce( tar, TroopAssetID.MORALE, math.floor( morale ) )
		end
	end
end

function Combat:InfluenceFriendlyOrg( side, troop )
	local list
	if side == CombatSide.ATTACKER then
		list = Asset_GetList( self, CombatAssetID.ATTACKER_LIST )
	elseif side == CombatSide.DEFENDER then
		list = Asset_GetList( self, CombatAssetID.DEFENDER_LIST )
	end
	for _, tar in ipairs( list ) do
		if tar ~= troop and self:IsTroopValid( tar ) then
			local org = ( 12 - Asset_Get( tar, TroopAssetID.LEVEL ) * 0.5 ) * Asset_Get( tar, TroopAssetID.SOLDIER ) * 0.01
			Asset_Reduce( tar, TroopAssetID.ORGANIZATION, org )
		end
	end
end

function Combat:Kill( attacker, defender )
	WriteCombatLog( CombatLog.DESC, attacker:ToString( "COMBAT" ) .. " kill " .. defender:ToString( "COMBAT" ) )
	
	--influence friendly morale
	self:InfluenceFriendlyMorale( defender._combatSide )

	--remove from battlefield
	self:RemoveTroop( defender, true )

	--remove data
	Troop_Remove( defender )
end


local testMode = false
function Combat:DealDamage( attacker, defender, params )
	local dmg = params.dmg
	if not dmg then return end	

	if testMode == false and attacker._attacked == true and params.isCounter ~= true then
		--InputUtil_Pause( "Attack again?", attacker:ToString( "COMBAT" ), attacker._attacked )
	end

	if params.isCounter ~= true then
		attacker._attacked = true	
		defender._defended = true
		self:AddStat( attacker._combatSide, CombatStatistic.ATTACK, 1 )
	end	
	--self:AddStat( defender, CombatStatistic.DEFEND, 1 )

	local atklv = Asset_Get( attacker, TroopAssetID.LEVEL )
	local deflv = Asset_Get( defender, TroopAssetID.LEVEL )

	--expose attacker
	attacker._exposure = math.min( 100, ( attacker._exposure or 0 ) + 10 + deflv )
	defender._exposure = math.min( 100, ( defender._exposure or 0 ) + 15 + atklv )

	--reduce morale
	local morale = 5
	if params.isCounter == true then morale = morale - 2 end
	if params.isCritical == true then morale = morale + 2 end
	morale = math.max( 1, math.ceil( morale + ( atklv - deflv ) * 0.5 ) )
	Asset_Reduce( defender, TroopAssetID.MORALE, morale )
	self:AddStat( defender._combatSide, CombatStatistic.LOSE_MORALE, morale )

	--self:AddStat( attacker, CombatStatistic.DAMAGE, dmg )
	--self:AddStat( attacker._combatSide, CombatStatistic.DAMAGE, dmg )

	--reduce organization
	local organization = Asset_Get( defender, TroopAssetID.ORGANIZATION )
	local reduceOrg = math.max( 0, math.floor( dmg * params.orgRate ) )
	Asset_Reduce( defender, TroopAssetID.ORGANIZATION, reduceOrg )

	--kill soldier
	local defNumber = Asset_Get( defender, TroopAssetID.SOLDIER )
	local hitRate = math.min( 0.5, params.hitRate * defNumber / ( defNumber + organization ) )	
	local kill = math.ceil( dmg * hitRate )

	if defNumber <= kill then
		--WriteCombatLog( CombatLog.DESC, attacker:ToString( "COMBAT" ), MathUtil_FindName( CombatTask, type ).. defender:ToString( "COMBAT" ), " dmg=".. dmg, " kill="..kill, " left=", defNumber - kill, " org=".. organization )
		self:AddStat( attacker._combatSide, CombatStatistic.GAIN_VP, defNumber * defender._vp )		
		self:AddStat( defender._combatSide, CombatStatistic.DEAD, defNumber )	
		self:AddStat( attacker._combatSide, CombatStatistic.KILL, defNumber )
		self:AddStat( attacker            , CombatStatistic.KILL, defNumber )		
		self:Kill( attacker, defender )
		return
	end
	self:AddStat( attacker._combatSide, CombatStatistic.GAIN_VP, kill * defender._vp )
	
	--count soldier
	Asset_Set( defender, TroopAssetID.SOLDIER, defNumber - kill )

	--test, kill king
	local officer = Asset_Get( defender, TroopAssetID.OFFICER )
	if officer then
		if officer:IsGroupLeader() then
			self:RemoveTroopOfficer( defender )
		end
	end

	-----------------------------------------
	-- Damage( Kill ) Statistic	
	local atkcorps = Asset_Get( attacker, TroopAssetID.CORPS )
	local defcorps = Asset_Get( defender, TroopAssetID.CORPS )
	Stat_Add( "KILL@" .. self:GetTroopGroupName( attacker ), kill, StatType.ACCUMULATION )	
	Stat_Add( "DIE@" .. self:GetTroopGroupName( defender ), kill, StatType.ACCUMULATION )	
	--Stat_Add( "Combat@" .. self.id .. "_KILL", kill, StatType.ACCUMULATION )
	Stat_Add( "Combat@Kill", kill, StatType.ACCUMULATION )
	--Stat_Add( "DIE@" .. atkcorps.name,  kill, StatType.ACCUMULATION )
	--Stat_Add( "KILL@" .. defcorps.name, kill, StatType.ACCUMULATION )
	-----------------------------------------

	--statistic
	self:AddStat( defender._combatSide, CombatStatistic.DEAD, kill )
	self:AddStat( attacker._combatSide, CombatStatistic.KILL, kill )
	self:AddStat( attacker            , CombatStatistic.KILL, kill )

	if testMode == true then
		WriteCombatLog( attacker:ToString( "COMBAT" ) .."=>" .. MathUtil_FindName( CombatTask, params.type ).."=>" ..  defender:ToString( "COMBAT" ) ..  " dmg=".."=>" ..  dmg..  " kill=".."=>" ..  kill .."=>" ..  " org=".."=>" .. math.max( 0, organization - reduceOrg ) )
	else
		WriteCombatLog( CombatLog.DESC, attacker:ToString( "COMBAT" ), MathUtil_FindName( CombatTask, params.type ), defender:ToString( "COMBAT" ), " dmg=".. dmg, " kill="..kill, " left=", defNumber - kill, " org=".. organization )
	end
end

function Combat:DestroyDefense( atk, def, params )
	params.prot = def.prot
	local dmg, orgRate, hitRate, isCritical = Combat_CalcDamage( atk, def, params )
	if def.defense <= 0 then
		InputUtil_Pause( "already broken" )
	end
	if def.defense <= dmg then
		dmg = def.defense
		def.defense = 0
		if def.isWall == true then
			if def.side == CombatSide.ATTACKER then
				Asset_SetListItem( self, CombatAssetID.ATK_STATUS, CombatStatus.DEFENSE_BROKEN, true )
				--print( Asset_GetListItem( self, CombatAssetID.ATK_STATUS, CombatStatus.DEFENSE_BROKEN ) )
			elseif def.side == CombatSide.DEFENDER then
				Asset_SetListItem( self, CombatAssetID.DEF_STATUS, CombatStatus.DEFENSE_BROKEN, true )
				--print( Asset_GetListItem( self, CombatAssetID.DEF_STATUS, CombatStatus.DEFENSE_BROKEN ) )
			end			
			--InputUtil_Pause( "break def", def.side, def.x, def.y )
			if Asset_Get( self, CombatAssetID.TYPE ) == CombatType.SIEGE_COMBAT then
				self:InfluenceFriendlyMorale( def.side )
			end			
		end
		--self:InfluenceFriendlyOrg( def.side )
	else
		def.defense = def.defense - dmg
	end
	--WriteCombatLog( CombatLog.DESC, atk:ToString( "COMBAT" ), MathUtil_FindName( CombatTask, params.type ), "("..def.x..","..def.y..")", " dmg=".. dmg, " left=", def.defense )
	self:AddStat( atk._combatSide, CombatStatistic.DESTROY_DEFENSE, dmg )
	--InputUtil_Pause( atk:ToString( "COMBAT" ), "hit defense=" .. dmg .. "->" .. def.defense )
end

function Combat:CalcAttack( atk, def, params )	
	if atk._grid then
		params.isCrowd = atk._grid.soldier > atk._grid.depth
		if params.isCrowd == true then
			--print( atk._grid.soldier, atk._grid.depth, #atk._grid.troops )
		end
	end
	params.prot = 0
	if def._grid and def._grid.defense then
		params.prot = def._grid.defense > 0 and def._grid.prot or 0
	end	
	if atk._grid and def._grid and params.prot > 0 then
		params.isHeightAdv    = ( atk._grid.height or 0 ) > ( def._grid.height or 0 ) * 2
		params.isHeightDisadv = ( atk._grid.height or 0 ) * 2.5 < ( def._grid.height or 0 )
	end
	params.isTest = testMode
	params.isAssit = def._target ~= nil and def._target ~= atk	
	if isCritical == true then self:AddStat( atk._combatSide, CombatStatistic.CRITICAL_TIMES, 1 ) end
	local dmg, orgRate, hitRate, isCritical = Combat_CalcDamage( atk, def, params )
	return { type = params.type, dmg = dmg, orgRate = orgRate, hitRate = hitRate, isCounter = params.isCounter, isCritical = isCritical }	
end

function Combat:DealAttack( atk, def, params )
	params.isTired      = atk._attacked
	params.isSuppressed = atk._defended

	--WriteCombatLog( CombatLog.DESC, MathUtil_FindName( CombatTask, params.type ), atk:ToString( "COMBAT" ) .. " vs " .. def:ToString( "COMBAT" ) )
	if params.type == CombatTask.DESTROY_DEFENSE then
		self:DestroyDefense( atk, def, params )
		return
	end
	if not self:IsTroopValid( def ) then return end	
	local p1 = self:CalcAttack( atk, def, params )
	local weapon = Combat_FindCounterattackWeapon( def, params)
	if weapon then
		local params2 = {}		
		params2.type = CombatTask.FIGHT
		params2.weapon = weapon
		params2.isCounter = true
		params2.isTired      = def._attacked
		params2.isSuppressed = def._defended
		local p2 = self:CalcAttack( def, atk, params2 )
		self:DealDamage( def, atk, p2 )
	end
	self:DealDamage( atk, def, p1 )
end

------------------------------------------
-- Task

function Combat:ProcessMovement( task )
	table.insert( self._movements, task )
end

function Combat:ProcessAction( task )
	if not task then
		return
	end
	if task.type == CombatTask.PASS then
		self:AddStat( task.troop._combatSide, CombatStatistic.PASS, 1 )
		return
	end
	if task.type == CombatTask.DEFEND then
		self:Defend( task.troop )
		return
	end
	task.troop._target = task.target
	table.insert( self._tasks, task )	
end

function Combat:Flee( troop )
	troop._attend = nil

	--check probability
	if self:GetStatus( troop._combatSide, CombatStatus.SURROUNDED ) == true then
		--surrounded, maybe captured
		local sucratio = 65 - Asset_Get( troop, TroopAssetID.LEVEL ) * 3
		local ret = Random_GetInt_Sync( 1, 100 ) < sucratio
		if ret == false then
			--captured
			troop._captured = true
			local oppSide = self:GetOppSide( troop._combatSide )
			Asset_AppendList( self, CombatAssetID.PRISONER, { side = oppSide, prisoner = troop } )
			--InputUtil_Pause( troop:ToString( "COMBAT" ), "captured" )
			Debug_Log( "captured", troop:ToString() )
			Stat_Add( "Combat@Capture_Troop", nil, StatType.TIMES )
			Stat_Add( "Combat@Capture_Soldier", Asset_Get( troop, TroopAssetID.SOLDIER ), StatType.ACCUMULATION )
			return
		end
	end

	local morale = 15 - math.ceil( Asset_Get( troop, TroopAssetID.LEVEL ) * 0.5 )
	Asset_Reduce( troop, TroopAssetID.MORALE, math.ceil( morale ) )

	self:AddStat( troop._combatSide, CombatStatistic.LOSE_MORALE, morale )
	self:AddStat( troop, CombatStatistic.FLEE, 1 )

	self:InfluenceFriendlyOrg( troop._combatSide )

	--InputUtil_Pause( troop:ToString( "COMBAT" ), "fled" )
	return
end

function Combat:MoveTo( troop, x, y, type )
	local battlefield = self._currentField		
	local tx = MathUtil_Clamp( x, 0, battlefield.width + 1 )
	local ty = MathUtil_Clamp( y, 0, battlefield.height + 1 )
	
	if tx <= 0 or ty <= 0 or tx > battlefield.width or ty > battlefield.height then
		--out of battlefield		
		if type == CombatTask.FLEE then
			self:Flee( troop )
		end
	end
	
	WriteCombatLog( CombatLog.DESC, troop:ToString( "COMBAT" ) .. " Move ("..troop._x..","..troop._y..")->" .. "("..tx..","..ty..")", MathUtil_FindName( CombatTask, type ) )
	
	local curGrid = self:GetGrid( troop._x, troop._y )
	local nextGrid = self:GetGrid( tx, ty )	
	self:AddGridTroop( nextGrid, troop )
	self:RemoveGridTroop( curGrid, troop )
	troop._x = tx
	troop._y = ty
	troop._grid = curGrid

	if type == CombatTask.BACKWARD then
		troop._surrounded = true		
	end

	--self:DrawBattlefield()
end

function Combat:ExecuteMovement( task )
	local troop = task.troop

	--WriteCombatLog( CombatLog.DESC, troop:ToString( "COMBAT" ) .. " type=" .. MathUtil_FindName( CombatTask, task.type ) .. " tar=" .. ( task.target and NIDString( task.target ) or "" ) )

	--set acted flag
	troop._moved = true
	task.troop._target = task.target

	local xDelta, yDelta = self:GetFaceDir( troop )	
	
	if task.type == CombatTask.FORWARD then
		self:AddStat( troop._combatSide, CombatStatistic.FORWARD, 1 )
	elseif task.type == CombatTask.TOWARD_GRID then
		local grid = task.target
		local ox = grid.x > troop._x and 1 or ( grid.x < troop._x and -1 or 0 )
		local oy = grid.y > troop._y and 1 or ( grid.y < troop._y and -1 or 0 )
		self:MoveTo( troop, troop._x + ox, troop._y + oy, task.type )
		return

	elseif task.type == CombatTask.TOWARD_TAR then
		--self:DrawBattlefield()
		local target = task.target

		local ox,  oy = 0, 0
		if target._x > troop._x then
			ox = 1
		elseif target._x < troop._x then
			ox = -1
		end
		if target._y > troop._y then
			oy = 1
		elseif target._y < troop._y then
			oy = -1
		end

		--print( troop.id, troop._x, troop._y, "toward", task.target.id, task.target._x, task.target._y )
		local xDis = math.abs( target._x - troop._x )
		local yDis = math.abs( target._y - troop._y )
		--print( xDelta, yDelta, xDis, yDis )

		if target._retreat == true then xDis = xDis + 1 end

		if xDis > yDis then
			if self:MoveTo( troop, troop._x + ox, troop._y ) then return end
			if oy ~= 0 and self:MoveTo( troop, troop._x, troop._y + oy ) then return end
			if self:MoveTo( troop, troop._x, troop._y + yDelta ) then return end
		else
			if self:MoveTo( troop, troop._x, troop._y + oy ) then return end
			if ox ~= 0 and self:MoveTo( troop, troop._x + ox, troop._y ) then return end
			if self:MoveTo( troop, troop._x, troop._y + yDelta ) then return end
		end
		return
	elseif task.type == CombatTask.BACKWARD or task.type == CombatTask.FLEE then
		yDelta = -yDelta
		self:AddStat( troop._combatSide, CombatStatistic.BACKWARD, 1 )
	elseif task.type == CombatTask.STAY then
		troop._moved = false
		return
	end
	self:MoveTo( troop, troop._x + xDelta, troop._y + yDelta, task.type )
end

-----------------------------------------------
-- Debug & Test

function Combat:TestDamage()
	testMode = true
	local number = 1000
	local org    = number * 0.5
	local atklist = {}
	local deflist = {}
	--local testids = { 1, 2 }
	TroopTable_Foreach( function ( tab )
		if testids == nil or MathUtil_IndexOf( testids, tab.id ) then
			--if tab.category == TroopCategory.INFANTRY then
			--if tab.category == TroopCategory.CAVALRY then
			--if tab.id == 302 then
			if true then
				local atk = Corps_EstablishTroopByTable( tab, number )
				table.insert( atklist, atk )
				TroopTable_ListAbility( atk )
			end

			--if tab.category == TroopCategory.CAVALRY then
			if true then
				local def = Corps_EstablishTroopByTable( tab, number )
				table.insert( deflist, def )
			end
		end
	end )

	for _, atk in ipairs( atklist ) do
		for _, def in ipairs( deflist ) do
			Asset_Set( def, TroopAssetID.SOLDIER, number )
			Asset_Set( def, TroopAssetID.MAX_SOLDIER, number )
			Asset_Set( def, TroopAssetID.ORGANIZATION, org )
			self:Attack( atk, def, { type = CombatTask.FIGHT } )
			
			Asset_Set( def, TroopAssetID.SOLDIER, number )
			Asset_Set( def, TroopAssetID.MAX_SOLDIER, number )
			Asset_Set( def, TroopAssetID.ORGANIZATION, org )
			self:Attack( atk, def, { type = CombatTask.SHOOT } )

			Asset_Set( def, TroopAssetID.SOLDIER, number )
			Asset_Set( def, TroopAssetID.MAX_SOLDIER, number )
			Asset_Set( def, TroopAssetID.ORGANIZATION, org )
			self:Attack( atk, def, { type = CombatTask.CHARGE } )
		end	
	end
	testMode = false
end


----------------------------------------------
--
-- Very important function in COMBAT
--

function Combat_NeedWithdraw()

end

function Combat_IsPrepared( troop )
	local soldier = Asset_Get( troop, TroopAssetID.SOLDIER )
	local maxsoldier = Asset_Get( troop, TroopAssetID.MAX_SOLDIER )

	local organization = Asset_Get( troop, TroopAssetID.ORGANIZATION )	

	local morale = Asset_Get( troop, TroopAssetID.MORALE )

	local soliderRatio = soldier * 100 / maxsoldier
	local orgRatio = organization * 100 / soldier

	local ret = false
	local order = troop._order
	if order == CombatOrder.FORCED_ATTACK then
		ret = soliderRatio + orgRatio > 120 and soliderRatio > 55 and morale > 40
	elseif order == CombatOrder.ATTACK then
		ret = soliderRatio + orgRatio > 130 and soliderRatio > 60 and morale > 40
	elseif order == CombatOrder.DEFEND then
		ret = soliderRatio + orgRatio > 140 and soliderRatio > 65 and morale > 45
	elseif order == CombatOrder.SURVIVE then
		ret = soliderRatio + orgRatio > 150 and soliderRatio > 70 and morale > 45
	end
	--if ret == false then Debug_Log( troop.name .. "," .. troop.id .. " Pre=" .. ( ret == true and "Y" or "N" ) .. " side=" .. MathUtil_FindName( CombatSide, troop._combatSide ) .. " sol=" .. soldier .. "/" .. maxsoldier .. "(" .. soliderRatio .. "%) org=" .. orgRatio ) end
	return ret
end

function Combat_CalcDamage( atk, def, params )
	--Soldier number modification
	local atkNumber = Asset_Get( atk, TroopAssetID.SOLDIER )
	if params.isAssit == true then
		atkNumber = atkNumber * 0.5
	end	
	if params.isCounter == true then		
		atkNumber = atkNumber * 0.5
	end
	if params.isCrowd == true then
		atkNumber = atkNumber * 0.5
	end		
	if params.isSuppressed == true then
		atkNumber = atkNumber * 0.5
	end
	local number_mod = 0
	if atkNumber < 100 then number_mod = atkNumber
	elseif atkNumber < 500 then number_mod = 100 + ( atkNumber - 100 ) * 0.25
	elseif atkNumber < 2000 then number_mod = 200 + ( atkNumber - 500 ) * 0.1
	else number_mod = 350 end

	--Weapon & Armor Modification
	local atklv = Asset_Get( atk, TroopAssetID.LEVEL )	
	local hit_rate      = math.max( 10, params.weapon.accuracy + 5 * ( atklv - params.weapon.level ) )
	local org_rate      = 1	
	local weapon_pow    = params.weapon.power
	local armor     = Asset_Get( def, TroopAssetID.ARMOR ) or 0
	local toughness = Asset_Get( def, TroopAssetID.TOUGHNESS ) or 0
	hit_rate = hit_rate * 100 / ( 100 + toughness )
	--determine rate
	local weapon_rate = math.max( 0.1, 1 + ( armor > 0 and ( weapon_pow - armor ) / ( armor ) or 0 ) )

	local exposure_rate = 1
	local is_critical = false
	if params.isTest ~= true then
		--intel about enemy( exposure ) will determine how
		local exposure = 50 + ( def._exposure ~= nil and def._exposure * 0.5 or 50 )
		exposure_rate = Random_GetInt_Sync( exposure, 110 ) * 0.01

		--determine critical
		local atkmor = Asset_Get( atk, TroopAssetID.MORALE )
		local defmor = Asset_Get( def, TroopAssetID.MORALE ) or 0	
		local critical_range = math.min( 35, ( atkmor - defmor ) * 0.5 + 10 )
		is_critical = Random_GetInt_Sync( 1, 100 ) < critical_range
	end

	local dmg_rate = 1

	if params.isTired == true then
		dmg_rate = dmg_rate * 0.5
	end

	if params.type ~= CombatTask.DESTROY_DEFENSE then
		if params.isHeightAdv == true then
			--dmg_rate = dmg_rate * 1.2
			hit_rate = hit_rate + 0.15
			--InputUtil_Pause( atk.id, "height adv" )
		end
		if params.isHeightDisadv == true then
			dmg_rate = dmg_rate * 0.5
			--InputUtil_Pause( atk.id, 'height disadv')
		end
	end
	if is_critical == true then
		dmg_rate = dmg_rate * 1.5
	end	
	if params.prot and params.prot > 0 then
		dmg_rate = dmg_rate * 100 / ( 100 + params.prot )
	end

	--calc dmg
	local dmg = math.ceil( number_mod * dmg_rate * weapon_rate * exposure_rate )
	
	--print( "num=" .. number_mod, "dmg_rate="..dmg_rate, "wp_rate="..weapon_rate, "exposure_rate="..exposure_rate )
	--print( "num="..number_mod, weapon_pow, weapon_resist, "weapon="..math.ceil( weapon_rate * 100 ), "org=".. math.ceil( org_rate * 100 ), "hit=".. math.ceil( hit_rate * 100 ), " critical=" .. ( is_critical and "true" or "false" ) )
	--print( "atk=".. atk.id, "def=" .. ( def.id or "defense" ), "dule=",params.isDule, "counter=",params.isCounter, "Suppressive=",params.isSuppressive )	

	return dmg, org_rate, hit_rate, is_critical
end

function Combat_FindCounterattackWeapon( troop, params )
	if params.type == CombatTask.SHOOT then return nil end
	local weapon
	weapon = troop:GetWeaponBy( "range", WeaponRangeType.CLOSE )
	if weapon then return weapon end
	weapon = troop:GetWeaponBy( "range", WeaponRangeType.LONG )
	if weapon then return weapon end
	return nil
end