--------------------------------------------------------------
-- Supply
--   #Concept
--     1. Corps don't consume food in Encampment
--     2. Corps will carry food when leave encampment
--
--------------------------------------------------------------

 function Supply_CorpsHasEnoughFood( fromcity, destcity, corps )
	local food = Asset_Get( fromcity, CityAssetID.FOOD )
	local needfood = Corps_CalcNeedFood( corps, destcity )
	if FeatureOption.ENABLE_FOOD_SUPPLY == 0 then return true end
	return food >= needfood
end

function Supply_CorpsCarryFood( corps, destcity )
	local loc =  Asset_Get( corps, CorpsAssetID.LOCATION )
	local foodNeeded = Corps_CalcNeedFood( corps, destcity )
	local foodInCity = Asset_Get( loc, CityAssetID.FOOD )
	--InputUtil_Pause( "carry food need=" .. foodNeeded, " cityhas=" .. foodInCity )
	if foodInCity < foodNeeded then return false end
	Asset_Set( loc, CityAssetID.FOOD, foodInCity - foodNeeded )
	Asset_Plus( corps, CorpsAssetID.FOOD, foodNeeded )
	--corps:DumpMaintain()
	--InputUtil_Pause( corps.name, "carry food from", loc.name, "need=" .. foodNeeded, " cityfood=" .. foodInCity - foodNeeded )
	return true
end

--[[
--discard this concept
local function Supply_ConsumeFoodInCombat( combat )
	Asset_ForeachList( combat, CombatAssetID.TROOP_LIST, function ( troop )
		local corps = Asset_Get( troop, TroopAssetID.CORPS )
		if corps then return end

		local city = Asset_Get( troop, TroopAssetID.ENCAMPMENT )
		if not city then return end

		--consume
		local consume = Troop_GetConsumeFood( troop )
		local food = Asset_Get( city, CityAssetID.FOOD )		
		if food > consume * 0.3 then
			troop:ConsumeFood( math.min( food, consume ) )
			food = math.max( 0, food - consume )
			Asset_Set( city, CityAssetID.FOOD, food )
		else
			troop:Starvation()
		end
	end )
end
]]


--
local function Supply_CorpsConsumeFood( corps )
	local foodConsume = corps:ConsumeFood()
	if corps:IsAtHome() then
		--don't consume food in encampment		
		return
	else
		--consume carried food
		corps:ConsumeFood()
	end	
end

--
local function Supply_CorpsGainFood( corps )
	--supply
	local city = Asset_Get( corps, CorpsAssetID.ENCAMPMENT )	
	if not city then return end

	local food = Asset_Get( city, CityAssetID.FOOD )
	if food <= 0 then return end
	local need = math.min( food, corps:GetFoodCapacity() )

	--print( "Corps=" .. corps.id .. " supply food=" .. Asset_Get( corps, CorpsAssetID.FOOD ) .. "+" .. need, " fromcity=" .. city.name .. "=" .. food )
	--InputUtil_Pause( "Supply corps", corps.id, city )
	
	Asset_Plus( corps, CorpsAssetID.FOOD, need )
	Asset_Set( city, CityAssetID.FOOD, food - need )

	--Stat_Add( "Supply@Corps_" .. corps.id, need, StatType.ACCUMULATION )
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

	Entity_Foreach( EntityType.CORPS, Supply_CorpsConsumeFood )

	if day % 10 == 0 then
		--Supply all corps
		Entity_Foreach( EntityType.CORPS, Supply_CorpsGainFood )
	end

	if day % 10 == 0 then
		--Supply all troop in combat without corps
		--Entity_Foreach( EntityType.COMBAT, Supply_ConsumeFoodInCombat )
	end
end