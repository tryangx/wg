--Table
require "TableDefine"
--Data
require "EntityDefine"
--System
require "SystemDefine"
--Module
require "ModuleDefine"
--AI
require "AI"

--Local gamedata, not framework
require "GameData"

------------------------------

function Game_Init()
	-- Initialize random generator
	Random_SetSeed( g_gameSeed )
	Random_SetSeed_Unsync( g_unsyncSeed )

	-- Set asset watcher
	AssetAttrib_SetWatcher( function( entity, id, operation )
		if entity.type == EntityType.CHARA then
			if id == CharaAssetID.LOCATION then
				--InputUtil_Pause( entity.name, operation )
			end
		elseif entity.type == EntityType.PLOT then
			if id > 300 then
				--print( MathUtil_FindName( EntityType, entity.type )..entity.id.."(".. MathUtil_FindName( PlotAssetID, id )..")"..id.."." .. MathUtil_FindName( PlotAssetID, id ) .. " " ..( operation or "unkown" ) )
			end
		elseif entity.type == EntityType.CITY then
			if id == CityAssetID.SECURITY then
				--print( entity.name, MathUtil_FindName( CityAssetID, id ), operation or "unkown" )
			elseif id == CityAssetID.DISSATISFACTION then
				--print( entity.name, MathUtil_FindName( CityAssetID, id ), operation or "unkown" )
			elseif id == CityAssetID.STATUSES then
				--InputUtil_Pause( "set statuses", operation )
			end			
		elseif entity.type == EntityType.CHARA then
			--print( entity.name .." ".. MathUtil_FindName( CharaAssetID, id ) .. " " ..( operation or "unkown" ) )

		elseif entity.type == EntityType.RELATION then
			if id == RelationAssetID.OPINION_LIST then
				--print( "set rel", operation )
			end

		end		
	end)

	--------------------------------------
	-- Initialize table
	Scenario_InitData()

	local date = Scenario_GetData( "BASE_DATA" )

	g_Time:SetDate( date.start_date.year, date.start_date.month, date.start_date.day, date.start_date.year < 0 and true or false )

	-- Initialize Entity
	print( "load entity......" )

	Entity_Setup( EntityType.GROUP,    Group )
	Entity_Setup( EntityType.CITY,     City )
	Entity_Setup( EntityType.CHARA,    Chara )
	Entity_Setup( EntityType.CORPS,    Corps )
	Entity_Setup( EntityType.TROOP,    Troop )
	Entity_Setup( EntityType.WEAPON,   Weapon )
	Entity_Setup( EntityType.COMBAT,   Combat )
	Entity_Setup( EntityType.MAP,      Map )
	Entity_Setup( EntityType.PLOT,     Plot )
	Entity_Setup( EntityType.ROUTE,    Route )
	Entity_Setup( EntityType.MESSAGE,  Message )
	Entity_Setup( EntityType.PROPOSAL, Proposal )
	Entity_Setup( EntityType.TASK,     Task )
	Entity_Setup( EntityType.EVENT,    Event )
	Entity_Setup( EntityType.RELATION, Relation )
	Entity_Setup( EntityType.MEETING,  Meeting )
	Entity_Setup( EntityType.MOVE,     Move )
	Entity_Setup( EntityType.INTEL,    Intel )
	--Entity_Setup( EntityType.WEAPON, Weapon )

	Entity_Load( EntityType.GROUP, Scenario_GetData( "GROUP_DATA" ), EntityType )
	Entity_Load( EntityType.CITY,  Scenario_GetData( "CITY_DATA" ), EntityType )
	Entity_Load( EntityType.CHARA, Scenario_GetData( "CHARA_DATA" ), EntityType )
	Entity_Load( EntityType.CORPS, Scenario_GetData( "CORPS_DATA" ), EntityType )
	--Entity_Load( EntityType.WEAPON, Scenario_GetData( "WEAPON_DATA" ), EntityType )
	Entity_Load( EntityType.EVENT, Scenario_GetData( "EVENT_DATA" ), EntityType )

	DistrictTable_Load    ( Scenario_GetData( "DISTRICT_DATA" ), EntityType )
	PlotTable_Load        ( Scenario_GetData( "PLOT_TABLE_DATA" ), EntityType )
	ResourceTable_Load    ( Scenario_GetData( "RESOURCE_DATA" ), EntityType)
	TroopTable_Load       ( Scenario_GetData( "TROOP_DATA" ), EntityType )
	TacticTable_Load      ( Scenario_GetData( "TACTIC_DATA" ), EntityType )
	BattlefieldTable_Load ( Scenario_GetData( "BATTLEFIELD_DATA" ), EntityType )
	WeaponTable_Load      ( Scenario_GetData( "WEAPON_DATA" ), EntityType )
	SkillTable_Load       ( Scenario_GetData( "CHARA_SKILL_DATA" ), EntityType )

	--init weapon pointers
	TroopTable_Init()

	------------------------------------------------------------------------------------------
	--!!!! Important !!!!!
	--The sequence to initialize all datas should never changed, or it be designed correctly
	------------------------------------------------------------------------------------------

	-- Generate map
	if true then	
		print( "#Generate map......" )	
		g_map:Generate( Scenario_GetData( "MAP_DATA" ) )	
		g_map:AllocateToCity()
	end

	-- Initliaze Pointer
	print( "#Update pointer......" )
	for k, v in pairs( EntityType ) do
		--print( "Update Entity Pointer=" .. MathUtil_FindName( EntityType, v ) )
		Entity_Foreach( v, function ( entity )
			Entity_UpdateAttribPointer( entity )
			if v == EntityType.GROUP --or v == EntityType.CITY 
			then
			--Entity_Dump( entity )
			end
		end )
	end

	-- Initialize City & Plots
	if true then
		print( "#Init cities( plots )......" )
		Entity_Foreach( EntityType.CITY, function ( city )
			city:Init()
		end )
	end

	if true then
		--should wait after adjacent-city pointers initialized
		print( "#Generate Route......" )
		Route_Make()
	end

	print( "#Verify data......")
	for k, v in pairs( EntityType ) do
		--print( "Entity=" .. MathUtil_FindName( EntityType, v ) )
		Entity_Foreach( v, function ( entity )
			Entity_VerifyData( entity )
		end )
	end

	GameMap_Draw( g_map )

	print( "init system....." )

	System_Add( MessageSystem() )
	System_Add( CharaSystem() )
	System_Add( CitySystem() )
	System_Add( GroupSystem() )
	System_Add( CorpsSystem() )	
	System_Add( MoveSystem() )
	System_Add( WarfareSystem() )	
	System_Add( CharaCreatorSystem() )
	System_Add( ConsumeSystem() )
	System_Add( SupplySystem() )
	System_Add( LogisticsSystem() )
	System_Add( IntelSystem() )	
	System_Add( EventSystem() )
	System_Add( MeetingSystem() )
	System_Add( DiplomacySystem() )
	System_Add( TaskSystem() )	
	System_Add( GoalSystem() )
	System_Start()

	--init fomula
	Group_FormulaInit()

	--init datas, prevent any "crashed" caused by init-data leak 
	Entity_Foreach( EntityType.CITY, function( data )
		--Entity_Dump( data )
		--harvest at first
		City_Harvest( data )
	end )

	--set debugger watcher( print on the console )
	DBG_SetWatcher( "Debug_Meeting",  DBGLevel.NORMAL )
	--DBG_SetWatcher( "Debug_Meeting",  DBGLevel.IMPORTANT )

