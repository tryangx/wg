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

function Troop_RemoveOfficer( troop, isKilled )
	local officer = Asset_Get( troop, TroopAssetID.OFFICER )
	if not officer then return end

	troop:SetOfficer()

	local corps  = Asset_Get( troop, TroopAssetID.CORPS )	
	local leader = corps and Asset_Get( corps, CorpsAssetID.LEADER ) or nil
	if isKilled then
		Chara_Die( officer )
	end
end
-------------------------------------------

--return the food need carried to move to destination
function Corps_CalcNeedFood( corps, dest )
	--check task, determine more food should carry
	local days = 0
	local task = corps:GetTask()
	if task then
		local taskType = Asset_Get( task, TaskAssetID.TYPE )
		if taskType == TaskType.HARASS_CITY then
			days = 60
		elseif taskType == TaskType.ATTACK_CITY then
			days = 180
		elseif taskType == TaskType.INTERCEPT then
			days = 60
		else
			Debug_Log( "more food" .. days, MathUtil_FindName( TaskType, taskType ) )
		end
	end

	local from = Asset_Get( corps, CorpsAssetID.LOCATION )
	days = days + Move_CalcCorpsMoveDuration( corps, from, dest )
	--need food when back
	local needFood = corps:GetConsumeFood() * days
	local hasFood  = Asset_Get( corps, CorpsAssetID.FOOD )

	--check capacity
	--local capacity = corps:GetFoodCapacity()
	--InputUtil_Pause( "need" .. needFood, "capacity" .. capacity, days )	

	--print( "calcneed", from.name, dest.name, days, corps:GetConsumeFood(), needFood, hasFood )
	return needFood - hasFood
end



---------------------------------------------------------------------
-- Determine the maximum number of soldier in one troop
---------------------------------------------------------------------
-- Soldier Number( 600~2000 )
--    600 / influ+100~500 / leader+400~800 / troop lv+(0~600) /
function Corps_GetSolderNumber( corps, troop )
	local number = Scenario_GetData( "CORPS_PARAMS" ).SOLDIER_NUMBER.MIN_NUMBER	

	--group influence
	local group = corps and Asset_Get( corps, CorpsAssetID.GROUP ) or nil
	if group then
		local grade = Asset_Get( group, GroupAssetID.GRADE )
		--print( "influgrade=" .. grade, number )
		number = number + ( Scenario_GetData( "CORPS_PARAMS" ).SOLDIER_NUMBER.INFLUENCE_GRADE_BONUS[grade] or 0 )
	end

	--check title
	--local corps  = troop and Asset_Get( troop, TroopAssetID.CORPS ) or nil
	local leader = corps and Asset_Get( corps, CorpsAssetID.LEADER ) or nil
	local title  = leader and Asset_Get( leader, CharaAssetID.TITLE ) or nil
	if title then
		number = number + ( Scenario_GetData( "CORPS_PARAMS" ).SOLDIER_NUMBER.TITLE_GRADE_BONUS[title.grade] or 0 )
	end

	--check troop lv
	if troop then
		local level = Asset_Get( troop, TroopAssetID.LEVEL )
		number = number + ( Scenario_GetData( "CORPS_PARAMS" ).SOLDIER_NUMBER.TROOP_LV_BONUS.per_level or 0 ) * level
	end

	return number
end

---------------------------------------------------------------------
-- Determine the maximum number of troop in one Corps
---------------------------------------------------------------------

