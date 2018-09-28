--------------------------------------------------
-- For City test
--------------------------------------------------
function Test_CityMoney()	
	local city = Entity_Get( EntityType.CITY, 3 )
	--print( "==", city:ToString("DEVELOP") )
	while Game_IsRunning()  do
		Game_MainLoop()
	end	
	--InputUtil_Pause( city:ToString("DEVELOP") )
	if city then
		city:WatchBudget()
	end
end

--------------------------------------------------
-- For Corps
--------------------------------------------------
function Test_EstablishCorps()
	--test establish corps
	local city = Entity_New( EntityType.CITY )	
	city:Test()
	Entity_UpdateAttribPointer( city )
	Entity_Dump( city )
	Corps_EstablishInCity( city )
	Entity_Dump( city )	
end

--------------------------------------------------
-- For Chara testing
--------------------------------------------------
function Test_GenereateChara()
	local chara = CharaCreator_GenerateFictionalChara()
	Entity_Dump( chara )
end

function Test_CharaLevelUp()
	for i = 1, 19 do
		--print( "i=" .. i )
		Entity_Foreach( EntityType.CHARA, function ( chara )		
			Chara_LevelUp( chara )
			if Chara_LearnSkill( chara ) == false then
				Chara_GainTrait( chara )
			end
			--if i == 19 then print( chara:ToString("GROWTH") ) end
		end)
	end
end

--------------------------------------------------
-- For COMBAT testing
--------------------------------------------------
function Test_Establish( params )
	local corps = Entity_New( EntityType.CORPS )
	corps.name = "Corps"
	Asset_Set( corps, CorpsAssetID.GROUP,      params.group )
	Asset_Set( corps, CorpsAssetID.LEADER,     params.leader )
	Asset_Set( corps, CorpsAssetID.LOCATION,   params.location )
	Asset_Set( corps, CorpsAssetID.ENCAMPMENT, params.encampment )
	--InputUtil_Pause( corps.id, params.encampment )
	
	if not params.troopids then
		params.troopids = { 400, 401 }
	end
	if not params.charas then
		param.charas = {}
	end
	local defaultid = 10
	local index = 1
	local charaIndex = 1
	local soldier = params.soldier or 1000
	local org = params.org or soldier
	local numoftroop = params.numoftroop or 1
	for k = 1, numoftroop do
		local id = params.troopids[index]
		if not id then id = defaultid end
		index = index + 1
		local troopTable = TroopTable_Get( id )
		local troop = Entity_New( EntityType.TROOP )		
		Asset_Set( troop, TroopAssetID.CORPS, corps )
		Asset_Set( troop, TroopAssetID.SOLDIER, soldier )
		Asset_Set( troop, TroopAssetID.MAX_SOLDIER, soldier )		
		Asset_Set( troop, TroopAssetID.ORGANIZATION, org )

		id = params.charas[charaIndex]
		if id then
			local officer = Entity_Get( EntityType.CHARA, id )
			Asset_Set( troop, TroopAssetID.OFFICER, officer )
			Asset_Set( officer, CharaAssetID.CORPS, corps )
			Asset_Set( officer, CharaAssetID.TROOP, troop )
			charaIndex = charaIndex + 1
		end
		troop:LoadFromTable( troopTable )
		corps:AddTroop( troop )

		--InputUtil_Pause( "ADD", troop:ToString( 'COMBAT' ) )
	end

	return corps
end

function Test_EstablishTroopByIndex( index, number )
	if not number then  number = 1000 end
	local troopTable = TroopTable_Get( index )
	local troop = Entity_New( EntityType.TROOP )
	Asset_Set( troop, TroopAssetID.CORPS, corps )
	Asset_Set( troop, TroopAssetID.SOLDIER, number )
	Asset_Set( troop, TroopAssetID.MAX_SOLDIER, number )
	troop:LoadFromTable( troopTable )
	return troop
end

function Test_EstablishTroopByTable( table, number )
	if not number then  number = 1000 end
	local troop = Entity_New( EntityType.TROOP )
	Asset_Set( troop, TroopAssetID.CORPS, corps )
	Asset_Set( troop, TroopAssetID.SOLDIER, number )
	Asset_Set( troop, TroopAssetID.MAX_SOLDIER, number )
	troop:LoadFromTable( table )
	return troop
end

function Test_Combat()
	Combat_EnableTest()
	local city = Entity_Get( EntityType.CITY, 3 )
	local from = Entity_Get( EntityType.CITY, 4 )
	local trooops1 = { 301, 300, 200, 100, 101, 200, 200 }
	local trooops2 = { 100, 100, 101, 101, 200, 200, 300 }
	local charas1 = { 200, 201, 202 }
	local charas2 = { 100, 101 }
	local atkcorps = Test_Establish( { numoftroop = 1, siege = true, encampment = from, troopids = trooops1, charas = charas1 } )
	local defcorps = Test_Establish( { numoftroop = 6, encampment = city, troopids = trooops2, charas = charas2 } )
	Asset_Set( atkcorps, CorpsAssetID.LOCATION, 3 )
	Asset_Set( defcorps, CorpsAssetID.LOCATION, 4 )
	Asset_AppendList( city, CityAssetID.CORPS_LIST, defcorps )

	--set combat
	local combat = Entity_New( EntityType.COMBAT )
	Asset_Set( combat, CombatAssetID.START_DATE, g_Time:GetDateValue() )
	combat:AddCorps( atkcorps, CombatSide.ATTACKER )
	combat:AddCorps( defcorps, CombatSide.DEFENDER )
	Asset_Set( combat, CombatAssetID.CITY, city )
	Asset_Set( combat, CombatAssetID.PLOT, Asset_Get( city, CityAssetID.CENTER_PLOT ) )		

	local testSiege = false
	if testSiege == true then
		Asset_Set( combat, CombatAssetID.TYPE, CombatType.SIEGE_COMBAT )
		Asset_Set( combat, CombatAssetID.BATTLEFIELD, BattlefieldTable_Get( 100 ) )
		Asset_Set( combat, CombatAssetID.ATKCAMPFIELD, BattlefieldTable_Get( 200 ) )
		Asset_Set( combat, CombatAssetID.DEFCAMPFIELD, BattlefieldTable_Get( 300 ) )
	else
		Asset_Set( combat, CombatAssetID.TYPE, CombatType.FIELD_COMBAT )
		Asset_Set( combat, CombatAssetID.BATTLEFIELD, BattlefieldTable_Get( 100 ) )
		Asset_Set( combat, CombatAssetID.ATKCAMPFIELD, BattlefieldTable_Get( 200 ) )
		Asset_Set( combat, CombatAssetID.DEFCAMPFIELD, BattlefieldTable_Get( 200 ) )
	end
	--in siege combat, if attacker purpose not aggressive, they won't attack
	Asset_Set( combat, CombatAssetID.ATK_PURPOSE, CombatPurpose.AGGRESSIVE )
	Asset_Set( combat, CombatAssetID.DEF_PURPOSE, CombatPurpose.CONSERVATIVE )
	System_Get( SystemType.WARFARE_SYS ):AddCombat( combat )

	FeatureOption.DISABLE_FOOD_SUPPLY = true

	if nil then
		combat:TestDamage()
	else			
		local result = false
		while not result do
			result = Warfare_UpdateCombat( combat )
		end
	end
	
	--Entity_Dump( combat )
	return true
end

function Game_Debug()
	--if true then return false end
	Test_CityMoney()
	--Test_CharaLevelUp()
	--Test_Combat()
	return true
end