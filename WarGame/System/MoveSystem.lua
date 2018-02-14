------------------------------------------------

local DEFAULT_MOVE_DURATION = 30

------------------------------------------------

--record all moves from plot to plot
local _actions = {}

--record all actor in every plot
local _plots = {}

--record all encouter
local _encounters = {}

------------------------------------------------

local function Move_AddToPlot( move )
	local curplot = Asset_Get( move, MoveAssetID.CUR_PLOT )
	if not curplot then
		return false
	end
	if not _plots[curplot] then
		_plots[curplot] = {}
	end
	table.insert( _plots[curplot], move )
end

local function Move_CheckEncounter( move )
	--is there an enemy in the destination?
	local curplot = Asset_Get( move, MoveAssetID.CUR_PLOT )
	local list = _plots[curplot]
	if not list then return false end

	local actor = Asset_Get( move, MoveAssetID.ACTOR )
	local curGroup = Asset_Get( actor, CorpsAssetID.GROUP )
	
	local isEncounter = false
	for k, other in ipairs( list ) do
		if Asset_Get( other, MoveAssetID.ROLE ) == MoveRole.CORPS then			
			--is enemy corps?
			local otherActor = Asset_Get( other, MoveAssetID.ACTOR )
			local othGroup = Asset_Get( otherActor, CorpsAssetID.GROUP )
			--InputUtil_Pause( "encounter check", othGroup.name, curGroup.name )
			if Group_IsAtWar( curGroup, othGroup ) then
				--encounter, actually we should send a message to other system, but now, we call Combat by myself							
				isEncounter = true
				_actions[k] = nil
				Asset_Set( move, MoveAssetID.STATUS, MoveStatus.SUSPEND )
				Asset_Set( other, MoveAssetID.STATUS, MoveStatus.SUSPEND )
				Message_Post( MessageType.FIELD_COMBAT_TRIGGER, { plot = curplot, atk = actor, def = otherActor } )
				--InputUtil_Pause( "encounter" )
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
	local route = Asset_Get( move, MoveAssetID.ROUTE )
	local curplot  = Asset_Get( move, MoveAssetID.CUR_PLOT )
	local nextplot = Asset_Get( move, MoveAssetID.NEXT_PLOT )
	local tocity   = Asset_Get( move, MoveAssetID.TO_CITY )	
	local routeplot = route:FindNext( nextplot, tocity )
	--print( "cur  =", Asset_Get( curplot, PlotAssetID.X ), ",", Asset_Get( curplot, PlotAssetID.Y ) )
	--print( route, curplot, nextplot, toCity, routeplot )	
	--print( "next =", Asset_Get( routeplot, PlotAssetID.X ), ",", Asset_Get( routeplot, PlotAssetID.Y ) )
	Asset_Set( move, MoveAssetID.CUR_PLOT, nextplot )
	Asset_Set( move, MoveAssetID.NEXT_PLOT, routeplot )
	if nextplot then Asset_Plus( move, MoveAssetID.DURATION, Asset_Get( nextplot, PlotAssetID.ROAD ) ) end
	if routeplot then Asset_Plus( move, MoveAssetID.DURATION, Asset_Get( routeplot, PlotAssetID.ROAD ) ) end
	
	--print( Asset_Get( move, MoveAssetID.ACTOR ).name, "move to", Asset_Get( nextplot, PlotAssetID.X ), ",", Asset_Get( nextplot, PlotAssetID.Y ), "next=", Asset_Get( routeplot, PlotAssetID.X ), ",", Asset_Get( routeplot, PlotAssetID.Y ) )

	--check encounter in the new plot
	if Move_CheckEncounter( move ) == true then return true end

	--is route finished?
	if not routeplot then return false end

	Move_AddToPlot( move )

	return true
end

