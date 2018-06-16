---------------------------------------------------
--
--
--Concept
--
--   #MORALE
--   Core data
--     leads to:
--   1. Critical Hit
--   2. Disobey
--   3. Flee
--     affect by:
--   Encourage       +
--   Rest            +
--   Kill            +
--   Defeat          +
--   Friendly Killed -
--   Friendly Fled   - 
--   Critical Hit    -
--   Attack          -
--
--   #ORGANIZATION
--   Core data, means HIT POINT
--     leads to:
--   1. Reteat
--   2. Resist Damage
--     affect by:
--   1. Rest( after combat ) 
--   2. Reform( in combat )
--
--   #EXPOSE
--   Determine the TROOP information exposed, leads to:
--   1. Resist Damage
--
--   #RETREAT
--   Conditions:
--   1. Organization == 0
--
--   #FLEE
--   Conditions:
--   1. MORALE == 0
--   2. SOLDIER / MAX_SOLDIER < ( 100 - MORALE )
--
--   #KILL
--   TROOP kill all SOLDIER of TARGET TROOP
--   1. Honor
--   
--   #DEFEAT
--   Troop hit the target, make it RETREAT
--   1. Make Organization of Target Troop to 0
--
--   #ORDER
--   Commander will give order to every troop
--
--   #DISOBEY
--   Officer of Troop can disobey the order in 
--
--   #Order
--    1. Low morale lead to disobey order
--    2. Low org and Low mor and Low Loyality lead to betray
--  
--   #Morale
--    1. Reduce when been hit( delete )
--    2. Increase when gain advantage in duel( less than 100 )
--    3. Increase when kill enemy
--    4. Reduce when been surrouded
--    5. Reduce when friendly been killed
--    6. Reduce when officer injuried or killed
--    7. 
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
	TROOP_LIST     = 113,
	OFFICER_LIST   = 114,
	ATTACKER_LIST  = 120,
	DEFENDER_LIST  = 121,

	DAY           = 200,
	END_DAY       = 201,
	TIME          = 202,
	END_TIME      = 203,
	STEPDATA      = 204,	
	RESULT        = 210,
	WINNER        = 211,

	ATK_PURPOSE   = 221,
	DEF_PURPOSE   = 222,
	PRISONER      = 223,
}

CombatAssetAttrib = 
{
	type        = AssetAttrib_SetNumber     ( { id = CombatAssetID.TYPE,            type = CombatAssetType.BASE_ATTRIB } ),
	atkstatuses = AssetAttrib_SetDict       ( { id = CombatAssetID.ATK_STATUS,      type = CombatAssetType.BASE_ATTRIB } ),
	defstatuses = AssetAttrib_SetDict       ( { id = CombatAssetID.DEF_STATUS,      type = CombatAssetType.BASE_ATTRIB } ),

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
	stepdaa     = AssetAttrib_SetPointer( { id = CombatAssetID.STEPDATA, type = CombatAssetType.STATUS_ATTRIB, default = CombatStepData[1] } ),	

	result      = AssetAttrib_SetNumber( { id = CombatAssetID.RESULT,   type = CombatAssetType.STATUS_ATTRIB, default = CombatResult.UNKNOWN } ),	
	winner      = AssetAttrib_SetNumber( { id = CombatAssetID.WINNER,   type = CombatAssetType.STATUS_ATTRIB, default = CombatSide.UNKNOWN } ),	

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

local function WriteCombatLog( ... )
	--print( ... )
	Log_Write( "combat", Log_ToString( ... ) )
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
	--WriteCombatLog( "Add troop" .. troop:ToString() )

	--initialize
	troop:JoinCombat()

	--side data
	troop:SetCombatData( TroopCombatData.SIDE, side )

	troop:SetCombatData( TroopCombatData.EXPOSURE, 0 )

	--default order
	if side == CombatSide.ATTACKER then
		troop:SetCombatData( TroopCombatData.ORDER, CombatOrder.ATTACK )
	elseif side == CombatSide.DEFENDER then
		troop:SetCombatData( TroopCombatData.ORDER, CombatOrder.DEFEND )
	end

	--vp
	local soldier = Asset_Get( troop, TroopAssetID.SOLDIER )
	local attrib = Entity_GetAssetAttrib( troop, TroopAssetID.LEVEL )
	local vp = Asset_Get( troop, TroopAssetID.LEVEL ) + attrib.max
	troop:SetCombatData( TroopCombatData.VP, vp )

	self:AddStat( side, CombatStatistic.VP, vp )
	self:AddStat( side, CombatStatistic.START_SOLDIER, soldier )
	
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
	troop:SetOfficer()

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
	self:RemoveGridTroop( troop:GetCombatData( TroopCombatData.GRID ), troop )

	--remove from atk/def list
	local assetId = nil
	if troop:GetCombatData( TroopCombatData.SIDE ) == CombatSide.ATTACKER then
		Asset_RemoveListItem( self, CombatAssetID.ATTACKER_LIST, troop )
	elseif troop:GetCombatData( TroopCombatData.SIDE ) == CombatSide.DEFENDER then
		Asset_RemoveListItem( self, CombatAssetID.DEFENDER_LIST, troop )
	end

	--when troop is neutralized, leader should go back to staff or be captured
	self:RemoveTroopOfficer( troop, nil )-- isKilled )

	--clear combat datas
	troop:LeaveCombat()

	--WriteCombatLog( "remove troop", troop:ToString() )
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
	grid.fort    = data.fort or 0
	grid.depth   = data.depth or 1000
	grid.height  = data.height or 0
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
		if troop:GetCombatData( TroopCombatData.SIDE ) == CombatSide.ATTACKER then
			Asset_SetDictItem( self, CombatAssetID.ATK_STATUS, CombatStatus.RANK_BROKEN, true )
		elseif troop:GetCombatData( TroopCombatData.SIDE ) == CombatSide.DEFENDER then
			Asset_SetDictItem( self, CombatAssetID.DEF_STATUS, CombatStatus.RANK_BROKEN, true )
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
	grid.side = troop:GetCombatData( TroopCombatData.SIDE )
	table.insert( grid.troops, troop )

	--mean ranks broken
	if troop:GetCombatData( TroopCombatData.SIDE ) == CombatSide.ATTACKER then
		Asset_SetDictItem( self, CombatAssetID.ATK_STATUS, CombatStatus.RANK_BROKEN, false )
	elseif troop:GetCombatData( TroopCombatData.SIDE ) == CombatSide.DEFENDER then
		Asset_SetDictItem( self, CombatAssetID.DEF_STATUS, CombatStatus.RANK_BROKEN, false )
	end
end

function Combat:GetFrontGrid( troop )
	local ox, oy = self:GetFaceDir( troop )
	return self:GetGrid( troop:GetCombatData( TroopCombatData.X_POS ) + ox, troop:GetCombatData( TroopCombatData.Y_POS ) + oy )
end

function Combat:GetBackGrid( troop )
	local ox, oy = self:GetFaceDir( troop )
	return self:GetGrid( troop:GetCombatData( TroopCombatData.X_POS ) + ox, troop:GetCombatData( TroopCombatData.Y_POS ) - oy )
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
	if 1 then return end
	if not self._currentField then return end

	WriteCombatLog( "Field=" .. self._currentField.name )

	local battlefield = self._currentField
	local content = "     "
	for x = 1, battlefield.width do
		content = content .. ( x < 10 and "X=" .. x .. "  " or " X=" .. x .. " " )
	end
	WriteCombatLog( content )
	for y = 1, battlefield.height do
		content = ( y < 10 and "Y= " .. y or "Y=" .. y ) .. " "
		for x = 1, battlefield.width do
			local grid = self:GetGrid( x, y )
			local numoftroop = 0
			local side = CombatSide.UNKNOWN
			for _, troop in ipairs( grid.troops ) do
				if self:IsTroopValid( troop ) then
					numoftroop = numoftroop + 1
					side = troop:GetCombatData( TroopCombatData.SIDE )
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
		WriteCombatLog( content )
	end
end

function Combat:Dump()
	self:UpdateStatistic()
	self:DumpStatistic()
end

