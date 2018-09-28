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

require "GameDebug"

------------------------------

function Game_Init()	
	g_gameSeed = 1536141028--os.time()

	-- Initialize random generator
	Random_SetSeed( g_gameSeed )
	Random_SetSeed_Unsync( g_unsyncSeed )

	-- Set asset watcher
	--[[
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
			elseif id == CityAssetID.DISS then
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
	]]

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

	--DistrictTable_Load    ( Scenario_GetData( "DISTRICT_DATA" ), EntityType )
	PlotTable_Load        ( Scenario_GetData( "PLOT_TABLE_DATA" ), EntityType )
	ResourceTable_Load    ( Scenario_GetData( "RESOURCE_DATA" ), EntityType)
	TroopTable_Load       ( Scenario_GetData( "TROOP_DATA" ), EntityType )
	TacticTable_Load      ( Scenario_GetData( "TACTIC_DATA" ), EntityType )
	BattlefieldTable_Load ( Scenario_GetData( "BATTLEFIELD_DATA" ), EntityType )
	WeaponTable_Load      ( Scenario_GetData( "WEAPON_DATA" ), EntityType )
	SkillTable_Load       ( Scenario_GetData( "CHARA_SKILL_DATA" ), EntityType )	
	ConstructionTable_Load( Scenario_GetData( "CITY_CONSTR_DATA" ), EntityType )

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

	--!!! The order of System_Add() will determine the execution order, should be very careful	
	System_Add( MessageSystem() )
	System_Add( IntelSystem() )

	System_Add( RankingSystem() )
	System_Add( GoalSystem() )
	System_Add( CharaCreatorSystem() )

	System_Add( CharaSystem() )
	System_Add( CitySystem() )
	System_Add( GroupSystem() )
	System_Add( CorpsSystem() )

	System_Add( ConsumeSystem() )
	System_Add( SupplySystem() )
	System_Add( LogisticsSystem() )
		
	System_Add( EventSystem() )
	System_Add( MeetingSystem() )
	System_Add( DiplomacySystem() )
	System_Add( TaskSystem() )	
	System_Add( WarfareSystem() )
	System_Add( MoveSystem() )
	System_Start()

	--init fomula
	Group_FormulaInit()


	--init datas, prevent any "crashed" caused by init-data leak 
	Entity_Foreach( EntityType.CITY, function( data )
		--Entity_Dump( data )
		--harvest at first
		City_Harvest( data )
		City_GetYearTax( data )
	end )

	-----------------------------------
	--init chara's data
	Entity_Foreach( EntityType.CHARA, function ( chara )		
		--init atomic trait
		CharaCreator_GenerateAtomicTrait( chara )

		--in order to test, we add random trait for each players
		for i = 1, 3 do
			Chara_GainTrait( chara )
		end
		print( chara:ToString( "TRAITS") )

		for _, type in pairs( CharaActionPoint ) do
			chara:GainAP( type, math.ceil( chara:GetAPLimit( type ) * 0.5 ) )
		end
	end)

	Entity_Foreach( EntityType.CHARA, function ( chara )
		Chara_ResetLoyality( chara )

		--test
		if false and chara.id == 200 then
			for key, value in pairs( CharaSkillEffect ) do
				local v = Chara_GetSkillEffectValue( chara, CharaSkillEffect[key] )
				if v ~= 0 then
					print( key .. "=" .. v )
				end
			end
			InputUtil_Pause( "trace", chara.name )
		end
	end)	

	--set debugger watcher( print on the console )
	DBG_SetWatcher( "Debug_Meeting",  DBGLevel.NORMAL )
	--DBG_SetWatcher( "Debug_Meeting",  DBGLevel.IMPORTANT )

	g_init = true
end

function Game_Test()
	--[[]]
	--test combat
	return Game_Debug()
	--]]

	--check route
	--Route_Verify()
end

function Game_MainLoop()
	System_Update( g_turnStep )
	Game_NextTurn()
end

function Game_Start()
	Game_Init()
	
	--test
	if not Game_Test() then
		while Game_IsRunning()  do
			Game_MainLoop()
		end
	end
	
	--local city = Entity_Get( EntityType.CITY, 1 )
	--if city then city:TrackData() end

	

	GameExit()
end

function GameExit()
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
	Debug_Normal( "Combat==>" .. Entity_Number( EntityType.COMBAT ) ) Entity_Foreach( EntityType.COMBAT, function( entity ) Debug_Normal( entity:ToString( "ALL" ) ) end )
	Debug_Normal( "Troop==>" .. Entity_Number( EntityType.TROOP ) ) Entity_Foreach( EntityType.TROOP, function( entity ) Debug_Normal( entity:ToString( "ALL" ) ) end )

	Debug_Normal( "turn=" .. g_Time:ToString() )

	Random_Result()

	GameMap_Draw( g_map )

	local date = Scenario_GetData( "BASE_DATA" )
	print( "From:", g_Time:CreateDateDesc( date.start_date.year, date.start_date.month, date.start_date.day, date.start_date.year < 0 and true or false ) )
	print( g_Time:CreateCurrentDateDesc(), "win=" .. ( g_winner and g_winner.name or "[NONE]" ) )
end