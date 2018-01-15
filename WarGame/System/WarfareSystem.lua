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
	if winner == CombatSide.ATTACKER then
		if type == CombatType.SIEGE_COMBAT then	
			InputUtil_Pause( "atk capture city" )
		else
			InputUtil_Pause( "atk win, def withdraw" )
		end
	elseif winner == CombatSide.DEFENDER then
		if type == CombatType.SIEGE_COMBAT then	
			InputUtil_Pause( "def defend city" )
		else
			InputUtil_Pause( "def win, atk withdraw" )
		end
	elseif winner == CombatSide.UNKNOWN then
		if type == CombatType.SIEGE_COMBAT then	
			InputUtil_Pause( "siege draw" )
		else
			InputUtil_Pause( "draw" )
		end
	end
	return true
end

function WarfareSystem:Update()
	local lists = {}
	for k, combat in pairs( self._combats ) do				
		if self:UpdateCombat( combat ) == true then
			self._combats[k] = nil
			if Entity_Remove( combat ) then
				--InputUtil_Pause( "remove combat" )
			end			
		end
	end
end

function WarfareSystem:AddCombat( combat )
	table.insert( self._combats, combat )
end