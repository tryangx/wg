------------------------------------------------

local DEFAULT_MOVE_DURATION = 30

------------------------------------------------

--record all moves from plot to plot
local _plotMoves = {}

--record all actor in every plot
local _plotActors = {}

--record all encouter
local _encounters = {}

------------------------------------------------

function Move_Track( actor )
	return System_Get( SystemType.MOVE_SYS ):TrackMove( actor )
end

function Move_IsMoving( actor )
	return System_Get( SystemType.MOVE_SYS ):IsMoving( actor )
end

function Move_Chara( chara, dest )
	System_Get( SystemType.MOVE_SYS ):CharaMove( chara, dest )
end

function Move_Corps( corps, dest )	
	System_Get( SystemType.MOVE_SYS ):CorpsMove( corps, dest )
end

function Move_GetCharaMovement( chara )	
	--1 unit means 1KM/DAY
	return 200
end

function Move_GetIntelMovement( group )
	--1 unit means 1KM/DAY
	--pigeon
	return 500
end

function Move_CalcIntelTransDuration( group, from, to )
	local distance = Route_CalcCityCoorDistance( from, to )
	local movement = Move_GetIntelMovement( chara )
	return math.ceil( distance / movement )
end

function Move_CalcCharaMoveDuration( chara, from, to )
	local distance = Route_CalcCityDistance( from, to )
	local movement = Move_GetCharaMovement( chara )
	return math.ceil( distance / movement )
end

--return days
function Move_CalcCorpsMoveDuration( corps, from, to )
	local distance = Route_CalcCityDistance( from, to )
	local movement = Asset_Get( corps, CorpsAssetID.MOVEMENT )
	return math.ceil( distance / movement )
end

------------------------------------------------

--Add moving actor into plot's actor list
local function Move_AddToPlot( move )
	local curplot = Asset_Get( move, MoveAssetID.CUR_PLOT )
	if not curplot then return false end
	if not _plotActors[curplot] then _plotActors[curplot] = {} end
	table.insert( _plotActors[curplot], move )
end

local function Move_CheckEncounter( move )
	--is there an enemy in the destination?
	local curplot = Asset_Get( move, MoveAssetID.CUR_PLOT )
	local list = _plotActors[curplot]
	if not list then return false end

	if Asset_Get( move, MoveAssetID.ROLE ) == MoveRole.CHARA then
		--chara no encounter now
		return
	end

	local actor = Asset_Get( move, MoveAssetID.ACTOR )
	local curGroup = Asset_Get( actor, CorpsAssetID.GROUP )	
	local isEncounter = false
	for k, other in ipairs( list ) do
		if Asset_Get( other, MoveAssetID.ROLE ) == MoveRole.CORPS then
			--is enemy corps?
			local otherActor = Asset_Get( other, MoveAssetID.ACTOR )
			local othGroup = Asset_Get( otherActor, CorpsAssetID.GROUP )
			if Dipl_IsAtWar( curGroup, othGroup ) then
				--encounter, actually we should send a message to other system, but now, we call Combat by myself							
				Debug_Normal( "Encounter in", curplot:ToString(), actor:ToString( "MILITARY" ), otherActor:ToString( "MILITARY" ) )
				isEncounter = true
				_plotMoves[k] = nil
				Asset_Set( move, MoveAssetID.STATUS, MoveStatus.SUSPEND )
				Asset_Set( other, MoveAssetID.STATUS, MoveStatus.SUSPEND )
				Message_Post( MessageType.FIELD_COMBAT_TRIGGER, { plot = curplot, atk = actor, def = otherActor } )
				break
			end
		end
	end
	return isEncounter
end

local function Move_MoveToNext( move )
	local dur = Asset_Get( move, MoveAssetID.DURATION )
	Asset_Reduce( move, MoveAssetID.PROGRESS, dur )
	Asset_Set( move, MoveAssetID.DURATION, 0 )
	local path     = Asset_Get( move, MoveAssetID.PATH )
	local curplot  = Asset_Get( move, MoveAssetID.CUR_PLOT )
	local nextplot = Asset_Get( move, MoveAssetID.NEXT_PLOT )
	local tocity   = Asset_Get( move, MoveAssetID.TO_CITY )	
	local routeplot
	for inx, p in ipairs( path ) do
		if not curplot or p == curplot then
			routeplot = path[inx+1]
			break
		end
	end
	--print( "cur  =", Asset_Get( curplot, PlotAssetID.X ), ",", Asset_Get( curplot, PlotAssetID.Y ) )
	--print( route, curplot, nextplot, toCity, routeplot )	
	--print( "next =", Asset_Get( routeplot, PlotAssetID.X ), ",", Asset_Get( routeplot, PlotAssetID.Y ) )
	Asset_Set( move, MoveAssetID.CUR_PLOT, nextplot )
	Asset_Set( move, MoveAssetID.NEXT_PLOT, routeplot )

	if nextplot then Asset_Plus( move, MoveAssetID.DURATION, Asset_Get( nextplot, PlotAssetID.ROAD ) ) end
	if routeplot then Asset_Plus( move, MoveAssetID.DURATION, Asset_Get( routeplot, PlotAssetID.ROAD ) ) end
	
	--Follow tracks
	--Debug_Log( "moving-->" .. move:ToString() )

	--check encounter in the new plot
	if Move_CheckEncounter( move ) == true then
		return true
	end

	--is route finished?
	if not routeplot then
		--MathUtil_Dump( path )
		--InputUtil_Pause( "FINISH PATH" )
		return false
	end

	Move_AddToPlot( move )

	return true
