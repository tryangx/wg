--------------------------------------------------------------
-- Supply
--   #Concept
--     1. Corps don't consume food in Encampment( canceled )
--     2. Corps will carry food when leave encampment
--
--------------------------------------------------------------

------------------------------------------------------
-- Calculate the food corps carried to dispatch
------------------------------------------------------
function Supply_HasEnoughFoodForCorps( fromcity, destcity, corps )
	if FeatureOption.DISABLE_FOOD_SUPPLY then return true end

	local hasFood = Asset_Get( fromcity, CityAssetID.FOOD ) + Asset_Get( corps, CorpsAssetID.FOOD )
	--should carry more than 30 days food
	local needFood = Corps_CalcNeedFood( corps, destcity )

	--print( fromcity:ToString(), "has=" .. hasFood, "need=" .. needFood, corps:ToString("MILITARY") )

	return hasFood >= needFood
end

function Supply_HasEnoughFoodForCorpsList( fromcity, destcity, list )
	if FeatureOption.DISABLE_FOOD_SUPPLY then return true end

	local hasFood = Asset_Get( fromcity, CityAssetID.FOOD )
	--should carry more than 30 days food
	local needFood = 0
	for _, corps in ipairs( list ) do
		hasFood  = hasFood + Asset_Get( corps, CorpsAssetID.FOOD )
		needFood = needFood + Corps_CalcNeedFood( corps, destcity )
	end

	--print( fromcity:ToString(), "has=" .. hasFood, "need=" .. needFood, corps:ToString("MILITARY") )

	return hasFood >= needFood
end

function Supply_CorpsCarryFood( corps, destcity )
	local needFood = Corps_CalcNeedFood( corps, destcity )

	local loc =  Asset_Get( corps, CorpsAssetID.LOCATION )
	local corpsFood = Asset_Get( corps, CorpsAssetID.FOOD )

	if corpsFood >= needFood then
		return true
	end

	local cityFood  = Asset_Get( loc, CityAssetID.FOOD )
	if needFood > cityFood + corpsFood then
		needFood = cityFood
	end
	
	local capacity = corps:GetFoodCapacity()
	if needFood > capacity then
		needFood = capacity
	end
	
	Asset_Set( loc, CityAssetID.FOOD, cityFood - needFood )
	Asset_Plus( corps, CorpsAssetID.FOOD, needFood )
	--InputUtil_Pause( corps.name, "carry food from", loc.name, "need=" .. needFood, " cityfood=" .. cityFood - needFood )
	return true
end

function Supply_CorpsCarryMaterial( corps )	
	local capcity = corps:GetMaterialCapacity()
	local needMat = capcity - Asset_Get( corps, CorpsAssetID.MATERIAL )
	if needMat <= 0 then
		return true
	end

	local loc =  Asset_Get( corps, CorpsAssetID.LOCATION )
	local hasMat  = Asset_Get( loc, CityAssetID.MATERIAL )	
	if needMat > hasMat then needMat = hasMat end

	Asset_Set( loc, CityAssetID.MATERIAL, hasMat - needMat )
	Asset_Plus( corps, CorpsAssetID.MATERIAL, needMat )
	--InputUtil_Pause( corps.name, "carry mat from", loc.name, "need=" .. needMat, " citymat=" .. hasMat - needMat )

	return true
end

local function Supply_CityConsumeFood( city )
	local consumeFood = city:GetConsumeFood() * g_elapsed
	city:ConsumeFood( consumeFood )
end

local function Supply_CorpsConsumeFood( corps )
	corps:ConsumeFood( corps:GetConsumeFood() )
end

--replenish the food from city
local function Supply_CorpsReplenish( corps )
	local encampment = Asset_Get( corps, CorpsAssetID.ENCAMPMENT )
	if not encampment then return end

	local corpsFood = Asset_Get( corps, CorpsAssetID.FOOD )
	local corpsMat  = Asset_Get( corps, CorpsAssetID.MATERIAL )
	local hasFood   = Asset_Get( encampment, CityAssetID.FOOD )
	local hasMat    = Asset_Get( encampment, CityAssetID.MATERIAL )	
	local needFood  = math.min( hasFood, corps:GetFoodCapacity() - corpsFood )
	local needMat   = math.min( hasMat, corps:GetMaterialCapacity() - corpsMat )
	if not corps:IsAtHome() then
		local depatureTime = Asset_SetDictItem( corps, CorpsAssetID.STATUSES, CorpsStatus.DEPATURE_TIME )
		local diffDays = g_Time:CalcDiffDayByDate( depatureTime )
		if diffDays % 10 == 1 then
			local transFood, transMoney, transMat = encampment:GetTransCapacity()
			local transEff  = 0.8
			needMat   = math.ceil( math.min( transMat, needMat ) * transEff )
			needFood  = math.ceil( math.min( transFood, needFood ) * transEff )
		else
			--in delivery
			return
		end
	else
		needMat = 0		
	end

	Asset_Set( corps, CorpsAssetID.FOOD, corpsFood + needFood )
	Asset_Set( corps, CorpsAssetID.MATERIAL, corpsMat + needMat )
	Asset_Set( encampment, CityAssetID.FOOD, hasFood - needFood )
	Asset_Set( encampment, CityAssetID.MATERIAL, hasMat - needMat )
end


local function Supply_UpdateCorps( corps )
	corps:PaySalary()

	Supply_CorpsReplenish( corps )
	Supply_CorpsConsumeFood( corps )
end

--------------------------------------------------------------

SupplySystem = class()

function SupplySystem:__init()
	System_Setup( self, SystemType.SUPPLY_SYS )
end

function SupplySystem:Start()
end

function SupplySystem:Update()
	local day = g_Time:GetDay()
	
	Entity_Foreach( EntityType.CORPS, Supply_UpdateCorps )

	if day % 30 == 1 then		
		Entity_Foreach( EntityType.CITY, Supply_CityConsumeFood )
	end
end