GoalSystem = class()

function GoalSystem:__init()
	System_Setup( self, SystemType.GOAL_SYS )
end

function GoalSystem:Start()
end

function GoalSystem:Update()
	if FeatureOption.DISABLE_GOAL then return end
	
	local numOfAllCity = Entity_Number( EntityType.CITY )

	local validGroup
	local numOfValidGroup = 0
	Entity_Find( EntityType.GROUP, function ( group )
		local numOfCity = Asset_GetListSize( group, GroupAssetID.CITY_LIST )
		if numOfCity > 0 then
			validGroup = group
			numOfValidGroup = numOfValidGroup + 1
		end
		if numOfCity >= numOfAllCity then
			g_winner = group
			return true
		end
		return false
	end )
	if numOfValidGroup == 1 and not FeatureOption.DISABLE_CONQUER then
		g_winner = validGroup
	end
end