end

function Game_Test()
	--test chara sys
	--local chara = CharaCreator_GenerateFictionalChara()
	--Entity_Dump( chara )

	--[[
	--test establish corps
	local city = Entity_New( EntityType.CITY )	
	city:Test()
	Entity_UpdateAttribPointer( city )
	Entity_Dump( city )
	Corps_EstablishInCity( city )
	Entity_Dump( city )	
	--]]

	--[[]]
	--test combat
	if true then
		local city = Entity_Get( EntityType.CITY, 1 )
		local from = Entity_Get( EntityType.CITY, 2 )
		local atkcorps = Corps_EstablishTest( { numoftroop = 10, siege = true, encampment = from } )
		local defcorps = Corps_EstablishTest( { numoftroop = 4, encampment = city } )
		Asset_Set( atkcorps, CorpsAssetID.LOCATION, 2 )
		Asset_Set( defcorps, CorpsAssetID.LOCATION, 1 )
		Asset_AppendList( city, CityAssetID.CORPS_LIST, defcorps )

		--set combat
		local combat = Entity_New( EntityType.COMBAT )
		combat:AddCorps( atkcorps, CombatSide.ATTACKER )
		combat:AddCorps( defcorps, CombatSide.DEFENDER )
		Asset_Set( combat, CombatAssetID.CITY, city )
		Asset_Set( combat, CombatAssetID.PLOT, Asset_Get( city, CityAssetID.CENTER_PLOT ) )		

		local testSiege = true--true
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

	--check route
	--Route_Verify()
