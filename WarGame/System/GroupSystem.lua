function Group_FormulaInit()
	GroupGovernmentData = MathUtil_ConvertKey2ID( GroupGovernmentData, GroupGovernment )
end

function Group_SeizeCity( group, city )
	local oldGroup = Asset_Get( city, CityAssetID.GROUP )
	if oldGroup == group then
		error( "city="..city.name," already is under control by group=" .. gropu.name )
		return
	end

	if oldGroup then
		oldgroup:LoseCity( city )
	end

	group:OccupyCity( city )
end

function Group_Vanish( group )
	Entity_Remove( group )

	InputUtil_Pause( group:ToString(), "vanish" )
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