-----------------------------------
--  Remove troop from data
--    1. killed in combat
--    2. dismiss by command
--    3. sth. else
--
--  Don't care about the leader here.
--  It should be dealed with the situtation
--
function Troop_Remove( troop )
	--remove from list in corps
	local corps = Asset_Get( troop, TroopAssetID.CORPS )
	if corps then
		corps:RemoveTroop( troop )
	end

	--remove entity
	Entity_Remove( troop )
end

function Troop_GetConsumeFood( troop )
	local table = Asset_Get( troop, TroopAssetID.TABLEDATA )
	return table and table.consume.FOOD
end

-------------------------------------------

function Corps_GetTroopMaxNumberLv( city )
	local maxLv = 0
	if not city then return maxLv end
	local gropu = Asset_Get( city, CityAssetID.GROUP )
	if group then maxLv = math.max( maxLv, Corps_GetTroopMaxNumberByGroup( group ) ) end	
	return maxLv
end

function Corps_GetTroopMaxNumberLv( troop )
	return 0
end

function Corps_GetTroopMaxNumber( city, troop )	
	local maxLv = Corps_GetTroopMaxNumberLv( city )
	if troop then
		maxLv = math.max( maxLv, Corps_GetTroopMaxNumberLv( troop ) )
	end
	local number = Scenario_GetData( "TROOP_PARAMS" ).TROOP_MAX_NUMBER[maxLv]
	return number or Scenario_GetData( "TROOP_PARAMS" ).MIN_TROOP_SOLDIER
end

function Corps_GetLimityByCity( city )
	if city:IsCapital() == true then return 4 end
	return 2
end

function Corps_Join( corps, city )	
	--remove from old city
	local encampment = Asset_Get( corps, CorpsAssetID.ENCAMPMENT )

	if encampment == city then return end

	if encampment then
		encampment:RemoveCorps( corps )
	end

	if city then
		city:AddCorps( corps )
	end

	Asset_ForeachList( corps, CorpsAssetID.OFFICER_LIST, function ( chara )
		Chara_Join( chara, city )
	end )
end

function Corps_Dismiss( corps )	
	--remove from old city
	local encampment = Asset_Get( corps, CorpsAssetID.ENCAMPMENT )
	if encampment then
		encampment:RemoveCorps( corps )
	else
		Debug_Log( corps:ToString() .. " not belong to any group or city!" )
	end

	--killed the leaders
	Asset_ForeachList( corps, CorpsAssetID.OFFICER_LIST, function ( chara )
		Chara_Die( chara )
	end )

	--remove task
	local task = Asset_GetListItem( corps, CorpsAssetID.STATUSES, CorpsStatus.IN_TASK )
	if task then
		Task_Terminate( task )
	end

	Debug_Log( corps:ToString(), "dimiss" )

	Stat_Add( "Corps@Dismiss", corps:ToString(), StatType.LIST )

	Entity_Remove( corps )
end

function Corps_OfficerDie( corps, officer )
	corps:LoseOfficer( officer )
	Chara_Die( officer )
end

---------------------------------------

local function Corps_QueryRequirementResource( city )
	local resources = {}
	for _, type in pairs( TroopRequirement ) do
		if type == TroopRequirement.MONEY then
			resources[type] = Asset_Get( city, CityAssetID.MONEY )
		elseif type == TroopRequirement.MATERIAL then
			resources[type] = Asset_Get( city, CityAssetID.MATERIAL )		
		elseif type == TroopRequirement.SOLDIER then
			resources[type] = Asset_GetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu.RESERVES )
		elseif type == TroopRequirement.TECH then
		else
			error( "Unhandle troop requirement" )
		end
	end
	return resources
end

local function Corps_ChooseCorpsTemplate( city, purpose )
	if not purpose then purpose = CorpsPurpose.FIELD_COMBAT end

	local datas = MathUtil_FindDataList( Scenario_GetData("CORPS_TEMPLATE"), purpose, "purpose" )
	if not datas or #datas <= 0 then
		error( "no match purpose corps template=" .. purpose )
		return
	end
	local template = Random_GetTable_Sync( datas, "prob" )
	--print( "template", template )
	return template
end

