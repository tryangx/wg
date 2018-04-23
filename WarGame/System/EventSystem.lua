local EventTriggers = 
{
	--global
	NO_EVT_CD    = function( value, event, entity ) if System_Get( SystemType.EVENT_SYS ):GetCD( value == -1 and event.id or value, entity ) then return false end end,
	NO_EVT_FLAG  = function( value, event, entity ) if System_Get( SystemType.EVENT_SYS ):GetFlag( value == -1 and event.id or value, entity ) then return false end end,
	NO_GLB_CD    = function( value, event, entity ) if System_Get( SystemType.EVENT_SYS ):GetCD( value == -1 and event.id or value ) then return false end end,
	NO_GLB_FLAG  = function( value, event, entity ) if System_Get( SystemType.EVENT_SYS ):GetFlag( value == -1 and event.id or value ) then return false end end,
	HAS_EVT_FLAG = function( value, event, entity ) if not System_Get( SystemType.EVENT_SYS ):GetFlag( value == -1 and event.id or value, entity ) then return false end end,
	HAS_GLB_FLAG = function( value, event, entity ) if not System_Get( SystemType.EVENT_SYS ):GetFlag( value == -1 and event.id or value ) then return false end end,
	PROB     = function( value, event, entity ) 
		local r = Random_GetInt_Sync( 1, 10000 )
		--print( "prob=", r, value )
		if r > value then return false end		
	end,

	--handler
	SET_EVT_CD   = function( value, event, entity ) System_Get( SystemType.EVENT_SYS ):SetCD( event.id, entity, value ) end,
	SET_EVT_FLAG = function( value, event, entity ) System_Get( SystemType.EVENT_SYS ):SetFlag( value, entity, true ) end,
	SET_GLB_CD   = function( value, event, entity ) System_Get( SystemType.EVENT_SYS ):SetCD( event.id, nil, value ) end,
	SET_GLB_FLAG = function( value, event, entity ) System_Get( SystemType.EVENT_SYS ):SetFlag( value, nil, true ) end,
}

local EventHandlers = 
{
	--global
	SET_EVT_CD   = function( value, event, entity ) System_Get( SystemType.EVENT_SYS ):SetCD( event.id, entity, value ) end,
	SET_EVT_FLAG = function( value, event, entity ) System_Get( SystemType.EVENT_SYS ):SetFlag( value, entity, true ) end,
	SET_GLB_CD   = function( value, event, entity ) System_Get( SystemType.EVENT_SYS ):SetCD( event.id, nil, value ) end,
	SET_GLB_FLAG = function( value, event, entity ) System_Get( SystemType.EVENT_SYS ):SetFlag( value, nil, true ) end,

	--city
	SECURITY        = function( value, event, entity ) Asset_Plus( entity, CityAssetID.SECURITY, value ) end,	
	DISSATISFACTION = function( value, event, entity ) Asset_Plus( entity, CityAssetID.DISSATISFACTION, value ) end,
}

local function Event_TriggerEvent( entity, event )
	local target = Asset_Get( event, EventAssetID.TARGET )	
	if target ~= "NONE" and entity.type ~= EntityType[target] then
		return false
	end
	--print( target, entity.type, EntityType[target] )
	local condtions = Asset_GetList( event, EventAssetID.TRIGGER )
	if not condtions then
		return false
	end
	for _, cond in ipairs( condtions ) do
		for type, value in pairs( cond ) do
			local func = EventTriggers[type]
			if not func then
				InputUtil_Pause( "No event trigger function for ", type )
				return false
		end
			if func( value, event, entity ) == false then
				--InputUtil_Pause( "Event=" .. event.id .. " trigger failed for reason", type, value )
				return false
			end
		end
	end
	return true
end

local function Event_HandleEvent( entity, event )
	local effects = Asset_GetList( event, EventAssetID.EFFECTS )
	for _, eff in ipairs( effects ) do
		for type, value in pairs( eff ) do
			local func = EventHandlers[type]
			if not func then
				InputUtil_Pause( "No event handler function for ", type )
			else
				func( value, event, entity )
			end
		end
	end
	Stat_Add( "CityEvent", { city = entity.id, evt = event.id }, StatType.LIST )
	--InputUtil_Pause( "Event=" .. event.id .. " ocurred in " .. entity.name )	
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
	self._flag[-1] = {}
	self._cd[-1]   = {}
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
	for entity, flags in pairs( self._flag ) do
		for k, v in pairs( flags ) do
			if k >= EventFlag.TEMP_FLAG_RESERVED and k < EventFlag.GLOBAL_FLAG_RESERVED then
				--InputUtil_Pause( "clear flag", k, v )
				flags[k] = nil
			end
		end
	end
end

function EventSystem:GetCD( id, entity )
	--print( "Cd=", id, self._cd[id] )
	local category = entity and entity.id or -1
	return self._cd[category] and self._cd[entity.id][id] or nil
end

function EventSystem:GetFlag( id, entity )
	local category = entity and entity.id or -1
	return self._flag[category] and self._flag[category][id] or nil
end

function EventSystem:SetCD( id, entity, time )
	local category = entity and entity.id or -1
	if not self._cd[category] then self._cd[category] = {} end
	self._cd[category][id] = time
end

function EventSystem:SetFlag( id, entity, status )
	local category = entity and entity.id or -1
	if not self._flag[category] then self._flag[category] = {} end
	self._flag[category][id] = status
end

function EventSystem:Trigger( entity )
	--if 1 then return end
	Entity_Foreach( EntityType.EVENT, function ( event )
		if Event_TriggerEvent( entity, event ) == true then
			Event_HandleEvent( entity, event )
		end
	end)
end