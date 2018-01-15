
--Get military power evaluation
function City_GetMilitaryPower( city )
	--corps in city
	local power = 0
	Asset_ForeachList( city, CityAssetID.CORPS_LIST, function ( corps )
		Asset_ForeachList( corps, CorpsAssetID.TROOP_LIST, function( troop )
			power = power + Asset_Get( troop, TroopAssetID.SOLDIER ) * TroopTable_GetPower( troop )
		end )
	end )

	--reserved

	return power
end

--Get military power evaluation under intel report
function City_GetMilitaryPowerWithIntel( city, fromGroup )
	local power = City_GetMilitaryPower( city )
	return power
end

--Get corps support limitation in city
function City_GetCorpsLimit( city )
	local limit = 1
	return limit
end

--function City_GetCity
function City_GetSupportPopu( city )
	local popustparams = GetScenarioData( "CITY_POPUSTRUCTURE_PARAMS" )[1]
	local agr = Asset_Get( city, CityAssetID.AGRICULTURE )
	local farmer = Asset_GetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu.FARMER )
	local useagr = math.ceil( farmer / popustparams.POPU_PER_UNIT.FARMER )
	local supportPopu = math.ceil( useagr * PlotParams.FOOD_PER_AGRICULTURE / GlobalTime.TIME_PER_YEAR )
	local maxSupport = math.ceil( agr * PlotParams.FOOD_PER_AGRICULTURE / GlobalTime.TIME_PER_YEAR )
	local popu = Asset_Get( city, CityAssetID.POPULATION )
	print( city.name .. "popu=" .. popu .. "/" .. supportPopu .. "(" .. math.ceil( popu * 100 / supportPopu ) .. "%)" .. " Max:" .. maxSupport .. "(" .. math.ceil( popu * 100 / maxSupport ) .. "%)" )
	return popu
end