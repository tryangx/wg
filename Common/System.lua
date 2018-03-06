-----------------------------------
--
-- System 
--
--
----------------------------

local _manager = Manager( 1, "System", System )

function System_Add( sys )
	_manager:AddData( sys.type, sys )
end

function System_Update( elpasedTime )
	g_elapsed = elpasedTime
	_manager:ForeachData( function( sys )
		--InputUtil_Pause( MathUtil_FindName( SystemType, sys.type ) )
		sys:Update()
	end )
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