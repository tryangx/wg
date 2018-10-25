local EventVars = 
{
	CITY_DISS     = function ( entity ) return entity:GetDiss() end,
	CITY_SECURITY = function ( entity ) return entity:GetSecurity() end,
}

local EventCompare = 
{
	MORE  = function ( l, r, v ) return l > r + ( v or 0 ) end,
	LESS  = function ( l, r, v ) return l < r + ( v or 0 ) end,
	EQUAL = function ( l, r, v ) return l == r end,
}

local EventTriggers = 
{
	NO_EVT_CD    = function( value, event, entity ) return System_Get( SystemType.EVENT_SYS ):GetCD( entity.id, value.id ) == nil end,	
	NO_GLB_CD    = function( value, event, entity ) return System_Get( SystemType.EVENT_SYS ):GetCD( "GLB", value.id ) == nil end,	

	NO_EVT_FLAG  = function( value, event, entity ) return System_Get( SystemType.EVENT_SYS ):GetFlag( event.id, value.id ) == nil end,	
	NO_GLB_FLAG  = function( value, event, entity ) return System_Get( SystemType.EVENT_SYS ):GetFlag( "GLB", value.id ) == nil end,	
	NO_TMP_FLAG  = function( value, event, entity ) return System_Get( SystemType.EVENT_SYS ):GetFlag( "TMP", value.id ) == nil end,	

	HAS_EVT_FLAG = function( value, event, entity ) return System_Get( SystemType.EVENT_SYS ):GetFlag( entity.id, value.id ) end,
	HAS_GLB_FLAG = function( value, event, entity ) return System_Get( SystemType.EVENT_SYS ):GetFlag( "GLB", value.id ) end,
	HAS_TMP_FLAG = function( value, event, entity ) return System_Get( SystemType.EVENT_SYS ):GetFlag( "TMP", value.id ) end,

	COMPARE = function ( value, event, entity )
		local lfunc = EventVars[value.left]
		local rfunc = EventVars[value.right]
		if not lfunc then DBG_Error( "No event vars=" .. value.left ) end
		if not rfunc then DBG_Error( "No event vars=" .. value.right ) end
		local l = lfunc( entity )
		local r = rfunc( entity )
		local cfunc = EventCompare[value.method]
		if not cfunc then DBG_Error( "No event compare method=" .. value.method ) end
		--print( value.method, l, r )
		--InputUtil_Pause( entity:ToString("ALL") )
		return cfunc( l, r, value.value )
	end,

	PROB    = function( value, event, entity ) return Random_GetInt_Sync( 1, 10000 ) <= value end,
}

--temp var
local _choice

local EventHandlers = 
{
	--global
	SET_EVT_CD   = function( value, event, entity ) System_Get( SystemType.EVENT_SYS ):SetCD( entity.id, value.id, value.time ) end,
	SET_GLB_CD   = function( value, event, entity ) System_Get( SystemType.EVENT_SYS ):SetCD( "GLB", value.id, value.time ) end,

	SET_EVT_FLAG = function( value, event, entity ) System_Get( SystemType.EVENT_SYS ):SetFlag( entity.id, value.id, value.value ) end,	
	SET_GLB_FLAG = function( value, event, entity ) System_Get( SystemType.EVENT_SYS ):SetFlag( "GLB", value.id, value.value ) end,	
	SET_TMP_FLAG = function( value, event, entity ) System_Get( SystemType.EVENT_SYS ):SetFlag( "TMP", value.id, value.value ) end,

	--city
	CITY_ADD_STATUS = function ( value, event, entity ) entity:AddStatus( CityStatus[value.status], value.value ) end,
	CITY_DEMONSTRATE= function ( value, event, entity ) entity:Demonstrate( value.time ) end,
	CITY_STRIKE     = function ( value, event, entity ) entity:Strike( value.time ) end,

	--storyboard
	DIALOG      = function ( value, event, entity ) print( "[dailog]" .. value ) end,
	CHOICE      = function ( value )
		local options = {}
		for index, option in pairs( value ) do
			local key = "" .. index
			options[key] = { key = key, content = index .."=".. option.title, goto = option.goto }
		end
		local sel = InputUtil_Read( options )
		_choice = options[sel].goto
	end,
	EXIT        = function () return false end
}

