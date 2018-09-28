function Warfare_HasComat( plot )
	return System_Get( SystemType.WARFARE_SYS ):GetCombatByPlot( plot )
end

--atk can be invalid
--def can be invalid
function Warefare_FieldCombatOccur( plot, atk, def )
	--first, we should find exist combat in this plot
	local combatExist = false
	local combat = System_Get( SystemType.WARFARE_SYS ):GetCombatByPlot( plot )
	if not combat then
		combat = Entity_New( EntityType.COMBAT )
		Asset_Set( combat, CombatAssetID.START_DATE, g_Time:GetDateValue() )

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

	if not combatExist then
		Stat_Add( "Combat@Occur", combat:ToString( "ALL" ), StatType.LIST )
	end

	--set purpose
	Asset_Set( combat, CombatAssetID.ATK_PURPOSE, CombatPurpose.AGGRESSIVE )
	Asset_Set( combat, CombatAssetID.DEF_PURPOSE, CombatPurpose.AGGRESSIVE )

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
		Asset_Set( combat, CombatAssetID.START_DATE, g_Time:GetDateValue() )

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

	if not combatExist then
		Stat_Add( "Combat@Occur", combat:ToString( "ALL" ), StatType.LIST )
	end

	--set purpose
	Asset_Set( combat, CombatAssetID.ATK_PURPOSE, CombatPurpose.MODERATE )
	Asset_Set( combat, CombatAssetID.DEF_PURPOSE, CombatPurpose.AGGRESSIVE )

	if combatExist == false then
		System_Get( SystemType.WARFARE_SYS ):AddCombat( combat )
	end

	Message_Post( MessageType.FIELD_COMBAT_OCCURED, { combat = combat } )
	Message_Post( MessageType.COMBAT_OCCURED, { combat = combat } )

	--Debug_Log( "field combat occur", combat:ToString() )

	return combat
end