-- Troop Number( 3~10 )
--    3 / influ+1~5 / title+1~2
function Corps_GetTroopNumber( corps )
	local number = Scenario_GetData( "CORPS_PARAMS" ).TROOP_NUMBER.MIN_NUMBER
	--group influence
	local group = Asset_Get( corps, CorpsAssetID.GROUP )
	if group then
		local grade = Asset_Get( group, GroupAssetID.GRADE )
		--print( "influgrade=" .. grade, number )
		number = number + ( Scenario_GetData( "CORPS_PARAMS" ).TROOP_NUMBER.INFLUENCE_GRADE_BONUS[grade] or 0 )
	end

	--leader title	
	local leader = Asset_Get( corps, CorpsAssetID.LEADER )
	if leader then
		local title = Asset_Get( leader, CharaAssetID.TITLE )
		if title then
			--print( "titlegrade=" .. title.grade, number, Scenario_GetData( "CORPS_PARAMS" ).TROOP_NUMBER.TITLE_GRADE_BONUS[title.grade] )
			number = number + ( Scenario_GetData( "CORPS_PARAMS" ).TROOP_NUMBER.TITLE_GRADE_BONUS[title.grade] or 0 )
		end
	end

	--InputUtil_Pause( corps:ToString(), number )

	return number
end

---------------------------------------------------------------------
-- Determine how many corps can establish in one Group
---------------------------------------------------------------------
-- Corps Number( 1~3 )
--    1 / Barrack+1 / Military Base + 1 / Capital+1
function Corps_GetLimitByCity( city )
	local num = Scenario_GetData( "CORPS_PARAMS" ).CORPS_NUMBER.MIN_NUMBER
	if city:IsCapital() then
		num = num + Scenario_GetData( "CORPS_PARAMS" ).CORPS_NUMBER.CAIPTAL_BONUS
	end
	if city:GetStatus( CityStatus.MILITARY_BASE ) then
		num = num + Scenario_GetData( "CORPS_PARAMS" ).CORPS_NUMBER.MILITARY_BASE_BONUS
	end
	if city:GetConstructionByEffect( CityConstrEffect.CORPS_LIMIT ) then
		num = num + Scenario_GetData( "CORPS_PARAMS" ).CORPS_NUMBER.CONSTRUCTION_BONUS
	end
	return num
end

--get the number of requirement corps( minimum, not maximum )
function Corps_GetRequiredByCity( city )
	local num = 0
	if city:GetStatus( CityStatus.FRONTIER ) then num = 1 end
	if city:GetStatus( CityStatus.BATTLEFRONT ) then num = 1 end
	if city:GetStatus( CityStatus.MILITARY_BASE ) then num = num + 1 end
	if city:IsCapital() == true then num = num + 1 end
	return num
end

---------------------------------------------------------------------

function Corps_Enter( corps, city )
	corps:SetStatus( CorpsStatus.RETREAT_TO_CITY )

	Asset_Set( corps, CorpsAssetID.LOCATION, city )

	Asset_Foreach( corps, CorpsAssetID.OFFICER_LIST, function ( chara )				
		Chara_Join( chara, city, true )
	end )
end

--join not means enter
function Corps_Join( corps, city, isEnterCity )
	--remove from old city
	local encampment = Asset_Get( corps, CorpsAssetID.ENCAMPMENT )
	if encampment == city then return end

	if encampment then
		encampment:RemoveCorps( corps )
	end

	city:CorpsJoin( corps, isEnterCity )

	Debug_Log( corps.name .. " join " .. city.name )
end

function Corps_Dismiss( corps, neutralized )
	Debug_Log( corps:ToString(), "dismiss neutralized=", neutralized )

	corps:SetStatus( CorpsStatus.DISMISSED, 1 )

	Stat_Add( "Corps@Dismiss", corps:ToString() .. " neutralized=" .. ( neutralized and "1" or "0" ), StatType.LIST )

	local group = Asset_Get( corps, CorpsAssetID.GROUP )
	if group then
		group:RemoveCorps( corps )
	end

	--Remove officers
	Asset_Foreach( corps, CorpsAssetID.OFFICER_LIST, function ( chara )
		if neutralized then
			Chara_Die( chara )
		else
			Asset_Set( chara, CharaAssetID.CORPS )
		end
	end )

	--remove from old city
	local encampment = Asset_Get( corps, CorpsAssetID.ENCAMPMENT )
	if encampment then
		encampment:RemoveCorps( corps )
	else
		Debug_Log( corps:ToString() .. " not belong to any group or city!" )
	end

	--remove task
	local task = corps:GetTask()
	if task then
		Task_Terminate( task, corps )
	end

	--remove moving
	Move_Stop( corps )

	--remove troop
	Asset_Foreach( corps, CorpsAssetID.TROOP_LIST, function ( troop )
		Entity_Remove( troop )
	end)

	Entity_Remove( corps )
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
			resources[type] = city:GetPopu( CityPopu.RESERVES )

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

