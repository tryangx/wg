local function Warefare_CombatOccur()

end

function Warefare_FieldCombatOccur( corps, city )
	local combat = Entity_New( EntityType.COMBAT )
	
	--set type
	Asset_Set( combat, CombatAssetID.TYPE, CombatType.FIELD_COMBAT )

	--set battlefield
	Asset_Set( combat, CombatAssetID.BATTLEFIELD, BattlefieldTable_Get( 100 ) )
	Asset_Set( combat, CombatAssetID.ATKCAMPFIELD, BattlefieldTable_Get( 200 ) )
	Asset_Set( combat, CombatAssetID.DEFCAMPFIELD, BattlefieldTable_Get( 300 ) )

	--add attacker
	combat:AddCorps( corps, CombatSide.ATTACKER )

	--add defender
	Asset_ForeachList( city, CityAssetID.CORPS_LIST, function ( def )
		combat:AddCorps( def, CombatSide.DEFENDER )	
	end )	

	--set purpose
	Asset_Set( combat, CombatAssetID.ATK_PURPOSE, CombatPurpose.MODERATE )
	Asset_Set( combat, CombatAssetID.DEF_PURPOSE, CombatPurpose.MODERATE )

	System_Get( SystemType.WARFARE_SYS ):AddCombat( combat )

	MathUtil_Dump( corps )

	print( "field occur" )

	return combat
end

function Warefare_SiegeCombatOccur( corps, city )
	local combat = Entity_New( EntityType.COMBAT )
	
	--set type
	Asset_Set( combat, CombatAssetID.TYPE, CombatType.SIEGE_COMBAT )

	--set battlefield
	Asset_Set( combat, CombatAssetID.BATTLEFIELD, BattlefieldTable_Get( 100 ) )
	Asset_Set( combat, CombatAssetID.ATKCAMPFIELD, BattlefieldTable_Get( 200 ) )
	Asset_Set( combat, CombatAssetID.DEFCAMPFIELD, BattlefieldTable_Get( 300 ) )

	Asset_Set( combat, CombatAssetID.CITY, city )

	--add attacker
	combat:AddCorps( corps, CombatSide.ATTACKER )

	--add defender
	Asset_ForeachList( city, CityAssetID.CORPS_LIST, function ( def )
		combat:AddCorps( def, CombatSide.DEFENDER )	
	end )	

	--set purpose
	Asset_Set( combat, CombatAssetID.ATK_PURPOSE, CombatPurpose.AGGRESSIVE )
	Asset_Set( combat, CombatAssetID.DEF_PURPOSE, CombatPurpose.MODERATE )

	System_Get( SystemType.WARFARE_SYS ):AddCombat( combat )

	print( "food=" .. Asset_Get( corps, CorpsAssetID.FOOD ) )

	print( "siege occur", combat )

	return combat
end

-------------------------------------


WarfareSystem = class()

function WarfareSystem:__init()
	System_Setup( self, SystemType.WARFARE_SYS, "WARFARE" )
end

function WarfareSystem:Start()
	self._combats = {}
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
	if winner == CombatSide.ATTACKER then
		if type == CombatType.SIEGE_COMBAT then	
			print( "atk capture city", loc.name )
		else
			print( "atk win, def withdraw" )
		end

	elseif winner == CombatSide.DEFENDER then
		if type == CombatType.SIEGE_COMBAT then	
			print( "def defend city", loc.name )
		else
			print( "def win, atk withdraw" )
		end

	elseif winner == CombatSide.UNKNOWN then
		if type == CombatType.SIEGE_COMBAT then
			print( "siege draw", loc.name )
		else
			print( "field draw" )
		end
	end
	return true
end

function WarfareSystem:Update()
	local lists = {}
	for k, combat in pairs( self._combats ) do				
		if self:UpdateCombat( combat ) == true then
			Stat_Add( "Combat@Duration", Asset_Get( combat, CombatAssetID.TIME ), StatType.ACCUMULATION )

			self._combats[k] = nil
			Entity_Remove( combat )
		end
	end
end

function WarfareSystem:AddCombat( combat )
	table.insert( self._combats, combat )
end