--return days
function Move_CalcCorpsMoveDuration( corps, from, to )
	local distance = Route_QueryPathDistance( from, to )
	local movement = Asset_Get( corps, CorpsAssetID.MOVEMENT )
	return math.ceil( distance / movement )
end