end

--return weather finish the move
local function Move_DoAction( move )
	if Asset_Get( move, MoveAssetID.STATUS ) ~= MoveStatus.MOVING then return end

	if Move_MoveToNext( move ) == true then return false end
	
	--reach the destination
	Asset_Set( move, MoveAssetID.END_TIME, g_Time:GetDateValue() )
	
	local actor = Asset_Get( move, MoveAssetID.ACTOR )
	local dest  = Asset_Get( move, MoveAssetID.TO_CITY )
	local home
	local role = Asset_Get( move, MoveAssetID.ROLE )
	if role == MoveRole.CORPS then
		--InputUtil_Pause( Asset_Get( move, MoveAssetID.ACTOR ).name, "reach", Asset_Get( move, MoveAssetID.TO_CITY ).name )
		Stat_Add( "Corps@Move", g_Time:CalcDiffDayByDates( Asset_Get( move, MoveAssetID.END_TIME ), Asset_Get( move, MoveAssetID.BEGIN_TIME ) ), StatType.ACCUMULATION )
		Asset_Set( actor, CorpsAssetID.LOCATION, dest )
		home = Asset_Get( actor, CorpsAssetID.ENCAMPMENT )
	elseif role == MoveRole.CHARA then
		Asset_Set( actor, CharaAssetID.LOCATION, dest )
		home = Asset_Get( actor, CharaAssetID.HOME )
	end
	
	--Debug_Log( actor:ToString() .. " move to " .. dest:ToString() )

	Message_Post( MessageType.ARRIVE_DESTINATION, { actor = Asset_Get( move, MoveAssetID.ACTOR ), destination = Asset_Get( move, MoveAssetID.DEST_PLOT ) } )

	--Stat_Add( "Move@End", move:ToString( "END" ), StatType.LIST )

	return true
end

local function Move_Update( move )
	--suspend or stop?
	if Asset_Get( move, MoveAssetID.STATUS ) ~= MoveStatus.MOVING then return end

	--move on
	local actor = Asset_Get( move, MoveAssetID.ACTOR )
	local role = Asset_Get( move, MoveAssetID.ROLE )
	
	local movement
	if role == MoveRole.CORPS then
		movement = Asset_Get( actor, CorpsAssetID.MOVEMENT )
	elseif role == MoveRole.CHARA then
		movement = Move_GetCharaMovement( actor )
	end
	Asset_Plus( move, MoveAssetID.PROGRESS, movement )
	
	if move:IsArrived() then
		table.insert( _plotMoves, move )
		return
	end
	
	Move_AddToPlot( move )
end

------------------------------------------------


local function Move_OnStartMoving( msg )
	local actor = Asset_GetListItem( msg, MessageAssetID.PARAMS, "actor" )
	System_Get( SystemType.MOVE_SYS ):StartMoving( actor )
end

local function Move_OnStopMoving( msg )
	local actor = Asset_GetListItem( msg, MessageAssetID.PARAMS, "actor" )
	System_Get( SystemType.MOVE_SYS ):StopMoving( actor )
end

local function Move_OnCancelMoving( msg )
	error( "it shouldn't be here" )
end

local function Move_OnCombatEnded( msg )
	local combat  = Asset_GetListItem( msg, MessageAssetID.PARAMS, "combat" )
	if not combat then return end

	Asset_ForeachList( combat, CombatAssetID.CORPS_LIST, function ( corps )
		if corps:IsBusy() == false then
			System_Get( SystemType.MOVE_SYS ):StopMoving( corps )
		else
			local task = Asset_GetListItem( corps, CorpsAssetID.STATUSES, CorpsStatus.IN_TASK )
			Debug_Log( corps:ToString(), "is busying", task:ToString() )
		end
	end )
end

------------------------------------------------

MoveSystem = class()

