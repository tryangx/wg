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
--Formula
require "Formula/Formula"

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
		if entity.type == EntityType.PLOT then
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
	local date = GetScenarioData( "BASE_DATA" )

	g_calendar:SetDate( date.start_date.year, date.start_date.month, date.start_date.day, date.start_date.year < 0 and true or false )

	-- Initialize Entity
	print( "load entity......" )

	Entity_Setup( EntityType.GROUP,  Group )
	Entity_Setup( EntityType.CITY,   City )
	Entity_Setup( EntityType.CHARA,  Chara )
	Entity_Setup( EntityType.CORPS,  Corps )
	Entity_Setup( EntityType.TROOP,  Troop )
	Entity_Setup( EntityType.SKILL,  Skill )
	Entity_Setup( EntityType.TECH,   Tech )
	Entity_Setup( EntityType.WEAPON, Weapon )
	Entity_Setup( EntityType.COMBAT, Combat )
	Entity_Setup( EntityType.MAP,    Map )
	Entity_Setup( EntityType.PLOT,   Plot )
	Entity_Setup( EntityType.ROUTE,  Route )
	Entity_Setup( EntityType.PROPOSAL, Proposal )
	Entity_Setup( EntityType.TASK,   Task )
	Entity_Setup( EntityType.EVENT,  Event )
	--Entity_Setup( EntityType.WEAPON, Weapon )

	Entity_Load( EntityType.GROUP, GetScenarioData( "GROUP_DATA" ) )
	Entity_Load( EntityType.CITY,  GetScenarioData( "CITY_DATA" ) )
	Entity_Load( EntityType.CHARA, GetScenarioData( "CHARA_DATA" ) )
	Entity_Load( EntityType.CORPS, GetScenarioData( "CORPS_DATA" ) )
	--Entity_Load( EntityType.WEAPON, GetScenarioData( "WEAPON_DATA" ) )
	Entity_Load( EntityType.EVENT, GetScenarioData( "EVENT_DATA" ) )

	DistrictTable_Load    ( GetScenarioData( "DISTRICT_DATA" ) )
	PlotTable_Load        ( GetScenarioData( "PLOT_TABLE_DATA" ) )
	ResourceTable_Load    ( GetScenarioData( "RESOURCE_DATA" ) )
	TroopTable_Load       ( GetScenarioData( "TROOP_DATA" ) )
	TacticTable_Load      ( GetScenarioData( "TACTIC_DATA" ) )
	BattlefieldTable_Load ( GetScenarioData( "BATTLEFIELD_DATA" ) )
	WeaponTable_Load      ( GetScenarioData( "WEAPON_DATA" ) )

	--init weapon pointers
	TroopTable_Init()

	-- Generate map
	if true then	
		print( "generate map......" )	
		g_map:Generate( GetScenarioData( "MAP_DATA" ) )	
		g_map:AllocateToCity()
	end

	-- Initialize City & Plots
	if true then
		print( "init cities( plots )......" )
		Entity_Foreach( EntityType.CITY, function ( city )
			city:InitPlots()
			city:InitPopu()
		end )
	end

	-- Initliaze Pointer
	print( "update pointer......" )
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
		print( "Generate Route......" )
		Route_Make()
	end

	print( "verify data......")
	for k, v in pairs( EntityType ) do
		print( "Entity=" .. MathUtil_FindName( EntityType, v ) )
		Entity_Foreach( v, function ( entity )
			Entity_VerifyData( entity )
		end )
	end

	GameMap_Draw( g_map )

	print( "init system....." )

	System_Add( CharaSystem() )
	System_Add( CitySystem() )
	System_Add( GroupSystem() )
	System_Add( CorpsSystem() )	
	System_Add( MarchSystem() )
	System_Add( WarfareSystem() )	
	System_Add( CharaCreatorSystem() )
	System_Add( ConsumeSystem() )
	System_Add( SupplySystem() )
	System_Add( LogisticsSystem() )
	System_Add( IntelSystem() )
	System_Add( ProposalSystem() )
	System_Add( TaskSystem() )
	System_Add( EventSystem() )
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
	System_Get( SystemType.CORPS_SYS ):EstablishCorpsInCity( city )
	Entity_Dump( city )	
	--]]

	--[[]]
	--test combat
	if false then
		local city = Entity_Get( EntityType.CITY, 100 )
		local from = Entity_Get( EntityType.CITY, 101 )
		local combat = Entity_New( EntityType.COMBAT )
		local atkcorps = System_Get( SystemType.CORPS_SYS ):EstablishTestCorps( { numoftroop = 10, siege = true, encampment = from } )
		combat:AddCorps( atkcorps, CombatSide.ATTACKER )
		local defcorps = System_Get( SystemType.CORPS_SYS ):EstablishTestCorps( { numoftroop = 4, encampment = city } )
		combat:AddCorps( defcorps, CombatSide.DEFENDER )		
		Asset_Set( combat, CombatAssetID.CITY, city )
		Asset_AppendList( city, CityAssetID.CORPS_LIST, defcorps )	
		local testSiege = false--true
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
		--NEUTRALIZE, AGGRESSIVE
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
	
	local city = Entity_Get( EntityType.CITY, 1000 )
	city:TrackData()

	while Game_IsRunning()  do
		System_Update( g_turnStep )
		Game_NextTurn()
	end

	city:TrackData( true )
	city:DumpGrowthAttrs()
	city:DumpProperty()

	Stat_Dump()
end