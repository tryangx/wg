function Warefare_FieldCombatOccur( plot, atk, def )
	--first, we should find exist combat in this plot
	local combatExist = false
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
	else
		combatExist = true
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

	if combatExist == false then
		System_Get( SystemType.WARFARE_SYS ):AddCombat( combat )
	end

	Message_Post( MessageType.FIELD_COMBAT_OCCURED, { combat = combat } )
	Message_Post( MessageType.COMBAT_OCCURED, { combat = combat } )

	--Debug_Log( "field combat occur", combat:ToString() )

	return combat
end

function Warefare_HarassCombatOccur( corps, city )
	local combatExist = false
	local plot = Asset_Get( city, CityAssetID.CENTER_PLOT )
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
		local corpsList = city:GetDefendCorps()
		for _, def in ipairs( corpsList ) do
			if def:IsAtHome() then
				combat:AddCorps( def, CombatSide.DEFENDER )
			end
		end
	else
		combatExist = true
	end

	--add attacker
	combat:AddCorps( corps, CombatSide.ATTACKER )

	--set purpose
	Asset_Set( combat, CombatAssetID.ATK_PURPOSE, CombatPurpose.MODERATE )
	Asset_Set( combat, CombatAssetID.DEF_PURPOSE, CombatPurpose.MODERATE )

	if combatExist == false then
		System_Get( SystemType.WARFARE_SYS ):AddCombat( combat )
	end

	--print( "field(harass) occur" )

	Message_Post( MessageType.FIELD_COMBAT_OCCURED, { combat = combat } )
	Message_Post( MessageType.COMBAT_OCCURED, { combat = combat } )

	--Debug_Log( "field combat occur", combat:ToString() )

	return combat
end

function Warefare_SiegeCombatOccur( corps, city )
	local combatExist = false
	local plot = Asset_Get( city, CityAssetID.CENTER_PLOT )
	local combat = System_Get( SystemType.WARFARE_SYS ):GetCombatByPlot( plot )
	if not combat then
		combat = Entity_New( EntityType.COMBAT )
	
		--set type
		Asset_Set( combat, CombatAssetID.TYPE, CombatType.SIEGE_COMBAT )

		--set battlefield
		Asset_Set( combat, CombatAssetID.BATTLEFIELD, BattlefieldTable_Get( 100 ) )
		Asset_Set( combat, CombatAssetID.ATKCAMPFIELD, BattlefieldTable_Get( 200 ) )
		Asset_Set( combat, CombatAssetID.DEFCAMPFIELD, BattlefieldTable_Get( 300 ) )

		Asset_Set( combat, CombatAssetID.PLOT, plot )
		Asset_Set( combat, CombatAssetID.CITY, city )

		--add defender
		Asset_Foreach( city, CityAssetID.CORPS_LIST, function ( def )
			if def:IsAtHome() then
				combat:AddCorps( def, CombatSide.DEFENDER )	
			end
		end )	
	else
		combatExist = true
	end

	--add attacker
	combat:AddCorps( corps, CombatSide.ATTACKER )
	
	--set purpose
	Asset_Set( combat, CombatAssetID.ATK_PURPOSE, CombatPurpose.AGGRESSIVE )
	Asset_Set( combat, CombatAssetID.DEF_PURPOSE, CombatPurpose.MODERATE )

	if combatExist == false then
		System_Get( SystemType.WARFARE_SYS ):AddCombat( combat )
	end

	--print( "food=" .. Asset_Get( corps, CorpsAssetID.FOOD ) )

	Message_Post( MessageType.SIEGE_COMBAT_OCCURED, { combat = combat } )
	Message_Post( MessageType.COMBAT_OCCURED, { combat = combat } )

	city:SetStatus( CityStatus.IN_SIEGE, true )

	--Debug_Log( corps:ToString(), "try siege" )
	Debug_Log( "siege combat occur", combat:ToString( "DEBUG_CORPS" ), city:ToString( "MILITARY" ) )
	--InputUtil_Pause( "p" )

	return combat
end