--return weather finish the move
local function Move_DoAction( move )
	if Asset_Get( move, MoveAssetID.STATUS ) ~= MoveStatus.MOVING then return end

	if Move_MoveToNext( move ) == true then
		return false
	end
	
	--reach the destination
	Asset_Set( move, MoveAssetID.END_TIME, g_calendar:GetDateValue() )
	
	local role = Asset_Get( move, MoveAssetID.ROLE )
	if role == MoveRole.CORPS then
		--InputUtil_Pause( Asset_Get( move, MoveAssetID.ACTOR ).name, "reach", Asset_Get( move, MoveAssetID.TO_CITY ).name )
		Stat_Add( "Corps@Move", g_calendar:CalcDiffDayByDates( Asset_Get( move, MoveAssetID.END_TIME ), Asset_Get( move, MoveAssetID.BEGIN_TIME ) ), StatType.ACCUMULATION )
		Asset_Set( Asset_Get( move, MoveAssetID.ACTOR ), CorpsAssetID.LOCATION, Asset_Get( move, MoveAssetID.TO_CITY ) )
	elseif role == MoveRole.CHARA then
		Asset_Set( Asset_Get( move, MoveAssetID.ACTOR ), CharaAssetID.LOCATION, Asset_Get( move, MoveAssetID.TO_CITY ) )
	end
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
		movement = Asset_Get( actor, CharaAssetID.MOVEMENT )
	end
	Asset_Plus( move, MoveAssetID.PROGRESS, movement )
	
	if move:IsReachNext() then
		table.insert( _actions, move )
	else
		Move_AddToPlot( move )
	end
	
	return false
end

------------------------------------------------

local function Move_OnFieldCombatEnd( msg )
	
end

------------------------------------------------

MoveSystem = class()

function MoveSystem:__init()
	System_Setup( self, SystemType.MOVE_SYS )
end

function MoveSystem:Start()
	self._actors = {}

	Message_Handle( SystemType.MOVE_SYS, MessageType.FIELD_COMBAT_END, Move_OnFieldCombatEnd )
end

--1. Determine whether move to the next plot, put them into list
--2. Check encounter and process with these encounter events
--3. 
function MoveSystem:Update()
	--clear caches
	_actions = {}
	_plots   = {}

	--update moves
	Entity_Foreach( EntityType.MOVE, Move_Update )

	--do actions
	for _, move in ipairs( _actions ) do
		if move and Move_DoAction( move ) == true then
			self._actors[Asset_Get( move, MoveAssetID.ACTOR )] = nil
			Entity_Remove( move )
		end
	end

	--print( "move has", Entity_Number( EntityType.MOVE ) )
end

function MoveSystem:MoveP2P( actor, from, to , type )

end

function MoveSystem:MoveC2C( actor, fromCity, toCity, type )
	local route = Route_QueryPath( fromCity, toCity )
	if not route then
		error( "no route from=" .. String_ToStr( fromCity, "name" ) .. " to=" .. String_ToStr( toCity, "name" ) )
		return
	end
	if self._actors[actor] then
		InputUtil_Pause( actor.name .. " is moving" )
		--[[
		print( "actors")
		MathUtil_Dump( self._actors )
		]]
		return
	end

	local move = Entity_New( EntityType.MOVE )
	Asset_Set( move, MoveAssetID.BEGIN_TIME, g_calendar:GetDateValue() )
	Asset_Set( move, MoveAssetID.ROLE, type )
	Asset_Set( move, MoveAssetID.ACTOR, actor )
	Asset_Set( move, MoveAssetID.STATUS, MoveStatus.MOVING )
	Asset_Set( move, MoveAssetID.FROM_CITY, fromCity )
	Asset_Set( move, MoveAssetID.TO_CITY, toCity )
	Asset_Set( move, MoveAssetID.ROUTE, route )
	Asset_Set( move, MoveAssetID.NEXT_PLOT, g_map:GetPlot( Asset_Get( fromCity, CityAssetID.X ), Asset_Get( fromCity, CityAssetID.Y ) ) )
	Asset_Set( move, MoveAssetID.DEST_PLOT, g_map:GetPlot( Asset_Get( toCity, CityAssetID.X ), Asset_Get( toCity, CityAssetID.Y ) ) )
	Move_MoveToNext( move )
	
	self._actors[actor] = move

	--if type == MoveRole.CORPS then InputUtil_Pause( actor.name, "move from=" .. fromCity.name, "to=" .. toCity.name ) end
end

function MoveSystem:Move( actor, fromCity, toCity, type )
	self:MoveC2C( actor, fromCity, toCity, type )
end

function MoveSystem:CorpsMove( actor, destination )	
	self:Move( actor, Asset_Get( actor, CorpsAssetID.LOCATION ), destination, MoveRole.CORPS )
end

function MoveSystem:CharaMove( actor, destination )
	self:Move( actor, Asset_Get( actor, CharaAssetID.LOCATION ), destination, MoveRole.CHARA )
end