end

local function Game_MainLoop()
	System_Update( g_turnStep )
	Game_NextTurn()
end

function Game_Start()
	Game_Init()
	
	if Game_Test() then return end
	
	--local city = Entity_Get( EntityType.CITY, 1 )
	--if city then city:TrackData() end

	while Game_IsRunning()  do
		Game_MainLoop()
	end

	--city:TrackData( true )
	--city:DumpGrowthAttrs()
	--city:DumpProperty()

	Stat_Dump()

	Track_HistoryDump( nil, function( key, data )
		if key == "soldier" then
			Debug_Normal( key, g_Time:CreateDateDescByValue( data.date ), data.name .. "=" .. data.soldier )
		elseif key == "reserves" then
			Debug_Normal( key, g_Time:CreateDateDescByValue( data.date ), data.name .. "=" .. data.reserves )
		elseif key == "dev" then
			Debug_Normal( key, g_Time:CreateDateDescByValue( data.date ), data.name .. "=" .. data.agr .. "/" .. data.comm .. "/" .. data.prod )
		end
	end )

	Entity_Foreach( EntityType.CITY, function ( entity )
		--print( entity:ToString( "BUDGET_YEAR" ) )
		--print( entity:ToString( "GROWTH" ) )
		print( entity:ToString( "POPULATION" ) )
		print( entity:ToString( "DEVELOP" ) )
		--print( entity:ToString( "TAX" ) )	
		print( entity:ToString( "SUPPLY" ) )	
		print( entity:ToString( "CHARA" ) )	
		--InputUtil_Pause()
	end)		

--	Debug_Normal( "Troop==>" ) Entity_Foreach( EntityType.TROOP, function ( entity ) Debug_Normal( entity:ToString( "ALL" ) ) end )
	Debug_Normal( "Chara==>" .. Entity_Number( EntityType.CHARA ) ) Entity_Foreach( EntityType.CHARA, function ( entity ) Debug_Normal( entity:ToString( "ALL" ) ) end )
	Debug_Normal( "Corps==>" .. Entity_Number( EntityType.CORPS ) ) Entity_Foreach( EntityType.CORPS, function ( entity ) Debug_Normal( entity:ToString( "ALL" ) ) end )
	Debug_Normal( "City==>" .. Entity_Number( EntityType.CITY ) ) Entity_Foreach( EntityType.CITY, function ( entity ) Debug_Normal( entity:ToString( "ALL" ) ) end )
	Debug_Normal( "Group==>" .. Entity_Number( EntityType.GROUP ) ) Entity_Foreach( EntityType.GROUP, function ( entity ) Debug_Normal( entity:ToString( "ALL" ) ) end )	
	Debug_Normal( "Task==>" .. Entity_Number( EntityType.TASK ) ) Entity_Foreach( EntityType.TASK, function( entity ) Debug_Normal( entity:ToString( "DEBUG" ), "exist" ) end )
	Debug_Normal( "Move==>" .. Entity_Number( EntityType.MOVE ) ) Entity_Foreach( EntityType.MOVE, function( entity ) Debug_Normal( entity:ToString(), "still" ) end )
	Debug_Normal( "Dipl==>" .. Entity_Number( EntityType.RELATION ) ) Entity_Foreach( EntityType.RELATION, function( entity ) Debug_Normal( entity:ToString( "ALL" ) ) end )

	print( g_Time:CreateCurrentDateDesc(), "win=" .. ( g_winner and g_winner.name or "[NONE]" ) )
end