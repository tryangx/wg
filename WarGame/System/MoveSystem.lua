------------------------------------------------

local DEFAULT_MOVE_DURATION = 30

------------------------------------------------

--record moves that they are ready to go to the next plot
--DS: [id] = move
local _plotMoves = {}

--record all actor in every plot
--DS: [plot] = { move1, move2, ... }
local _plotActors = {}

--record all encouter
local _encounters = {}

------------------------------------------------

local function Move_Debug( move, content )
	local actor = Asset_Get( move, MoveAssetID.ACTOR )
	local role = Asset_Get( move, MoveAssetID.ROLE )
	if role ~= MoveRole.CORPS then return end
	--if actor.id == 5 or actor.id == 17 then
	if false then
		DBG_TrackBug( move:ToString( "DEBUG" ) .. " " .. content )
	end
end

function Move_Track( actor )
	return System_Get( SystemType.MOVE_SYS ):TrackMove( actor )
end

function Move_IsMoving( actor )
	return System_Get( SystemType.MOVE_SYS ):IsMoving( actor )
end

function Move_HasMoving( actor )
	return System_Get( SystemType.MOVE_SYS ):GetMove( actor )
end

function Move_Stop( actor )
	--should be carefull, only when actor is invalid( chara died, corps dismiss , etc )
	System_Get( SystemType.MOVE_SYS ):StopMoving( actor )
end

function Move_Suspend( actor )
	return System_Get( SystemType.MOVE_SYS ):SuspendMove( actor )
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
	--depends on pigeon can fly 500KM one day
	return 500
end

--return days
function Move_CalcIntelTransDuration( group, from, to )
	local distance = Route_CalcCityCoorDistance( from, to )
	local movement = Move_GetIntelMovement( chara )
	return math.ceil( distance / movement )
end

