GoalSystem = class()

function GoalSystem:__init()
	System_Setup( self, SystemType.GOAL_SYS )
end

function GoalSystem:Start()
end

function GoalSystem:Update()
	local numOfCity = Entity_Number( EntityType.CITY )
	Entity_Find( EntityType.GROUP, function ( group )
		if Asset_GetListSize( group, GroupAssetID.CITY_LIST ) >= numOfCity then
			g_winner = group
			return true
		end
		return false
	end )
end