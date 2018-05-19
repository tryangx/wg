
----------------------------------------------------------------

SkillTable = class()

function SkillTable:Load( data )
	self.id   = data.id or 0	
	self.name = data.name or 0

	self.effects      = MathUtil_Copy( data.effects )
	self.prerequisite = MathUtil_Copy( data.prerequisite )
	self.traits       = MathUtil_Copy( data.traits )
end

-------------------------------
_trait2Skill = {}
_multiTrait2Skill = {}

local _SkillTableMng = Manager( 0, "SkillTable", SkillTable )

function SkillTable_Load( datas )
	_SkillTableMng:Clear()
	_SkillTableMng:LoadFromData( datas )

	_SkillTableMng:ForeachData( function ( skill )
		for _, traitList in pairs( skill.traits ) do
			if #traitList == 1 then
				local trait = CharaTraitType[traitList[1]]
				if not _trait2Skill[trait] then
					_trait2Skill[trait] = {}
				end
				table.insert( _trait2Skill[trait], skill )				
			else
				--[[
				MathUtil_Permutation( traitList, 1, #traitList, function ( list )
					local name = ""					
					for _, traitName in ipairs( list ) do
						print( CharaTraitType[traitName], traitName )
					end
					InputUtil_Pause()
				end )
				]]
				table.insert( _multiTrait2Skill, skill )
			end
		end
	end)
	--InputUtil_Pause( "single=" .. MathUtil_Size( _trait2Skill ), "multi=" .. #_multiTrait2Skill )
end

function SkillTable_Get( id )
	return _SkillTableMng:GetData( id )
end

function SkillTable_Foreach( fn )
	_SkillTableMng:ForeachData( fn )
end

function SkillTable_Find( fn )
	return _SkillTableMng:FindData( fn )
end

function SkillTable_QuerySkillList( chara )
	local skills = {}

	function CheckPrerequisite( prerequisite )
		if not prerequisite then return true end
		if prerequisite.pot_above and Asset_Get( chara, CharaAssetID.POTENTIAL ) < prerequisite.pot_above then
			return false
		end
		if prerequisite.exp_above and Asset_Get( chara, CharaAssetID.EXP ) < prerequisite.exp_above then
			return false
		end
		return true
	end

	local traitDict = Asset_GetDict( chara, CharaAssetID.TRAITS )
	--print( MathUtil_ToString( traitList ) )
	--single trait requirement
	for _, trait in pairs( traitDict ) do
		if _trait2Skill[trait] then			
			for _, skill in pairs( _trait2Skill[trait] ) do
				if CheckPrerequisite( skill.prerequisite ) then
					table.insert( skills, skill )
				end
			end
		end
	end

	--multi trait requirement
	for _, skill in ipairs( _multiTrait2Skill ) do
		local valid = false
		for _, list in ipairs( skill.traits ) do
			valid = true
			for _, traitName in ipairs( list ) do
				local trait = CharaTraitType[traitName]
				--print( trait, traitName )
				if not MathUtil_IndexOf( traitDict, trait ) then
					valid = false
					break
				end
			end
			if valid == true then break end
		end
		if valid == true then
			if CheckPrerequisite( skill.prerequisite ) then
				table.insert( skills, skill )
			end
		end
	end

	return skills
end