--return days
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
	if Asset_Get( move, MoveAssetID.ROLE ) ~= MoveRole.CORPS then
		--pass chara encouter checker now
		return
	end

	--check the CUR_PLOT whthere there is an enemy in the plot
	--local plot = Asset_Get( move, MoveAssetID.CUR_PLOT )
	local plot = Asset_Get( move, MoveAssetID.NEXT_PLOT )
	local actor = Asset_Get( move, MoveAssetID.ACTOR )

	--check exist combat in the next plot
	local combat = Warfare_GetComat( plot )
	if combat then
		if not actor then
			DBG_Error("why")
		end

		local curplot  = Asset_Get( move, MoveAssetID.CUR_PLOT )
		local actGroup = Asset_Get( actor, CorpsAssetID.GROUP )

		--print( "combat exist", actor:ToString("STATUS"), move:ToString())	

		--determine back encampment or trigger/attend combat
		if combat:HasGroupCorps( actGroup ) 
			or ( Dipl_IsAlly( actGroup, Asset_Get( combat, CombatAssetID.ATK_GROUP ) ) or Dipl_IsAlly( actGroup, Asset_Get( combat, CombatAssetID.DEF_GROUP ) ) )
			or ( Dipl_IsAtWar( actGroup, Asset_Get( combat, CombatAssetID.ATK_GROUP ) ) or Dipl_IsAtWar( actGroup, Asset_Get( combat, CombatAssetID.DEF_GROUP ) ) ) then

			if Asset_Get( combat, CombatAssetID.TYPE ) == CombatType.SIEGE_COMBAT then
				--determine to help the attacker or defender
				if actGroup == Asset_Get( combat, CombatAssetID.DEF_GROUP )					
					or Dipl_IsAlly( actGroup, Asset_Get( combat, CombatAssetID.DEF_GROUP ) )
					or Dipl_IsAtWar( actGroup, Asset_Get( combat, CombatAssetID.ATK_GROUP ) ) then
	
					--InputUtil_Pause( "encounter", actor:ToString(), combat:ToString("BRIEF") )

					--help defender, will cancel the exist siege combat
					local defList = MathUtil_ShallowCopy( Asset_GetList( combat, CombatAssetID.ATK_CORPS_LIST ) )
					Message_Post( MessageType.COMBAT_INTERRUPTED, { combat = combat } )
								
					--trigger a new field combat
					--  todo: should corps in siege city will attend the field combat?
					--InputUtil_Pause( "trigger new combat" )
					Message_Post( MessageType.FIELD_COMBAT_TRIGGER, { plot = plot, atk = actor, defList = defList } )
				else
					--help attacker, just attend the combat					
					Message_Post( MessageType.COMBAT_ATTEND, { combat = combat, atk = actor } )
				end
			else
				--attend field combat
				local atk, def
				if actGroup == Asset_Get( combat, CombatAssetID.ATK_GROUP ) then atk = actor end
				if actGroup == Asset_Get( combat, CombatAssetID.DEF_GROUP ) then def = actor end				
				Message_Post( MessageType.COMBAT_ATTEND, { combat = combat, atk = atk, def = def } )
				--print( "3", combat:ToString("DEBUG_CORPS"), "#", actor:ToString() )
			end
		else
			--retreat
			print( "act=" .. actGroup:ToString() )
			print( "atk=", Asset_Get( combat, CombatAssetID.ATK_GROUP ), Dipl_IsAlly( actGroup, Asset_Get( combat, CombatAssetID.ATK_GROUP ) ), Dipl_IsAtWar( actGroup, Asset_Get( combat, CombatAssetID.ATK_GROUP ) ) )
			print( "def=", Asset_Get( combat, CombatAssetID.DEF_GROUP ), Dipl_IsAlly( actGroup, Asset_Get( combat, CombatAssetID.DEF_GROUP ) ), Dipl_IsAtWar( actGroup, Asset_Get( combat, CombatAssetID.DEF_GROUP ) ) )

			print( "act=", actGroup:ToString(), actor:ToString() )
			print( combat:ToString() )
			print( "blocked")
			Message_Post( MessageType.MOVE_IS_BLOCKED, { plot = plot, actor = actor } )	
		end

		move:Suspend()

		return true
	end

	local list = _plotActors[plot]
	if not list then return false end

	local task = actor:GetTask()
	if Asset_Get( task, TaskAssetID.RESULT ) ~= TaskResult.UNKNOWN then
		--task failed, in retreat status
		return false
	end

	local isEncounter = false
	
	local curGroup = Asset_Get( actor, CorpsAssetID.GROUP )	
	
	function CanTriggerCombat( actor, opponent )
		--is opponent corps?
		if Asset_Get( opponent, MoveAssetID.ROLE ) ~= MoveRole.CORPS then return end

		--is opponent corps?
		local oppActor = Asset_Get( opponent, MoveAssetID.ACTOR )
		local oppGroup = Asset_Get( oppActor, CorpsAssetID.GROUP )
		if not Dipl_IsAtWar( curGroup, oppGroup ) then return end

		--is task failed?
		local oppTask = oppActor:GetTask()
		if oppTask and Asset_Get( oppTask, TaskAssetID.RESULT ) ~= TaskResult.UNKNOWN then
			return
		end

		Log_Write( "move", "encounter plot=" .. plot:ToString() .. " " .. actor:ToString( "MILITARY" ) .. " " .. oppActor:ToString( "MILITARY" ) )

		return oppActor
	end

	for _, otherMove in ipairs( list ) do
		local oppActor = CanTriggerCombat( move, otherMove )
		if oppActor then
			--encounter, actually we should send a message to other system, but now, we call Combat by myself
			isEncounter = true
			Message_Post( MessageType.FIELD_COMBAT_TRIGGER, { plot = plot, atk = actor, def = oppActor } )
			break
		end
	end

	return isEncounter
end

