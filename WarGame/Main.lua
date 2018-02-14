--Formula
require "Formula/Formula"
--Table
require "Table/TableDefine"
--Data
require "Entity/EntityDefine"
--System
require "System/SystemDefine"
--Module
require "Module/ModuleDefine"
--AI
require "AI/AI"

--Local gamedata, not framework
require "GameData"

------------------------------

WarGame = class()

function WarGame:Init()
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
			elseif id == CityAssetID.SATISFACTION then
				--print( entity.name, MathUtil_FindName( CityAssetID, id ), operation or "unkown" )
			end			
		elseif entity.type == EntityType.CHARA then
			--print( entity.name .." ".. MathUtil_FindName( CharaAssetID, id ) .. " " ..( operation or "unkown" ) )
		end		
	end)

	--------------------------------------
	-- Initialize table
	Scenario_InitData()

	local date = Scenario_GetData( "BASE_DATA" )

	g_calendar:SetDate( date.start_date.year, date.start_date.month, date.start_date.day, date.start_date.year < 0 and true or false )

	-- Initialize Entity
	print( "load entity......" )

	Entity_Setup( EntityType.GROUP,    Group )
	Entity_Setup( EntityType.CITY,     City )
	Entity_Setup( EntityType.CHARA,    Chara )
	Entity_Setup( EntityType.CORPS,    Corps )
	Entity_Setup( EntityType.TROOP,    Troop )
	Entity_Setup( EntityType.SKILL,    Skill )
	Entity_Setup( EntityType.TECH,     Tech )
	Entity_Setup( EntityType.WEAPON,   Weapon )
	Entity_Setup( EntityType.COMBAT,   Combat )
	Entity_Setup( EntityType.MAP,      Map )
	Entity_Setup( EntityType.PLOT,     Plot )
	Entity_Setup( EntityType.ROUTE,    Route )
	Entity_Setup( EntityType.MESSAGE,  Message )
	Entity_Setup( EntityType.PROPOSAL, Proposal )
	Entity_Setup( EntityType.TASK,     Task )
	Entity_Setup( EntityType.EVENT,    Event )
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

	--init weapon pointers
	TroopTable_Init()

	-- Generate map
	if true then	
		print( "#Generate map......" )	
		g_map:Generate( Scenario_GetData( "MAP_DATA" ) )	
		g_map:AllocateToCity()
	end

	-- Initialize City & Plots
	if true then
		print( "#Init cities( plots )......" )
		Entity_Foreach( EntityType.CITY, function ( city )
			city:InitPlots()
			city:InitPopu()
		end )
	end

	-- Initliaze Pointer
	print( "#Update pointer......" )
	for k, v in pairs( EntityType ) do
		print( "Update Entity Pointer=" .. MathUtil_FindName( EntityType, v ) )
		Entity_Foreach( v, function ( entity )
			Entity_UpdateAttribPointer( entity )
			if v == EntityType.GROUP
			--or v == EntityType.CITY 
			then
			--Entity_Dump( entity )
			end
		end )
	end

	if true then
		--should wait after adjacent-city pointers initialized
		print( "#Generate Route......" )
		Route_Make()
	end

	print( "#Verify data......")
	for k, v in pairs( EntityType ) do
		print( "Entity=" .. MathUtil_FindName( EntityType, v ) )
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
	System_Add( TaskSystem() )
	System_Add( EventSystem() )
	System_Add( MeetingSystem() )
	System_Start()

	--init fomula
	Group_FormulaInit()

	--test chara sys
	--local chara = System_Get( SystemType.CHARA_CREATOR_SYS ):GenerateFictionalChara()
	--Entity_Dump( chara )

	Entity_Foreach( EntityType.CITY, function( data )
		--Entity_Dump( data )
	end )

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
	if false then
		local city = Entity_Get( EntityType.CITY, 100 )
		local from = Entity_Get( EntityType.CITY, 101 )
		local atkcorps = Corps_EstablishTest( { numoftroop = 10, siege = true, encampment = from } )
		local defcorps = Corps_EstablishTest( { numoftroop = 4, encampment = city } )		
		Asset_AppendList( city, CityAssetID.CORPS_LIST, defcorps )

		--set combat
		local combat = Entity_New( EntityType.COMBAT )
		combat:AddCorps( atkcorps, CombatSide.ATTACKER )
		combat:AddCorps( defcorps, CombatSide.DEFENDER )
		
		Asset_Set( combat, CombatAssetID.CITY, city )

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

		--=combat:TestDamage()
		--Entity_Dump( combat )
		--[[]]		
	end

--[[
	]]
end

function WarGame:Start()
	self:Init()
	
	local city = Entity_Get( EntityType.CITY, 100 )
	city:TrackData()

	while Game_IsRunning()  do
		System_Update( g_turnStep )
		Game_NextTurn()
	end

	--city:TrackData( true )
	--city:DumpGrowthAttrs()
	--city:DumpProperty()

	Stat_Dump()

	Track_HistoryDump( nil, function( key, data )
		if key == "soldier" then
			print( key, g_calendar:CreateDateDescByValue( data.date ), data.name .. "=" .. data.soldier )
		elseif key == "dev" then
			print( key, g_calendar:CreateDateDescByValue( data.date ), data.name .. "=" .. data.agr .. "/" .. data.comm .. "/" .. data.prod )
		end
	end )
end