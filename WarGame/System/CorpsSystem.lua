function Corps_Join( corps, city )	
	--remove from old city
	local encampment = Asset_Get( corps, CorpsAssetID.ENCAMPMENT )

	if encampment == city then return end

	if encampment then
		encampment:CorpsLeave( corps )
	end

	if city then
		city:CorpsJoin( corps )
	end

	Asset_ForeachList( corps, CorpsAssetID.OFFICER_LIST, function ( chara )
		Chara_Join( chara, city )
	end )
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
			resources[type] = Asset_GetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu.SOLDIER )
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

local function Corps_CanEstablishTroop( city, table, number, resources )
	--print( "Establish Troop=" .. table.name .. "*" .. number )
	if table.requirement.MIN_SOLDIER then
		if number < table.requirement.MIN_SOLDIER then
			print( "minimum number limit" )
			return false
		end
	end
	local needs = {}
	if table.requirement.SOLDIER then
		local need = number * table.requirement.SOLDIER
		if resources[TroopRequirement.SOLDIER] < need then
			DBG_Watch( "est troop", "no soldier " .. resources[TroopRequirement.SOLDIER] .. "/" .. need )
			return false
		end
		needs[TroopRequirement.SOLDIER] = need
	end
	if table.requirement.MONEY then
		local need = number * table.requirement.MONEY
		if resources[TroopRequirement.MONEY] < need then
			DBG_Watch( "est troop", "no money" .. resources[TroopRequirement.MONEY] .. "/" .. need )
			return false
		end
		needs[TroopRequirement.MONEY] = need
	end
	if table.requirement.MATERIAL then
		local need = number * table.requirement.MATERIAL
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

function Corps_CanEstablishCorps( city, number )
	--query resource for requirements
	local resources = Corps_QueryRequirementResource( city )

	return not TroopTable_Foreach( function( troopTable )
		if Corps_CanEstablishTroop( city, troopTable, number, resources ) == true then
			return true
		end
	end )
end

------------------------------------------------------
-- Establish a corps in the city
------------------------------------------------------

local function Corps_EstablishTroop( city, corps, numberOfReqTroop, soldierPerTroop )
	local troopTables = Asset_Get( city, CityAssetID.TROOPTABLE_LIST )
	
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
			--print( "failed to find ", MathUtil_FindName( TroopCategory, category ), #troopTables )
			return false
		end
		if Corps_CanEstablishTroop( city, troopTable, soldierPerTroop, resources ) ~= true then
			--print( "establish troop failed")
			return false
		end

		local troop = Entity_New( EntityType.TROOP )
		troop:LoadFromTable( troopTable )
		Asset_Set( troop, TroopAssetID.SOLDIER, soldierPerTroop )
		Asset_Set( troop, TroopAssetID.MAX_SOLDIER, soldierPerTroop )
		Asset_Set( troop, TroopAssetID.CORPS, corps )
		Asset_AppendList( corps, CorpsAssetID.TROOP_LIST, troop )

		--print( "Add troop ", troopTable.name, soldierPerTroop )
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
function Corps_EstablishInCity( city, purpose, leader, troopNumber )
	local troopTables = Asset_Get( city, CityAssetID.TROOPTABLE_LIST )
	if not troopTables or #troopTables == 0 then
		print( "too bad, no troop table valid~" )
		return
	end

	--find corps template
	local template = Corps_ChooseCorpsTemplate( city, purpose )

	--to make a corps
	local corps = Entity_New( EntityType.CORPS )
	Asset_Set( corps, CorpsAssetID.LEADER,     leader )
	Asset_Set( corps, CorpsAssetID.LOCATION,   city )
	Asset_Set( corps, CorpsAssetID.ENCAMPMENT, city )
	Asset_Set( corps, CorpsAssetID.TEMPLATE,   template )

	--set group and name
	local group = Asset_Get( city, CityAssetID.GROUP )	
	Asset_Set( corps, CorpsAssetID.GROUP,      group )	
	if group then
		corps.name = group.name .. " Corps"
	else
		corps.name = city.name .. " Corps"
	end

	--query resource for requirements
	local resources = Corps_QueryRequirementResource( city )

	--get how many soldier in the city
	local soldier = Asset_GetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu.SOLDIER )
	local numberOfReqTroop = 1
	local soldierPerTroop = 0
	--determine how many troop in	
	if not troopNumber then
		--calculate number of troops required by the corps
		numberOfReqTroop = MathUtil_Sum( template.priority_troop_category, "number" )
		--calculate minimum soldier per required troop
		soldierPerTroop = math.max( Scenario_GetData( "TROOP_PARAMS" ).MIN_TROOP_SOLDIER, math.floor( soldier / numberOfReqTroop ) )
		--should create a corps is understaffed or failed?
		if soldierPerTroop >= soldier then
			soldierPerTroop = soldier
			numberOfReqTroop = 1
		end
	else
		soldierPerTroop = math.min( soldier, Scenario_GetData( "TROOP_PARAMS" ).MAX_TROOP_SOLDIER )
	end

	Corps_EstablishTroop( city, corps, numberOfReqTroop, soldierPerTroop )

	--put corps into city
	city:CorpsJoin( corps )

	--InputUtil_Pause( "est corps food=" .. reservedfood, food, Asset_GetListSize( corps, CorpsAssetID.TROOP_LIST ) )
	--InputUtil_Pause( "EstablishCorps=" .. corps.name, corps.id, corps:GetSoldier(), numberOfReqTroop )

	return corps
end

function Corps_ReinforceInCity( corps, city )
	local troopTables = Asset_Get( city, CityAssetID.TROOPTABLE_LIST )
	if not troopTables or #troopTables == 0 then
		print( "too bad, no troop table valid~" )
		return
	end

	local soldier = Asset_GetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu.SOLDIER )
	local soldierPerTroop = MathUtil_Clamp( soldier, Scenario_GetData( "TROOP_PARAMS" ).MIN_TROOP_SOLDIER, Scenario_GetData( "TROOP_PARAMS" ).MAX_TROOP_SOLDIER )
	Corps_EstablishTroop( city, corps, 1, soldierPerTroop )

	--InputUtil_Pause( "reinforce")
end

function Corps_Train( corps, city )
	Asset_ForeachList( corps, CorpsAssetID.TROOP_LIST, function ( troop )
		Asset_Plus( troop, TroopAssetID.TRAINING, Random_GetInt_Sync( 5, 15 ) )
	end )
	--InputUtil_Pause( "train corps", corps:GetTraining() )
end

function Corps_Dispatch( corps, city )
	Corps_Join( corps, city )
end

function Corps_AttackCity( corps, city )
	return Warefare_SiegeCombatOccur( corps, city )
	--Message_Post( MessageType.FIELD_COMBAT_TRIGGER, { plot = curplot, atk = actor, def = otherActor } )
end

function Corps_HarassCity( corps, city )
	return Warefare_HarassCombatOccur( corps, city )
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
		Asset_AppendList( corps, CorpsAssetID.TROOP_LIST, troop )
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