local function Corps_CanEstablishTroop( city, table, soldier, resources, shouldUseResources )
	--print( "Establish Troop=" .. table.name .. "*" .. number )
	if table.requirement.MIN_SOLDIER then
		if soldier < table.requirement.MIN_SOLDIER then
			--print( "minimum number limit", soldier )
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
			--DBG_Watch( "est troop", "no money " .. resources[TroopRequirement.MONEY] .. "/" .. need )
			return false
		end
		needs[TroopRequirement.MONEY] = need
	end
	if table.requirement.MATERIAL then
		local need = soldier * table.requirement.MATERIAL
		if resources[TroopRequirement.MATERIAL] < need then
			--DBG_Watch( "est troop", "no material " .. resources[TroopRequirement.MATERIAL] .. "/" .. need )
			return false
		end		
		needs[TroopRequirement.MATERIAL] = need
	end

	if shouldUseResources == true then
		for k, v in pairs( needs ) do
			resources[k] = resources[k] - v
		end
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

function Corps_CanEstablishCorps( city, reserves )
	--query resource for requirements
	local resources = Corps_QueryRequirementResource( city )
	local troopTable = TroopTable_Find( function( troopTable )		
		if City_HasTroopBudget( city, troopTable, reserves ) ~= true then
			return false
		end
		if Corps_CanEstablishTroop( city, troopTable, reserves, resources ) == false then
			return false
		end
		return true
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

	--calculate the category of troops( infantry / archer / cavalry / etc )
	local numberOfCategory = {}
	local numberOfTroop = Asset_GetListSize( corps, CorpsAssetID.TROOP_LIST )
	if numberOfTroop > 0 then
		Asset_Foreach( corps, CorpsAssetID.TROOP_LIST, function ( troop )
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
		if City_HasTroopBudget( city, troopTable, soldierPerTroop ) ~= true then
			print( city:ToString("ASSET"), "budget checker failed" )
			return false
		end

		if Corps_CanEstablishTroop( city, troopTable, soldierPerTroop, resources, true ) ~= true then
			--Debug_Log( "establish troop failed")
			return false
		end

		local troop = Entity_New( EntityType.TROOP )
		troop:LoadFromTable( troopTable )

		--determine the potential, maybe consider about the culture
		Asset_Set( troop, TroopAssetID.POTENTIAL, Scenario_GetData( "TROOP_PARAMS" ).TROOP_POTENTIAL )

		local maxSoldier = Corps_GetSolderNumber( corps )
		Asset_Set( troop, TroopAssetID.SOLDIER, soldierPerTroop )
		Asset_Set( troop, TroopAssetID.MAX_SOLDIER, maxSoldier )
		Asset_Set( troop, TroopAssetID.CORPS, corps )
		Asset_AppendList( corps, CorpsAssetID.TROOP_LIST, troop )

		--decrease the reserves
		city:ReducePopu( CityPopu.RESERVES, soldierPerTroop )

		local group = Asset_Get( corps, CorpsAssetID.GROUP )
		if group then
			Stat_Add( "IncSoldier@" .. group:ToString(), soldierPerTroop, StatType.ACCUMULATION )
		end
		--InputUtil_Pause( "Add troop ", troopTable.name, maxSoldier )
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

	--try to fill up the vacancies
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
function Corps_EstablishInCity( city, leader, troopNumber, purpose )
	if not leader then
		error( "no leader, no corps" )
		return
	end
	if leader then
		if Asset_Get( leader, CharaAssetID.CORPS ) then
			error( leader.name .. " alread has a corps" )
		end
	end

	local troopTables = Asset_GetList( city, CityAssetID.TROOPTABLE_LIST )
	if not troopTables or #troopTables == 0 then
		Debug_Log( "too bad, no troop table valid~" )
		return
	end

	--find corps template
	local template = Corps_ChooseCorpsTemplate( city, purpose )

	--to make a corps
	local corps = Entity_New( EntityType.CORPS )

	--set group and name
	local group = Asset_Get( city, CityAssetID.GROUP )	
	Asset_Set( corps, CorpsAssetID.GROUP, group )
	if group then
		--insert into corps_list
		group:AddCorps( corps )
		corps.name = group.name .. "_Corps_" .. corps.id
	else
		corps.name = city.name .. "_Corps_" .. corps.id
	end
	
	--remove leader from current city to pass sanity checker in later
	Asset_RemoveListItem( city, CityAssetID.CHARA_LIST,   leader )

	corps:AssignLeader( leader )

	if not troopNumber then
		troopNumber = Corps_GetTroopNumber( corps )
	end

	Asset_Set( leader, CharaAssetID.CORPS,     corps )

	Asset_Set( corps, CorpsAssetID.LOCATION,   city )
	Asset_Set( corps, CorpsAssetID.ENCAMPMENT, city )
	Asset_Set( corps, CorpsAssetID.TEMPLATE,   template )

	if leader then
		Stat_Add( "Corps@Leader", leader:ToString() .. "->" .. corps:ToString(), StatType.LIST )
	end

	--query resource for requirements
	local resources = Corps_QueryRequirementResource( city )

	--get how many soldier in the city
	local reserves = city:GetPopu( CityPopu.RESERVES )
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
	soldierPerTroop = math.floor( reserves / numberOfReqTroop )

	--limit by the tech/theory/etc.	
	soldierPerTroop = math.min( soldierPerTroop, Corps_GetSolderNumber( corps ) )

	--boundary checks
	local minSoldier = Scenario_GetData( "TROOP_PARAMS" ).MIN_TROOP_SOLDIER
	if soldierPerTroop < minSoldier then
		numberOfReqTroop = math.max( 1, math.floor( reserves / minSoldier ) )
		soldierPerTroop = math.floor( reserves / numberOfReqTroop )
	end

	Corps_EstablishTroop( city, corps, numberOfReqTroop, soldierPerTroop )

	--set leader to troop
	local officer = leader
	Asset_Foreach( corps, CorpsAssetID.TROOP_LIST, function ( troop )
		if officer then
			Asset_Set( troop, TroopAssetID.OFFICER, officer )
			officer = nil
		end
	end)

	--put corps into city
	city:CorpsJoin( corps )

	--put corps into group

	--sanity checker
	if corps:GetSoldier() == 0 then
		DBG_TrackBug( "failed=" .. corps:ToString() .. " in=" .. city.name .. " reserves=" .. reserves )
	end

	--InputUtil_Pause( "est corps food=" .. reservedfood, food, Asset_GetListSize( corps, CorpsAssetID.TROOP_LIST ) )

	city:WatchBudget( "establish=" .. reserves )
	
	return corps
end

function Corps_ReinforceTroop( corps, soldier )
	Asset_FindItem( corps, CorpsAssetID.TROOP_LIST, function ( troop )
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
		Stat_Add( "Reinforce@" .. group:ToString(), soldier, StatType.ACCUMULATION )
		return soldier <= 0
	end )
end

function Corps_EnrollInCity( corps, city )
	--debug check
	local troopTables = Asset_GetList( city, CityAssetID.TROOPTABLE_LIST )
	if not troopTables or #troopTables == 0 then
		print( "too bad, no troop table valid~" )
		return
	end

	local numberOfTroop = 1
	local reserves = city:GetPopu( CityPopu.RESERVES )
	local soldierPerTroop = Corps_GetSoldierNumber( nil )
	if reserves < soldierPerTroop then soldierPerTroop = reserves end
	Corps_EstablishTroop( city, corps, numberOfTroop, soldierPerTroop )

	Stat_Add( "Enroll@" .. corps.id, 1, StatType.TIMES )

	city:WatchBudget( "enroll=" .. reserves )
end

function Corps_GainExp( corps, rate )
	if not rate or rate <= 0 then return end
	Asset_Foreach( corps, CorpsAssetID.TROOP_LIST, function ( troop )
		local needExp = troop:GetLevelUPExp()
		local exp = math.ceil( needExp * rate * 0.01 )
		troop:GainExp( exp )
		--print( corps.name, troop.name, rate, exp .. "/" .. needExp )
	end )
end

function Corps_Train( corps, progress )
	local maxTraining = corps:GetMaxTraining()
	Asset_Foreach( corps, CorpsAssetID.TROOP_LIST, function ( troop )
		local training = troop:GetStatus( TroopStatus.TRAINING )
		if not training then training = 0 end
		training = training + progress

		troop:SetStatus( TroopStatus.TRAINING, math.min( training, maxTraining ) )
	end )
	--InputUtil_Pause( "train corps", corps:GetTraining() )
end

function Corps_Regroup( corps, list )
	for _, otherCorps in ipairs( list ) do
		if otherCorps ~= corps then
			Asset_Foreach( otherCorps, CorpsAssetID.TROOP_LIST, function ( troop )
				local leader = Asset_Get( troop, TroopAssetID.OFFICER )
				if leader then Asset_Set( leader, CharaAssetID.CORPS ) end				
				corps:AddTroop( troop )
			end )			
			Asset_Foreach( otherCorps, CorpsAssetID.OFFICER_LIST, function ( officer )
				--we'll move officer from troop to staff
			end)

			otherCorps:SetTask()

			Asset_Clear( otherCorps, CorpsAssetID.TROOP_LIST )
			Asset_Clear( otherCorps, CorpsAssetID.OFFICER_LIST )

			Corps_Dismiss( otherCorps )
		end
	end
	--InputUtil_Pause( "regroup", corps:ToString("BRIEF") )
end

function Corps_Dispatch( corps, city )
	Corps_Join( corps, city, true )
end

function Corps_AttackCity( corps, city )
	Message_Post( MessageType.SIEGE_COMBAT_TRIGGER, { city = city, atk = corps } )
end

function Corps_HarassCity( corps, city )
	Message_Post( MessageType.FIELD_COMBAT_TRIGGER, { city = city, atk = corps } )
end

-----------------------------------------------------------

CorpsSystem = class()

function CorpsSystem:__init()
	System_Setup( self, SystemType.CORPS_SYS, "CorpsSystem" )
end

function CorpsSystem:Start()
end

function CorpsSystem:Update()
	Entity_Foreach( EntityType.CORPS, function( corps )
		if corps:GetStatus( CorpsStatus.DISMISSED ) then return end
		
		corps:Update()		
		corps:Todo()

		if corps:GetStatus( CorpsStatus.DISMISSED ) then return end
		--sanity checker
		local encampment = Asset_Get( corps, CorpsAssetID.ENCAMPMENT )
		if not encampment or not corps then
			print( encampment and encampment:ToString() or "nil", corps and corps:ToString("ALL") or "nil" )
		end
		if Asset_Get( encampment, CityAssetID.GROUP ) ~= Asset_Get( corps, CorpsAssetID.GROUP ) then
			DBG_Error( "why here?", corps:ToString("ALL"), encampment:ToString() )
		end
	end )
end