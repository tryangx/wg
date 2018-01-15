MarchRole = 
{
	ROLE  = 1,
	CORPS = 2,
}

MarchSystem = class()

function MarchSystem:__init()
	System_Setup( self, SystemType.MARCH_SYS )
end

function MarchSystem:Start()
	self._tasks = {}
end

function MarchSystem:Update()

end

function MarchSystem:MoveCorps( actor, destination )
	local task = {}
	task.role  = MarchRole.CORPS
	task.actor = actor
	task.destination = destination
	table.insert( self._tasks, task )
end