local function Corps_CanEstablishTroop( city, table, soldier, resources )
	--print( "Establish Troop=" .. table.name .. "*" .. number )
	if table.requirement.MIN_SOLDIER then
		if soldier < table.requirement.MIN_SOLDIER then
			--print( "minimum number limit", soldierPerTroop )
			return false
		end
	end
	local needs = {}
	if table.requirement.SOLDIER then
		local need = soldier * table.requirement.SOLDIER
		if resources[TroopRequirement.SOLDIER] < need then
			DBG_Watch( "est troop", "no soldier " .. resources[TroopRequirement.SOLDIER] .. "/" .. need )
			return false
		end
		needs[TroopRequirement.SOLDIER] = need
	end
	if table.requirement.MONEY then
		local need = soldier * table.requirement.MONEY
		if resources[TroopRequirement.MONEY] < need then
			DBG_Watch( "est troop", "no money" .. resources[TroopRequirement.MONEY] .. "/" .. need )
			return false
		end
		needs[TroopRequirement.MONEY] = need
	end
	if table.requirement.MATERIAL then
		local need = soldier * table.requirement.MATERIAL
		if resources[TroopRequirement.MATERIAL] < need then
			DBG_Watch( "est troop", "no material" .. resources[TroopRequirement.MATERIAL] .. "/" .. need )
			return false
		end		
		needs[TroopRequirement.MATERIAL] = need
	end
	for k, v in pairs( needs ) do
		resources[k] = resources[k] - v
	end
	return true
end

-----------------------------------------------------------

