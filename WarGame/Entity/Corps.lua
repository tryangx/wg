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
	MOVEMENT       = 121,

	TASKS          = 130,

	FOOD           = 200,
	MATERIAL       = 201,
}

local function Corps_SetTroop( entity, id, value )
	local troop = Entity_SetTroop( entity, id, value )
	if troop and typeof( troop ) ~= "number" then
		Asset_Set( entity, CorpsAssetID.OFFICER_LIST, Asset_Get( troop, TroopAssetID.OFFICER ) )
	end
	return troop
end

local function Corps_RecalMovement( entity, id, value )
	--recalculate movement
	local movement = Asset_Get( entity, CorpsAssetID.MOVEMENT )
	local troopmove = Asset_Get( value, TroopAssetID.MOVEMENT )
	if troopmove < movement or movement == 0 then
		Asset_Set( entity, CorpsAssetID.MOVEMENT, troopmove )
	end
end

CorpsAssetAttrib =
{
	group      = AssetAttrib_SetPointer    ( { id = CorpsAssetID.GROUP,         type = CorpsAssetType.BASE_ATTRIB, setter = Entity_SetGroup } ),
	leader     = AssetAttrib_SetPointer    ( { id = CorpsAssetID.LEADER,        type = CorpsAssetType.BASE_ATTRIB, setter = Entity_SetChara } ),
	troops     = AssetAttrib_SetPointerList( { id = CorpsAssetID.TROOP_LIST,    type = CorpsAssetType.BASE_ATTRIB, setter = Corps_SetTroop, changer = Corps_RecalMovement } ),	
	officers   = AssetAttrib_SetPointerList( { id = CorpsAssetID.OFFICER_LIST,  type = CorpsAssetType.BASE_ATTRIB, setter = Entity_SetChara } ),
	location   = AssetAttrib_SetPointer    ( { id = CorpsAssetID.LOCATION,      type = CorpsAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	encampment = AssetAttrib_SetPointer    ( { id = CorpsAssetID.ENCAMPMENT,    type = CorpsAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),	
	template   = AssetAttrib_SetPointer    ( { id = CorpsAssetID.TEMPLATE,      type = CorpsAssetType.BASE_ATTRIB } ),
	movement   = AssetAttrib_SetNumber     ( { id = CorpsAssetID.MOVEMENT,      type = CorpsAssetType.BASE_ATTRIB, default = 0 } ),

	statuses   = AssetAttrib_SetPointerList( { id = CorpsAssetID.STATUSES,      type = CorpsAssetType.BASE_ATTRIB } ),
	tasks      = AssetAttrib_SetPointerList( { id = CorpsAssetID.TASKS,         type = CorpsAssetType.BASE_ATTRIB } ),

	food       = AssetAttrib_SetNumber     ( { id = CorpsAssetID.FOOD,          type = CorpsAssetType.PROPERTY_ATTRIB, default = 0 } ),
	material   = AssetAttrib_SetNumber     ( { id = CorpsAssetID.MATERIAL,      type = CorpsAssetType.PROPERTY_ATTRIB, default = 0 } ),
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
end

-------------------------------------------

function Corps:ToString( type )
	local content = "[" .. self.name .. "]"	
	if type == "SIMPLE"	then
		content = content .. Asset_Get( self, CorpsAssetID.LOCATION ):ToString()
		--content = content .. " trp=" .. Asset_GetListSize( self, CorpsAssetID.TROOP_LIST )
	elseif type == "ALL"	then
		content = content .. " grp=" .. String_ToStr( Asset_Get( self, CorpsAssetID.GROUP ), "name" )
		local leader = Asset_Get( self, CorpsAssetID.LEADER )
		if leader then
			content = content .. leader:ToString()
		end
		content = content .. Asset_Get( self, CorpsAssetID.LOCATION ):ToString()
		content = content .. " trp=" .. Asset_GetListSize( self, CorpsAssetID.TROOP_LIST )
		content = content .. " soldier=" .. self:GetSoldier()
	elseif type == "BRIEF" then		
		local leader = Asset_Get( self, CorpsAssetID.LEADER )
		if leader then
			content = content .. leader:ToString()
		end
		content = content .. " soldier=" .. self:GetSoldier()
		Asset_ForeachList( self, CorpsAssetID.TROOP_LIST, function( troop )
			content = content .. " " .. troop:ToString( type )
		end)
	elseif type == "MILITARY" then
		content = content .. " trp=" .. Asset_GetListSize( self, CorpsAssetID.TROOP_LIST )
		content = content .. " soldier=" .. self:GetSoldier()
	elseif type == "POSITION" then
		content = content .. " loc=" .. Asset_Get( self, CorpsAssetID.LOCATION ):ToString()
	elseif type == "MAINTAIN" then
		local food = Asset_Get( self, CorpsAssetID.FOOD )
		local consume = self:GetConsumeFood()
		local foodDays = math.ceil( food / consume )
		print( self.name, "food supply=" .. foodDays .. "Days" )
		content = content .. " suply" .. foodDays .. "/" .. foodDays
	end
	return content
end

-------------------------------------------

function Corps:GetTraining()
	local total = 0
	local number = 0
	Asset_ForeachList( self, CorpsAssetID.TROOP_LIST, function ( troop )
		total = total + Asset_Get( troop, TroopAssetID.TRAINING )
		number = number + 1
	end )
	total = math.ceil( total / number )
	return total
end

---------------------------------------------
-- Getter
function Corps:GetSoldier()
	local number = 0
	local maxNumber = 0
	Asset_ForeachList( self, CorpsAssetID.TROOP_LIST, function ( troop )
		number = number + Asset_Get( troop, TroopAssetID.SOLDIER )
		maxNumber = maxNumber + Asset_Get( troop, TroopAssetID.MAX_SOLDIER )
	end )
	return number,  maxNumber
end

function Corps:GetConsumeFood()
	local foodConsume = 0
	Asset_ForeachList( self, CorpsAssetID.TROOP_LIST, function( troop )
		local soldier = Asset_Get( troop, TroopAssetID.SOLDIER )
		local table = Asset_Get( troop, TroopAssetID.TABLEDATA )
		foodConsume = foodConsume + soldier * table.consume.FOOD
	end)
	return foodConsume
end

function Corps:GetFoodCapacity()
	local foodCapacity = 0
	Asset_ForeachList( self, CorpsAssetID.TROOP_LIST, function( troop )
		local soldier = Asset_Get( troop, TroopAssetID.SOLDIER )
		local table = Asset_Get( troop, TroopAssetID.TABLEDATA )
		foodCapacity = foodCapacity + soldier * table.capacity.FOOD
	end)
	return foodCapacity
end

function Corps:GetNeedFood( )
	-- body
end

-------------------------------------------
-- 

function Corps:IsAtHome()
	local location   = Asset_Get( self, CorpsAssetID.LOCATION )
	local encampment = Asset_Get( self, CorpsAssetID.ENCAMPMENT )
	return location == encampment
end

function Corps:IsBusy()
	local status = Asset_GetListItem( self, CorpsAssetID.STATUSES, CorpsStatus.IN_TASK )
	if not status then return false end
	return status ~= false
end

---------------------------------------------

function Corps:Update( ... )
end

-------------------------------------------

function Corps:AddTroop( troop )
	Asset_AppendList( self, CorpsAssetID.TROOP_LIST, troop )
end

function Corps:RemoveTroop( troop )
	Asset_RemoveListItem( self, CorpsAssetID.TROOP_LIST, troop )
end

function Corps:LoseOfficer( officer )
	Asset_RemoveListItem( self, CorpsAssetID.OFFICER_LIST, officer )
end

-------------------------------------------
-- handler

function Corps:Starvation()
	Asset_ForeachList( self, CorpsAssetID.TROOP_LIST, function( troop )
		troop:Starvation()
	end)
end

--consume carried food
function Corps:ConsumeFood( consume )
	local foodConsume = self:GetConsumeFood()
	local food = Asset_Get( self, CorpsAssetID.FOOD )
	if food >= foodConsume then
		Asset_ForeachList( self, CorpsAssetID.TROOP_LIST, function( troop )
			troop:ConsumeFood()
		end)
		Asset_Set( self, CorpsAssetID.FOOD, food - foodConsume )		
		--self:DumpMaintain()
		--InputUtil_Pause( self.name, "consume=" .. foodConsume, "left=" .. food - foodConsume )
		--Stat_Add( "ConsumeFood@Corps_" .. self.id, foodConsume, StatType.ACCUMULATION )
		return foodConsume
	end

	--starvation
	Asset_Set( self, CorpsAssetID.FOOD, 0 )
	self:Starvation()

	return food
end

-------------------------------------------

--return the food need carried to move to destination
function Corps_CalcNeedFood( corps, destination )
	local from = Asset_Get( corps, CorpsAssetID.LOCATION )
	local days = Move_CalcCorpsMoveDuration( corps, from, destination )
	--need food when back
	local needfood = corps:GetConsumeFood() * days * 2
	local hasfood  = Asset_Get( corps, CorpsAssetID.FOOD )
	return needfood - hasfood
end