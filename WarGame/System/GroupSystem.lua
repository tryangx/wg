function Group_FormulaInit()
	GroupGovernmentData = MathUtil_ConvertKey2ID( GroupGovernmentData, GroupGovernment )
end
	
function Group_SeizeCity( group, city )
	local oldGroup = Asset_Get( city, CityAssetID.GROUP )
	if oldGroup == group then
		error( "city="..city.name," already is under control by group=" .. group.name )
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

function Group_FindFitGrade( group )
	local influence  = group:GetInfluence()
	local reputation = group:GetReputation()
	local grade
	for _, param in pairs( GroupGradeParams ) do
		local valid = true
		local cond = param.prerequisite
		if cond then
			--MathUtil_Dump( cond )
			--print( "find fit", param.grade )
			if valid == true and cond.reputation and cond.reputation > reputation then valid = false end
			if valid == true and cond.influence and cond.influence > influence then valid = false end
			if valid == true and cond.province and cond.province > group:GetProvince() then valid = false end
			if valid == true and cond.ally_city_ratio_in_continent then end
			if valid == true and cond.ally_city_ratio_in_world then end			
		end
		if valid == true and ( not grade or grade < param.grade ) then grade = param.grade end
	end
	return grade
end

-----------------------------------------

GroupSystem = class()

function GroupSystem:__init()
	System_Setup( self, SystemType.GROUP_SYS )
end

function GroupSystem:Start()
end

function GroupSystem:Update()
	local day = g_Time:GetDay()
	Entity_Foreach( EntityType.GROUP, function ( group )
		group:Update()

		if day == DAY_IN_MONTH then
			group:UpdateSpy()
			--Stat_Add( "GroupStatus@" .. group.name, g_Time:ToString() .. " " .. group:ToString( "POWER" ), StatType.LIST )
		end

		if day == DAY_IN_MONTH then
			group:UpdateInfluences()
			group:UpdateReputations()
		end
	end )
end