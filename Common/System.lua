-----------------------------------
--
-- System 
--
--
----------------------------

local _manager = Manager( 1, "System", System )

local _list = {}

function System_Add( sys )
	_manager:AddData( sys.type, sys )
	table.insert( _list, sys )
end

function System_Update( elpasedTime )
	g_elapsed = elpasedTime
	for _, sys in ipairs( _list ) do
		--InputUtil_Pause( MathUtil_FindName( SystemType, sys.type ) )
		sys:Update()
	end
end

function System_Setup( sys, type )
	sys.type = type
end

function System_Start()
	_manager:ForeachData( function ( sys )
		sys:Start()
	end)
end

function System_Get( type )
	return _manager:GetData( type )
end