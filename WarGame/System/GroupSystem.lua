

-----------------------------------------

GroupSystem = class()

function GroupSystem:__init()
	System_Setup( self, SystemType.GROUP_SYS )
end

function GroupSystem:Start()
end

function GroupSystem:Update()
	Entity_Foreach( EntityType.GROUP, function ( group )
		--print( "it time to ", group.name )
	end )
end