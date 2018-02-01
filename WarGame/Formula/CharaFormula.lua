function Chara_GetLimitByGroup( group )
	if not group then return 0 end
	local government = Asset_Get( group, GroupAssetID.GOVERNMENT )
	print( "gov=" .. MathUtil_FindName( GroupGovernment, government ) )
	return GroupGovernmentData[government].CAPITAL_CHARA_LIMIT
end

function Chara_GetLimitByCity( city )
	if not city then return 0 end
	if city:IsCapital() then return -1 end
	local lv = Asset_Get( city, CityAssetID.LEVEL )	
	local ret = math.ceil( lv / 4 ) + 1
	DBG_Warning( "chara_limit_bycity", ret )
	return ret
end
