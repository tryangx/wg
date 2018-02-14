function Warefare_FieldCombatOccur( plot, atk, def )
	--first, we should find exist combat in this plot
	local combat = System_Get( SystemType.WARFARE_SYS ):GetCombatByPlot( plot )
	if not combat then
		combat = Entity_New( EntityType.COMBAT )
		--set type
		Asset_Set( combat, CombatAssetID.TYPE, CombatType.FIELD_COMBAT )

		--set battlefield
		Asset_Set( combat, CombatAssetID.BATTLEFIELD, BattlefieldTable_Get( 100 ) )
		Asset_Set( combat, CombatAssetID.ATKCAMPFIELD, BattlefieldTable_Get( 200 ) )
		Asset_Set( combat, CombatAssetID.DEFCAMPFIELD, BattlefieldTable_Get( 300 ) )
	
		--set plot
		Asset_Set( combat, CombatAssetID.PLOT, plot )
	end

	--add attacker
	if atk then
		combat:AddCorps( atk, CombatSide.ATTACKER )
	end

	if def then
		combat:AddCorps( def, CombatSide.DEFENDER )	
	end

	--set purpose
	Asset_Set( combat, CombatAssetID.ATK_PURPOSE, CombatPurpose.MODERATE )
	Asset_Set( combat, CombatAssetID.DEF_PURPOSE, CombatPurpose.MODERATE )

	System_Get( SystemType.WARFARE_SYS ):AddCombat( combat )

	--print( "field occur" )

	Message_Post( MessageType.FIELD_COMBAT_OCCURED, { combat = combat } )
	Message_Post( MessageType.COMBAT_OCCURED, { combat = combat } )

	return combat
end

function Warefare_HarassCombatOccur( corps, city )
	local combat = System_Get( SystemType.WARFARE_SYS ):GetCombatByPlot( plot )
	if not combat then
		combat = Entity_New( EntityType.COMBAT )

		--set type
		Asset_Set( combat, CombatAssetID.TYPE, CombatType.FIELD_COMBAT )

		--set battlefield
		Asset_Set( combat, CombatAssetID.BATTLEFIELD, BattlefieldTable_Get( 100 ) )
		Asset_Set( combat, CombatAssetID.ATKCAMPFIELD, BattlefieldTable_Get( 200 ) )
		Asset_Set( combat, CombatAssetID.DEFCAMPFIELD, BattlefieldTable_Get( 300 ) )

		--plot and city
		local plot = Asset_Get( city, CityAssetID.CENTER_PLOT )
		Asset_Set( combat, CombatAssetID.PLOT, plot )
		Asset_Set( combat, CombatAssetID.CITY, city )
		
		--add defender
		Asset_ForeachList( city, CityAssetID.CORPS_LIST, function ( def )
			combat:AddCorps( def, CombatSide.DEFENDER )	
		end )
	end

	--add attacker
	combat:AddCorps( corps, CombatSide.ATTACKER )

	--set purpose
	Asset_Set( combat, CombatAssetID.ATK_PURPOSE, CombatPurpose.MODERATE )
	Asset_Set( combat, CombatAssetID.DEF_PURPOSE, CombatPurpose.MODERATE )

	System_Get( SystemType.WARFARE_SYS ):AddCombat( combat )

	--print( "field(harass) occur" )

	Message_Post( MessageType.FIELD_COMBAT_OCCURED, { combat = combat } )
	Message_Post( MessageType.COMBAT_OCCURED, { combat = combat } )

	return combat
end

function Warefare_SiegeCombatOccur( corps, city )
	local combat = System_Get( SystemType.WARFARE_SYS ):GetCombatByPlot( plot )
	if not combat then
		combat = Entity_New( EntityType.COMBAT )
	
		--set type
		Asset_Set( combat, CombatAssetID.TYPE, CombatType.SIEGE_COMBAT )

		--set battlefield
		Asset_Set( combat, CombatAssetID.BATTLEFIELD, BattlefieldTable_Get( 100 ) )
		Asset_Set( combat, CombatAssetID.ATKCAMPFIELD, BattlefieldTable_Get( 200 ) )
		Asset_Set( combat, CombatAssetID.DEFCAMPFIELD, BattlefieldTable_Get( 300 ) )

		local plot = Asset_Get( city, CityAssetID.CENTER_PLOT )
		Asset_Set( combat, CombatAssetID.PLOT, plot )
		Asset_Set( combat, CombatAssetID.CITY, city )

		--add defender
		Asset_ForeachList( city, CityAssetID.CORPS_LIST, function ( def )
			combat:AddCorps( def, CombatSide.DEFENDER )	
		end )		
	end

	--add attacker
	combat:AddCorps( corps, CombatSide.ATTACKER )
	
	--set purpose
	Asset_Set( combat, CombatAssetID.ATK_PURPOSE, CombatPurpose.AGGRESSIVE )
	Asset_Set( combat, CombatAssetID.DEF_PURPOSE, CombatPurpose.MODERATE )

	System_Get( SystemType.WARFARE_SYS ):AddCombat( combat )

	--print( "food=" .. Asset_Get( corps, CorpsAssetID.FOOD ) )
	--print( "siege occur", combat )

	Message_Post( MessageType.SIEGE_COMBAT_OCCURED, { combat = combat } )
	Message_Post( MessageType.COMBAT_OCCURED, { combat = combat } )

	return combat
end

-------------------------------------

local function WarfareSystem_OnCombatEnd( msg )		
	local params = Asset_Get( msg, MessageAssetID.PARAMS )
	Message_Post( MessageType.COMBAT_REMOVE, params )
end

