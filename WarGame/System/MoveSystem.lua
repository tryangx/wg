local DEFAULT_MOVE_DURATION = 30

MoveRole = 
{
	CHARA = 1,
	CORPS = 2,
}

local _watchActor = nil

------------------------------------------------

function Move_SetWatchActor( actor )
	if not _watchActor or not actor then
		_watchActor = actor 
	end
end

local function Move_MoveToNext( move )	
	move.progress  = 0
	move.duration  = 0
	--print( "cur  =", Asset_Get( move.cur_plot, PlotAssetID.X ), ",", Asset_Get( move.cur_plot, PlotAssetID.Y ) )
	--print( "next =", Asset_Get( move.next_plot, PlotAssetID.X ), ",", Asset_Get( move.next_plot, PlotAssetID.Y ) )		
	move.cur_plot  = move.next_plot
	move.next_plot = move.route:FindNext( move.cur_plot, move.to_city )
	if move.cur_plot then move.duration = move.duration + Asset_Get( move.cur_plot, PlotAssetID.ROAD ) end
	if move.next_plot then move.duration = move.duration + Asset_Get( move.next_plot, PlotAssetID.ROAD ) end

	if move.actor == _watchActor then
		InputUtil_Pause( move.actor.name, Asset_Get( move.cur_plot, PlotAssetID.X ) .. "," .. Asset_Get( move.cur_plot, PlotAssetID.Y ) .. "->" .. Asset_Get( move.dest_plot, PlotAssetID.X ) .. "," .. Asset_Get( move.dest_plot, PlotAssetID.Y ) )	
	end

	if not move.next_plot then
		return false		
	end

	if move.actor == _watchActor then
		print( "next", Asset_Get( move.next_plot, PlotAssetID.X ) .. "," .. Asset_Get( move.next_plot, PlotAssetID.Y ) )
	end
end

local function Move_Update( move )
	local movement
	if move.role == MoveRole.CORPS then
		movement = Asset_Get( move.actor, CorpsAssetID.MOVEMENT )
	elseif move.role == MoveRole.CHARA then
		movement = Asset_Get( move.actor, CharaAssetID.MOVEMENT )
	end

	move.progress = move.progress + movement

	if move.actor == _watchActor then
		print( "prog=" .. move.progress, move.duration, move.actor.name )
	end

	if move.progress >= move.duration then
		--if move.cur_plot == move.dest_plot then
		if Move_MoveToNext( move ) == false then
			move.endtime = g_calendar:GetDateValue()

			--reach the destination
			if move.role == MoveRole.CORPS then
				Stat_Add( "Corps@Move", g_calendar:CalcDiffDayByDates( move.endtime, move.begtime ), StatType.ACCUMULATION )
				Asset_Set( move.actor, CorpsAssetID.LOCATION, move.to_city )
			elseif move.role == MoveRole.CHARA then
				Asset_Set( move.actor, CharaAssetID.LOCATION, move.to_city )
			end

			if move.actor == _watchActor then
				print( move.actor.name, "arrive", move.to_city.name )
				--InputUtil_Pause( move.actor.name, "arrive destination=" .. move.to_city.name )
			end

			return true
		else
			--next plot
			--MathUtil_Dump( move.cur_plot )			
			--MathUtil_Dump( move.dest_plot )
			--print( "check plot", move.cur_plot, move.dest_plot )
		end		
	end
	return false
end

------------------------------------------------

MoveSystem = class()

function MoveSystem:__init()
	System_Setup( self, SystemType.MOVE_SYS )
end

function MoveSystem:Start()
	self._moves = {}
	self._actors = {}
end

function MoveSystem:Update()
	for k, move in pairs( self._moves ) do
		if Move_Update( move ) == true then			
			self._actors[move.actor] = nil
			self._moves[k] = nil
		end
	end
end

function MoveSystem:Move( actor, fromCity, toCity, type )
	local route = Route_QueryPath( fromCity, toCity )
	if not route then
		error( "no route from=" .. String_ToStr( fromCity, "name" ) .. " to=" .. String_ToStr( toCity, "name" ) )
		return
	end
	if self._actors[actor] then
		InputUtil_Pause( actor.name .. " is moving" )
		--[[
		print( "moves")
		MathUtil_Dump( self._moves )
		print( "actors")
		MathUtil_Dump( self._actors )
		]]
		return
	end

	local move = {}	
	move.begtime = g_calendar:GetDateValue()
	move.role  = type
	move.actor = actor
	move.from_city  = fromCity
	move.to_city    = toCity
	move.x = Asset_Get( destination, CityAssetID.X )
	move.y = Asset_Get( destination, CityAssetID.Y )
	move.route = route
	move.next_plot = g_map:GetPlot( Asset_Get( fromCity, CityAssetID.X ), Asset_Get( fromCity, CityAssetID.Y ) )
	move.dest_plot = g_map:GetPlot( Asset_Get( toCity, CityAssetID.X ), Asset_Get( toCity, CityAssetID.Y ) )	
	Move_MoveToNext( move )
	table.insert( self._moves, move )	
	self._actors[actor] = move
	
	print( actor.id, actor.name, "move duration=" .. move.duration, fromCity.name, toCity.name )
	if move.actor == _watchActor then
	end
end

function MoveSystem:CorpsMove( actor, destination )	
	self:Move( actor, Asset_Get( actor, CorpsAssetID.LOCATION ), destination, MoveRole.CORPS )	
end

function MoveSystem:CharaMove( actor, destination )
	self:Move( actor, Asset_Get( actor, CharaAssetID.LOCATION ), destination, MoveRole.CHARA )
end