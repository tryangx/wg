function Group_FormulaInit()
	GroupGovernmentData = MathUtil_ConvertKey2ID( GroupGovernmentData, GroupGovernment )
	MathUtil_Dump( newDatas )
end

---------------------------------------

function Group_GetCharaLimit( group )
	if not group then return 0 end
	local numofcities = Asset_GetListSize( group, GroupAssetID.CITY_LIST )
	local government = Asset_Get( group, GroupAssetID.GOVERNMENT )
--	print( "gov=" .. MathUtil_FindName( GroupGovernment, government ) )
	return GroupGovernmentData[government].CAPITAL_CHARA_LIMIT
end