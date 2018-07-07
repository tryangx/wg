BonusType =
{
	NONE         = 0,

	--Plot & Resource
	AGRICULTURE  = 2,
	COMMERCE     = 3,
	PRODUCTION   = 4,
}


--------------------------------------

function Table_CalculateBonuses( bonuses, datas )
	if not datas then return end
	for k, bonus in pairs( datas ) do
		local type = BonusType[bonus.type]
		if type then
			if not bonuses[type] then
				bonuses[type] = bonus.value
			else
				bonuses[type] = bonuses[type] + bonus.value
			end
		else
			Debug_Log( "Invalid Bonus Type=", bonus.type )
		end		
	end
end

function Table_ConvertConditions( datas )	
	local conditions = MathUtil_Copy( datas )
	for k, condition in ipairs( conditions ) do
		condition.type = ResourceCondition[condition.type]
		if condition.type == ResourceCondition.CONDITION_BRANCH then
			Table_ConvertConditions( condition.value )
		end
	end	
end