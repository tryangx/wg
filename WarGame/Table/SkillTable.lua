
----------------------------------------------------------------

SkillTable = class()

function SkillTable:Load( data )
	self.id   = data.id or 0	
	self.name = data.name or 0
	self.type = CharaSkillType[data.type]

	if not data.type then DBG_Error( "no skilltype", data.id ) end

	self.effects      = MathUtil_Copy( data.effects )
	self.prerequisite = MathUtil_Copy( data.prerequisite )
	self.conditions   = MathUtil_Copy( data.conditions )
end

function SkillTable:ToString( type )
	local content = ""
	content = content .. self.name .. "[" .. self.id .. "]"
	if type == "EFFECT" then
		for _, effect in ipairs( self.effects ) do
			content = content .. effect.type .. ","
		end
	end
	return content
end

-------------------------------
_trait2Skill = {}
_multiTrait2Skill = {}

local _SkillTableMng = Manager( 0, "SkillTable", SkillTable )

function SkillTable_Load( datas )
	_SkillTableMng:Clear()
	_SkillTableMng:LoadFromData( datas )
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
	local traitDict = Asset_GetDict( chara, CharaAssetID.TRAITS )

	local function CheckCondition( cond )
		if cond.prob and Random_GetInt_Sync( 1, 100 ) > cond.prob then return end
		if cond.pot_above and Asset_Get( chara, CharaAssetID.POTENTIAL ) < cond.pot_above then return end		
		if cond.lv_above and Asset_Get( chara, CharaAssetID.LEVEL ) < cond.lv_above then return end		
		if cond.trait and not traitDict[cond.trait] then return end		
		if cond.no_trait and traitDict[cond.trait] then return end		
		if cond.traits then
			for _, traitName in ipairs( cond.traits ) do
				local traitType = CharaTraitType[traitName]
				--print( "checktraits", traitName, traitType )
				if not traitDict[traitType] then return end
			end
		end
		if cond.no_traits then
			for _, traitName in ipairs( cond.traits ) do
				local traitType = CharaTraitType[traitName]
				--print( "checktraits", traitName, traitType )
				if traitDict[traitType] then return end
			end
		end
		return true
	end

	_SkillTableMng:ForeachData( function ( skill )
		if Asset_HasItem( chara, CharaAssetID.SKILLS, skill ) == true then
			--print( "already has", skill.name )
			return
		end
		local valid = false
		if skill.conditions then
			for _, cond in ipairs( skill.conditions ) do
				if CheckCondition( cond ) == true then
					valid = true
					break
				end
			end
		end
		if valid == true then
			table.insert( skills, skill )
		end
	end )

	return skills
end