local function Move_MoveToNext( move )
	local dur = Asset_Get( move, MoveAssetID.DURATION )
	Asset_Reduce( move, MoveAssetID.PROGRESS, dur )
	Asset_Set( move, MoveAssetID.DURATION, 0 )

	local nextplot = Asset_Get( move, MoveAssetID.NEXT_PLOT )
	--check encounter in the new plot
	if Move_CheckEncounter( move ) == true then
		Move_Debug( move, "encounter in" .. nextplot:ToString() )
		return true
	end

	local curplot  = Asset_Get( move, MoveAssetID.CUR_PLOT )
	--local tocity   = Asset_Get( move, MoveAssetID.TO_CITY )	
	local routeplot
	local path     = Asset_Get( move, MoveAssetID.PATH )	
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

	if nextplot then
		--InputUtil_Pause( "addroad", Asset_Get( nextplot, PlotAssetID.ROAD ) )
		Asset_Plus( move, MoveAssetID.DURATION, Asset_Get( nextplot, PlotAssetID.ROAD ) )
	end
	if routeplot then
		--InputUtil_Pause( "addroad", Asset_Get( routeplot, PlotAssetID.ROAD ) )
		Asset_Plus( move, MoveAssetID.DURATION, Asset_Get( routeplot, PlotAssetID.ROAD ) )
	end
	
	--Follow tracks
	--Debug_Log( "moving-->" .. move:ToString() )

	--is route finished?
	if not routeplot then
		--MathUtil_Dump( path )
		--InputUtil_Pause( "FINISH PATH" )
		return false
	end

	Move_Debug( move, "moveto=" .. nextplot:ToString() )

	Move_AddToPlot( move )

	return true
end

--return weather finish the move
local function Move_DoAction( move )
	if Asset_Get( move, MoveAssetID.STATUS ) ~= MoveStatus.MOVING then
		Move_Debug( move, "not moving" )
		return
	end

	if Move_MoveToNext( move ) == true then
		--haven't reach the destination
		return false
	end
	
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
		actor:EnterCity( dest )
		home = Asset_Get( actor, CharaAssetID.HOME )

	end
	
	Log_Write( "move", actor:ToString("LOCATION") .. " move to=" .. dest:ToString() )
	--Debug_Log( actor:ToString() .. " move to " .. dest:ToString() )

	move:End()

	Message_Post( MessageType.ARRIVE_DESTINATION, { actor = Asset_Get( move, MoveAssetID.ACTOR ), destination = Asset_Get( move, MoveAssetID.DEST_PLOT ) } )

	--Stat_Add( "Move@End", move:ToString( "END" ), StatType.LIST )

	return true
end

local function Move_Update( move )
	--sanity checker
	if move:GetPassDay() > DAY_IN_YEAR then
		Debug_Log( move:ToString() .. " is bug" )
	end

	--suspend or stop?
	if Asset_Get( move, MoveAssetID.STATUS ) ~= MoveStatus.MOVING then
		return
	end

	--move on
	local movement = move:GetMovement()
	Asset_Plus( move, MoveAssetID.PROGRESS, movement )

	--Move_Debug( move, "update mv=" .. movement .. " role=" .. role )
	
	if move:IsArrived() then
		_plotMoves[move.id] = move
		return
	end
	
	Move_AddToPlot( move )
end

------------------------------------------------


local function Move_OnStartMoving( msg )
	local actor    = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "actor" )
	local waittime = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "waittime" )
	System_Get( SystemType.MOVE_SYS ):StartMoving( actor, waittime )
end

local function Move_OnStopMoving( msg )
	local actor = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "actor" )
	System_Get( SystemType.MOVE_SYS ):StopMoving( actor )
end

local function Move_OnCancelMoving( msg )
	error( "it shouldn't be here" )
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
	for _, move in pairs( _plotMoves ) do
		if Move_DoAction( move ) == true then
			local actor = Asset_Get( move, MoveAssetID.ACTOR )			
			Log_Write( "move", actor:ToString() .. " arrive destc=" .. String_ToStr( Asset_Get( move, MoveAssetID.TO_CITY ), "name" ) .. " destp=" .. Asset_Get( move, MoveAssetID.DEST_PLOT ):ToString() )
			if Asset_Get( move, MoveAssetID.ROLE ) == MoveRole.CORPS then
				if actor:IsAtHome() then
					Asset_SetDictItem( actor, CorpsAssetID.STATUSES, CorpsStatus.DEPATURE_TIME, nil )
				end
			end
			self._actors[actor] = nil
			Entity_Remove( move )
		end
	end

	--debug checker
	Entity_Foreach( EntityType.CHARA, function ( entity )
		if entity:IsAtHome() then return end
		if entity:IsBusy() then return end
		if self:IsMoving( entity ) then return end
		error( entity:ToString("LOCATION") .. "idle outside" )
	end)
	Entity_Foreach( EntityType.CORPS, function ( entity )
		if entity:IsAtHome() then return end
		if entity:IsBusy() then return end
		if self:IsMoving( entity ) then return end
		error( entity:ToString("POSITION") .. "idle outside" )
	end)

	--print( "move has", Entity_Number( EntityType.MOVE ) )
