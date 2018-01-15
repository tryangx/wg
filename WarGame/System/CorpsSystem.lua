function Corps_QueryRequirementResource( city )
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

function Corps_ChooseCorpsTemplate( city, purpose )
	if not purpose then purpose = CorpsPurpose.FIELD_COMBAT end

	local datas = MathUtil_FindDataList( GetScenarioData("CORPS_TEMPLATE"), purpose, "purpose" )
	if not datas or #datas <= 0 then
		error( "no match purpose corps template=" .. purpose )
		return
	end
	local template = Random_GetTable_Sync( datas, "prob" )
	return template
end

function Corps_CanEstablishTroop( city, table, number, resources )
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

function Corps_CanEstablishCorps( city, number )
	--query resource for requirements
	local resources = Corps_QueryRequirementResource( city )

	return not TroopTable_Foreach( function( troopTable )
		if Corps_CanEstablishTroop( city, troopTable, number, resources ) == true then
			return true
		end
	end )
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
-- Establish a corps in the city
------------------------------------------------------

-- @param purpose default is FIELD_COMBAT
-- @useage CorpsSystem:EstablishCorpsInCity( city )
function CorpsSystem:EstablishCorpsInCity( city, purpose, leader, troopNumber )
	local template = Corps_ChooseCorpsTemplate( city, purpose )

	--to make a corps
	local group = Asset_Get( city, CityAssetID.GROUP )

	local corps = Entity_New( EntityType.CORPS )
	if group then
		corps.name = group.name .. " Corps"
	else
		corps.name = city.name .. " Corps"
	end
	Asset_Set( corps, CorpsAssetID.GROUP,      group )
	Asset_Set( corps, CorpsAssetID.LEADER,     leader )
	Asset_Set( corps, CorpsAssetID.LOCATION,   city )
	Asset_Set( corps, CorpsAssetID.ENCAMPMENT, city )

	--query resource for requirements
	local resources = Corps_QueryRequirementResource( city )

	--get how many soldier in the city

	local soldier = Asset_GetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu.SOLDIER )
	local soldierPerTroop = 0
	--determine how many troop in
	if not troopNumber then
		--calculate number of troops required by the corps
		local numberOfReqTroop = MathUtil_Sum( template.priority_troop_category, "number" )

		--calculate minimum soldier per required troop
		soldierPerTroop = math.max( TroopConstant.NUMBER.MIN_NUMBER, math.floor( soldier / numberOfReqTroop ) )

		--should create a corps is understaffed or failed?
		if soldierPerTroop >= soldier then
			soldierPerTroop = soldier
			numberOfReqTroop = 1
		end
	else
		numberOfReqTroop = 1
		soldierPerTroop = math.min( soldier, 1000 )
	end

	local troopTables = Asset_Get( city, CityAssetID.TROOPTABLE_LIST )
	if not troopTables or #troopTables == 0 then
		print( "too bad, no troop table valid~" )
		return
	end

	--try to esatblish priority troops	
	for _, data in pairs( template.priority_troop_category ) do
		local category = data.category		
		for num = 1, data.number do
			local troopTable = ChooseTroopTable( category, troopTables )
			if not troopTable then
				--print( "failed to find " .. MathUtil_FindName( TroopCategory, category ) )
				break
			end
			if Corps_CanEstablishTroop( city, troopTable, soldierPerTroop, resources ) ~= true then
				--print( "establish troop failed")
				break
			end

			local troop = Entity_New( EntityType.TROOP )
			troop:LoadFromTable( troopTable )
			Asset_Set( troop, TroopAssetID.SOLDIER, soldierPerTroop )
			Asset_Set( troop, TroopAssetID.CORPS, corps )
			Asset_AppendList( corps, CorpsAssetID.TROOP_LIST, troop )

			--print( "Add troop ", troopTable, soldierPerTroop )
		end
	end

	--allot food
	local reservedfood = Corps_GetConsumeFood( corps ) * 30
	local food = Asset_Get( city, CityAssetID.FOOD )
	reservedfood = math.min( food, reservedfood )
	Asset_Set( corps, CorpsAssetID.FOOD, reservedfood )
	food = food - reservedfood
	Asset_Set( city, CityAssetID.FOOD )

	--put corps into city
	Asset_AppendList( city, CityAssetID.CORPS_LIST, corps )

	InputUtil_Pause( "est corps food=" .. reservedfood, food, Asset_GetListSize( corps, CorpsAssetID.TROOP_LIST ) )
	--InputUtil_Pause( "EstablishCorps=" .. corps.name, corps.id )

	return corps
end

--------------------------------------------------
-- For COMBAT testing
--------------------------------------------------

function CorpsSystem:EstablishTestCorps( params )
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
		Asset_Set( troop, TroopAssetID.SOLDIER, org )
		troop:LoadFromTable( troopTable )
		Asset_AppendList( corps, CorpsAssetID.TROOP_LIST, troop )
	end

	Asset_Set( corps, CorpsAssetID.FOOD, Corps_GetConsumeFood( corps ) * 30 )

	return corps
end

function CorpsSystem:EstablishTroopByIndex( index, number )
	if not number then  number = 1000 end
	local troopTable = TroopTable_Get( index )
	local troop = Entity_New( EntityType.TROOP )
	Asset_Set( troop, TroopAssetID.CORPS, corps )
	Asset_Set( troop, TroopAssetID.SOLDIER, number )
	troop:LoadFromTable( troopTable )
	return troop
end


function CorpsSystem:EstablishTroopByTable( table, number )
	if not number then  number = 1000 end
	local troop = Entity_New( EntityType.TROOP )
	Asset_Set( troop, TroopAssetID.CORPS, corps )
	Asset_Set( troop, TroopAssetID.SOLDIER, number )
	troop:LoadFromTable( table )	
	return troop
end