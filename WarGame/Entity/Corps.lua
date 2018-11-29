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
		Asset_AppendList( entity, CorpsAssetID.OFFICER_LIST, Asset_Get( troop, TroopAssetID.OFFICER ) )
	end
	return troop
end

local function Corps_RecalMovement( entity, id, value )
	--recalculate movement
	local movement = Asset_Get( entity, CorpsAssetID.MOVEMENT )
	local troopmove = value:GetMovement()
	--troopmove = math.ceil( troopmove * ( 100 + Chara_GetSkillEffectValue( Asset_Get( value, TroopAssetID.OFFICER ), CharaSkillEffect.MOVEMENT_BONUS ) * 0.01 ) )
	if troopmove < movement or movement == 0 then
		Asset_Set( entity, CorpsAssetID.MOVEMENT, troopmove )
	end
end

local function DebugChara( entity, id, value )
	if value and value:GetStatus( CharaStatus.DEAD ) then
		error( value.name .. " is dead")
	end
	if typeof( value ) == "number" then
		error( "sdf")
	end
	print( "set value=", value )
	return Entity_SetChara( entity, id, value )
end

CorpsAssetAttrib =
{
	group      = AssetAttrib_SetPointer    ( { id = CorpsAssetID.GROUP,         type = CorpsAssetType.BASE_ATTRIB, setter = Entity_SetGroup } ),
	leader     = AssetAttrib_SetPointer    ( { id = CorpsAssetID.LEADER,        type = CorpsAssetType.BASE_ATTRIB, setter = DebugChara } ),
	troops     = AssetAttrib_SetPointerList( { id = CorpsAssetID.TROOP_LIST,    type = CorpsAssetType.BASE_ATTRIB, setter = Corps_SetTroop, changer = Corps_RecalMovement } ),	
	officers   = AssetAttrib_SetPointerList( { id = CorpsAssetID.OFFICER_LIST,  type = CorpsAssetType.BASE_ATTRIB, setter = Entity_SetChara } ),
	location   = AssetAttrib_SetPointer    ( { id = CorpsAssetID.LOCATION,      type = CorpsAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	encampment = AssetAttrib_SetPointer    ( { id = CorpsAssetID.ENCAMPMENT,    type = CorpsAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),	
	template   = AssetAttrib_SetPointer    ( { id = CorpsAssetID.TEMPLATE,      type = CorpsAssetType.BASE_ATTRIB } ),
	movement   = AssetAttrib_SetNumber     ( { id = CorpsAssetID.MOVEMENT,      type = CorpsAssetType.BASE_ATTRIB, default = 0 } ),

	statuses   = AssetAttrib_SetDict       ( { id = CorpsAssetID.STATUSES,      type = CorpsAssetType.BASE_ATTRIB } ),

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
	local content = "[" .. ( self.name or "" ) .. "](" .. self.id .. ")"
	local leader = Asset_Get( self, CorpsAssetID.LEADER )
	if leader then
		content = content .. leader:ToString()
	end

	local loc = Asset_Get( self, CorpsAssetID.LOCATION )
	local enc = Asset_Get( self, CorpsAssetID.LOCATION )
	content = content .. " @=" .. ( loc and loc:ToString() or "--" ) .."/" .. ( enc and enc:ToString() or "--" )

	if type == "ALL" then
		content = content .. " maxtrp=" .. Corps_GetTroopNumber( self )
		content = content .. " maxsol=" .. Corps_GetSolderNumber( self )
	end

	if type == "SIMPLE" or type == "ALL" then
		content = content .. " ld=" .. String_ToStr( Asset_Get( self, CorpsAssetID.LEADER ), "name" )		
	end

	if type == "TASK" then
		local task = self:GetTask()
		if task then
			content = content .. " task=" .. task.id
		end
	end
	
	if type == "STATUS" or type == "ALL" then
		if leader then
			local ldTask = leader:GetTask()
			if ldTask then
				content = content .. " ld_task=" .. ldTask:ToString()
			else
				content = content .. " ld_task=no"
			end
		end
		local task = self:GetTask()
		if task then
			content = content .. " task=" .. task:ToString()
		end
		local combat = self:GetStatus( CorpsStatus.IN_COMBAT )
		if combat then
			content = content .. " combat=" .. combat
		end		
		content = content .. ( self:GetStatus( CorpsStatus.DISMISSED ) and "dismissed" or " " )
		content = content .. " " .. ( self:IsAtHome() and "athome" or "outside" )
		content = content .. " " .. ( self:IsBusy() and "busy" or "idle" )
		content = content .. " " .. ( Move_IsMoving( self ) and "moving" or "stay" )		
		local soldier, maxSoldier = self:GetSoldier()
		content = content .. " soldier=" .. soldier .. "/" .. maxSoldier
	end

	if type == "OFFICER" then
		content = content .. " ldr=" .. String_ToStr( Asset_Get( self, CorpsAssetID.LEADER ), "name" )
		Asset_Foreach( self, CorpsAssetID.OFFICER_LIST, function( chara )
			content = content .. " " .. chara:ToString()
		end)	
	end
	
	if type == "BRIEF" then
		content = content .. " loc=" .. Asset_Get( self, CorpsAssetID.LOCATION ):ToString()
		content = content .. " camp=" .. Asset_Get( self, CorpsAssetID.ENCAMPMENT ):ToString()
		content = content .. " ld=" .. String_ToStr( Asset_Get( self, CorpsAssetID.LEADER ), "name" )
		content = content .. " of=" .. 	Asset_GetListSize( self, CorpsAssetID.OFFICER_LIST )
		content = content .. " soldier=" .. self:GetSoldier()
		Asset_Foreach( self, CorpsAssetID.TROOP_LIST, function( troop )
			content = content .. " " .. troop:ToString( type )
		end)	
	
	elseif type == "POSITION" then
		content = content .. " @" .. Asset_Get( self, CorpsAssetID.LOCATION ):ToString() .."/" .. Asset_Get( self, CorpsAssetID.ENCAMPMENT ):ToString()
	
	elseif type == "MAINTAIN" then
		local food = Asset_Get( self, CorpsAssetID.FOOD )
		local consume = self:GetConsumeFood()
		local foodDays = math.ceil( food / consume )
		print( self.name, "food supply=" .. foodDays .. "Days" )
		content = content .. " suply" .. foodDays .. "/" .. foodDays
	end

	if type == "MILITARY" or type == "ALL" then
		content = content .. " trp=" .. Asset_GetListSize( self, CorpsAssetID.TROOP_LIST )
		local soldier, maxSoldier = self:GetSoldier()
		content = content .. " soldier=" .. soldier .. "/" .. maxSoldier
	end

	return content
end

-------------------------------------------

function Corps:GetTraining()
	local total = 0
	local number = 0
	Asset_Foreach( self, CorpsAssetID.TROOP_LIST, function ( troop )
		total = total + ( troop:GetStatus( TroopStatus.TRAINING ) or 0 )
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
	Asset_Foreach( self, CorpsAssetID.TROOP_LIST, function ( troop )
		number = number + Asset_Get( troop, TroopAssetID.SOLDIER )
		maxNumber = maxNumber + Asset_Get( troop, TroopAssetID.MAX_SOLDIER )
	end )
	return number,  maxNumber
end

function Corps:GetCapacity( typename )
	local capacity = 0
	Asset_Foreach( self, CorpsAssetID.TROOP_LIST, function( troop )
		local soldier = Asset_Get( troop, TroopAssetID.SOLDIER )
		local troopTable = Asset_Get( troop, TroopAssetID.TABLEDATA )
		capacity = capacity + soldier * troopTable.capacity[typename]
	end)
	return capacity
end

--[[
function Corps:GetConsume( typename )
	local consume = 0
	Asset_Foreach( self, CorpsAssetID.TROOP_LIST, function( troop )
		local soldier = Asset_Get( troop, TroopAssetID.SOLDIER )
		local troopTable = Asset_Get( troop, TroopAssetID.TABLEDATA )
		consume = consume + soldier * troopTable.consume[typename]
	end)
	return consume
end
]]

function Corps:GetConsumeFood()
	local params = City_GetPopuParams( Asset_Get( self, CorpsAssetID.ENCAMPMENT ) ).POPU_CONSUME_FOOD
	return params.SOLDIER
end

function Corps:GetSalary()
	local params = City_GetPopuParams( Asset_Get( self, CorpsAssetID.ENCAMPMENT ) ).POPU_SALARY
	return params.SOLDIER
end

function Corps:GetFoodCapacity()
	return self:GetCapacity( "FOOD" )
end

function Corps:GetMaterialCapacity()
	return self:GetCapacity( "MATERIAL" )
end

-------------------------------------------

function Corps:GetTask()
	return Asset_GetDictItem( self, CorpsAssetID.STATUSES, CorpsStatus.IN_TASK )	
end

function Corps:SetTask( task )
	Asset_SetDictItem( self, CorpsAssetID.STATUSES, CorpsStatus.IN_TASK, task )
end

function Corps:IsAtHome()
	if self:GetStatus( CorpsStatus.OUTSIDE ) then return false end
	local location   = Asset_Get( self, CorpsAssetID.LOCATION )
	local encampment = Asset_Get( self, CorpsAssetID.ENCAMPMENT )
	return location == encampment
end

function Corps:IsBusy()
	local task = self:GetTask()
	if task then
		--print( task:ToString(), "busy")
		return true
	end
	local leader = Asset_Get( self, CorpsAssetID.LEADER )	
	if leader and leader:IsBusy() then
		--print( leader, "busy")
		return true
	end
	Asset_Foreach( self, CorpsAssetID.OFFICER_LIST, function ( chara )
		if chara:IsBusy() then
			--print( self.name, chara.name, "busy")
			return true
		end
	end)
	return false
end

-------------------------------------------

function Corps:AddTroop( troop )
	Asset_AppendList( self, CorpsAssetID.TROOP_LIST, troop )

	--add officer into list
	local officer = Asset_Get( troop, TroopAssetID.OFFICER )
	Asset_AppendList( self, CorpsAssetID.OFFICER_LIST, officer )
end

function Corps:RemoveTroop( troop )
	Asset_RemoveListItem( self, CorpsAssetID.TROOP_LIST, troop )

	local officer = Asset_Get( troop, TroopAssetID.OFFICER )
	if not officer then return end

	local leader = Asset_Get( self, CorpsAssetID.LEADER )
	if leader == officer then
		function AssignToEmptyTroop( troop )
			local officer = Asset_Get( troop, TroopAssetID.OFFICER )
			if not officer then
				Asset_Set( troop, TroopAssetID.OFFICER, leader )
				InputUtil_Pause( "set leader=" .. leader:ToString() .. " to empty-troop=" .. troop:ToString() )
				return true
			end
		end
		--move to empty troop
		if Asset_FindItem( self, CorpsAssetID.TROOP_LIST, AssignToEmptyTroop ) then
			return
		end

		function AssignToTroop( troop )
			local officer = Asset_Get( troop, TroopAssetID.OFFICER )
			if officer then
				Asset_Set( troop, TroopAssetID.OFFICER_LIST, leader )
				InputUtil_Pause( "set leader=" .. leader:ToString() .. " to empty-troop=" .. troop:ToString() )
				return true
			end
		end
		--instead of low rank troop
		if Asset_FindItem( self, CorpsAssetID.TROOP_LIST, AssignToTroop ) then
			return
		end
		error( "should consider about leader" )		
	end
end

function Corps:AssignLeader( leader )
	--debug checker
	if self:HasOfficer( leader ) then
		DBG_Error( leader.name .. " already as officer in " .. self:ToString() )
	end
	if Asset_Get( leader, CharaAssetID.CORPS ) then
		DBG_Error( leader.name .. " already in corps=" .. Asset_Get( leader, CharaAssetID.CORPS ):ToString() )
	end

	leader:LeadCorps( self )

	Asset_Set( self, CorpsAssetID.LEADER, leader )
	self:AddOfficer( leader )

	self:Recalculate()
end

function Corps:LoseOfficer( officer )	
	local leader = Asset_Get( self, CorpsAssetID.LEADER )
	if leader == officer then
		Asset_Set( self, CorpsAssetID.LEADER )
		--print( self:ToString() .. "lose leader=" .. chara.name, Asset_Get( self, CorpsAssetID.LEADER ) )
	end
	Asset_RemoveListItem( self, CorpsAssetID.OFFICER_LIST, officer )

	Debug_Log( officer:ToString(), "leave corps=" .. self:ToString() )
end

function Corps:AddOfficer( officer )
	Asset_AppendList( self, CorpsAssetID.OFFICER_LIST, officer )
end

function Corps:HasOfficer( officer )
	return Asset_HasItem( self, CorpsAssetID.OFFICER_LIST, officer )
end

function Corps:GetStatus( status )
	return Asset_GetDictItem( self, CorpsAssetID.STATUSES, status )
end

function Corps:SetStatus( status, value )
	if status == CorpsStatus.IN_COMBAT and typeof(value) == "boolean" then
		error( "setcorpsstat=", value )	
	end
	Asset_SetDictItem( self, CorpsAssetID.STATUSES, status, value )
end

function Corps:GetMaxTraining()	
	return 100
	--return 100 + Chara_GetSkillEffectValue( Asset_Get( self, CorpsAssetID.LEADER ), CharaSkillEffect.MAX_TRAINING )
end

---------------------------------------------

function Corps:CanTrain()
	local leader = Asset_Get( self, CorpsAssetID.LEADER )
	if not leader then return false end
	
	local training = self:GetTraining()
	local maxTraining = self:GetMaxTraining()
	return training < maxTraining	
end

---------------------------------------------

function Corps:Update( ... )
	local soldier, maxSoldier = self:GetSoldier()
	--print( self:ToString(), maxSoldier, soldier )
	self:SetStatus( CorpsStatus.UNDERSTAFFED, ( maxSoldier - soldier ) * 100 / maxSoldier )	

	--find new leader
	local leader = Asset_Get( self, CorpsAssetID.LEADER )
	if not leader then
		--find new one
		local chara = Chara_FindBestCharaForJob( CityJob.COMMANDER, Asset_GetList( self, CorpsAssetID.OFFICER_LIST ) )
		if chara then
			Asset_Set( self, CorpsAssetID.LEADER, chara )
			chara:LeadCorps( self )
			--InputUtil_Pause( "set corps leader=" .. chara.name )
		end
	end

	--update troop
	if self:IsAtHome() then
		Asset_Foreach( self, CorpsAssetID.TROOP_LIST, function ( troop )
			troop:UpdateAtHome()
		end)
	end

	if Move_IsMoving( self ) then
		Asset_Foreach( self, CorpsAssetID.TROOP_LIST, function ( troop )
			troop:Move( g_elpased )
		end)
	end
end

--about task
function Corps:Todo()
	local task = self:GetTask()
	if task then
		Task_Update( task )
		return
	end

	if not self:IsAtHome() then
		--mostly, go back home
		if not Move_IsMoving( self ) then
			Move_Corps( self, Asset_Get( self, CorpsAssetID.ENCAMPMENT ) )
		end
		return
	end
end

-------------------------------------------
-- handler

--dispatch 
function Corps:Departure()
	Asset_SetDictItem( self, CorpsAssetID.STATUSES, CorpsStatus.DEPATURE_TIME, g_Time:GetDateValue() )
end

function Corps:EnterCity( city )
	Asset_Set( self, CorpsAssetID.LOCATION, city )

	Asset_SetDictItem( self, CorpsAssetID.STATUSES, CorpsStatus.DEPATURE_TIME, nil )
end

function Corps:Starve()
	Asset_Foreach( self, CorpsAssetID.TROOP_LIST, function( troop )
		troop:Starve()
	end )
end

function Corps:EatFood()
	Asset_Foreach( self, CorpsAssetID.TROOP_LIST, function( troop )
		troop:EatFood()
	end )
end

--consume carried food
function Corps:ConsumeFood( food )
	local hasFood     = Asset_Get( self, CorpsAssetID.FOOD )
	if hasFood >= food then
		self:EatFood()
		Asset_Set( self, CorpsAssetID.FOOD, hasFood - food )
	else
		self:Starve()
		Asset_Set( self, CorpsAssetID.FOOD, 0 )
	end
	return food
end

function Corps:PaySalary( isEnough )
	Asset_Foreach( self, CorpsAssetID.TROOP_LIST, function ( troop )
		local value = troop:GetStatus( TroopStatus.DOWNCAST )
		if isEnough then
			value = value < 10 and 0 or value * 0.5
		else
			value = value and value * 2 or 10
		end
		troop:SetStatus( TroopStatus.DOWNCAST, value )
	end )
end

-------------------------------------------

function Corps:Recalculate( ... )
	Asset_Foreach( self, CorpsAssetID.TROOP_LIST, function ( troop )
		local maxSoldier = Corps_GetSolderNumber( self, troop )
		local cur = Asset_Get( troop, TroopAssetID.MAX_SOLDIER )
		if cur ~= maxSoldier then Debug_Log( troop:ToString(), "recal", cur, maxSoldier ) end
		Asset_Set( troop, TroopAssetID.MAX_SOLDIER, maxSoldier )		
	end )
end

function Corps:LeaveCombat()
	local id = self:GetStatus( CorpsStatus.IN_COMBAT )
	self:SetStatus( CorpsStatus.IN_COMBAT )
	--print( self:ToString("STATUS"), "leave combat=", id )
	local hasLevelup = false
	Asset_Foreach( self, CorpsAssetID.TROOP_LIST, function ( troop )
		if troop:LevelUp() then hasLevelup = true end
	end)
	if hasLevelup then self:Recalculate() end
end