local function ChooseTroopTable( category, validTroopTables )	
	local list = {}
	for k, troop in ipairs( validTroopTables ) do
		if troop.category == category then
			table.insert( list, troop )
		end
	end
	if #list == 0 then
		return nil
	end	
	--choose a troop table
	return list[Random_GetInt_Sync( 1, #list )]
end

------------------------------------------------------

function Corps_CanEstablishCorps( city, soldier )
	--query resource for requirements
	local resources = Corps_QueryRequirementResource( city )
	local troopTable = TroopTable_Find( function( troopTable )
		if Corps_CanEstablishTroop( city, troopTable, soldier, resources ) == true then
			return true
		end
	end )
	return troopTable ~= nil
end

------------------------------------------------------
-- Establish a corps in the city
------------------------------------------------------

local function Corps_EstablishTroop( city, corps, numberOfReqTroop, soldierPerTroop )
	local troopTables = Asset_GetList( city, CityAssetID.TROOPTABLE_LIST )
	
	local template = Asset_Get( corps, CorpsAssetID.TEMPLATE )

	--query resource for requirements
	local resources = Corps_QueryRequirementResource( city )

	local numberOfCategory = {}
	local numberOfTroop = Asset_GetListSize( corps, CorpsAssetID.TROOP_LIST )
	if numberOfTroop > 0 then
		Asset_ForeachList( corps, CorpsAssetID.TROOP_LIST, function ( troop )
			local t = Asset_Get( troop, TroopAssetID.TABLEDATA )
			if not numberOfCategory[t.category] then
				numberOfCategory[t.category] = 0
			end
			numberOfCategory[t.category] = numberOfCategory[t.category] + 1			
		end )
		--print( "category" )
		--MathUtil_Dump( numberOfCategory )
	end

	function EstablishTroop( category )
		local troopTable = ChooseTroopTable( category, troopTables )
		if not troopTable then
			Debug_Log( "failed to find ", MathUtil_FindName( TroopCategory, category ), #troopTables )
			return false
		end
		if Corps_CanEstablishTroop( city, troopTable, soldierPerTroop, resources ) ~= true then
			Debug_Log( "establish troop failed")
			return false
		end

		local troop = Entity_New( EntityType.TROOP )
		troop:LoadFromTable( troopTable )

		local maxSoldier = Corps_GetTroopMaxNumber( city, troop )
		Asset_Set( troop, TroopAssetID.SOLDIER, soldierPerTroop )
		Asset_Set( troop, TroopAssetID.MAX_SOLDIER, maxSoldier )
		Asset_Set( troop, TroopAssetID.CORPS, corps )
		Asset_AppendList( corps, CorpsAssetID.TROOP_LIST, troop )

		local group = Asset_Get( corps, CorpsAssetID.GROUP )
		if group then
			Stat_Add( group:ToString() .. "@Soldier", soldierPerTroop, StatType.ACCUMULATION )
		end
		--Debug_Log( "Add troop ", troopTable.name, soldierPerTroop )
		return true
	end

	--try to esatblish priority troops
	for _, data in pairs( template.priority_troop_category ) do
		local need = data.number - ( numberOfCategory[data.category] or 0 )
		--print( "need", MathUtil_FindName( TroopCategory, data.category ), "need=" .. data.number, "has=" .. ( numberOfCategory[data.category] or 0 ), "add=" .. need )
		if numberOfCategory[data.category] then
			numberOfCategory[data.category] = numberOfCategory[data.category] - data.number
		end
		if need > 0 then
			for num = 1, need do				
				if EstablishTroop( data.category ) == true then
					numberOfReqTroop = numberOfReqTroop - 1
					if numberOfReqTroop <= 0 then break end
				else
					break
				end
			end
		end
		if numberOfReqTroop <= 0 then break end		
	end

	if numberOfReqTroop > 0 then
		--use tendency
		for num = 1, numberOfReqTroop do
			local rand = Random_GetInt_Sync( 1, 100 )
			--find category
			for _, data in pairs( template.tendency_troop_category ) do
				if rand <= data.prob then
					if EstablishTroop( data.category ) == true then
						numberOfReqTroop = numberOfReqTroop - 1
						if numberOfReqTroop <= 0 then break end
					else
						break
					end
				else
					rand = rand - data.prob
				end
			end
		end
	end
end

-- @param purpose default is FIELD_COMBAT
-- @useage CorpsSystem:EstablishCorpsInCity( city )
function Corps_EstablishInCity( city, leader, purpose, troopNumber )
	local troopTables = Asset_GetList( city, CityAssetID.TROOPTABLE_LIST )
	if not troopTables or #troopTables == 0 then
		Debug_Log( "too bad, no troop table valid~" )
		return
	end

	if not troopNumber then
		troopNumber = 2
	end

	--find corps template
	local template = Corps_ChooseCorpsTemplate( city, purpose )

	--to make a corps
	local corps = Entity_New( EntityType.CORPS )
	Asset_Set( corps, CorpsAssetID.LEADER,     leader )
	Asset_Set( leader, CharaAssetID.CORPS,     corps )

	Asset_Set( corps, CorpsAssetID.LOCATION,   city )
	Asset_Set( corps, CorpsAssetID.ENCAMPMENT, city )
	Asset_Set( corps, CorpsAssetID.TEMPLATE,   template )

	--set group and name
	local group = Asset_Get( city, CityAssetID.GROUP )	
	Asset_Set( corps, CorpsAssetID.GROUP, group )	
	if group then
		corps.name = group.name .. "_Corps_" .. corps.id
	else
		corps.name = city.name .. "_Corps_" .. corps.id
	end

	--query resource for requirements
	local resources = Corps_QueryRequirementResource( city )

	--get how many soldier in the city
	local soldier = Asset_GetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu.RESERVES )
	local numberOfReqTroop = 1
	local soldierPerTroop = 0
	
	--determine establish number of troops
	if not troopNumber then
		--calculate number of troops required by the corps
		numberOfReqTroop = MathUtil_Sum( template.priority_troop_category, "number" )
	else
		numberOfReqTroop = troopNumber
	end
	--calculate minimum soldier per required troop
	soldierPerTroop = math.floor( soldier / numberOfReqTroop )

	--limit by the tech/theory/etc.
	local maxSoldier = Corps_GetTroopMaxNumber( city, nil )
	if soldierPerTroop > maxSoldier then
		soldierPerTroop = maxSoldier
	end

	--boundary checks
	local minSoldier = Scenario_GetData( "TROOP_PARAMS" ).MIN_TROOP_SOLDIER
	if soldierPerTroop < minSoldier then
		numberOfReqTroop = math.max( 1, math.floor( soldier / minSoldier ) )
		soldierPerTroop = math.floor( soldier / numberOfReqTroop )
	end

	Corps_EstablishTroop( city, corps, numberOfReqTroop, soldierPerTroop )

	--set leader to troop
	local officer = leader
	Asset_ForeachList( corps, CorpsAssetID.TROOP_LIST, function ( troop )
		if officer then
			Asset_Set( troop, TroopAssetID.OFFICER, officer )
			officer = nil
		end
	end)

	--put corps into city
	city:AddCorps( corps )

	--InputUtil_Pause( "est corps food=" .. reservedfood, food, Asset_GetListSize( corps, CorpsAssetID.TROOP_LIST ) )
	
	return corps
end

function Corps_ReinforceTroop( corps, soldier )
	Asset_FindListItem( corps, CorpsAssetID.TROOP_LIST, function ( troop )
		local cur = Asset_Get( troop, TroopAssetID.SOLDIER )
		local max = Asset_Get( troop, TroopAssetID.MAX_SOLDIER )
		local req = max - cur		
		if soldier <= req then req = soldier end
		soldier = soldier - req				
		Asset_Set( troop, TroopAssetID.SOLDIER, cur + req )
		--print( troop.name, "soldier=" .. cur .. "+" .. cur + soldier )
		Stat_Add( "Reinforce@Troop", 1, StatType.ACCUMULATION )
		Stat_Add( "Reinforce@Corps", soldier, StatType.ACCUMULATION )
		local group = Asset_Get( corps, CorpsAssetID.GROUP )
		Stat_Add( group:ToString() .. "@Reinforce", soldier, StatType.ACCUMULATION )
		return soldier <= 0
	end )
end

function Corps_EnrollInCity( corps, city )
	local troopTables = Asset_GetList( city, CityAssetID.TROOPTABLE_LIST )
	if not troopTables or #troopTables == 0 then
		print( "too bad, no troop table valid~" )
		return
	end

	local numberOfTroop = 1
	local soldier = Asset_GetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu.RESERVES )
	local soldierPerTroop = Corps_GetTroopMaxNumber( city, nil )
	if soldier < soldierPerTroop then
		soldierPerTroop = soldier
	end
	Corps_EstablishTroop( city, corps, numberOfTroop, soldierPerTroop )
end

function Corps_Train( corps, progress )
	Asset_ForeachList( corps, CorpsAssetID.TROOP_LIST, function ( troop )
		Asset_Plus( troop, TroopAssetID.TRAINING, progress )
	end )
	--InputUtil_Pause( "train corps", corps:GetTraining() )
end

function Corps_Dispatch( corps, city )
	Corps_Join( corps, city )	
end

function Corps_AttackCity( corps, city, task )
	--return Warefare_SiegeCombatOccur( corps, city )
	Message_Post( MessageType.SIEGE_COMBAT_TRIGGER, { city = city, atk = corps, task = task } )
end

function Corps_HarassCity( corps, city, task )
	--return Warefare_HarassCombatOccur( corps, city )
	Message_Post( MessageType.FIELD_COMBAT_TRIGGER, { city = city, atk = corps, task = task } )
end

--------------------------------------------------
-- For COMBAT testing
--------------------------------------------------

function Corps_EstablishTest( params )
	local corps = Entity_New( EntityType.CORPS )
	corps.name = "Corps"
	Asset_Set( corps, CorpsAssetID.GROUP,      params.group )
	Asset_Set( corps, CorpsAssetID.LEADER,     params.leader )
	Asset_Set( corps, CorpsAssetID.LOCATION,   params.location )
	Asset_Set( corps, CorpsAssetID.ENCAMPMENT, params.encampment )
	--InputUtil_Pause( corps.id, params.encampment )
	
	local troopids = {}
	if params.siege == true then
 		troopids = { 400, 401 }
	end
	local defaultid = 10
	local index = 1
	local soldier = params.soldier or 1000
	local org = params.org or soldier
	local numoftroop = params.numoftroop or 5
	for k = 1, numoftroop do
		local id = troopids[index]
		if not id then
			id = defaultid
		else
			index = index + 1
		end
		local troopTable = TroopTable_Get( id )
		local troop = Entity_New( EntityType.TROOP )		
		Asset_Set( troop, TroopAssetID.CORPS, corps )
		Asset_Set( troop, TroopAssetID.SOLDIER, soldier )
		Asset_Set( troop, TroopAssetID.MAX_SOLDIER, soldier )		
		Asset_Set( troop, TroopAssetID.ORGANIZATION, org )
		troop:LoadFromTable( troopTable )
		corps:AddTroop( troop )
	end

	Asset_Set( corps, CorpsAssetID.FOOD, corps:GetConsumeFood() * 30 )

	return corps
end

function Corps_EstablishTroopByIndex( index, number )
	if not number then  number = 1000 end
	local troopTable = TroopTable_Get( index )
	local troop = Entity_New( EntityType.TROOP )
	Asset_Set( troop, TroopAssetID.CORPS, corps )
	Asset_Set( troop, TroopAssetID.SOLDIER, number )
	Asset_Set( troop, TroopAssetID.MAX_SOLDIER, number )
	troop:LoadFromTable( troopTable )
	return troop
end

function Corps_EstablishTroopByTable( table, number )
	if not number then  number = 1000 end
	local troop = Entity_New( EntityType.TROOP )
	Asset_Set( troop, TroopAssetID.CORPS, corps )
	Asset_Set( troop, TroopAssetID.SOLDIER, number )
	Asset_Set( troop, TroopAssetID.MAX_SOLDIER, number )
	troop:LoadFromTable( table )	
	return troop
end

-----------------------------------------------------------


CorpsSystem = class()

function CorpsSystem:__init()
	System_Setup( self, SystemType.CORPS_SYS, "CorpsSystem" )
end

function CorpsSystem:Start()
end

function CorpsSystem:Update()
end