--------------------------------------------------------------
-- Supply
--	 Supply corps from Encampment City
--   Supply guard from Combat Occur 
--

--------------------------------------------------------------

local function SupplyCombat( combat )	
	Asset_ForeachList( combat, CombatAssetID.TROOP_LIST, function ( troop )
		InputUtil_Pause( "Supply guard" )
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

local function SupplyCorps( corps )
	--consume
	local consume = corps:ConsumeFood()
	print( "Corps=" .. corps.id .. " consume food=" .. consume )

	--supply
	local city = Asset_Get( corps, CorpsAssetID.ENCAMPMENT )

	--InputUtil_Pause( "Supply corps", corps.id, city )
	if not city then return end	

	--Just teleport the food from city to corps now,
	--Maybe I can make it complex and reality in the future
	local need = 0
	local food = Asset_Get( city, CityAssetID.FOOD )
	if food > 0 then
		need = math.min( food, Corps_GetConsumeFood( corps ) )
		Asset_Plus( Corps, CorpsAssetID.FOOD, need )
		food = food - need
		Asset_Set( city, CityAssetID.FOOD, food )		
	end
	print( "Corps=" .. corps.id .. " supply food=" .. Asset_Get( corps, CorpsAssetID.FOOD ) .. "+" .. need, " fromcity=" .. city.name .. "=" .. food )
end

--------------------------------------------------------------

SupplySystem = class()

function SupplySystem:__init()
	System_Setup( self, SystemType.SUPPLY_SYS )
end

function SupplySystem:Start()
end

function SupplySystem:Update()
	local day = g_calendar:GetDay()

	if day % 10 == 0 then
		--Supply all troop in combat without corps
		Entity_Foreach( EntityType.COMBAT, SupplyCombat )
	end

	if day % 30 == 0 then
		--Supply all corps
		Entity_Foreach( EntityType.CORPS, SupplyCorps )
	end
end