function Warefare_SiegeCombatOccur( corps, city )
	if Asset_Get( corps, CorpsAssetID.GROUP ) == Asset_Get( city, CityAssetID.GROUP ) then
		--print( city:ToString(), "is already occupied" )
		return
	end
	local combatExist = false
	local plot = Asset_Get( city, CityAssetID.CENTER_PLOT )
	local combat = System_Get( SystemType.WARFARE_SYS ):GetCombatByPlot( plot )
	if not combat then
		combat = Entity_New( EntityType.COMBAT )
		Asset_Set( combat, CombatAssetID.START_DATE, g_Time:GetDateValue() )
	
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

	if not combatExist then
		Stat_Add( "Combat@Occur", combat:ToString( "ALL" ), StatType.LIST )
	end
	
	--set purpose
	Asset_Set( combat, CombatAssetID.ATK_PURPOSE, CombatPurpose.AGGRESSIVE )
	Asset_Set( combat, CombatAssetID.DEF_PURPOSE, CombatPurpose.MODERATE )

	if combatExist == false then
		System_Get( SystemType.WARFARE_SYS ):AddCombat( combat )
	end

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


	local IsAffectReputation = false

	local removeTroopList = {}

	if type == CombatType.SIEGE_COMBAT then
		--reset in-siege status
		city:SetStatus( CityStatus.IN_SIEGE, nil )

		--dismiss guard & reserve
		local guard, reserves = 0, 0
		Asset_Foreach( combat, CombatAssetID.DEFENDER_LIST, function ( troop )
			if troop:GetStatus( TroopStatus.GUARD ) then
				guard = guard + Asset_Get( troop, TroopAssetID.SOLDIER )
				table.insert( removeTroopList, troop )
			end
			if troop:GetStatus( TroopStatus.RESERVE ) then
				reserves = reserves + Asset_Get( troop, TroopAssetID.SOLDIER )
				table.insert( removeTroopList, troop )
			end
		end )
		local oldGuard = city:GetPopu( CityPopu.GUARD )
		city:SetPopu( CityPopu.GUARD, guard )
		local oldReserves = city:GetPopu( CityPopu.GUARD )
		city:SetPopu( CityPopu.RESERVES, reserves )
		--if reserves > 0 then InputUtil_Pause( "set guard, reserves", city.name, guard, oldGuard, reserves, oldReserves ) end
		Stat_Add( "Guard@Lose", oldGuard - guard, StatType.ACCUMULATION )
		Stat_Add( "Reserve@Lose", oldReserves - reserves, StatType.ACCUMULATION )

		city:SetStatus( CityStatus.IN_SIEGE )

		--Seize city
		if winner == CombatSide.ATTACKER  then
			local group = combat:GetGroup( winner )
			if group then
				--InputUtil_Pause( "occupy", city:ToString(), group:ToString() )
				Stat_Add( "City@Occupy", city:ToString() .. " occupied by " .. ( group and group:ToString() or "" ) .. " " .. g_Time:CreateCurrentDateDesc(), StatType.LIST )
				Debug_Log( city:ToString() .. " occupied by " .. ( group and group:ToString() or "" ), g_Time:CreateCurrentDateDesc() )
				group:OccupyCity( city )
			end
			
			local corpsList = combat:GetCorpsList( winner )
			for _, corps in ipairs( corpsList ) do
				Corps_Join( corps, city, true )
				--InputUtil_Pause( corps:ToString("BRIEF"), city:ToString("BRIEF") )
			end

			IsAffectReputation = true
		end
	elseif type == CombatType.FIELD_COMBAT then		
		IsAffectReputation = result == CombatResult.BRILLIANT_VICTORY or result == CombatResult.DISASTROUS_LOSE
	end

	--deal with prisoner
	Asset_Foreach( combat, CombatAssetID.PRISONER, function ( data )
		local troop = data.prisoner
		if data.side == winner then
			--release the prisoner
			if troop:GetStatus( TroopStatus.RESERVE ) or troop:GetStatus( TroopStatus.GUARD ) then return end
			InputUtil_Pause( "just dismiss the troop and kill the officer" )
			if troop:GetStatus( TroopStatus.SURRENDER ) or Random_GetInt_Sync( 1, 100 ) < 80 then
				--accept surrender
				local corpsList = combat:GetCorpsList( winner )
				local corps = corpsList[0]
				corps:AddTroop( troop )

				local officer = Asset_Get( troop, TroopAssetID.OFFICER )
				if officer then
					Chara_Serve( officer, Asset_Get( corps, CorpsAssetID.GROUP ), Asset_Get( corps, CorpsAssetID.ENCAMPMENT ) )
				end
				InputUtil_Pause( crops:ToString() .. "accept surrender=" .. troop:ToString() )
			else
				--killed
				Troop_RemoveOfficer( troop, true )
				Troop_Remove( troop )				
				InputUtil_Pause( troop:ToString(), "killed after surrender" )
			end			
		else
			--back to the corps
			troop:Release()
			InputUtil_Pause( troop:ToString(), "released", combat:ToString() )
		end
	end )

	Stat_Add( "Combat@Result", combat:ToString( "RESULT" ), StatType.LIST )
	Stat_Add( MathUtil_FindName( CombatType, type ) .. "@WIN=" .. MathUtil_FindName( CombatSide, winner ), 1, StatType.TIMES )
	--Stat_Add( "Combat@Winner", combat:ToString() .. " winner=" .. combat:GetGroupName( winner ), StatType.LIST )

	local group = combat:GetGroup( winner )
	local oppGroup = combat:GetGroup( combat:GetOppSide( winner ) )
	if group then
		group:ElectLeader()
		if IsAffectReputation then group:WinCombat( combat ) end
	end
	if oppGroup then
		oppGroup:ElectLeader()
		if IsAffectReputation then oppGroup:LoseCombat( combat ) end
	end

	Debug_Log( combat:ToString( "DEBUG_CORPS" ) )
	Debug_Log( combat:ToString( "RESULT" ), "combat end!!!" )

	Asset_Foreach( combat, CombatAssetID.CORPS_LIST, function ( corps )
		if corps:GetSoldier() == 0 then
			Corps_Dismiss( corps, true )
			Stat_Add( "Corps@Vanished", corps:ToString( "SIMPLE"), StatType.LIST )
		else
			Corps_AfterCombat( corps )
		end
	end )

	Debug_Log( "combat end", combat:ToString( "RESULT" ) )

	Message_Post( MessageType.COMBAT_ENDED, { combat = combat } )

	--sanity checker, whether release all guard & reserves
	for _, troop in ipairs( removeTroopList ) do
		Debug_Log( "remove troop=" .. troop.id .. " CID=" .. combat.id )
		Entity_Remove( troop )
	end
	--[[
	Entity_Foreach( EntityType.TROOP, function ( troop )		
		if troop:GetStatus( TroopStatus.RESERVE ) then
			--InputUtil_Pause( "1")
		 	--DBG_Error( troop:ToString( "ALL" ) )
		 	Debug_Log( troop:ToString( "ALL" ) )
		end
		if troop:GetStatus( TroopStatus.GUARD ) then
			--InputUtil_Pause( "2")
			--DBG_Error( troop:ToString( "ALL" ) )
			Debug_Log( troop:ToString( "ALL" ) )
		end
	end)
	]]

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

	if combat then
		Message_Post( MessageType.COMBAT_TRIGGERRED, { combat = combat, atk = atk, def = def } )
		Stat_Add( "Combat@Field", 1, StatType.TIMES )
	else
		Message_Post( MessageType.COMBAT_UNTRIGGER, { corps = atk } )
	end
end

local function Warfare_OnSiegeCombatTrigger( msg )
	local atk   = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "atk" )
	local city  = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "city" )
	local combat = Warefare_SiegeCombatOccur( atk, city )
	if combat then
		Message_Post( MessageType.COMBAT_TRIGGERRED, { combat = combat, atk = atk } )
		Stat_Add( "Combat@Siege", 1, StatType.TIMES )
	else
		Message_Post( MessageType.COMBAT_UNTRIGGER, { corps = atk } )
	end
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
	for id, combat in pairs( self._combats ) do
		if Warfare_UpdateCombat( combat ) == true then
			Stat_Add( "Combat@Duration", Asset_Get( combat, CombatAssetID.TIME ), StatType.ACCUMULATION )
			self._combats[id] = nil
		end
	end
end

function WarfareSystem:GetCombatByPlot( plot )
	return self._combats[plot.id]
end

function WarfareSystem:AddCombat( combat )
	local plot = Asset_Get( combat, CombatAssetID.PLOT )
	if not plot then
		error( "why no plot" )
		return
	end
	if self._combats[plot.id] then
		local existCombat = self._combats[plot]
		print( existCombat:ToString( "DEBUG_CORPS" ) )
		DBG_Error( "Plot" .. "(x=" .. Asset_Get( plot, PlotAssetID.X ) .. ",y=" .. Asset_Get( plot, PlotAssetID.Y ) .. ") already has a combat!" )
		return;
	end	
	self._combats[plot.id] = combat
end