--if combat is 
function Warfare_GetComat( plot )
	local combat = System_Get( SystemType.WARFARE_SYS ):GetCombatByPlot( plot )
	return combat
end

local function Warfare_JoinCombat( combat, corps, side )	
	Move_Suspend( corps )
	corps:EnterCombat( combat.id )	
	combat:AddCorps( corps, side )
end

--atk can be invalid
--def can be invalid
function Warefare_FieldCombatOccur( plot, atk, def, defList )
	--first, we should find exist combat in this plot
	local combatExist = true
	local combat = Warfare_GetComat( plot )
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

		Asset_Set( combat, CombatAssetID.ATK_PURPOSE, CombatPurpose.AGGRESSIVE )
		Asset_Set( combat, CombatAssetID.DEF_PURPOSE, CombatPurpose.AGGRESSIVE )

		System_Get( SystemType.WARFARE_SYS ):AddCombat( combat )

		combatExist = false
	end

	if atk then Warfare_JoinCombat( combat, atk, CombatSide.ATTACKER ) end
	if def then Warfare_JoinCombat( combat, def, CombatSide.DEFENDER ) end

	if defList then
		for _, corps in pairs( defList ) do
			Warfare_JoinCombat( combat, corps, CombatSide.DEFENDER )
		end
	end

	if combatExist == false then
		Stat_Add( "Combat@Occur", combat:ToString( "DEBUG_CORPS" ), StatType.LIST )
	else
		Stat_Add( "Combat@Update", combat:ToString( "ALL" ), StatType.LIST )
	end

	Message_Post( MessageType.FIELD_COMBAT_OCCURED, { combat = combat } )
	Message_Post( MessageType.COMBAT_OCCURED, { combat = combat } )

	--Debug_Log( "field combat occur", combat:ToString() )

	return combat
end

function Warefare_HarassCombatOccur( city, corps )
	local combatExist = true
	local plot = Asset_Get( city, CityAssetID.CENTER_PLOT )
	local combat = Warfare_GetComat( plot )
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
				Warfare_JoinCombat( combat, def, CombatSide.DEFENDER )
			end
		end

		--set purpose
		Asset_Set( combat, CombatAssetID.ATK_PURPOSE, CombatPurpose.MODERATE )
		Asset_Set( combat, CombatAssetID.DEF_PURPOSE, CombatPurpose.AGGRESSIVE )

		System_Get( SystemType.WARFARE_SYS ):AddCombat( combat )

		combatExist = false
	end

	--add attacker
	Warfare_JoinCombat( combat, corps, CombatSide.ATTACKER )

	if combatExist == false then
		Stat_Add( "Combat@Occur", combat:ToString( "DEBUG_CORPS" ), StatType.LIST )
	else
		Stat_Add( "Combat@Update", combat:ToString( "ALL" ), StatType.LIST )
	end

	Message_Post( MessageType.FIELD_COMBAT_OCCURED, { combat = combat } )
	Message_Post( MessageType.COMBAT_OCCURED, { combat = combat } )

	--Debug_Log( "field combat occur", combat:ToString() )

	return combat
end