function Warfare_UpdateCombat( combat )
	combat:NextDay()
	
	local result = combat:GetResult()
	if result == CombatResult.UNKNOWN then
		return false
	end

	combat:Dump()

	local type   = Asset_Get( combat, CombatAssetID.TYPE )
	local winner = Asset_Get( combat, CombatAssetID.WINNER )
	local city   = Asset_Get( combat, CombatAssetID.CITY )

	--Debug_Log( "CombatResult=" .. MathUtil_FindName( CombatResult, result ) )

	Stat_Add( "Combat@Result", combat:ToString( "RESULT" ), StatType.LIST )

	if type == CombatType.SIEGE_COMBAT then
		--reset in-siege status
		city:SetStatus( city, CityStatus.IN_SIEGE, nil )

		--dismiss guard
		local guard = 0
		Asset_Foreach( combat, CombatAssetID.DEFENDER_LIST, function ( troop )
			if Asset_GetDictItem( troop, TroopAssetID.STATUSES, TroopStatus.GUARD ) == true then
				guard = guard + Asset_Get( troop, TroopAssetID.SOLDIER )
			end
		end )
		local old = city:GetPopu( CityPopu.GUARD )
		city:SetPopu( CityPopu.GUARD, guard )
		--InputUtil_Pause( "set guard", city.name, guard, old )
		Stat_Add( "Guard@Lose", old - guard, StatType.ACCUMULATION )

		city:SetStatus( CityStatus.IN_SIEGE )

		--Seize city
		if winner == CombatSide.ATTACKER then
			local group = combat:GetGroup( winner )
			if group then
				group:OccupyCity( city )
			end
			
			local corpsList = combat:GetCorpsList( winner )
			for _, corps in ipairs( corpsList ) do
				Corps_Join( corps, city )
				--InputUtil_Pause( corps:ToString("BRIEF"), city:ToString("BRIEF") )
			end

			Debug_Log( city:ToString() .. " occupied by " .. ( group and group:ToString() or "" ), g_Time:CreateCurrentDateDesc() )
			Stat_Add( "City@Occupy", city:ToString() .. " occupied by " .. ( group and group:ToString() or "" ) .. " " .. g_Time:CreateCurrentDateDesc(), StatType.LIST )
			--InputUtil_Pause( "occupy", city:ToString(), group:ToString() )
		end
	elseif type == CombatType.FIELD_COMBAT then		
	end

	Stat_Add( MathUtil_FindName( CombatType, Asset_Get( combat, CombatAssetID.TYPE ) ) .. "@WIN=" .. MathUtil_FindName( CombatSide, winner ), 1, StatType.TIMES )
	--Stat_Add( "Combat@Winner", combat:ToString() .. " winner=" .. combat:GetGroupName( winner ), StatType.LIST )

	local group = combat:GetGroup( winner )
	local oppGroup = combat:GetGroup( combat:GetOppSide( winner ) )
	if group then
		group:ElectLeader()
	end
	if oppGroup then
		oppGroup:ElectLeader()
	end

	Debug_Log( combat:ToString( "DEBUG_CORPS" ) )
	Debug_Log( combat:ToString( "RESULT" ), "combat end!!!" )

	Asset_Foreach( combat, CombatAssetID.CORPS_LIST, function  ( corps )
		if corps:GetSoldier() == 0 then
			Corps_Dismiss( corps, "neutralized" )
			Stat_Add( "Corps@Vanished", corps:ToString( "SIMPLE"), StatType.LIST )
		end
	end )

	Debug_Log( "combat end", combat:ToString( "RESULT" ) )

	Message_Post( MessageType.COMBAT_ENDED, { combat = combat } )

	--InputUtil_Pause()

	return true
end

-------------------------------------

local function Warfare_OnCombatEnded( msg )		
	local params = Asset_GetList( msg, MessageAssetID.PARAMS )
	Message_Post( MessageType.COMBAT_REMOVE, params )
end

local function Warfare_OnCombatRemove( msg )
	local combat = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "combat" )
	if not combat then
		error( "why no combat to remove?" )
	end

	Stat_Add( "CombatDur@" .. combat.id, Asset_Get( combat, CombatAssetID.DAY ), StatType.VALUE )

	Asset_Foreach( combat, CombatAssetID.ATK_CORPS_LIST, function ( corps )
		Asset_SetDictItem( corps, CorpsAssetID.STATUSES, CorpsStatus.IN_COMBAT, nil )
	end )
	Asset_Foreach( combat, CombatAssetID.DEF_CORPS_LIST, function ( corps )
		Asset_SetDictItem( corps, CorpsAssetID.STATUSES, CorpsStatus.IN_COMBAT, nil )
	end )

	--don't remove combat now, should after combat_end message was processed
	Entity_Remove( combat )
	--Debug_Log( "remove combat" )
end

local function Warfare_OnFieldCombatTrigger( msg )
	local city = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "city" )
	local plot = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "plot" )
	local atk  = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "atk" )
	local def  = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "def" )
	local task = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "task" )

	local combat
	if plot then
		combat = Warefare_FieldCombatOccur( plot, atk, def )
	elseif city then
		local corps = city:GetDefendCorps()
		if #corps == 0 then
			combat = Warefare_SiegeCombatOccur( atk, city )
		else
			combat = Warefare_HarassCombatOccur( atk, city )
		end 		
	end
	Message_Post( MessageType.COMBAT_TRIGGERRED, { task = task, combat = combat, atk = atk, def = def } )

	Stat_Add( "Combat@Field", 1, StatType.TIMES )
end

local function Warfare_OnSiegeCombatTrigger( msg )
	local atk   = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "atk" )
	local city  = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "city" )
	local combat = Warefare_SiegeCombatOccur( atk, city )

	Message_Post( MessageType.COMBAT_TRIGGERRED, { task = task, combat = combat, atk = atk } )

	Stat_Add( "Combat@Siege", 1, StatType.TIMES )
end

-------------------------------------


WarfareSystem = class()

function WarfareSystem:__init()
	System_Setup( self, SystemType.WARFARE_SYS, "WARFARE" )
end

function WarfareSystem:Start()
	self._combats = {}

	Message_Handle( self.type, MessageType.FIELD_COMBAT_TRIGGER, Warfare_OnFieldCombatTrigger )
	Message_Handle( self.type, MessageType.SIEGE_COMBAT_TRIGGER, Warfare_OnSiegeCombatTrigger )	

	Message_Handle( self.type, MessageType.COMBAT_ENDED, Warfare_OnCombatEnded )
	Message_Handle( self.type, MessageType.COMBAT_REMOVE, Warfare_OnCombatRemove )
end

function WarfareSystem:UpdateCombat( combat )
end

function WarfareSystem:Update()
	local lists = {}
	for plot, combat in pairs( self._combats ) do				
		if Warfare_UpdateCombat( combat ) == true then
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
	if not plot then
		error( "why no plot" )
		return
	end
	if self._combats[plot] then
		local existCombat = self._combats[plot]
		print( existCombat:ToString( "DEBUG_CORPS" ) )
		error( "Plot" .. "(x=" .. Asset_Get( plot, PlotAssetID.X ) .. ",y=" .. Asset_Get( plot, PlotAssetID.Y ) .. ") already has a combat!" )
		return;
	end	
	self._combats[plot] = combat
end