local function WarfareSystem_OnCombatRemove( msg )
	local combat = Asset_GetListItem( msg, MessageAssetID.PARAMS, "combat" )
	if not combat then
		error( "why no combat to remove?" )
	end

	Stat_Add( "Combat@DurDay_" .. combat.id, Asset_Get( combat, CombatAssetID.DAY ), StatType.VALUE )

	Asset_ForeachList( combat, CombatAssetID.ATK_CORPS_LIST, function ( corps )
		Asset_SetListItem( corps, CorpsAssetID.STATUSES, CorpsStatus.IN_COMBAT, nil )
	end )
	Asset_ForeachList( combat, CombatAssetID.DEF_CORPS_LIST, function ( corps )
		Asset_SetListItem( corps, CorpsAssetID.STATUSES, CorpsStatus.IN_COMBAT, nil )
	end )

	--don't remove combat now, should after combat_end message was processed
	Entity_Remove( combat )
	--InputUtil_Pause( "remove combat" )
end

local function WarfareSystem_OnFieldCombatTrigger( msg )
	local plot = Asset_GetListItem( msg, MessageAssetID.PARAMS, "plot" )
	local atk  = Asset_GetListItem( msg, MessageAssetID.PARAMS, "atk" )
	local def  = Asset_GetListItem( msg, MessageAssetID.PARAMS, "def" )
	local combat = Warefare_FieldCombatOccur( plot, atk, def )
	--InputUtil_Pause( "trigger combat msg id=" .. combat.id )
end


local function WarfareSystem_OnSiegeCombatTrigger( msg )
	local corps = Asset_GetListItem( msg, MessageAssetID.PARAMS, "corps" )
	local city  = Asset_GetListItem( msg, MessageAssetID.PARAMS, "city" )
	Warefare_SiegeCombatOccur( corps, city )
end

-------------------------------------


WarfareSystem = class()

function WarfareSystem:__init()
	System_Setup( self, SystemType.WARFARE_SYS, "WARFARE" )
end

function WarfareSystem:Start()
	self._combats = {}

	Message_Handle( SystemType.WARFARE_SYS, MessageType.FIELD_COMBAT_TRIGGER, WarfareSystem_OnFieldCombatTrigger )
	Message_Handle( SystemType.WARFARE_SYS, MessageType.SIEGE_COMBAT_TRIGGER, WarfareSystem_OnSiegeCombatTrigger )

	Message_Handle( SystemType.WARFARE_SYS, MessageType.COMBAT_END, WarfareSystem_OnCombatEnd )
	Message_Handle( SystemType.WARFARE_SYS, MessageType.COMBAT_REMOVE, WarfareSystem_OnCombatRemove )
end

function WarfareSystem:UpdateCombat( combat )
	combat:NextDay()
	local result = combat:GetResult()
	if result == CombatResult.UNKNOWN then return false end

	combat:Dump()
	print( "CombatResult=" .. MathUtil_FindName( CombatResult, result ) )
	local type = Asset_Get( combat, CombatAssetID.TYPE )
	local winner = Asset_Get( combat, CombatAssetID.WINNER )
	local loc = Asset_Get( combat, CombatAssetID.CITY )

	if type == CombatType.SIEGE_COMBAT then	
		if winner == CombatSide.ATTACKER then
			Stat_Add( "Combat@Siege_Atk_Win", nil, StatType.TIMES )
			Stat_Add( "Combat@Result_" .. combat.id, "Siege Atk Win=" .. combat:GetGroupName( winner ), StatType.DESC )
		elseif winner == CombatSide.DEFENDER then
			Stat_Add( "Combat@Siege_Def_Win", nil, StatType.TIMES )
			Stat_Add( "Combat@Result_" .. combat.id, "Siege Def Win=" .. combat:GetGroupName( winner ), StatType.DESC )
		else
			Stat_Add( "Combat@Siege_Draw", nil, StatType.TIMES )
			Stat_Add( "Combat@Result_" .. combat.id, "Siege Draw", StatType.DESC )
		end
		Message_Post( MessageType.SIEGE_COMBAT_END, { combat = combat } )
	elseif type == CombatType.FIELD_COMBAT then
		if winner == CombatSide.ATTACKER then
			Stat_Add( "Combat@Field_Atk_Win", nil, StatType.TIMES )
			Stat_Add( "Combat@Result_" .. combat.id, "Field Atk Win=" .. combat:GetGroupName( winner ), StatType.DESC )
		elseif winner == CombatSide.DEFENDER then
			Stat_Add( "Combat@Field_Def_Win", nil, StatType.TIMES )
			Stat_Add( "Combat@Result_" .. combat.id, "Field Def Win=" .. combat:GetGroupName( winner ), StatType.DESC )
		else
			Stat_Add( "Combat@Field_Draw", nil, StatType.TIMES )
			Stat_Add( "Combat@Result_" .. combat.id, "Field Draw", StatType.DESC )
		end
		Message_Post( MessageType.FIELD_COMBAT_END, { combat = combat } )
	end

	Message_Post( MessageType.COMBAT_END, { combat = combat } )
	return true
end

function WarfareSystem:Update()
	local lists = {}
	for plot, combat in pairs( self._combats ) do				
		if self:UpdateCombat( combat ) == true then
			Stat_Add( "Combat@Duration", Asset_Get( combat, CombatAssetID.TIME ), StatType.ACCUMULATION )
			self._combats[plot] = nil
		end
	end
end

function WarfareSystem:GetCombatByPlot( plot )
	return self._combats[plot]
end

function WarfareSystem:AddCombat( combat )
	local plot = Asset_Get( combat, CombatAssetID.PLOT )
	if self._combats[plot] then
		error( "Plot" .. "(x=" .. Asset_Get( plot, PlotAssetID.X ) .. ",y=" .. Asset_Get( plot, PlotAssetID.Y ) .. ") already has a combat!" )
	end
	self._combats[plot] = combat
end