function Warefare_SiegeCombatOccur( city, corps )
	if Asset_Get( corps, CorpsAssetID.GROUP ) == Asset_Get( city, CityAssetID.GROUP ) then
		print( city:ToString(), "is already occupied" )
		return
	end
	local combatExist = true
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

		--print( combat:ToString(), " combatbegin" )
		--city:TrackData()

		--add defender
		Asset_Foreach( city, CityAssetID.CORPS_LIST, function ( def )
			if def:IsAtHome() then
				Warfare_JoinCombat( combat, def, CombatSide.DEFENDER )
			end
		end )

		--set purpose
		Asset_Set( combat, CombatAssetID.ATK_PURPOSE, CombatPurpose.AGGRESSIVE )
		Asset_Set( combat, CombatAssetID.DEF_PURPOSE, CombatPurpose.MODERATE )

		System_Get( SystemType.WARFARE_SYS ):AddCombat( combat )

		combatExist = false
	end

	--add attacker
	Warfare_JoinCombat( combat, corps, CombatSide.ATTACKER )

	if not combatExist then
		Stat_Add( "Combat@Occur", combat:ToString( "DEBUG_CORPS" ), StatType.LIST )
	else
		Stat_Add( "Combat@Update", combat:ToString( "ALL" ), StatType.LIST )
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
		
		local oldReserves = city:GetPopu( CityPopu.RESERVES )
		city:SetPopu( CityPopu.RESERVES, reserves )

		Stat_Add( "Guard@Lose", oldGuard - guard, StatType.ACCUMULATION )
		Stat_Add( "Reserve@Lose", oldReserves - reserves, StatType.ACCUMULATION )

		city:SetStatus( CityStatus.IN_SIEGE )

		--Seize city
		if winner == CombatSide.ATTACKER  then
			local group = combat:GetGroup( winner )
			if group then
				print( "occupy", city:ToString(), group:ToString(), g_Time:ToString() )
				Stat_Add( "City@Occupy", city:ToString() .. " occupied by " .. ( group and group:ToString() or "" ) .. " " .. g_Time:CreateCurrentDateDesc(), StatType.LIST )
				Debug_Log( city:ToString() .. " occupied by " .. ( group and group:ToString() or "" ), g_Time:CreateCurrentDateDesc() )
				group:OccupyCity( city )
			end
			
			--garrsion the occupied city
			local corpsList = combat:GetCorpsList( winner )
			for _, corps in ipairs( corpsList ) do
				if Asset_Get( corps, CorpsAssetID.GROUP ) ~= group then
					error( "why corps is here" )
				end
				--InputUtil_Pause( "garrision", corps:ToString(""), city:ToString("") )
				Corps_Join( corps, city, true )
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

	function GrantMedal( troop )
		local medal = TroopMedalTable_Find( function ( medal )
			local existMedal = Asset_GetDictItem( troop, TroopAssetID.MEDALS, medal.id )
			if existMedal then
				--InputUtil_Pause( troop:ToString(), "has medal=" .. medal.name )
				return
			end
			local valid = true
			for _, cond in pairs( medal.prerequsite ) do
				valid = true
				--if valid == true and cond.combat and CombatType[cond.combat] ~= Asset_Get( combat, CombatAssetID.TYPE ) then valid = false end
				if valid == true then break end
			end			
			return valid
		end )
		if medal then
			troop:GrantMedal( medal )
			--local existMedal = Asset_GetDictItem( troop, TroopAssetID.MEDALS, medal.id )
			--print( troop:ToString(), "grant medal=" .. medal.name, existMedal )
		end
	end

	--check medals
	local listid = winner == CombatSide.ATTACKER and CombatAssetID.ATK_CORPS_LIST or CombatAssetID.DEF_CORPS_LIST
	Asset_Foreach( combat, listid, function ( corps )
		Asset_Foreach( corps, CorpsAssetID.TROOP_LIST, function ( troop )
			--medal number is less than level / 5
			--if Asset_GetDictSize( troop, TroopAssetID.MEDALS ) >= Asset_Get( troop, TroopAssetID.LEVEL ) * 0.5 then return end
			GrantMedal( troop )
		end)
	end )

	Stat_Add( "Combat@Result", combat:ToString( "RESULT" ), StatType.LIST )
	Stat_Add( MathUtil_FindName( CombatType, type ) .. "@WIN=" .. MathUtil_FindName( CombatSide, winner ), 1, StatType.TIMES )
	--Stat_Add( "Combat@Winner", combat:ToString() .. " winner=" .. combat:GetGroupName( winner ), StatType.LIST )

	--combat bonus
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

	--Debug_Log( combat:ToString( "DEBUG_CORPS" ) )
	--print( combat:ToString( "RESULT" ), "combat end!!!" )

	combat:WipeCorps()

	Message_Send( MessageType.COMBAT_ENDED, { combat = combat } )

	--release all guard & reserves
	for _, troop in ipairs( removeTroopList ) do
		Debug_Log( "remove troop=" .. troop.id .. " CID=" .. combat.id )
		Entity_Remove( troop )
	end
	--[[
	--sanity checker, wheter guard & reserve still exist
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
	local combat = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "combat" )
	if not combat then
		DBG_Error( "why no combat to remove?" )
		return
	end
	
	if Asset_Get( combat, CombatAssetID.TYPE ) == CombatType.SIEGE_COMBAT then
		--local city = Asset_Get( combat, CombatAssetID.CITY )
		--city:TrackData( true )
	end

	--print( "combat end=" .. combat:ToString(), g_Time:ToString() )

	Stat_Add( "CombatDur@" .. combat.id, Asset_Get( combat, CombatAssetID.DAY ), StatType.VALUE )

	Asset_Foreach( combat, CombatAssetID.CORPS_LIST, function ( corps )
		--sanity checker
		--print( corps:ToString(), "should leave combat="..combat:ToString())
		if not corps:GetTask() and Move_IsMoving( corps ) then
			if not corps:GetStatus( CorpsStatus.RETREAT_TO_CITY ) then
				Entity_ToString( EntityType.MOVE )
				DBG_Error( "why is moving", corps:ToString("STATUS") )
			end
		end
	end )
	--[[
	Asset_Foreach( combat, CombatAssetID.ATK_CORPS_LIST, function ( corps )
		corps:SetStatus( CorpsStatus.IN_COMBAT )
	end )
	Asset_Foreach( combat, CombatAssetID.DEF_CORPS_LIST, function ( corps )
		corps:SetStatus( CorpsAssetID.STATUSES, CorpsStatus.IN_COMBAT )
	end )
	]]

	--remove combat cached manually
	System_Get( SystemType.WARFARE_SYS ):RemoveCombat( combat )

	--don't remove combat now, should after combat_end message was processed
	Entity_Remove( combat )
	--Debug_Log( "remove combat" )
end

local function Warfare_OnFieldCombatTrigger( msg )
	local city = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "city" )
	local plot = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "plot" )
	local atk  = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "atk" )
	local def  = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "def" )
	local defList = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "defList" )

	local combat
	if plot then
		combat = Warefare_FieldCombatOccur( plot, atk, def, defList )

	elseif city then
		local corps = city:GetDefendCorps()
		if #corps == 0 then
			combat = Warefare_SiegeCombatOccur( city, atk )
		else
			combat = Warefare_HarassCombatOccur( city, atk )
		end
	end

	if combat then
		Message_Post( MessageType.COMBAT_TRIGGERRED_NOTIFY, { combat = combat, atk = atk, def = def } )
		Stat_Add( "Combat@Field", 1, StatType.TIMES )
		--print( g_Time:ToString(), "fieldcombat=" .. combat:ToString() )
	else
		DBG_Error( "why here" )
		Message_Post( MessageType.COMBAT_UNTRIGGER_NOTIFY, { corps = atk } )
	end
