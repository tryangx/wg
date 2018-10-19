-------------------------------------------------

GoalSystem = class()

function GoalSystem:__init()
	System_Setup( self, SystemType.GOAL_SYS )
end

function GoalSystem:Start()
end

function GoalSystem:Update()
	if FeatureOption.DISABLE_GOAL then return end

	local day   = g_Time:GetDay()
	local month = g_Time:GetMonth()
	
	local numOfAllCity = Entity_Number( EntityType.CITY )

	local validGroup
	local numOfValidGroup = 0
	Entity_Find( EntityType.GROUP, function ( group )
		local numOfCity = Asset_GetListSize( group, GroupAssetID.CITY_LIST )		

		--check goal
		Asset_FindItem( group, GroupAssetID.GOAL_LIST, function ( goalData, goalType )
			if day == 1 then
				--check final goal in the 1st day of month
				if goalType == GroupGoalType.TERRIORITY then
					if numOfCity >= numOfAllCity * goalData.target then
						g_winner = group
						return goalData					
					end
				
				elseif goalType == GroupGoalType.DOMINATION then
					return nil	
				end
			end			

			if month == 12 and day == DAY_IN_MONTH then
				local achieveGoal = false

				--check short goal in last day of the year
				if goalType == GroupGoalType.OCCUPY_CITY then
					if Asset_Get( goalData.city, CityAssetID.GROUP ) == group then
						achieveGoal = true
					end

				elseif goalType == GroupGoalType.ENHANCE_CITY then
					if goalData.city:GetPopu( CityPopu.SOLDIER ) >= goalData.soldier then
						achieveGoal = true
					end

				elseif goalType == GroupGoalType.DEVELOP_CITY then
					if goalData.city:GetDevelopScore() >= goalData.devScore then
						achieveGoal = true
					end

				elseif goalType == GroupGoalType.DEFEND_CITY then
					if Asset_Get( goalData.city, CityAssetID.GROUP ) == group then
						achieveGoal = true
					end
				end

				if achieveGoal then
					group:AchieveGoal()
					--InputUtil_Pause( "achieve goal", MathUtil_FindName( GroupGoalType, goalType ) )					
					Stat_Add( "AchieveGoal@" .. MathUtil_FindName( GroupGoalType, goalType ), 1, StatType.TIMES )
				else
					group:UnfinishGoal()
					Stat_Add( "Unfinish@" .. MathUtil_FindName( GroupGoalType, goalType ), 1, StatType.TIMES )
				end

				--remove goal
				Asset_SetDictItem( group, GroupAssetID.GOAL_LIST, goalType, nil )
			end
		end )

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