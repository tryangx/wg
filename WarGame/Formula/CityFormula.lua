function City_GetSoldier( city )
	--corps in city
	local soldier = 0
	Asset_ForeachList( city, CityAssetID.CORPS_LIST, function ( corps )
		Asset_ForeachList( corps, CorpsAssetID.TROOP_LIST, function( troop )
			soldier = soldier + Asset_Get( troop, TroopAssetID.SOLDIER )
		end )
	end )

	return soldier
end

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
	local popustparams = Scenario_GetData( "CITY_POPUSTRUCTURE_PARAMS" )[1]
	local agr = Asset_Get( city, CityAssetID.AGRICULTURE )
	local farmer = Asset_GetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu.FARMER )
	local useagr = math.ceil( farmer / popustparams.POPU_PER_UNIT.FARMER )
	local supportPopu = math.ceil( useagr * PlotParams.FOOD_PER_AGRICULTURE / GlobalTime.TIME_PER_YEAR )
	local maxSupport = math.ceil( agr * PlotParams.FOOD_PER_AGRICULTURE / GlobalTime.TIME_PER_YEAR )
	local popu = Asset_Get( city, CityAssetID.POPULATION )
	print( city.name .. "popu=" .. popu .. "/" .. supportPopu .. "(" .. math.ceil( popu * 100 / supportPopu ) .. "%)" .. " Max:" .. maxSupport .. "(" .. math.ceil( popu * 100 / maxSupport ) .. "%)" )
	return popu
end

-----------------------------------------------

function City_GetPopuParams( city )
return Scenario_GetData( "CITY_POPUSTRUCTURE_PARAMS" )[1]
end

function City_GetPopuTypeByDevIndex( id )
	if id == CityAssetID.AGRICULTURE then
		return "FARMER"
	elseif id == CityAssetID.COMMERCE then
		return "MERCHANT"
	elseif id == CityAssetID.PRODUCTION then
		return "WORKER"
	end
	return "NONE"
end

-- Measure how many population in every career required by the development index.
function City_NeedPopu( city, poputype )
	local cityparams = City_GetPopuParams( city )
	local needparam  = cityparams.POPU_NEED_RATIO
	local unitparam  = cityparams.POPU_PER_UNIT

	--some career needs the fixed ratio of the total population
	if needparam[poputype] then
		local popu   = Asset_Get( city, CityAssetID.POPULATION )
		return math.floor( needparam[poputype] * popu )
	end

	--some career needs the number of population per development index 
	if poputype == "FARMER" then
		return Asset_Get( city, CityAssetID.AGRICULTURE ) * unitparam[poputype]
	elseif poputype == "WORKER" then
		return Asset_Get( city, CityAssetID.PRODUCTION ) * unitparam[poputype]
	elseif poputype == "MERCHANT" then
		return Asset_Get( city, CityAssetID.COMMERCE ) * unitparam[poputype]
	end
	
	return 0
end

function City_NeedDevIndex( city, id )
	local cityparams = City_GetPopuParams( city )
	local unitparam  = cityparams.POPU_PER_UNIT

	if id == CityAssetID.AGRICULTURE then
		return math.ceil( Asset_Get( city, CityAssetID.AGRICULTURE ) / unitparam.FARMER )
	elseif id == CityAssetID.COMMERCE then
		return math.ceil( Asset_Get( city, CityAssetID.COMMERCE ) / unitparam.MERCHANT )
	elseif id == CityAssetID.PRODUCTION then
		return math.ceil( Asset_Get( city, CityAssetID.PRODUCTION ) / unitparam.WORKER )
	end

	return 0
end

---------------------------------------------