function Combat:DumpStatistic()
	Asset_Foreach( self, CombatAssetID.TROOP_LIST, function ( troop )
		WriteCombatLog( troop:ToString( "COMBAT_ALL" ) )
	end )

	WriteCombatLog( "Type = " .. MathUtil_FindName( CombatType, Asset_Get( self, CombatAssetID.TYPE ) ) )
	WriteCombatLog( "Day  = " .. Asset_Get( self, CombatAssetID.DAY ) )

	local combat = self
	function DumpStatus( side )
		local list
		if side == CombatSide.ATTACKER then
			WriteCombatLog( "ATK Status=" )
			list = Asset_GetDict( combat, CombatAssetID.ATK_STATUS )
		elseif side == CombatSide.DEFENDER then
			WriteCombatLog( "DEF Status=" )
			list = Asset_GetDict( combat, CombatAssetID.DEF_STATUS )
		end
		if list then
			for k, v in pairs( list ) do
				WriteCombatLog( "", MathUtil_FindName( CombatStatus, k  ) .. "=", v )
			end
		end
	end
	DumpStatus( CombatSide.ATTACKER )
	DumpStatus( CombatSide.DEFENDER )

	for k, v in pairs( CombatStatistic ) do
		if self._stat[CombatSide.ALL][v] ~= nil then
			WriteCombatLog( "Tot " .. k .. "=".. self._stat[CombatSide.ALL][v] )
		end
	end
	for k, v in pairs( CombatStatistic ) do
		if self._stat[CombatSide.ATTACKER][v] ~= nil then			
			WriteCombatLog( "Att " .. k .. "=".. self._stat[CombatSide.ATTACKER][v] )
		end
		if self._stat[CombatSide.DEFENDER][v] ~= nil then
			WriteCombatLog( "Def " .. k .. "=".. self._stat[CombatSide.DEFENDER][v] )
		end
	end
	for k, v in pairs( CombatStatistic ) do
		if v >= CombatStatistic._ACCUMULATE_TYPE then
			Asset_Foreach( self, CombatAssetID.TROOP_LIST, function ( troop )
				if self._stat[troop] and self._stat[troop][v] then
					WriteCombatLog( troop:ToString( "COMBAT" ) .. " " .. " " .. k .. "=" .. self._stat[troop][v] )
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

function Combat:ClearRefStats()
	for k, v in pairs( CombatStatistic ) do
		if v >= CombatStatistic._REFERENCE_TYPE then
			for obj, list in pairs( self._stat ) do
				self._stat[obj][v] = nil
			end
		end
	end
end

function Combat:PrepareRefStats()
	Asset_Foreach( self, CombatAssetID.TROOP_LIST, function ( troop )		
		local exposure = 100 + Random_GetInt_Sync( ( troop:GetCombatData( TroopCombatData.EXPOSURE ) - 100 ) * 0.25, ( 100 - troop:GetCombatData( TroopCombatData.EXPOSURE ) ) * 0.25 )
		local soldier = Asset_Get( troop, TroopAssetID.SOLDIER )
		local troopTable = Asset_Get( troop, TroopAssetID.TABLEDATA )
		local side = troop:GetCombatData( TroopCombatData.SIDE )
		self:AddStat( side, CombatStatistic.TOTAL_SOLDIER, soldier )
		self:AddStat( side, CombatStatistic.MAX_SOLDIER, Asset_Get( troop, TroopAssetID.MAX_SOLDIER ) )
		self:AddStat( side, CombatStatistic.EXPOSURE_SOLDIER,  math.ceil( soldier * exposure * 0.01 ) * soldier )		
		self:AddStat( side, CombatStatistic.TOTAL_POWER, soldier * TroopTable_GetPower( troop ) )
		self:AddStat( side, CombatStatistic.EXPOSURE_POWER,  math.ceil( soldier * exposure * 0.01 ) * TroopTable_GetPower( troop ) )		
		self:AddStat( side, CombatStatistic.FOOD_CONSUME, soldier * troopTable.consume.FOOD )

		self:AddStat( side, CombatStatistic.MORALE, soldier * Asset_Get( troop, TroopAssetID.MORALE ) )
		self:AddStat( side, CombatStatistic.ORGANIZATION, Asset_Get( troop, TroopAssetID.ORGANIZATION ) )
	end )

	function PrepareSideStats( side )
		local id = side == CombatSide.ATTACKER and CombatAssetID.ATK_CORPS_LIST or CombatAssetID.DEF_CORPS_LIST
		Asset_Foreach( self, id, function ( corps )
			local food = Asset_Get( corps, CorpsAssetID.FOOD )
			self:AddStat( side, CombatStatistic.FOOD_HAS, food )
		end )
		local foodHas = self:GetStat( CombatSide.ATTACKER, CombatStatistic.FOOD_HAS )
		local foodConsume = self:GetStat( CombatSide.ATTACKER, CombatStatistic.FOOD_CONSUME )
		self:SetStat( side, CombatStatistic.FOOD_DAY, math.ceil( foodHas / foodConsume ) )

		local maxSoldier = self:GetStat( side, CombatStatistic.MAX_SOLDIER )
		local totalSoldier = self:GetStat( side, CombatStatistic.TOTAL_SOLDIER )
		self:SetStat( side, CombatStatistic.CASUALTY_RATIO, math.ceil( ( maxSoldier - totalSoldier ) * 100 / maxSoldier ) )

		self:SetStat( side, CombatStatistic.MORALE_RATIO, math.ceil( self:GetStat( side, CombatStatistic.MORALE ) / totalSoldier ) )
		self:SetStat( side, CombatStatistic.ORG_RATIO, math.ceil( self:GetStat( side, CombatStatistic.ORGANIZATION ) * 100 / totalSoldier ) )

		--clear 
		self:SetStat( side, CombatStatistic.MORALE )
		self:SetStat( side, CombatStatistic.ORGANIZATION )

		local oppSide = side == CombatSide.ATTACKER and CombatSide.DEFENDER or CombatSide.ATTACKER
		local oppExpSoldier = self:GetStat( oppSide, CombatStatistic.TOTAL_SOLDIER )
		self:SetStat( side, CombatStatistic.PROP_RATIO, math.ceil( totalSoldier * 100 / ( totalSoldier + oppExpSoldier ) ) )
	end
	PrepareSideStats( CombatSide.ATTACKER )
	PrepareSideStats( CombatSide.DEFENDER )
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
	if Asset_Get( self, CombatAssetID.RESULT ) ~= CombatResult.UNKNOWN then
		return true
	end

	if Asset_Get( self, CombatAssetID.DAY ) > Asset_Get( self, CombatAssetID.END_DAY ) then
		return true
	end

	if Asset_Get( self, CombatAssetID.WINNER ) ~= CombatSide.UNKNOWN then
		return true
	end

	if Asset_Get( self, CombatAssetID.TIME ) > Asset_Get( self, CombatAssetID.END_TIME ) then
		return true
	end

	return false
end

function Combat:IsSameSide( troop, target )
	return troop:GetCombatData( TroopCombatData.SIDE ) == target:GetCombatData( TroopCombatData.SIDE )
end

function Combat:IsTroopPrepared( troop )
	return troop and troop:GetCombatData( TroopCombatData.PREPARED ) ~= nil
end

function Combat:IsTroopValid( troop )
	return troop and troop:GetCombatData( TroopCombatData.ATTENDED ) ~= nil
end

function Combat:IsPrepared( troop )
	local soldier = Asset_Get( troop, TroopAssetID.SOLDIER )
	local maxsoldier = Asset_Get( troop, TroopAssetID.MAX_SOLDIER )

	local organization = Asset_Get( troop, TroopAssetID.ORGANIZATION )	

	local morale = Asset_Get( troop, TroopAssetID.MORALE )

	local soliderRatio = soldier * 100 / maxsoldier
	local orgRatio = organization * 100 / soldier

	local ret = false
	local order = troop:GetCombatData( TroopCombatData.ORDER )
	if order == CombatOrder.FORCED_ATTACK then
		ret = soliderRatio + orgRatio > 120 and soliderRatio > 55 and morale > 40
	elseif order == CombatOrder.ATTACK then
		ret = soliderRatio + orgRatio > 130 and soliderRatio > 60 and morale > 40
	elseif order == CombatOrder.DEFEND then
		ret = soliderRatio + orgRatio > 140 and soliderRatio > 65 and morale > 45
	elseif order == CombatOrder.SURVIVE then
		ret = soliderRatio + orgRatio > 150 and soliderRatio > 70 and morale > 45
	end
	--if ret == false then WriteCombatLog( troop.name .. "," .. troop.id .. " Pre=" .. ( ret == true and "Y" or "N" ) .. " side=" .. MathUtil_FindName( CombatSide, troop:GetCombatData( TroopCombatData.SIDE ) ) .. " sol=" .. soldier .. "/" .. maxsoldier .. "(" .. soliderRatio .. "%) org=" .. orgRatio ) end
	return ret
end


-----------------------------------------------------

function Combat:GetStatus( side, status )
	if side == CombatSide.ATTACKER then
		return Asset_GetDictItem( self, CombatAssetID.ATK_STATUS, status )
	elseif side == CombatSide.DEFENDER then
		return Asset_GetDictItem( self, CombatAssetID.DEF_STATUS, status )
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
	troop:SetCombatData( TroopCombatData.X_POS )
	troop:SetCombatData( TroopCombatData.Y_POS )
	troop:SetCombatData( TroopCombatData.ATTENDED, 1 )
	
	--status
	troop:SetCombatData( TroopCombatData.RETREAT )
	troop:SetCombatData( TroopCombatData.FLEE )
	troop:SetCombatData( TroopCombatData.SURROUNDED )
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
			if troop:GetCombatData( TroopCombatData.PREPARED ) then
				self:EmbattleTroop( troop )
				index = index + 1
				if index > #postlist then index = 1 end
				local posgrid = postlist[index]
				local x = posgrid.x
				local y = posgrid.y
				troop:SetCombatData( TroopCombatData.X_POS, x )
				troop:SetCombatData( TroopCombatData.Y_POS, y )
				troop:SetCombatData( TroopCombatData.FACE_DIR, faceDir )

				--add into grids				
				local grid = self:GetGrid( x, y )
				self:AddGridTroop( grid, troop )
				troop:SetCombatData( TroopCombatData.GRID, grid )

				troop:SetCombatData( TroopCombatData.EXPOSURE, math.ceil( troop:GetCombatData( TroopCombatData.EXPOSURE ) * 0.5 ) )

				--WriteCombatLog( "put", troop:GetCombatData( TroopCombatData.X_POS ), troop:GetCombatData( TroopCombatData.Y_POS ), troop:ToString( "COMBAT" ), MathUtil_FindName( CombatSide, troop:GetCombatData( TroopCombatData.SIDE ) ), Asset_Get( troop, TroopAssetID.SOLDIER ) )
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

--after been hit, check the troop, both attacker and defender in an duel
function Combat:CheckTroop( troop )
	local org = Asset_Get( troop, TroopAssetID.ORGANIZATION )	
	if not troop:GetCombatData( TroopCombatData.RETREAT ) then
		if org == 0 then
			self:DoAction( troop, CombatAction.RETREAT )			
		end
	end

	if not troop:GetCombatData( TroopCombatData.FLEE ) then
		local maxSoldier = Asset_Get( troop, TroopAssetID.MAX_SOLDIER )
		local soldier = Asset_Get( troop, TroopAssetID.SOLDIER )
		local casualty = ( maxSoldier - soldier ) * 100 / maxSoldier
		local mor = Asset_Get( troop, TroopAssetID.MORALE )	
		if mor == 0 or casualty > mor then
			self:DoAction( troop, CombatAction.FLEE )
		end
	end
end

function Combat:CheckConditions( obj, conditions )	
	local score = 0
	for _, cond in pairs( conditions ) do		
		if not cond.reason then error( "reason data checker" ) end
		local match = true
		if match == true and cond.not_siege and ( combatType == CombatType.SIEGE_COMBAT or combatType == CombatType.CAMP_COMBAT ) then match = false end
		if match == true and cond.not_field and combatType == CombatType.FIELD_COMBAT then match = false end
		if match == true and cond.is_field and ( combatType ~= CombatType.FIELD_COMBAT or combatType ~= CombatType.CAMP_COMBAT ) then match = false end
		if match == true and cond.is_siege and combatType ~= CombatType.SIEGE_COMBAT and combatType ~= CombatType.CAMP_COMBAT then match = false end			
		if match == true and cond.is_atk and side ~= CombatSide.ATTACKER then match = false end			
		if match == true and cond.is_def and side ~= CombatSide.DEFENDER then match = false end
		if match == true and cond.is_surrounded and cond.is_surrounded ~= self:GetStat( obj, CombatStatistic.SURROUNDED ) then match = false end

		if cond.is_surrounded then
			--print( "is surrounded", cond.is_surrounded, self:GetStat( obj, CombatStatistic.SURROUNDED ), match )
			--pprint( String_ToStr( obj, "name" ), self:GetStat( obj, CombatStatistic.ORG_RATIO ), cond.org_below)
		end

		if match == true and cond.prop_above and self:GetStat( obj, CombatStatistic.PROP_RATIO ) < cond.prop_above then match = false end
		if match == true and cond.prop_below and self:GetStat( obj, CombatStatistic.PROP_RATIO ) > cond.prop_below then match = false end

		if match == true and cond.casualty_above and self:GetStat( obj, CombatStatistic.CASUALTY_RATIO ) < cond.casualty_above then match = false end
		if match == true and cond.casualty_below and self:GetStat( obj, CombatStatistic.CASUALTY_RATIO ) > cond.casualty_below then match = false end
		
		if match == true and cond.org_above and self:GetStat( obj, CombatStatistic.ORG_RATIO ) < cond.org_above then match = false end
		if match == true and cond.org_below and self:GetStat( obj, CombatStatistic.ORG_RATIO ) > cond.org_below then match = false end

		if cond.org_below then
			--pprint( String_ToStr( obj, "name" ), self:GetStat( obj, CombatStatistic.ORG_RATIO ), cond.org_below)
		end

		if match == true and cond.mor_above and self:GetStat( obj, CombatStatistic.MORALE_RATIO ) < cond.mor_above then match = false end
		if match == true and cond.mor_below and self:GetStat( obj, CombatStatistic.MORALE_RATIO ) > cond.mor_below then match = false end

		if match == true and cond.prepare_above and self:GetStat( obj, CombatStatistic.PREPARE_RATIO ) < cond.prepare_above then match = false end
		if match == true and cond.prepare_below and self:GetStat( obj, CombatStatistic.PREPARE_RATIO ) > cond.prepare_below then match = false end

		if FeatureOption.DISABLE_FOOD_SUPPLY then
		elseif match == true then
		 	if cond.food_above and self:GetStat( obj, CombatStatistic.FOOD_DAY ) < cond.food_above then match = false end
		 	if cond.food_below and self:GetStat( obj, CombatStatistic.FOOD_DAY ) > cond.food_below then match = false end
		end

		if match == true and cond.prob and Random_GetInt_Sync( 1, 100 ) > cond.prob then match = false end
		if match == true and cond.score then match = false score = score + cond.score end
		if match == true or score > 100 then
			WriteCombatLog( "reason=" .. cond.reason )
			--InputUtil_Pause( "reason=" .. ( cond.reason or "none" ), score, cond.prob, match )
			--Stat_Add( "Withdraw@Reason", self:ToString() .. " " .. MathUtil_FindName( CombatSide, side ) .. " " .. ( cond.reason or "" ) .. " " .. self:ToString(), StatType.LIST )
			return true
		end
	end
	return false
end

function Combat:Prepare()
	local combatType = Asset_Get( self, CombatAssetID.TYPE )

	self:ClearRefStats()

	self:PrepareRefStats()

	local atkPurpose = Asset_Get( self, CombatAssetID.ATK_PURPOSE )
	local defPurpose = Asset_Get( self, CombatAssetID.DEF_PURPOSE )	

--[[
	for k, v in pairs( CombatStatistic ) do
		if v > CombatStatistic._RATIO_TYPE then
			if self._stat[CombatSide.ATTACKER][v] ~= nil then			
				print( "Att " .. k .. "=".. self._stat[CombatSide.ATTACKER][v] )
			end
			if self._stat[CombatSide.DEFENDER][v] ~= nil then
				print( "Def " .. k .. "=".. self._stat[CombatSide.DEFENDER][v] )
			end
		end
	end
	]]

	--1st check surrender	
	if self:CheckConditions( CombatSide.ATTACKER, CombatPurposeParam[atkPurpose].SURRENDER ) == true then
		InputUtil_Pause( "surrender")
		return CombatPrepareResult.ATK_SURRENDER
	end
	if self:CheckConditions( CombatSide.DEFENDER, CombatPurposeParam[defPurpose].SURRENDER ) == true then
		InputUtil_Pause( "surrender")
		return CombatPrepareResult.DEF_SURRENDER
	end

	--2nd check withdraw
	local atkWithdraw, defWithdraw = false, false
	if self:CheckConditions( CombatSide.ATTACKER, CombatPurposeParam[atkPurpose].WITHDRAW ) == true then
		atkWithdraw = true
	end
	if self:CheckConditions( CombatSide.DEFENDER, CombatPurposeParam[defPurpose].WITHDRAW ) == true then
		defWithdraw = true
	end
	if atkWithdraw and defWithdraw then
		InputUtil_Pause( "both withdraw" )
		Asset_Set( self, CombatAssetID.RESULT, CombatResult.DRAW )
		return CombatPrepareResult.BOTH_DECLINED
	elseif atkWithdraw then
		InputUtil_Pause( "atk withdraw")
		Asset_Set( self, CombatAssetID.RESULT, CombatResult.STRATEGIC_LOSE )
		return CombatPrepareResult.BOTH_DECLINED
	elseif defWithdraw then
		InputUtil_Pause( "def withdraw")
		Asset_Set( self, CombatAssetID.RESULT, CombatResult.STRATEGIC_VICTORY )		 
		return CombatPrepareResult.BOTH_DECLINED
	end

	--3rd check rest	
	Asset_Foreach( self, CombatAssetID.TROOP_LIST, function ( troop )
		local side = troop:GetCombatData( TroopCombatData.SIDE )
		local purpose = side == CombatSide.ATTACKER and atkPurpose or defPurpose
		local withdraw = side == CombatSide.ATTACKER and atkWithdraw or defWithdraw

		--prepare troop stats
		local soldier = Asset_Get( troop, TroopAssetID.SOLDIER ) 
		self:AddStat( troop, CombatStatistic.ORG_RATIO, math.ceil( Asset_Get( troop, TroopAssetID.ORGANIZATION ) * 100 / soldier ) )
		self:AddStat( troop, CombatStatistic.MORALE_RATIO, Asset_Get( troop, TroopAssetID.MORALE ) )
		
		--checker
		if withdraw == true or self:CheckConditions( troop, CombatPurposeParam[purpose].REST ) == true then
			troop:SetCombatData( TroopCombatData.PREPARED )
		else
			troop:SetCombatData( TroopCombatData.PREPARED, 1 )
			self:AddStat( side, CombatStatistic.PREPARE_SOLDIER, soldier )
		end
	end )

	function PrepareStat( side )
		local prepSoldier, totalSoldier
		prepSoldier  = self:GetStat( side, CombatStatistic.PREPARE_SOLDIER )
		totalSoldier = self:GetStat( side, CombatStatistic.TOTAL_SOLDIER )
		self:SetStat( side, CombatStatistic.PREPARE_RATIO, math.ceil( prepSoldier * 100 / totalSoldier ) )
	end
	PrepareStat( CombatSide.ATTACKER )
	PrepareStat( CombatSide.DEFENDER )

	--4th check attack
	local atkAttend = self:CheckConditions( CombatSide.ATTACKER, CombatPurposeParam[atkPurpose].ATTEND )
	local defAttend = self:CheckConditions( CombatSide.DEFENDER, CombatPurposeParam[defPurpose].ATTEND )	
	if atkAttend and defAttend then
		return CombatPrepareResult.BOTH_ACCEPTED		
	elseif atkAttend == defAttend then
		--both sides decide to rest
		WriteCombatLog( "both declined", atkAttend, defAttend, MathUtil_FindName( CombatResult, Asset_Get( self, CombatAssetID.RESULT ) ) )
		return CombatPrepareResult.BOTH_DECLINED
	end
	if not atkAttend then
		if self:CheckConditions( CombatSide.DEFENDER, CombatPurposeParam[defPurpose].STORM ) == true then
			--force attack
			return CombatPrepareResult.DEF_ACCEPTED
		end		
	elseif not defAttend then
		if self:CheckConditions( CombatSide.ATTACKER, CombatPurposeParam[atkPurpose].STORM ) == true then
			return CombatPrepareResult.ATK_ACCEPTED
		end
	end
	--have a rest
	return CombatPrepareResult.BOTH_DECLINED
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
		troop:SetCombatData( TroopCombatData.PREPARED, 1 )
		self:AddTroop( troop, CombatSide.DEFENDER )
		--InputUtil_Pause( "add guard", troop:ToString( "COMBAT" ), numpertroop )
	end
end

function Combat:PrepareSide( side )
	Asset_Foreach( self, CombatAssetID.TROOP_LIST, function ( troop )
		if troop:GetCombatData( TroopCombatData.SIDE ) == side then
			troop:SetCombatData( TroopCombatData.PREPARED, 1 )
		end
	end )
end

--Return true means continue next step, return false not
function Combat:NextStep( step )
	--WriteCombatLog( "step=" .. MathUtil_FindName( CombatStepType, step ) )

	if step == CombatStepType.REST then
		if Asset_Get( self, CombatAssetID.DAY ) > 0 then
			self:Rest()
		end

	elseif step == CombatStepType.PREPARE then
		--pass a day
		Asset_Plus( self, CombatAssetID.DAY, 1 )
		--reset states
		Asset_Set( self, CombatAssetID.RESULT, CombatResult.UNKNOWN )				
		--if self:CheckStatus() == false then return false end
		
		--check preparation
		local result = self:Prepare()

		if result == CombatPrepareResult.ATK_SURRENDER then
			--to do
			--make all to be prisoner
			error( "to do")
			return false

		elseif result == CombatPrepareResult.DEF_SURRENDER then
			--to do
			--make all to be prisoner
			error( "to do")
			return false

		elseif result == CombatPrepareResult.BOTH_DECLINED then
			if Asset_Get( self, CombatAssetID.RESULT ) == CombatResult.DRAW then
				Stat_Add( "Combat@BothWithdraw", 1, StatType.TIMES )
			elseif Asset_Get( self, CombatAssetID.RESULT ) ~= CombatResult.UNKNOWN then				
				Stat_Add( "Combat@OneWithdraw", 1, StatType.TIMES )
			else
				self:AddStat( CombatSide.ALL, CombatStatistic.REST_DAY, 1 )
				Stat_Add( "Combat@Rest", 1, StatType.TIMES )
				self:NextStep( CombatStepType.REST )
			end
			return false

		elseif result == CombatPrepareResult.BOTH_ACCEPTED then
			if Asset_Get( self, CombatAssetID.TYPE ) == CombatType.SIEGE_COMBAT then
			else
				Asset_Set( self, CombatAssetID.TYPE, CombatType.FIELD_COMBAT )
			end
			self._currentField = Asset_Get( self, CombatAssetID.BATTLEFIELD )
			self:AddStat( CombatSide.ALL, CombatStatistic.COMBAT_DAY, 1 )

		elseif result == CombatPrepareResult.ATK_ACCEPTED then
			if Asset_Get( self, CombatAssetID.TYPE ) == CombatType.SIEGE_COMBAT then
				self._currentField = Asset_Get( self, CombatAssetID.BATTLEFIELD )
				self:AddStat( CombatSide.ALL, CombatStatistic.STORM_DAY, 1 )
			else
				Asset_Set( self, CombatAssetID.TYPE, CombatType.CAMP_COMBAT )
				self._currentField = Asset_Get( self, CombatAssetID.DEFCAMPFIELD )
				self:AddStat( CombatSide.ALL, CombatStatistic.STORM_DAY, 1 )
			end

		elseif result == CombatPrepareResult.DEF_ACCEPTED then
			if Asset_Get( self, CombatAssetID.TYPE ) == CombatType.SIEGE_COMBAT then
				Stat_Add( "Siege@AtkWithdraw", 1, StatType.TIMES )
				return false
			else
				Asset_Set( self, CombatAssetID.TYPE, CombatType.CAMP_COMBAT )
				self._currentField = Asset_Get( self, CombatAssetID.ATKCAMPFIELD )
				self:AddStat( CombatSide.ALL, CombatStatistic.STORM_DAY, 1 )
			end
		end

		--InputUtil_Pause( "start combat", MathUtil_FindName( CombatPrepareResult, result ) )

		self:PrepareSide( CombatSide.DEFENDER )
		self:PrepareSide( CombatSide.ATTACKER )

		CombatAI_SetEnviroment( CombatAIEnviroment.COMBAT_INSTANCE, self )

		print( MathUtil_FindName( CombatPrepareResult, result ))

	elseif step == CombatStepType.EMBATTLE then
		self:Embattle()
		self:PrepareDefense()		

	elseif step == CombatStepType.ORDER then
		self:Order()

	elseif step == CombatStepType.INCOMBAT then
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

	local stepData = Asset_Get( self, CombatAssetID.STEPDATA )
	--use default now
	if not stepData then stepData = CombatStepData[1] end

	local stepIndex = 1
	local step = stepData[stepIndex]
	while step and self:NextStep( step ) do
		stepIndex = stepIndex + 1
		step = stepData[stepIndex]
		--InputUtil_Pause( "step=",MathUtil_FindName( CombatStepType, step ), stepIndex, #stepDatas )
	end

	--[[
	if step == CombatStepType.PREPARE then
		local atkPower = self:GetStat( CombatSide.ATTACKER, CombatStatistic.TOTAL_POWER )
		local defPower = self:GetStat( CombatSide.DEFENDER, CombatStatistic.TOTAL_POWER )
		local atkSoldier = self:GetStat( CombatSide.ATTACKER, CombatStatistic.TOTAL_SOLDIER )
		local defSoldier = self:GetStat( CombatSide.DEFENDER, CombatStatistic.TOTAL_SOLDIER )
		local atkIntense = self:GetStat( CombatSide.ATTACKER, CombatStatistic.COMBAT_INTENSE )
		local defIntense = self:GetStat( CombatSide.DEFENDER, CombatStatistic.COMBAT_INTENSE )
		local atk = atkIntense
		local def = defIntense
		WriteCombatLog( "combat prepared failed", atk, def, self:ToString() )		
	end
	--]]

	--Feedback
	self:Feedback()

	--Dump for debug
	--self:Dump()

	--InputUtil_Pause( "day end=" .. Asset_Get( self, CombatAssetID.DAY ), "winner=" .. Asset_Get( self, CombatAssetID.WINNER ) )

	--Stat_Add( "Combat" .. self.id .. "@DAY", 1, StatType.TIMES )
end

--no combat
function Combat:Rest()
	Asset_Foreach( self, CombatAssetID.TROOP_LIST, function ( troop )
		self:Reform( troop )
		self:Encourage( troop )
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
				Asset_SetDictItem( city, CityAssetID.DEFENSES, grid.x, grid.defense )
				WriteCombatLog( "DEFENSE-" .. grid.x .. "=" .. grid.defense )
			end
		end
	end
end

function Combat:UpdateRound()
	--Timer go on
	Asset_Plus( self, CombatAssetID.TIME, 1 )
	WriteCombatLog( "#Day=" .. Asset_Get( self, CombatAssetID.DAY ) .. " Time=" .. Asset_Get( self, CombatAssetID.TIME ) .. "/" .. Asset_Get( self, CombatAssetID.END_TIME ) )
	self:DrawBattlefield()
end

function Combat:IsAttend( side )
	local attend = false
	local list = side == CombatSide.ATTACKER and CombatAssetID.ATTACKER_LIST or CombatAssetID.DEFENDER_LIST
	Asset_Foreach( self, list, function( troop )
		if troop:GetCombatData( TroopCombatData.ATTENDED ) then
			attend = true
		end
	end )
	if attend == false then
		Asset_Set( self, CombatAssetID.WINNER, side == CombatSide.ATTACKER and CombatSide.DEFENDER or CombatSide.ATTACKER )
	end
	return attend
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

	if self:IsAttend( CombatSide.ATTACKER ) == false or self:IsAttend( CombatSide.DEFENDER ) == false then
		--InputUtil_Pause( "winner attend=" .. Asset_Get( self, CombatAssetID.WINNER ) )
		return
	end

	local atkvp = self._stat[CombatSide.ATTACKER]["GAIN_VP"] or 0
	local defvp = self._stat[CombatSide.DEFENDER]["GAIN_VP"] or 0
	local vp = math.abs( atkvp - defvp )
	local totalvp = self:GetStat( CombatSide.ATTACKER, CombatStatistic.VP ) + self:GetStat( CombatSide.DEFENDER, CombatStatistic.VP ) 
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

	--InputUtil_Pause("update")
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
		if v >= CombatStatistic._UPDATE_TYPE and v < CombatStatistic._REFERENCE_TYPE then
			--update everytime
			self._stat[CombatSide.ALL][v] = 0
			self._stat[CombatSide.ATTACKER][v] = 0
			self._stat[CombatSide.DEFENDER][v] = 0
		end
	end
	
	Asset_Foreach( self, CombatAssetID.TROOP_LIST, function( troop )
		local soldier = Asset_Get( troop, TroopAssetID.SOLDIER )
		self:AddStat( troop:GetCombatData( TroopCombatData.SIDE ), CombatStatistic.SOLDIER, soldier )
	end )
end

function Combat:UpdateStatus( list )
	local isAtkFlee, isDefFlee = true, true
	for _, troop in ipairs( list ) do
		if self:IsTroopValid( troop ) then
			--reset flags
			troop:SetCombatData( TroopCombatData.TARGET )
			troop:SetCombatData( TroopCombatData.ATTACKED )
			troop:SetCombatData( TroopCombatData.DEFENDED )
			troop:SetCombatData( TroopCombatData.MOVED )

			if troop:GetCombatData( TroopCombatData.SURROUNDED ) == true then
				if self:FindNearbyFriendly( troop ) == nil then
					self:Surrounded( troop )
				else
					troop:SetCombatData( TroopCombatData.SURROUNDED )
				end
			end

			CombatAI_CheckTroopStatus( troop )

			if troop:GetCombatData( TroopCombatData.FLEE ) == true then
				if troop:GetCombatData( TroopCombatData.SIDE ) == CombatSide.ATTACKER then
					isAtkFlee = false
				elseif troop:GetCombatData( TroopCombatData.SIDE ) == CombatSide.DEFENDER then
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
		elseif task.type == CombatTask.DESTROY then
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
			self:Attack( task.troop, task.target, { type = task.type, weapon = task.weapon } )
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
	if not dest:GetCombatData( TroopCombatData.X_POS ) then
		MathUtil_Dump( dest )
	end
	if not sour:GetCombatData( TroopCombatData.X_POS ) then
		--MathUtil_Dump( sour )
	end
	return math.abs( sour:GetCombatData( TroopCombatData.X_POS ) - dest:GetCombatData( TroopCombatData.X_POS ) ) + math.abs( sour:GetCombatData( TroopCombatData.Y_POS ) - dest:GetCombatData( TroopCombatData.Y_POS ) )
end

function Combat:CalcDistance2( x1, y1, x2, y2 )
	--print( NIDString( sour ), NIDString( dest ) )
	return math.abs( x1 - x2 ) + math.abs( y1 - y2 )
end

function Combat:GetFaceDir( troop )
	return troop:GetCombatData( TroopCombatData.FACE_DIR )[2], troop:GetCombatData( TroopCombatData.FACE_DIR )[3]
end

function Combat:FindContactGrid( troop )
	local oppSide = self:GetOppSide( troop:GetCombatData( TroopCombatData.SIDE ) )
	local findGrid = nil
	local findDistance = 0
	for _, grid in pairs( self._grids ) do
		if grid.side == troop:GetCombatData( TroopCombatData.SIDE ) then
			for _, of in ipairs( _positionOffsets ) do
				local nextGrid = self:GetGrid( grid.x + of.x, grid.y + of.y )
				if nextGrid and nextGrid.side == oppSide then
					local distance = self:CalcDistance2( grid.x, grid.y, troop:GetCombatData( TroopCombatData.X_POS ), troop:GetCombatData( TroopCombatData.Y_POS ) )
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
	local x, y = troop:GetCombatData( TroopCombatData.X_POS ), troop:GetCombatData( TroopCombatData.Y_POS )
	local ox, oy = self:GetFaceDir( troop )
	while x > 0 and x <= self._currentField.width and y > 0 and y <= self._currentField.height do
		x = x + ox
		y = y + oy
		return self:FindGridTarget( self:GetGrid( x, y ), troop:GetCombatData( TroopCombatData.SIDE ) )
	end
	return nil
end

function Combat:FindBackTarget( troop )
	local x, y = troop:GetCombatData( TroopCombatData.X_POS ), troop:GetCombatData( TroopCombatData.Y_POS )
	local ox, oy = self:GetFaceDir( troop )
	while x > 0 and x <= self._currentField.width and y > 0 and y <= self._currentField.height do
		x = x + ox
		y = y + oy
		return self:FindGridTarget( self:GetGrid( x, y ), troop:GetCombatData( TroopCombatData.SIDE ) )
	end
	return nil
end

-- Use BFS to find the closest target filter by given fn
-- fn returns 1 means find target, returns 0 means not target, returns -1 means blocked
function Combat:FindBfsTarget( troop, fn )
	--WriteCombatLog( "current=", troop.name, troop:GetCombatData( TroopCombatData.X_POS ), troop:GetCombatData( TroopCombatData.Y_POS ) )
	local openList   = { { x = troop:GetCombatData( TroopCombatData.X_POS ), y = troop:GetCombatData( TroopCombatData.Y_POS ), distance = 0 } }
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
							--WriteCombatLog( "add", tx, ty, index, offset.x, offset.y, closeList[index] )
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
		local grid = self:GetGrid( troop:GetCombatData( TroopCombatData.X_POS ) + of.x, troop:GetCombatData( TroopCombatData.Y_POS ) + of.y )
		local target = self:FindGridTarget( grid, troop:GetCombatData( TroopCombatData.SIDE ) )		
		if target and self:IsTroopValid( target ) then
			--InputUtil_Pause( "find nearest target", troop:ToString( "COMBAT" ), troop:GetCombatData( TroopCombatData.X_POS ), troop:GetCombatData( TroopCombatData.Y_POS ), grid.x, grid.y )
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
			return self:FindGrid( self:GetGrid( x, y ), troop:GetCombatData( TroopCombatData.SIDE ) )
		end
	end

	local xDelta, yDelta = self:GetFaceDir( troop )
	local x, y = troop:GetCombatData( TroopCombatData.X_POS ), troop:GetCombatData( TroopCombatData.Y_POS )
	local findTar
	if xDelta == 0 then
		findTar = FindTarget( troop:GetCombatData( TroopCombatData.X_POS ), troop:GetCombatData( TroopCombatData.Y_POS ), 0, yDelta )
		if findTar then return findTar end
		findTar = FindTarget( troop:GetCombatData( TroopCombatData.X_POS ), troop:GetCombatData( TroopCombatData.Y_POS ), 0, -yDelta )
		if findTar then return findTar end	
	else
		findTar = FindTarget( troop:GetCombatData( TroopCombatData.X_POS ), troop:GetCombatData( TroopCombatData.Y_POS ), xDelta, 0 )
		if findTar then return findTar end
		findTar = FindTarget( troop:GetCombatData( TroopCombatData.X_POS ), troop:GetCombatData( TroopCombatData.Y_POS ), -xDelta, 0 )
		if findTar then return findTar end
	end
	return nil
end

function Combat:FindNearestTarget( troop )
	local list
	if troop:GetCombatData( TroopCombatData.SIDE ) == CombatSide.ATTACKER then
		list = Asset_Get( self, CombatAssetID.DEFENDER_LIST )
	elseif troop:GetCombatData( TroopCombatData.SIDE ) == CombatSide.DEFENDER then
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
	local x, y = troop:GetCombatData( TroopCombatData.X_POS ), troop:GetCombatData( TroopCombatData.Y_POS )
	local oppSide = self:GetOppSide( troop )
	local battlefield = self._currentField
	while y > 0 and y <= battlefield.height and x > 0 and x <= battlefield.width do
		x = x + ox
		y = y + oy		
		local grid = self:GetGrid( x, y )		
		if grid and grid.side ~= troop:GetCombatData( TroopCombatData.SIDE ) then
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
		local grid = self:GetGrid( troop:GetCombatData( TroopCombatData.X_POS ) + of.x, troop:GetCombatData( TroopCombatData.Y_POS ) + of.y )
		local tar = self:FindGridTarget( grid, self:GetOppSide( troop:GetCombatData( TroopCombatData.SIDE ) ) )
		if tar then return tar end
	end
	return nil
end

function Combat:FindCounterattackWeapon( troop, params )
	if params.type == CombatTask.SHOOT then return nil end
	local weapon
	weapon = troop:GetWeaponBy( "range", WeaponRangeType.CLOSE )
	if weapon then return weapon end
	weapon = troop:GetWeaponBy( "range", WeaponRangeType.LONG )
	if weapon then return weapon end
	return nil
end

-----------------------------------------

function Combat:DoAction( troop, action, target )
	if action == CombatAction.MOVE then
	
	elseif action == CombatAction.ATTACK then
		self:InfluenceMorale( troop, -Random_GetInt_Sync( 3, 6 ) )
	
	elseif action == CombatAction.DEFEND then
		self:InfluenceMorale( troop, -Random_GetInt_Sync( 4, 5 ) )

	elseif action == CombatAction.KILL then
		local morale = math.max( 10, math.ceil( 25 + ( Asset_Get( target, TroopAssetID.LEVEL ) - Asset_Get( troop, TroopAssetID.LEVEL ) ) * 0.5 ) )
		self:InfluenceMorale( troop, morale )
	
	elseif action == CombatAction.BEAT then
		self:InfluenceMorale( troop, math.ceil( 5 + Asset_Get( troop, TroopAssetID.LEVEL ) ) )

	elseif action == CombatAction.RETREAT then
		WriteCombatLog( "RETREAT=" .. troop:ToString( "COMBAT_ALL" ) )
		troop:SetCombatData( TroopCombatData.RETREAT, 1 )
		self:InfluenceMorale( troop, math.ceil( Asset_Get( troop, TroopAssetID.LEVEL ) - 20 ) )

	elseif action == CombatAction.FLEE then
		troop:SetCombatData( TroopCombatData.FLEE, 1 )
		self:InfluenceFriendlyMorale( troop:GetCombatData( TroopCombatData.SIDE ), troop )		
		WriteCombatLog( "FLEE=" .. troop:ToString( "COMBAT_ALL" ) )

	elseif action == CombatAction.BEEN_CRT_HIT then
		local atklv = Asset_Get( target, TroopAssetID.LEVEL )
		local deflv = Asset_Get( troop, TroopAssetID.LEVEL )
		local morale = math.max( 4, math.ceil( 10 + ( atklv - deflv ) * 0.5 ) )
		self:InfluenceMorale( troop, -morale )

	elseif action == CombatAction.BEEN_FLANK_HIT then
		local morale = math.max( 4, math.ceil( 5 + ( atklv - deflv ) * 0.35 ) )
		self:InfluenceMorale( troop, -morale )

	elseif action == CombatAction.BEEN_KILLED then
		self:InfluenceFriendlyMorale( troop:GetCombatData( TroopCombatData.SIDE ) )

	elseif action == CombatAction.FRIENDLY_RETREAT then
	elseif action == CombatAction.FRIENDLY_KILLED then
	elseif action == CombatAction.FRIENDLY_FLED then
	
	elseif action == CombatAction.DEFENCE_DESTOYED then
		if Asset_Get( self, CombatAssetID.TYPE ) == CombatType.SIEGE_COMBAT then
			self:InfluenceFriendlyMorale( def.side )
		end

	end

	WriteCombatLog( troop:ToString(), "act=" .. MathUtil_FindName( CombatAction, action ), String_ToStr( target, "name" ) )
end

function Combat:InfluenceOrg( troop, delta )
	if delta == 0 then return end
	local maxOrg = troop:GetMaxOrg()
	local org = Asset_Get( troop, TroopAssetID.ORGANIZATION )	
	org = math.max( 0, math.min( maxOrg, math.ceil( org + delta ) ) )
	Asset_Set( troop, TroopAssetID.ORGANIZATION, org )
end

function Combat:InfluenceMorale( troop, delta )
	if delta == 0 then return end
	local maxMorale = troop:GetMaxMorale()
	local morale = Asset_Get( troop, TroopAssetID.MORALE )
	morale = math.max( 0, math.min( maxMorale, math.ceil( morale + delta ) ) )
	Asset_Set( troop, TroopAssetID.MORALE, morale )
	WriteCombatLog( troop.name, "mor_delta=" .. morale .. ( delta > 0 and "+" .. delta or delta ) )
end

function Combat:InfluenceFriendlyMorale( side, troop, increase )
	local list
	if side == CombatSide.ATTACKER then
		list = Asset_GetList( self, CombatAssetID.ATTACKER_LIST )
	elseif side == CombatSide.DEFENDER then
		list = Asset_GetList( self, CombatAssetID.DEFENDER_LIST )
	end	
	if not list then return end

	local lv = troop and Asset_Get( troop, TroopAssetID.LEVEL ) or 1
	for _, tar in ipairs( list ) do
		if tar ~= troop and self:IsTroopValid( tar ) then
			local tarLv = Asset_Get( tar, TroopAssetID.LEVEL )
			local morale = math.max( 0, math.ceil( 10 + ( lv - tarLv ) * 0.5 ) )
			self:InfluenceMorale( tar, morale * ( increase and 1 or -1 ) )
		end
	end
end

function Combat:InfluenceFriendlyOrg( side, troop, increase )
	local list
	if side == CombatSide.ATTACKER then
		list = Asset_GetList( self, CombatAssetID.ATTACKER_LIST )
	elseif side == CombatSide.DEFENDER then
		list = Asset_GetList( self, CombatAssetID.DEFENDER_LIST )
	end

	local lv = troop and Asset_Get( troop, TroopAssetID.LEVEL ) or 1
	for _, tar in ipairs( list ) do
		if tar ~= troop and self:IsTroopValid( tar ) then
			local tarLv = Asset_Get( tar, TroopAssetID.LEVEL )
			local org = tar:GetMaxOrg() * math.max( 0, 10 + ( lv - tarLv ) * 0.5 )
			self:InfluenceOrg( tar, -org )
		end
	end
end

-----------------------------------------
-- Troop Action

function Combat:Encourage( troop )
	--restore morale
	local level = Asset_Get( troop, TroopAssetID.LEVEL )
	local morale = math.ceil( 5 + level + level )
	self:InfluenceMorale( troop, morale )
	self:AddStat( troop:GetCombatData( TroopCombatData.SIDE ), CombatStatistic.RESTORE_MORALE, morale )
	--InputUtil_Pause( "encourage mor=", morale )
end

function Combat:Reform( troop )
	--restore organization
	local level = Asset_Get( troop, TroopAssetID.LEVEL )
	local maxOrg = troop:GetMaxOrg()
	local restore = maxOrg * ( level + 10 ) * 0.01
	self:InfluenceOrg( troop, restore )
	self:AddStat( troop:GetCombatData( TroopCombatData.SIDE ), CombatStatistic.RESTORE_ORG, org )
end

function Combat:Defend( troop )
end

function Combat:Surrounded( troop )
	local level = Asset_Get( troop, TroopAssetID.LEVEL )
	local morale = math.ceil( 15 - level )
	self:InfluenceMorale( troop, morale )
	self:AddStat( troop:GetCombatData( TroopCombatData.SIDE ), CombatStatistic.LOSE_MORALE, morale )
	InputUtil_Pause( "surrounded mor=", morale )
end

function Combat:Kill( attacker, defender )
	WriteCombatLog( attacker:ToString( "COMBAT" ) .. " kill " .. defender:ToString( "COMBAT" ) )
		
	self:DoAction( defender, CombatAction.BEEN_KILLED )

	self:DoAction( attacker, CombatAction.KILL, defender )

	--remove from battlefield
	self:RemoveTroop( defender, true )
	--remove data
	Troop_Remove( defender )
end

function Combat:DealDamage( attacker, defender, params )
	local dmg = params.dmg
	if not dmg then return end	

	local atklv = Asset_Get( attacker, TroopAssetID.LEVEL )
	local deflv = Asset_Get( defender, TroopAssetID.LEVEL )

	--Expose attacker
	attacker:SetCombatData( TroopCombatData.EXPOSURE, math.min( 100, ( attacker:GetCombatData( TroopCombatData.EXPOSURE ) or 0 ) + Random_GetInt_Sync( 5, 15 ) ) )
	defender:SetCombatData( TroopCombatData.EXPOSURE, math.min( 100, ( defender:GetCombatData( TroopCombatData.EXPOSURE ) or 0 ) + Random_GetInt_Sync( 5, 15 ) ) )

	if not params.isCounter then
		attacker:SetCombatData( TroopCombatData.ATTACKED )
		defender:SetCombatData( TroopCombatData.DEFENDED )

		self:DoAction( attacker, CombatAction.ATTACK )
		self:DoAction( defender, CombatAction.DEFEND )

		if params.isCritical then
			self:DoAction( defender, CombatAction.BEEN_CRT_HIT, attacker )
		end
		if params.isFLank then
			self:DoAction( defender, CombatAction.BEEN_FLANK_HIT, attacker )
		end

		self:AddStat( attacker:GetCombatData( TroopCombatData.SIDE ), CombatStatistic.ATTACK, 1 )
	end	

	--self:AddStat( attacker, CombatStatistic.DAMAGE, dmg )
	--self:AddStat( attacker:GetCombatData( TroopCombatData.SIDE ), CombatStatistic.DAMAGE, dmg )

	--Reduce organization
	local organization = Asset_Get( defender, TroopAssetID.ORGANIZATION )
	local reduceOrg = math.min( 0, -math.floor( dmg * params.orgRate ) )
	self:InfluenceOrg( defender, reduceOrg )

	--Kill soldier
	local defNumber = Asset_Get( defender, TroopAssetID.SOLDIER )
	local hitRate = math.min( 0.5, params.hitRate * defNumber / ( defNumber + organization ) )	
	local kill = math.ceil( dmg * hitRate )

	if defNumber <= kill then
		--WriteCombatLog( attacker:ToString( "COMBAT" ), MathUtil_FindName( CombatTask, type ).. defender:ToString( "COMBAT" ), " dmg=".. dmg, " kill="..kill, " left=", defNumber - kill, " org=".. organization )
		self:AddStat( attacker:GetCombatData( TroopCombatData.SIDE ), CombatStatistic.GAIN_VP, defNumber * ( defender:GetCombatData( TroopCombatData.VP ) or 0 ) )
		self:AddStat( defender:GetCombatData( TroopCombatData.SIDE ), CombatStatistic.DEAD, defNumber )	
		self:AddStat( attacker:GetCombatData( TroopCombatData.SIDE ), CombatStatistic.KILL, defNumber )
		self:AddStat( attacker            , CombatStatistic.KILL, defNumber )		
		self:Kill( attacker, defender )
		return
	end
	
	--Count soldier
	Asset_Set( defender, TroopAssetID.SOLDIER, defNumber - kill )

	--test, kill king or leader
	--[[
	local officer = Asset_Get( defender, TroopAssetID.OFFICER )
	if officer then
		if officer:IsGroupLeader() then
			self:RemoveTroopOfficer( defender )
		end
	end
	]]

	-----------------------------------------
	--Check status, whether should retreat or flee
	self:CheckTroop( defender )
	if defender:GetCombatData( CombatStatistic.RETREAT ) then
		self:DoAction( attacker, CombatAction.BEAT )
	end

	-----------------------------------------
	-- Damage( Kill ) Statistic	
	local atkcorps = Asset_Get( attacker, TroopAssetID.CORPS )
	local defcorps = Asset_Get( defender, TroopAssetID.CORPS )
	Stat_Add( "KILL@" .. self:GetTroopGroupName( attacker ), kill, StatType.ACCUMULATION )	
	Stat_Add( "DIE@" .. self:GetTroopGroupName( defender ), kill, StatType.ACCUMULATION )		
	Stat_Add( "Combat@Kill", kill, StatType.ACCUMULATION )
	--Stat_Add( "Combat@" .. self.id .. "_KILL", kill, StatType.ACCUMULATION )
	--Stat_Add( "DIE@" .. atkcorps.name,  kill, StatType.ACCUMULATION )
	--Stat_Add( "KILL@" .. defcorps.name, kill, StatType.ACCUMULATION )	
	self:AddStat( attacker:GetCombatData( TroopCombatData.SIDE ), CombatStatistic.GAIN_VP, kill * ( defender:GetCombatData( TroopCombatData.VP ) or 0 ) )
	-----------------------------------------

	--statistic
	self:AddStat( defender:GetCombatData( TroopCombatData.SIDE ), CombatStatistic.DEAD, kill )
	self:AddStat( attacker:GetCombatData( TroopCombatData.SIDE ), CombatStatistic.KILL, kill )
	self:AddStat( attacker, CombatStatistic.KILL, kill )

	WriteCombatLog( attacker:ToString( "COMBAT" ), MathUtil_FindName( CombatTask, params.type ), defender:ToString( "COMBAT" ), " dmg=".. dmg, " kill="..kill, " left=", defNumber - kill, " org=".. organization )
end

function Combat:DestroyDefense( atk, def, params )
	params.prot = def.prot
	local dmg, orgRate, hitRate, isCritical = self:CalcDamage( atk, def, params )
	if def.defense <= 0 then
		InputUtil_Pause( "already broken" )
	end
	if def.defense <= dmg then
		dmg = def.defense
		def.defense = 0
		if def.isWall == true then
			if def.side == CombatSide.ATTACKER then
				Asset_SetDictItem( self, CombatAssetID.ATK_STATUS, CombatStatus.DEFENSE_BROKEN, true )
				--print( Asset_GetDictItem( self, CombatAssetID.ATK_STATUS, CombatStatus.DEFENSE_BROKEN ) )
			elseif def.side == CombatSide.DEFENDER then
				Asset_SetDictItem( self, CombatAssetID.DEF_STATUS, CombatStatus.DEFENSE_BROKEN, true )
				--print( Asset_GetDictItem( self, CombatAssetID.DEF_STATUS, CombatStatus.DEFENSE_BROKEN ) )
			end			
			--InputUtil_Pause( "break def", def.side, def.x, def.y )
			self:DoAction( nil, CombatAction.DEFENCE_DESTOYED )
		end
	else
		def.defense = def.defense - dmg
	end
	--WriteCombatLog( atk:ToString( "COMBAT" ), MathUtil_FindName( CombatTask, params.type ), "("..def.x..","..def.y..")", " dmg=".. dmg, " left=", def.defense )
	self:AddStat( atk:GetCombatData( TroopCombatData.SIDE ), CombatStatistic.DESTROY, dmg )
	--InputUtil_Pause( atk:ToString( "COMBAT" ), "hit defense=" .. dmg .. "->" .. def.defense )
end

function Combat:CalcDamage( atk, def, params )	
	-------------------------------
	--Number Modification
	local atkNumber = Asset_Get( atk, TroopAssetID.SOLDIER )
	local defNumber = Asset_Get( def, TroopAssetID.SOLDIER )
	
	--attack from flank
	if params.isFlank == true then
		atkNumber = atkNumber * 0.75
	end
	--too many soldier in the grid
	if params.isCrowd == true then
		atkNumber = atkNumber * 0.75
	end
	--been suppresed by missile
	if params.isSuppressed == true then
		atkNumber = atkNumber * 0.75
	end

	local number_mod = 0
	if atkNumber < 100 then number_mod = atkNumber
	elseif atkNumber < 500 then number_mod = 100 + ( atkNumber - 100 ) * 0.25
	elseif atkNumber < 2000 then number_mod = 200 + ( atkNumber - 500 ) * 0.1
	else number_mod = 350 end

	-------------------------------
	--Weapon & Armor Modification
	local atklv      = Asset_Get( atk, TroopAssetID.LEVEL )	
	local weapon_pow = params.weapon.power

	local hit_rate   = math.max( 10, params.weapon.accuracy + 1 * ( atklv - params.weapon.level ) )
	local org_rate   = 1

	--"def" maybe defensive, not soldier
	local armor, toughness = 0, 0
	if def.type then
		armor     = Asset_Get( def, TroopAssetID.ARMOR )
		toughness = Asset_Get( def, TroopAssetID.TOUGHNESS )
	end
	hit_rate = hit_rate * 100 / ( 100 + toughness )
	
	--Determine rate
	local weapon_rate = math.max( 0.1, 1 + ( armor > 0 and ( weapon_pow - armor ) / ( armor ) or 0 ) )

	local exposure_rate = 1	
	--intel about enemy( exposure ) will determine how
	local exposure = 100
	if not params.isDefense then
		exposure = math.ceil( ( def:GetCombatData( TroopCombatData.EXPOSURE ) or 0 ) * 0.5 ) + 50
	end
	exposure_rate = Random_GetInt_Sync( exposure, 100 ) * 0.01

	-------------------------------
	--Determine critical( by morale )
	local is_critical = false
	if exposure > 80 then
		local atkmor = Asset_Get( atk, TroopAssetID.MORALE )
		local defmor = Asset_Get( def, TroopAssetID.MORALE ) or 0	
		local critical_range = math.min( 35, ( atkmor - defmor ) * 0.5 + 10 )
		is_critical = Random_GetInt_Sync( 1, 100 ) < critical_range
	end

	-------------------------------
	--Determine damage rate
	local dmg_rate = Random_GetInt_Sync( 90, 110 ) * 0.01
	--counter attack
	if params.isCounter == true then
		dmg_rate = dmg_rate * 0.75
	end
	--attacker is tired
	if params.isTired == true then
		dmg_rate = dmg_rate * 0.75
	end
	
	-------------------------------
	--Determine Defence Height Modification
	if params.type ~= CombatTask.DESTROY then
		if params.height ~= 0 then
			--height advantage will increase the accuracy
			hit_rate = hit_rate + MathUtil_Interpolate( params.height or 0, -1, 1, -0.8, 0.25 )

			--height advantage will improve the damage
			dmg_rate = dmg_rate + MathUtil_Interpolate( params.height or 0, -1, 1, -0.5, 0.25 )
		end
	end

	if is_critical == true then
		dmg_rate = dmg_rate * 1.5
	end	

	if params.fort and params.fort > 0 then
		dmg_rate = dmg_rate * 100 / ( 100 + params.fort )
	end

	--calc dmg
	local dmg = math.ceil( number_mod * dmg_rate * weapon_rate * exposure_rate )
	
	--print( "num=" .. number_mod, "dmg_rate="..dmg_rate, "wp_rate="..weapon_rate, "exposure_rate="..exposure_rate )
	--print( "num="..number_mod, weapon_pow, weapon_resist, "weapon="..math.ceil( weapon_rate * 100 ), "org=".. math.ceil( org_rate * 100 ), "hit=".. math.ceil( hit_rate * 100 ), " critical=" .. ( is_critical and "true" or "false" ) )
	--print( "atk=".. atk.id, "def=" .. ( def.id or "defense" ), "dule=",params.isDule, "counter=",params.isCounter, "Suppressive=",params.isSuppressive )	
	--print( atk:ToString(), def:ToString(), dmg, org_rate, hit_rate, is_critical )

	return dmg, org_rate, hit_rate, is_critical
end

function Combat:CalcAttack( atk, def, params )	
	if atk:GetCombatData( TroopCombatData.GRID ) then
		params.isCrowd = atk:GetCombatData( TroopCombatData.GRID ).soldier > atk:GetCombatData( TroopCombatData.GRID ).depth
	end
	
	if def:GetCombatData( TroopCombatData.GRID ) and def:GetCombatData( TroopCombatData.GRID ).defense then
		params.fort = def:GetCombatData( TroopCombatData.GRID ).defense > 0 and def:GetCombatData( TroopCombatData.GRID ).defense or 0
	end	

	if atk:GetCombatData( TroopCombatData.GRID ) and def:GetCombatData( TroopCombatData.GRID ) then
		local atkHeight = ( atk:GetCombatData( TroopCombatData.GRID ).height or 0 )
		local defHeight = ( def:GetCombatData( TroopCombatData.GRID ).height or 0 )
		params.height = atkHeight + defHeight > 0 and ( atkHeight - defHeight ) / ( atkHeight + defHeight )	or 0
	end
	
	params.isFlank = def:GetCombatData( TroopCombatData.TARGET ) ~= nil and def:GetCombatData( TroopCombatData.TARGET ) ~= atk

	local dmg, orgRate, hitRate, isCritical = self:CalcDamage( atk, def, params )
	return { type = params.type, dmg = dmg, orgRate = orgRate, hitRate = hitRate, isCounter = params.isCounter, isCritical = isCritical }	
end

-- params
--	isTired       means attacker has attacked
--  isSuppressed  means defender has been attacked
--  isCounter     means defender counter attack the attacker
--  isCrowd       means too many soldier stay in the same grid, should be punished.
--  fort          means defense for the defender
--  height        means attacker has the height advantage( attacker.height  / ( attacker.height + defender.height ) )
function Combat:Attack( atk, def, params )
	params.fort         = 0
	params.height       = 0
	params.isDefense    = false
	params.isCrowd      = false
	params.isCounter    = false
	params.isFlank      = false	
	params.isTired      = atk:GetCombatData( TroopCombatData.ATTACKED )
	params.isSuppressed = atk:GetCombatData( TroopCombatData.DEFENDED )	

	--WriteCombatLog( MathUtil_FindName( CombatTask, params.type ), atk:ToString( "COMBAT" ) .. " vs " .. def:ToString( "COMBAT" ) )
	if params.type == CombatTask.DESTROY then
		params.isDefense = true
		self:DestroyDefense( atk, def, params )
		return
	end

	if not self:IsTroopValid( def ) then
		WriteCombatLog( def:ToString(), "not in combat" )
		return
	end

	local p1 = self:CalcAttack( atk, def, params )
	local weapon = self:FindCounterattackWeapon( def, params )
	if weapon then
		local params2 = {}
		params2.type         = CombatTask.FIGHT
		params2.weapon       = weapon
		params.fort          = 0
		params.height        = 0
		params2.isDefense    = false
		params2.isCrowd      = false
		params2.isCounter    = true
		params2.isFlank      = false
		params2.isTired      = def:GetCombatData( TroopCombatData.ATTACKED )
		params2.isSuppressed = def:GetCombatData( TroopCombatData.DEFENDED )
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
		self:AddStat( task.troop:GetCombatData( TroopCombatData.SIDE ), CombatStatistic.PASS, 1 )
		return
	end
	if task.type == CombatTask.DEFEND then
		self:Defend( task.troop )
		return
	end
	task.troop:SetCombatData( TroopCombatData.TARGET, task.target )
	table.insert( self._tasks, task )	
end

function Combat:Flee( troop )
	troop:SetCombatData( TroopCombatData.ATTENDED )

	--check probability
	if self:GetStatus( troop:GetCombatData( TroopCombatData.SIDE ), CombatStatus.SURROUNDED ) == true then
		--surrounded, maybe captured
		local sucratio = 65 - Asset_Get( troop, TroopAssetID.LEVEL ) * 3
		local ret = Random_GetInt_Sync( 1, 100 ) < sucratio
		if ret == false then
			--captured
			troop:SetCombatData( TroopCombatData.CAPTURED )
			local oppSide = self:GetOppSide( troop:GetCombatData( TroopCombatData.SIDE ) )
			Asset_AppendList( self, CombatAssetID.PRISONER, { side = oppSide, prisoner = troop } )
			--InputUtil_Pause( troop:ToString( "COMBAT" ), "captured" )
			WriteCombatLog( "captured", troop:ToString() )
			Stat_Add( "Combat@Capture_Troop", nil, StatType.TIMES )
			Stat_Add( "Combat@Capture_Soldier", Asset_Get( troop, TroopAssetID.SOLDIER ), StatType.ACCUMULATION )
			return
		end
	end

	self:DoAction( troop, CombatAction.FLEE )

	self:AddStat( troop:GetCombatData( TroopCombatData.SIDE ), CombatStatistic.LOSE_MORALE, morale )
	self:AddStat( troop, CombatStatistic.FLEE, 1 )

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

	WriteCombatLog( troop:ToString( "COMBAT" ) .. " Move ("..troop:GetCombatData( TroopCombatData.X_POS )..","..troop:GetCombatData( TroopCombatData.Y_POS )..")->" .. "("..tx..","..ty..")", MathUtil_FindName( CombatTask, type ) )
	
	local curGrid = self:GetGrid( troop:GetCombatData( TroopCombatData.X_POS ), troop:GetCombatData( TroopCombatData.Y_POS ) )
	local nextGrid = self:GetGrid( tx, ty )	
	self:AddGridTroop( nextGrid, troop )
	self:RemoveGridTroop( curGrid, troop )
	troop:SetCombatData( TroopCombatData.X_POS, tx )
	troop:SetCombatData( TroopCombatData.Y_POS, ty )
	troop:SetCombatData( TroopCombatData.GRID, curGrid )

	if type == CombatTask.BACKWARD then
		troop:SetCombatData( TroopCombatData.SURROUNDED, 1 )
	end
end

function Combat:ExecuteMovement( task )
	local troop = task.troop

	--WriteCombatLog( troop:ToString( "COMBAT" ) .. " type=" .. MathUtil_FindName( CombatTask, task.type ) .. " tar=" .. ( task.target and NIDString( task.target ) or "" ) )

	--set acted flag
	troop:SetCombatData( TroopCombatData.MOVED, 1 )
	task.troop:SetCombatData( TroopCombatData.TARGET, task.target )

	local xDelta, yDelta = self:GetFaceDir( troop )

	--print( troop.name, xDelta, yDelta )

	if task.type == CombatTask.FORWARD then
		self:AddStat( troop:GetCombatData( TroopCombatData.SIDE ), CombatStatistic.FORWARD, 1 )
	
	elseif task.type == CombatTask.TOWARD_GRID then
		local grid = task.target
		local ox = grid.x > troop:GetCombatData( TroopCombatData.X_POS ) and 1 or ( grid.x < troop:GetCombatData( TroopCombatData.X_POS ) and -1 or 0 )
		local oy = grid.y > troop:GetCombatData( TroopCombatData.Y_POS ) and 1 or ( grid.y < troop:GetCombatData( TroopCombatData.Y_POS ) and -1 or 0 )
		self:MoveTo( troop, troop:GetCombatData( TroopCombatData.X_POS ) + ox, troop:GetCombatData( TroopCombatData.Y_POS ) + oy, task.type )
		return

	elseif task.type == CombatTask.TOWARD_TAR then
		local target = task.target

		local ox,  oy = 0, 0
		if target:GetCombatData( TroopCombatData.X_POS ) > troop:GetCombatData( TroopCombatData.X_POS ) then
			ox = 1
		elseif target:GetCombatData( TroopCombatData.X_POS ) < troop:GetCombatData( TroopCombatData.X_POS ) then
			ox = -1
		end
		if target:GetCombatData( TroopCombatData.Y_POS ) > troop:GetCombatData( TroopCombatData.Y_POS ) then
			oy = 1
		elseif target:GetCombatData( TroopCombatData.Y_POS ) < troop:GetCombatData( TroopCombatData.Y_POS ) then
			oy = -1
		end

		--print( troop.id, troop:GetCombatData( TroopCombatData.X_POS ), troop:GetCombatData( TroopCombatData.Y_POS ), "toward", task.target.id, task.target:GetCombatData( TroopCombatData.X_POS ), task.target:GetCombatData( TroopCombatData.Y_POS ) )
		local xDis = math.abs( target:GetCombatData( TroopCombatData.X_POS ) - troop:GetCombatData( TroopCombatData.X_POS ) )
		local yDis = math.abs( target:GetCombatData( TroopCombatData.Y_POS ) - troop:GetCombatData( TroopCombatData.Y_POS ) )
		--print( xDelta, yDelta, xDis, yDis )

		if target:GetCombatData( TroopCombatData.RETREAT ) == true then xDis = xDis + 1 end

		if xDis > yDis then
			if self:MoveTo( troop, troop:GetCombatData( TroopCombatData.X_POS ) + ox, troop:GetCombatData( TroopCombatData.Y_POS ) ) then return end
			if oy ~= 0 and self:MoveTo( troop, troop:GetCombatData( TroopCombatData.X_POS ), troop:GetCombatData( TroopCombatData.Y_POS ) + oy ) then return end
			if self:MoveTo( troop, troop:GetCombatData( TroopCombatData.X_POS ), troop:GetCombatData( TroopCombatData.Y_POS ) + yDelta ) then return end
		else
			if self:MoveTo( troop, troop:GetCombatData( TroopCombatData.X_POS ), troop:GetCombatData( TroopCombatData.Y_POS ) + oy ) then return end
			if ox ~= 0 and self:MoveTo( troop, troop:GetCombatData( TroopCombatData.X_POS ) + ox, troop:GetCombatData( TroopCombatData.Y_POS ) ) then return end
			if self:MoveTo( troop, troop:GetCombatData( TroopCombatData.X_POS ), troop:GetCombatData( TroopCombatData.Y_POS ) + yDelta ) then return end
		end
		return

	elseif task.type == CombatTask.BACKWARD or task.type == CombatTask.FLEE then
		yDelta = -yDelta
		self:AddStat( troop:GetCombatData( TroopCombatData.SIDE ), CombatStatistic.BACKWARD, 1 )

	elseif task.type == CombatTask.STAY then
		troop:SetCombatData( TroopCombatData.MOVED )
		return
	end

	self:MoveTo( troop, troop:GetCombatData( TroopCombatData.X_POS ) + xDelta, troop:GetCombatData( TroopCombatData.Y_POS ) + yDelta, task.type )
end

-----------------------------------------------
-- Debug & Test

function Combat:TestDamage()
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
				atk:JoinCombat( self )
				atk:SetCombatData( TroopCombatData.ATTENDED, 1 )
				table.insert( atklist, atk )				
				TroopTable_ListAbility( atk )
			end

			--if tab.category == TroopCategory.CAVALRY then
			if true then
				local def = Corps_EstablishTroopByTable( tab, number )
				def:JoinCombat( self )
				def:SetCombatData( TroopCombatData.ATTENDED, 1 )
				table.insert( deflist, def )
			end
		end
	end )

	for _, atk in ipairs( atklist ) do
		for _, def in ipairs( deflist ) do
			local weapon
	
			weapon = atk:GetWeaponByTask( CombatTask.FIGHT )
			if weapon then
				Asset_Set( def, TroopAssetID.SOLDIER, number )
				Asset_Set( def, TroopAssetID.MAX_SOLDIER, number )
				Asset_Set( def, TroopAssetID.ORGANIZATION, org )
				self:Attack( atk, def, { type = CombatTask.FIGHT, weapon = weapon } )
			end
			
			weapon = atk:GetWeaponByTask( CombatTask.SHOOT )
			if weapon then
				Asset_Set( def, TroopAssetID.SOLDIER, number )
				Asset_Set( def, TroopAssetID.MAX_SOLDIER, number )
				Asset_Set( def, TroopAssetID.ORGANIZATION, org )
				self:Attack( atk, def, { type = CombatTask.SHOOT, weapon = weapon } )
			end

			weapon = atk:GetWeaponByTask( CombatTask.CHARGE )
			if weapon then
				Asset_Set( def, TroopAssetID.SOLDIER, number )
				Asset_Set( def, TroopAssetID.MAX_SOLDIER, number )
				Asset_Set( def, TroopAssetID.ORGANIZATION, org )
				self:Attack( atk, def, { type = CombatTask.CHARGE, weapon = weapon } )
			end
		end	
	end
end

