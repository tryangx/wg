CorpsAssetType = 
{
	BASE_ATTRIB     = 1,
	PROPERTY_ATTRIB = 2,
	GROWTH_ATTRIB   = 3,
}

CorpsAssetID = 
{
	GROUP          = 101,
	LEADER         = 102,
	TROOP_LIST     = 103,
	OFFICER_LIST   = 104,
	LOCATION       = 110,
	ENCAMPMENT     = 111,
	STATUSES       = 112,
	TEMPLATE       = 120,

	FOOD           = 200,
	MATERIAL       = 201,
	
	TRAINING       = 300,
}

local function Corps_SetTroop( entity, id, value )
	local troop = Entity_SetTroop( entity, id, value )
	if troop and typeof( troop ) ~= "number" then
		Asset_Set( entity, CorpsAssetID.OFFICER_LIST, Asset_Get( troop, TroopAssetID.LEADER ) )
	end
	return troop
end

CorpsAssetAttrib =
{
	group      = AssetAttrib_SetPointer    ( { id = CorpsAssetID.GROUP,         type = CorpsAssetType.BASE_ATTRIB, setter = Entity_SetGroup } ),
	leader     = AssetAttrib_SetPointer    ( { id = CorpsAssetID.LEADER,        type = CorpsAssetType.BASE_ATTRIB, setter = Entity_SetChara } ),
	troops     = AssetAttrib_SetPointerList( { id = CorpsAssetID.TROOP_LIST,    type = CorpsAssetType.BASE_ATTRIB, setter = Corps_SetTroop } ),	
	officers   = AssetAttrib_SetPointerList( { id = CorpsAssetID.OFFICER_LIST,  type = CorpsAssetType.BASE_ATTRIB, setter = Entity_SetChara } ),
	location   = AssetAttrib_SetPointer    ( { id = CorpsAssetID.LOCATION,      type = CorpsAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	encampment = AssetAttrib_SetPointer    ( { id = CorpsAssetID.ENCAMPMENT,    type = CorpsAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),	
	template   = AssetAttrib_SetPointer    ( { id = CorpsAssetID.TEMPLATE,      type = CorpsAssetType.BASE_ATTRIB } ),
	statuses   = AssetAttrib_SetPointerList( { id = CorpsAssetID.STATUSES,      type = CorpsAssetType.BASE_ATTRIB } ),

	food       = AssetAttrib_SetNumber     ( { id = CorpsAssetID.FOOD,          type = CorpsAssetType.PROPERTY_ATTRIB, default = 0 } ),
	material   = AssetAttrib_SetNumber     ( { id = CorpsAssetID.MATERIAL,      type = CorpsAssetType.PROPERTY_ATTRIB, default = 0 } ),

	training   = AssetAttrib_SetNumber     ( { id = CorpsAssetID.TRAINING,      type = CorpsAssetType.GROWTH_ATTRIB, default = 0 } ),
}


-------------------------------------------


Corps = class()

function Corps:__init()
	Entity_Init( self, EntityType.CORPS, CorpsAssetAttrib )
end

function Corps:Load( data )
	self.id = data.id
	self.name = data.name

	Asset_Set( self, CorpsAssetID.GROUP,      data.group )
	Asset_Set( self, CorpsAssetID.LEADER,     data.leader )
	Asset_Set( self, CorpsAssetID.TROOP_LIST, data.troops )
	Asset_Set( self, CorpsAssetID.LOCATION,   data.location )
	Asset_Set( self, CorpsAssetID.ENCAMPMENT, data.encampment )

	Asset_Set( self, CorpsAssetID.TRAINING,   data.training )
end

function Corps:Breif()
	local number = 0
	Asset_ForeachList( self, CorpsAssetID.TROOP_LIST, function( troop )
		print( troop )
		number = number + Asset_Get( troop, TroopAssetID.SOLDIER )
	end)
	return self.name .. "[" .. self.id ..  "] Num=" .. number
end

function Corps:Starvation()
	Asset_ForeachList( self, CorpsAssetID.TROOP_LIST, function( troop )
		troop:Starvation()
	end)
end

function Corps:ConsumeFood()
	local foodConsume = Corps_GetConsumeFood( self )
	local food = Asset_Get( self, CorpsAssetID.FOOD )
	if food >= foodConsume then
		Asset_ForeachList( self, CorpsAssetID.TROOP_LIST, function( troop )
			troop:ConsumeFood()
		end)
		Asset_Set( self, CorpsAssetID.FOOD, food - foodConsume )
		return foodConsume
	end
	Asset_Set( self, CorpsAssetID.FOOD, 0 )
	self:Starvation()
	return food
end

function Corps:Update( ... )
end

-------------------------------------------

function Corps_GetConsumeFood( corps )
	local foodConsume = 0
	Asset_ForeachList( corps, CorpsAssetID.TROOP_LIST, function( troop )
		local soldier = Asset_Get( troop, TroopAssetID.SOLDIER )
		local table = Asset_Get( troop, TroopAssetID.TABLEDATA )
		foodConsume = foodConsume + soldier * table.consume.FOOD
	end)
	return foodConsume
end