function MoveSystem:__init()
	System_Setup( self, SystemType.MOVE_SYS )
end

function MoveSystem:Start()
	self._actors = {}

	Message_Handle( self.type, MessageType.START_MOVING,  Move_OnStartMoving )
	Message_Handle( self.type, MessageType.STOP_MOVING,   Move_OnStopMoving )
	Message_Handle( self.type, MessageType.CANCEL_MOVING, Move_OnCancelMoving )
	Message_Handle( self.type, MessageType.COMBAT_ENDED,  Move_OnCombatEnded )
end

--1. Determine whether move to the next plot, put them into list
--2. Check encounter and process with these encounter events
--3. 
function MoveSystem:Update()
	--clear caches
	_plotMoves = {}
	_plotActors   = {}

	--update moves
	Entity_Foreach( EntityType.MOVE, Move_Update )

	--do actions
	for _, move in ipairs( _plotMoves ) do
		if move and Move_DoAction( move ) == true then
			local actor = Asset_Get( move, MoveAssetID.ACTOR )
			if Asset_Get( move, MoveAssetID.ROLE ) == MoveRole.CORPS then
				if actor:IsAtHome() then
					Asset_SetListItem( actor, CorpsAssetID.STATUSES, CorpsStatus.DEPATURE_TIME, nil )
				end
			end
			self._actors[actor] = nil
			Entity_Remove( move )			
		end
	end

	--print( "move has", Entity_Number( EntityType.MOVE ) )
end

function MoveSystem:IsMoving( actor )
	return self._actors[actor] ~= nil
end

function MoveSystem:MoveP2P( actor, from, to , type )
	
end

function MoveSystem:MoveC2C( actor, fromCity, toCity, type )
	if fromCity == toCity then
		DBG_Warning( actor:ToString(), "already in", toCity:ToString() )
		return
	end

	local path = Route_FindPathByCity( fromCity, toCity )
	if not path or #path == 0 then
		error( "no path from=" .. String_ToStr( fromCity, "name" ) .. " to=" .. String_ToStr( toCity, "name" ) )
		return
	end
	if self._actors[actor] then
		InputUtil_Pause( actor:ToString() .. " is moving" )
		--[[
		print( "actors")
		MathUtil_Dump( self._actors )
		]]
		return
	end

	local move = Entity_New( EntityType.MOVE )
	Asset_Set( move, MoveAssetID.BEGIN_TIME, g_Time:GetDateValue() )
	Asset_Set( move, MoveAssetID.ROLE, type )
	Asset_Set( move, MoveAssetID.ACTOR, actor )
	Asset_Set( move, MoveAssetID.STATUS, MoveStatus.MOVING )
	Asset_Set( move, MoveAssetID.FROM_CITY, fromCity )
	Asset_Set( move, MoveAssetID.TO_CITY, toCity )
	Asset_Set( move, MoveAssetID.PATH, path )
	Asset_Set( move, MoveAssetID.NEXT_PLOT, g_map:GetPlot( Asset_Get( fromCity, CityAssetID.X ), Asset_Get( fromCity, CityAssetID.Y ) ) )
	Asset_Set( move, MoveAssetID.DEST_PLOT, g_map:GetPlot( Asset_Get( toCity, CityAssetID.X ), Asset_Get( toCity, CityAssetID.Y ) ) )
	Move_MoveToNext( move )
	
	self._actors[actor] = move

	Stat_Add( "Move@Start", actor:ToString() .. " move from=" .. fromCity.name .. " to " .. toCity.name, StatType.LIST )

	--Debug_Log( actor:ToString( "LOCATION" ) .. " try to move from=" .. fromCity:ToString() .. " to " .. toCity:ToString() )
end

function MoveSystem:CorpsMove( actor, destination )
	actor:Dispatch()
	self:MoveC2C( actor, Asset_Get( actor, CorpsAssetID.LOCATION ), destination, MoveRole.CORPS )
end

function MoveSystem:CharaMove( actor, destination )	
	self:MoveC2C( actor, Asset_Get( actor, CharaAssetID.LOCATION ), destination, MoveRole.CHARA )
end

function MoveSystem:StopMoving( actor )
	local move = self._actors[actor]
	if move then
		Debug_Log( "cancel move", move:ToString() )
		self._actors[actor] = nil
		Entity_Remove( move )
	end
end

function MoveSystem:StartMoving( actor )
	local move = self._actors[actor]
	if move then
		--InputUtil_Pause( "resume moving", move:ToString() )
		Asset_Set( move, MoveAssetID.STATUS, MoveStatus.MOVING )
	end
end

function MoveSystem:TrackMove( actor )
	local move = self._actors[actor]
	if not move then return end
	Debug_Log( move:ToString() )
end