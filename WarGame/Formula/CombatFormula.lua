----------------------------------------------
--
-- Very important function in COMBAT
--

function Combat_NeedWithdraw()

end

function Combat_IsPrepared( troop )
	local soldier = Asset_Get( troop, TroopAssetID.SOLDIER )
	local maxsoldier = Asset_Get( troop, TroopAssetID.MAX_SOLDIER )

	local organization = Asset_Get( troop, TroopAssetID.ORGANIZATION )	

	local morale = Asset_Get( troop, TroopAssetID.MORALE )

	local soliderRatio = soldier * 100 / maxsoldier
	local orgRatio = organization * 100 / soldier

	local ret = false
	local order = troop._order
	if order == CombatOrder.FORCED_ATTACK then
		ret = soliderRatio + orgRatio > 120 and soliderRatio > 55 and morale > 40
	elseif order == CombatOrder.ATTACK then
		ret = soliderRatio + orgRatio > 130 and soliderRatio > 60 and morale > 40
	elseif order == CombatOrder.DEFEND then
		ret = soliderRatio + orgRatio > 140 and soliderRatio > 65 and morale > 45
	elseif order == CombatOrder.SURVIVE then
		ret = soliderRatio + orgRatio > 150 and soliderRatio > 70 and morale > 45
	end
	--if ret == false then
		print( troop.name .. "," .. troop.id .. " Pre=" .. ( ret == true and "Y" or "N" ) .. " side=" .. MathUtil_FindName( CombatSide, troop._combatSide ) .. " sol=" .. soliderRatio .. " org=" .. orgRatio )
	--end
	return ret
end

function Combat_CalcDamage( atk, def, params )
	--Soldier number modification
	local atkNumber = Asset_Get( atk, TroopAssetID.SOLDIER )
	if params.isAssit == true then
		atkNumber = atkNumber * 0.5
	end	
	if params.isCounter == true then		
		atkNumber = atkNumber * 0.5
	end
	if params.isCrowd == true then
		atkNumber = atkNumber * 0.5
	end		
	if params.isSuppressed == true then
		atkNumber = atkNumber * 0.5
	end
	local number_mod = 0
	if atkNumber < 100 then number_mod = atkNumber
	elseif atkNumber < 500 then number_mod = 100 + ( atkNumber - 100 ) * 0.25
	elseif atkNumber < 2000 then number_mod = 200 + ( atkNumber - 500 ) * 0.1
	else number_mod = 350 end

	--Weapon & Armor Modification
	local atklv = Asset_Get( atk, TroopAssetID.LEVEL )	
	local hit_rate      = math.max( 10, params.weapon.accuracy + 5 * ( atklv - params.weapon.level ) )
	local org_rate      = 1	
	local weapon_pow    = params.weapon.power
	local armor     = Asset_Get( def, TroopAssetID.ARMOR ) or 0
	local toughness = Asset_Get( def, TroopAssetID.TOUGHNESS ) or 0
	hit_rate = hit_rate * 100 / ( 100 + toughness )
	--determine rate
	local weapon_rate = math.max( 0.1, 1 + ( armor > 0 and ( weapon_pow - armor ) / ( armor ) or 0 ) )

	local exposure_rate = 1
	local is_critical = false
	if params.isTest ~= true then
		--intel about enemy( exposure ) will determine how
		local exposure = 50 + ( def._exposure ~= nil and def._exposure * 0.5 or 50 )
		exposure_rate = Random_GetInt_Sync( exposure, 110 ) * 0.01

		--determine critical
		local atkmor = Asset_Get( atk, TroopAssetID.MORALE )
		local defmor = Asset_Get( def, TroopAssetID.MORALE ) or 0	
		local critical_range = math.min( 35, ( atkmor - defmor ) * 0.5 + 10 )
		is_critical = Random_GetInt_Sync( 1, 100 ) < critical_range
	end

	local dmg_rate = 1

	if params.isTired == true then
		dmg_rate = dmg_rate * 0.5
	end

	if params.type ~= CombatTask.DESTROY_DEFENSE then
		if params.isHeightAdv == true then
			--dmg_rate = dmg_rate * 1.2
			hit_rate = hit_rate + 0.15
			--InputUtil_Pause( atk.id, "height adv" )
		end
		if params.isHeightDisadv == true then
			dmg_rate = dmg_rate * 0.5
			--InputUtil_Pause( atk.id, 'height disadv')
		end
	end
	if is_critical == true then
		dmg_rate = dmg_rate * 1.5
	end	
	if params.prot and params.prot > 0 then
		dmg_rate = dmg_rate * 100 / ( 100 + params.prot )
	end

	--calc dmg
	local dmg = math.ceil( number_mod * dmg_rate * weapon_rate * exposure_rate )
	
	--print( "num=" .. number_mod, "dmg_rate="..dmg_rate, "wp_rate="..weapon_rate, "exposure_rate="..exposure_rate )
	--print( "num="..number_mod, weapon_pow, weapon_resist, "weapon="..math.ceil( weapon_rate * 100 ), "org=".. math.ceil( org_rate * 100 ), "hit=".. math.ceil( hit_rate * 100 ), " critical=" .. ( is_critical and "true" or "false" ) )
	--print( "atk=".. atk.id, "def=" .. ( def.id or "defense" ), "dule=",params.isDule, "counter=",params.isCounter, "Suppressive=",params.isSuppressive )	

	return dmg, org_rate, hit_rate, is_critical
end

function Combat_FindCounterattackWeapon( troop, params )
	if params.type == CombatTask.SHOOT then return nil end
	local weapon
	weapon = troop:GetWeaponBy( "range", WeaponRangeType.CLOSE )
	if weapon then return weapon end
	weapon = troop:GetWeaponBy( "range", WeaponRangeType.LONG )
	if weapon then return weapon end
	return nil
end