end

local function Warfare_OnSiegeCombatTrigger( msg )
	local atk   = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "atk" )
	local city  = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "city" )	
	local plot = Asset_Get( city, CityAssetID.CENTER_PLOT )
	local combat = System_Get( SystemType.WARFARE_SYS ):GetCombatByPlot( plot )
	if combat then
		--corps from A maybe interrupted a siege combat between B and C
		if combat:GetGroup( CombatSide.ATTACKER ) ~= Asset_Get( atk, CorpsAssetID.GROUP ) then
			local defList = MathUtil_ShallowCopy( Asset_GetList( combat, CombatAssetID.ATK_CORPS_LIST ) )
			Message_Post( MessageType.COMBAT_INTERRUPTED, { combat = combat } )
						
			--trigger a new field combat
			--  todo: should corps in siege city will attend the field combat?
			--InputUtil_Pause( "trigger new combat" )			
			Message_Post( MessageType.FIELD_COMBAT_TRIGGER, { plot = plot, atk = actor, defList = defList } )
			return
		end
	end		
	local combat = Warefare_SiegeCombatOccur( city, atk )
	if combat then
		Message_Post( MessageType.COMBAT_TRIGGERRED_NOTIFY, { combat = combat, atk = atk } )
		Stat_Add( "Combat@Siege", 1, StatType.TIMES )
		--print( g_Time:ToString(), "siegecombat=" .. combat:ToString() )
	else
		Debug_Log( atk:ToString(), "no need to attack", city:ToString() )
		Message_Post( MessageType.COMBAT_UNTRIGGER_NOTIFY, { corps = atk, city = city } )
	end
end

local function Warfare_OnCombatAttend( msg )
	local combat = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "combat" )
	local atk = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "atk" )
	
	local type = Asset_Get( combat, CombatAssetID.TYPE )
	if type == CombatType.SIEGE_COMBAT then
		local retCombat = Warefare_SiegeCombatOccur( Asset_Get( combat, CombatAssetID.CITY ), atk )
		Message_Post( MessageType.COMBAT_TRIGGERRED_NOTIFY, { combat = retCombat, atk = atk } )
	else
		local def = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "def" )
		local retCombat = Warefare_FieldCombatOccur( Asset_Get( combat, CombatAssetID.PLOT ), atk, def )
		Message_Post( MessageType.COMBAT_TRIGGERRED_NOTIFY, { combat = retCombat, atk = atk, def = def } )
	end	
end

local function Warfare_OnCombatInterrupted( msg )		
	local combat = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "combat" )
	combat:WipeCorps()

	--print( "interuppted", combat:ToString("") )

	local params = Asset_GetList( msg, MessageAssetID.PARAMS )
	Message_Send( MessageType.COMBAT_ENDED, params )
end

-------------------------------------


WarfareSystem = class()

function WarfareSystem:__init()
	System_Setup( self, SystemType.WARFARE_SYS, "WARFARE" )
end

function WarfareSystem:Start()
	self._combats = {}

	Message_Handle( self.type, MessageType.COMBAT_INTERRUPTED,   Warfare_OnCombatInterrupted )

	Message_Handle( self.type, MessageType.FIELD_COMBAT_TRIGGER, Warfare_OnFieldCombatTrigger )
	Message_Handle( self.type, MessageType.SIEGE_COMBAT_TRIGGER, Warfare_OnSiegeCombatTrigger )
	Message_Handle( self.type, MessageType.COMBAT_ATTEND,        Warfare_OnCombatAttend )	

	Message_Handle( self.type, MessageType.COMBAT_ENDED,         Warfare_OnCombatEnded )
end

function WarfareSystem:UpdateCombat( combat )
end

function WarfareSystem:Update()
	local lists = {}
	for id, combat in pairs( self._combats ) do
		if Warfare_UpdateCombat( combat ) == true then
			Stat_Add( "Combat@Duration", Asset_Get( combat, CombatAssetID.TIME ), StatType.ACCUMULATION )
			--self._combats[id] = nil
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

function WarfareSystem:RemoveCombat( combat )
	local plot = Asset_Get( combat, CombatAssetID.PLOT )	
	if plot then
		self._combats[plot.id] = nil
	else
		error( "1")
	end
end