end

function MoveSystem:IsMoving( actor )
	local move = self._actors[actor]
	if not move then return false end
	return move:IsMoving()
end

function MoveSystem:GetMove( actor )
	return self._actors[actor]
end

function MoveSystem:MoveP2P( actor, from, to , type )	
end

function MoveSystem:MoveC2C( actor, fromCity, toCity, type )
	if fromCity == toCity then
		DBG_TrackBug( actor:ToString() .. " already in=" .. fromCity.name )
		return
	end

	local path = Route_FindPathByCity( fromCity, toCity )
	if not path or #path == 0 then
		error( "no path from=" .. String_ToStr( fromCity, "name" ) .. " to=" .. String_ToStr( toCity, "name" ) )
		return
	end
	if self._actors[actor] then
		DBG_Error( actor:ToString() .. " is moving" )
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
	
	move:Start()

	self._actors[actor] = move

	Stat_Add( "Move@Start", actor:ToString() .. " move from=" .. fromCity.name .. " to " .. toCity.name, StatType.LIST )

	Move_Debug( move, "moving" )

	if actor.id == 2 and move.id == 85 then
		--InputUtil_Pause( "start" .. move:ToString() )
	end	

	--Debug_Log( actor:ToString( "LOCATION" ) .. " try to move from=" .. fromCity:ToString() .. " to " .. toCity:ToString() )
	return move
end

function MoveSystem:CorpsMove( actor, destination )
	actor:Departure()
	local move = self:MoveC2C( actor, Asset_Get( actor, CorpsAssetID.LOCATION ), destination, MoveRole.CORPS )
	Log_Write( "move", actor:ToString() .. " moveto destc=" .. String_ToStr( Asset_Get( move, MoveAssetID.TO_CITY ), "name" ) .. " destp=" .. Asset_Get( move, MoveAssetID.DEST_PLOT ):ToString() )
end

function MoveSystem:CharaMove( actor, destination )	
	self:MoveC2C( actor, Asset_Get( actor, CharaAssetID.LOCATION ), destination, MoveRole.CHARA )
end

function MoveSystem:StopMoving( actor )
	local move = self._actors[actor]
	if move then
		Move_Debug( move, "stop move" )		
		Debug_Log( "stop move", move:ToString() )
		Log_Write( "move", "stop move=" .. actor:ToString() .. " moveto destc=" .. String_ToStr( Asset_Get( move, MoveAssetID.TO_CITY ), "name" ) .. " destp=" .. Asset_Get( move, MoveAssetID.DEST_PLOT ):ToString() )		
		--Entity_ToString( EntityType.MOVE )
		--print( "moving stop", actor:ToString(), self:IsMoving( actor ) )
		self._actors[actor] = nil
		Entity_Remove( move )
		return true
	else
		Debug_Log( "no move for ", actor:ToString() )
	end
end

function MoveSystem:StartMoving( actor, prepareTime )
	local move = self._actors[actor]
	if move then
		--sanity checker
		if actor:GetStatus( CorpsStatus.IN_COMBAT ) then DBG_Error( "why move", actor:ToString("STAUTS"), move:ToString("STATUS") ) end

		move:Start()
		move:Wait( prepareTime )
		--InputUtil_Pause( "resume moving", move:ToString() )		
	end
end

function MoveSystem:TrackMove( actor )
	local move = self._actors[actor]
	if not move then return end
	Debug_Log( move:ToString() )
end

function MoveSystem:SuspendMove( actor )
	local move = self._actors[actor]
	if not move then
		return
	end
	move:Suspend()	
end