local function Event_TriggerEvent( entity, event )
	local target = event.target
	if target and entity.type ~= EntityType[target] then
		return false
	end
	--print( target, entity.type, EntityType[target] )
	
	local condtions = event.trigger
	if not condtions then
		DBG_Error( "ev=" .. event.id .. " should has atleast one condition" )
		return false
	end

	local valid
	for _, cond in ipairs( condtions ) do
		valid = true
		for type, value in pairs( cond ) do
			local func = EventTriggers[type]
			if not func then DBG_Error( "No event trigger function=" .. type ) end
			if func( value, event, entity ) == false then
				--InputUtil_Pause( "Event=" .. event.id .. " trigger failed for reason", type, value )
				valid = false
			end
			if valid == false then break end
		end
		if valid == true then
			Debug_Log( "event=" .. event.id .. " triggered", entity:ToString("ALL") )
			break
		end
	end
	return valid
end

local function Event_HandleEffect( entity, effects )
	local ret = true
	for type, value in pairs( effects ) do
		if type == "BRANCH" then			
			if value.title == _choice then
				--MathUtil_Dump( value.effects )
				--print( value.title, _choice, value.title == _choice, value.effect )
				Event_HandleEffect( entity, value.effect )
			end
		else
			local func = EventHandlers[type]
			if not func then DBG_Error( "No event handler function=" .. type ) end
			if func( value, event, entity ) == false then ret = false end
		end		
	end
	return ret
end

local function Event_HandleEvent( entity, event )
	_choice = nil

	local effects = event.effect
	for _, item in ipairs( effects ) do
		if Event_HandleEffect( entity, item ) == false then break end
	end
	Stat_Add( "CityEvent", { city = entity.id, evt = event.id }, StatType.LIST )
	Debug_Log( "trigger event=" .. event.name .. " in=" .. entity:ToString() .. " date=" .. g_Time:ToString() )
	print( "Event=" .. event.id .. " ocurred in " .. entity.name )	
end

---------------------------------

function Event_Trigger( entity, type )
	System_Get( SystemType.EVENT_SYS ):Trigger( entity, type )
end

---------------------------------

EventSystem = class()

function EventSystem:__init()
	System_Setup( self, SystemType.EVENT_SYS )

	Stat_SetDumper( "CityEvent", function ( data )
		local city = Entity_Get( EntityType.CITY, data.city )
		local evt  = Entity_Get( EntityType.EVENT, data.evt )
		if city and evt then
			print( "City=" .. ( city.name or "" ) .. " trigger evt=" .. ( evt.name or "" ) .. "("..evt.id.. ")" )
		end
	end, StatType.LIST )
end

function EventSystem:Start()
	-- flag and cd
	--	e.g. self._flags = { [entityid] = { eventid = 100 } }
	--
	self._flag = {}		
	self._cd   = {}

	self._typeEvents = {}
	Entity_Foreach( EntityType.EVENT, function ( event )
		EventTable_Add( event )
	end )
	EventTable_Find( function ( event )
		if not self._typeEvents[event.type] then
			self._typeEvents[event.type] = {}
		end
		local list = self._typeEvents[event.type]
		table.insert( list, event )
		print( "add event to list=" .. event.type, #list )
	end)
end

function EventSystem:Update()
	--clear CD
	for entity, evts in pairs( self._cd ) do
		for k, v in pairs( evts ) do
			if v > 1 then
				evts[k] = v - 1
			else
				evts[k] = nil
				--InputUtil_Pause( "evt cd cleared" )
			end
		end
	end

	--clear flag
	self._flag["TMP"] = nil
end

function EventSystem:GetCD( type, id )
	--print( "Cd=", id, self._cd[id] )
	return self._cd[type] and self._cd[type][id] or nil
end

function EventSystem:GetFlag( type, id )
	return self._flag[type] and self._flag[type][id] or nil
end

function EventSystem:SetCD( type, id, time )
	if not self._cd[type] then self._cd[type] = {} end
	self._cd[type][id] = time
end

function EventSystem:SetFlag( type, id, status )
	if not self._flag[type] then self._flag[type] = {} end
	self._flag[type][id] = status
	print( "set ev st", type, id, status )
end

function EventSystem:Trigger( entity, type )
	if type then
		if not self._typeEvents[type] then return end
		for _, event in ipairs( self._typeEvents[type] ) do
			if Event_TriggerEvent( entity, event ) == true then
				Event_HandleEvent( entity, event )
			end
		end
	else
		EventTable_Find( function ( event )			
			if Event_TriggerEvent( entity, event ) == true then
				Event_HandleEvent( entity, event )
				return true
			end
		end)
	end
end