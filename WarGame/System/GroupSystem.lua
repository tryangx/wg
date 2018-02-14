function Group_IsAtWar( group1, group2 )
	if group1 == group2 then return false end
	--simply all is enemy
	return true
end


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