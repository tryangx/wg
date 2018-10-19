CharaAssetType = 
{
	BASE_ATTRIB   = 1,
	ACTION_ATTRIB = 2,
	GROWTH_ATTRIB = 3,
	RELATION_ATTRIB = 4,
}

CharaAssetID = 
{
	--
	AGE             = 102,
	--when did he born
	BIRTH           = 103,
	--how many days he left
	LIFE            = 104,
	--male/female/sth else?
	GENDER          = 105,
	--is historic or fictional
	ORIGIN          = 106,
	GROUP           = 110,
	TITLE           = 111,
	CAREER          = 112,
	HOME            = 120,
	LOCATION        = 121,
	CORPS           = 122,
	TROOP           = 123,
	STATUSES        = 130,
	TASKS           = 131,

	--action
	ACTION_POINT    = 200,
	--[[
	POLITICS        = 201,
	POLITICS_TALENT = 202,
	POLITICS_LIMIT  = 203,
	STRATEGY        = 204,
	STRATEGY_TALENT = 205,
	STRATEGY_LIMIT  = 206,	
	TACTIC          = 207,
	TACTIC_TALENT   = 208,
	TACTIC_LIMIT    = 209,
	]]

	--GROWTH
	--normal, good, excellent, best, perfect
	GRADE           = 300,
	--equals to the sum of level + skill 
	POTENTIAL       = 301,
	--determine to learn skills
	LEVEL           = 303,
	--determine how many skills enabled
	LOYALITY        = 310,
	--determine what job can be assigned.
	CONTRIBUTION    = 311,

	--affect what skills can learn
	TRAITS          = 320,
	SKILLS          = 321,

	--relationship	
	SUBORDINATES    = 400,
	SUPERIOR        = 401,
	RELATIONS       = 402,
}

local function Chara_SetTrait( entity, id, value, key )
	if typeof( key ) == "string" then		
		key = CharaTraitType[key]
	end
	--InputUtil_Pause( "settrait", key, value )
	return value, key
end

CharaAssetAttrib = 
{
	--base
	age        = AssetAttrib_SetNumber ( { id = CharaAssetID.AGE,        type = CharaAssetType.BASE_ATTRIB, min = 1, max = 120 } ),
	birth      = AssetAttrib_SetNumber ( { id = CharaAssetID.BIRTH,      type = CharaAssetType.BASE_ATTRIB } ),
	life       = AssetAttrib_SetNumber ( { id = CharaAssetID.LIFE,       type = CharaAssetType.BASE_ATTRIB, min = 1, max = 100 } ),
	gender     = AssetAttrib_SetNumber ( { id = CharaAssetID.GENDER,     type = CharaAssetType.BASE_ATTRIB, enum = CharaGender } ),
	origin     = AssetAttrib_SetNumber ( { id = CharaAssetID.ORIGIN,     type = CharaAssetType.BASE_ATTRIB, enum = CharaOrigin } ),	
	group      = AssetAttrib_SetPointer( { id = CharaAssetID.GROUP,      type = CharaAssetType.BASE_ATTRIB, setter = Entity_SetChara } ),
	title      = AssetAttrib_SetPointer ( { id = CharaAssetID.TITLE,     type = CharaAssetType.BASE_ATTRIB, setter = Entity_GetCharaTitle } ),
	career     = AssetAttrib_SetNumber ( { id = CharaAssetID.CAREER,     type = CharaAssetType.BASE_ATTRIB, } ),
	home       = AssetAttrib_SetPointer( { id = CharaAssetID.HOME,       type = CharaAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	location   = AssetAttrib_SetPointer( { id = CharaAssetID.LOCATION,   type = CharaAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	corps      = AssetAttrib_SetPointer( { id = CharaAssetID.CORPS,      type = CharaAssetType.BASE_ATTRIB, setter = Entity_SetCorps } ),
	troop      = AssetAttrib_SetPointer( { id = CharaAssetID.TROOP,      type = CharaAssetType.BASE_ATTRIB, setter = Entity_SetTroop } ),
	statuses   = AssetAttrib_SetDict   ( { id = CharaAssetID.STATUSES,   type = CityAssetType.BASE_ATTRIB } ),

	--action
	aps          = AssetAttrib_SetDict( { id = CharaAssetID.ACTION_POINT,      type = CharaAssetType.ACTION_ATTRIB } ),
	--[[
	politics     = AssetAttrib_SetNumber( { id = CharaAssetID.POLITICS,        type = CharaAssetType.ACTION_ATTRIB, min = 0, max = 9999 } ),
	politics_tal = AssetAttrib_SetNumber( { id = CharaAssetID.POLITICS_TALENT, type = CharaAssetType.ACTION_ATTRIB, min = 0, max = 100 } ),
	politics_lim = AssetAttrib_SetNumber( { id = CharaAssetID.POLITICS_LIMIT,type = CharaAssetType.ACTION_ATTRIB, min = 0, max = 9999 } ),
	strategy     = AssetAttrib_SetNumber( { id = CharaAssetID.STRATEGY,        type = CharaAssetType.ACTION_ATTRIB, min = 0, max = 9999 } ),
	strategy_tal = AssetAttrib_SetNumber( { id = CharaAssetID.STRATEGY_TALENT, type = CharaAssetType.ACTION_ATTRIB, min = 0, max = 100 } ),
	strategy_lim = AssetAttrib_SetNumber( { id = CharaAssetID.STRATEGY_LIMIT,type = CharaAssetType.ACTION_ATTRIB, min = 0, max = 9999 } ),
	tactic       = AssetAttrib_SetNumber( { id = CharaAssetID.TACTIC,          type = CharaAssetType.ACTION_ATTRIB, min = 0, max = 9999 } ),
	tactic_tal   = AssetAttrib_SetNumber( { id = CharaAssetID.TACTIC_TALENT,   type = CharaAssetType.ACTION_ATTRIB, min = 0, max = 100 } ),
	tactic_lim   = AssetAttrib_SetNumber( { id = CharaAssetID.TACTIC_LIMIT,  type = CharaAssetType.ACTION_ATTRIB, min = 0, max = 9999 } ),
	]]

	grade        = AssetAttrib_SetNumber     ( { id = CharaAssetID.GRADE,        type = CharaAssetType.GROWTH_ATTRIB, enum = CharaGrade, default = CharaGrade.NORMAL } ),
	level        = AssetAttrib_SetNumber     ( { id = CharaAssetID.LEVEL,        type = CharaAssetType.GROWTH_ATTRIB, min = 1, max = 20 } ),
	potential    = AssetAttrib_SetNumber     ( { id = CharaAssetID.POTENTIAL,    type = CharaAssetType.GROWTH_ATTRIB, min = 0, max = 100 } ),
	loyality     = AssetAttrib_SetDict       ( { id = CharaAssetID.LOYALITY,     type = CharaAssetType.GROWTH_ATTRIB } ),
	contribution = AssetAttrib_SetNumber     ( { id = CharaAssetID.CONTRIBUTION, type = CharaAssetType.GROWTH_ATTRIB, min = 0 } ),

	traits       = AssetAttrib_SetDict       ( { id = CharaAssetID.TRAITS,       type = CharaAssetType.GROWTH_ATTRIB, setter = Chara_SetTrait } ),
	skills       = AssetAttrib_SetPointerList( { id = CharaAssetID.SKILLS,       type = CharaAssetType.GROWTH_ATTRIB, setter = Entity_SetSkill } ),

	superior     = AssetAttrib_SetPointer    ( { id = CharaAssetID.SUPERIOR,     type = CharaAssetType.RELATION_ATTRIB } ),
	subdordinate = AssetAttrib_SetPointerList( { id = CharaAssetID.SUBORDINATES, type = CharaAssetType.RELATION_ATTRIB } ),
	relationship = AssetAttrib_SetPointerList( { id = CharaAssetID.RELATIONS,    type = CharaAssetType.RELATION_ATTRIB } ),
}


-------------------------------------------


Chara = class()

function Chara:__init()
	Entity_Init( self, EntityType.CHARA, CharaAssetAttrib )
end

function Chara:Load( data )
	self.id = data.id
	self.name = data.name

	Asset_Set( self, CharaAssetID.BIRTH,     data.birth )
	Asset_Set( self, CharaAssetID.AGE,       g_Time:CalcDiffYear( data.birth, data.birth < 0 and true or false ) )
	Asset_Set( self, CharaAssetID.GENDER,    data.gender )
	Asset_Set( self, CharaAssetID.LIFE,      data.life )
	Asset_Set( self, CharaAssetID.ORIGIN,    data.origin )
	Asset_Set( self, CharaAssetID.GROUP,     data.group )
	Asset_Set( self, CharaAssetID.HOME,      data.home )
	Asset_Set( self, CharaAssetID.LOCATION,  data.location )
	Asset_Set( self, CharaAssetID.CORPS,     data.corps )
	Asset_Set( self, CharaAssetID.TROOP,     data.troop )

	--action
	--[[
	Asset_Set( self, CharaAssetID.POLITICS,        data.politics[0] )
	Asset_Set( self, CharaAssetID.POLITICS_TALENT, data.politics[1] )
	Asset_Set( self, CharaAssetID.POLITICS_LIMIT,  data.politics[2] )
	Asset_Set( self, CharaAssetID.STRATEGY,        data.strategy[0] )
	Asset_Set( self, CharaAssetID.STRATEGY_TALENT, data.strategy[1] )
	Asset_Set( self, CharaAssetID.STRATEGY_LIMIT,  data.strategy[2] )
	Asset_Set( self, CharaAssetID.TACTIC,          data.tactic[0] )
	Asset_Set( self, CharaAssetID.TACTIC_TALENT,   data.tactic[1] )
	Asset_Set( self, CharaAssetID.TACTIC_LIMIT,    data.tactic[2] )
	]]

	--growth
	Asset_Set( self, CharaAssetID.GRADE, CharaGrade[data.grade] )
	Asset_Set( self, CharaAssetID.POTENTIAL, data.potential )
	Asset_Set( self, CharaAssetID.CONTRIBUTION, data.contribution )
	Asset_Set( self, CharaAssetID.LEVEL, data.level or 1 )
	Asset_CopyList( self, CharaAssetID.SKILLS, data.skills )
	Asset_CopyDict( self, CharaAssetID.TRAITS, data.traits )
	Asset_CopyDict( self, CharaAssetID.RELATIONS, data.relations )

	--FOR TEST
	if data.politics[2] + data.strategy[2] + data.tactic[2] <= 0 then
		CharaCreator_GenerateCharaActionData( self, Asset_Get( self, CharaAssetID.GRADE ) )
	end
end

function Chara:VerifyData()
	--default location is home
	if not Asset_Get( self, CharaAssetID.LOCATION ) then		
		--print( self.name, "location data repaired", Asset_Get( self, CharaAssetID.HOME ) )
		Asset_Set( self, CharaAssetID.LOCATION, Asset_Get( self, CharaAssetID.HOME ) )
	end

	--check position
	if not Asset_Get( self, CharaAssetID.LOCATION ) and Asset_Get( self, CharaAssetID.GROUP ) then
		DBG_Error( self.name, "no place to stay" )
	end
end

function Chara:ToString( type )
	local content = "[" .. self.name .. "]"

	if type == "BELONG" or type == "ALL" then
		content = content .. " gp=" .. String_ToStr( Asset_Get( self, CharaAssetID.GROUP ), "name" )
	end

	if type == "GROWTH" or type == "ALL" then
		content = content .. " lv=" .. Asset_Get( self, CharaAssetID.LEVEL )
	end

	if type == "TITLE" or type == "ALL" then
		local title = Asset_Get( self, CharaAssetID.TITLE )
		content = content .. " til=" .. ( title and title.name or "" )
		content = content .. " cot=" .. Asset_Get( self, CharaAssetID.CONTRIBUTION )
	end

	if type == "ALL" then
	end

	if type == "TASK" or type == "ALL" then
		local task = self:GetTask()
		if task then
			content = content .. " task=" .. task:ToString()
		end
	end

	if type == "AP" then
		for _, type in pairs( CharaActionPoint ) do
			content = content .. " "  .. MathUtil_FindName( CharaActionPoint, type ) .. "=" .. self:GetAP( type )
		end
	end

	if type == "LOCATION" or type == "ALL" then
		content = content .. " home=" .. String_ToStr( Asset_Get( self, CharaAssetID.HOME ), "name" )
		content = content .. " @" .. String_ToStr( Asset_Get( self, CharaAssetID.LOCATION ), "name" )
	end
	if type == "CORPS" or type == "ALL" then
		content = content .. " corps=" .. String_ToStr( Asset_Get( self, CharaAssetID.CORPS ), "name" )
	end
	if type == "JOB" or type == "ALL" then
		local home = Asset_Get( self, CharaAssetID.HOME )
		content = content .. " job=" .. ( home and MathUtil_FindName( CityJob, home:GetCharaJob( self ) ) or "" )
		content = content .. " txp=" .. ( self:GetStatus( CharaStatus.TOTAL_EXP ) or 0 )
		content = content .. " mxp=" .. ( self:GetStatus( CharaStatus.MILITARY_EXP ) or 0 )
		content = content .. " oop=" .. ( self:GetStatus( CharaStatus.OFFICER_EXP ) or 0 )
		content = content .. " dpp=" .. ( self:GetStatus( CharaStatus.DIPLOMATIC_EXP ) or 0 )
	end	
	if type == "TRAITS" or type == "GROWTH" then		
		for trait, _ in pairs( Asset_GetDict( self, CharaAssetID.TRAITS ) ) do
			content = content .. " " .. MathUtil_FindName( CharaTraitType, trait )
		end
	end
	if type == "SKILL" or type == "GROWTH" or type == "ALL" then
		for _, skill in pairs( Asset_GetDict( self, CharaAssetID.SKILLS ) ) do
			content = content .. " " .. skill.name .. ","
		end
	end
	if type == "STATUS" then
		for status, v in pairs( Asset_GetDict( self, CharaAssetID.STATUSES ) ) do
			if v then
				if typeof( v ) == "boolean" then
					content = content .. " " .. MathUtil_FindName( CharaStatus, status ) .. "=" .. ( v and "T" or "F" )
				elseif typeof( v ) == "object" or typeof( v ) == "table" then
				else 
					content = content .. " " .. MathUtil_FindName( CharaStatus, status ) .. "=" .. v
				end				
			end
		end
	end
	return content
end

------------------------------------------

function Chara:GetLoyality()
	if not self._loyality then		
		Chara_UpdateLoyality( self )
	end
	--if self._loyality == 0 then print( self.name, self._loyality ) end
	return self._loyality
end

function Chara:GetLoyalityValue( type )
	return Asset_GetDictItem( self, CharaAssetID.LOYALITY, type ) or 0
end

function Chara:SetLoyalityValue( type, value )
	return Asset_SetDictItem( self, CharaAssetID.LOYALITY, type, value )
end

------------------------------------------

function Chara:GetTask()
	return Asset_GetDictItem( self, CharaAssetID.STATUSES, CharaStatus.IN_TASK )
end

function Chara:SetTask( task )	
	if task and self:GetTask() then error( "already in task" .. self:ToString("TASK") ) end

	if task then
		Debug_Log( self:ToString(), "recv taks=" .. task:ToString() )
	elseif self:GetTask() then
		Debug_Log( self:ToString(), "oldtask=" .. self:GetTask():ToString() )
	end

	Asset_SetDictItem( self, CharaAssetID.STATUSES, CharaStatus.IN_TASK, task )
end

function Chara:GetTrait( traitType )
	return Asset_SetDictItem( self, CharaAssetID.TRAITS, traitType )
end

--[[
function Chara:GetSkillByEffect( effectType )
	return Asset_FindItem( self, CharaAssetID.SKILLS, function ( skill )
		local ret = Chara_GetEffectValueBySkill( skill, effectType )
		if ret then return true end
	end)
end
]]

function Chara:GetEffectValue( effectType )
	local value = 0
	local reqLoyality = 0
	local loyality = self:GetLoyality()
	Asset_Foreach( self, CharaAssetID.SKILLS, function ( skill )
		if loyality < reqLoyality then
			--InputUtil_Pause( self.name, skill.name, "req loy=" .. loyality .. "/" .. reqLoyality )
			--Debug_Log( "cann't trigger", self.name, skill.name, MathUtil_FindName( CharaSkillEffect, effectType ) )
			return
		end
		--skill only enable when loyality matches
		local ret = Chara_GetEffectValueBySkill( skill, effectType )		
		if ret then
			value = value + ret
			--Debug_Log( "trigger", self.name, skill.name, MathUtil_FindName( CharaSkillEffect, effectType ) .."=" .. ret )
		end
		reqLoyality = reqLoyality + 10
	end )

	--if value ~= 0 then InputUtil_Pause( "get eff", value, MathUtil_FindName( CharaSkillEffect, effectType ) ) end
	if value ~= 0 then
		Stat_Add( "Eff_" .. MathUtil_FindName( CharaSkillEffect, effectType ) .. "@" .. self.name , value, StatType.ACCUMULATION )
	end
	return value
end

------------------------------------------

function Chara:IsGroupLeader()
	local group = Asset_Get( self, CharaAssetID.GROUP )
	local leader = Asset_Get( group, GroupAssetID.LEADER )
	return leader == self
end

function Chara:IsAtHome()
	local location = Asset_Get( self, CharaAssetID.LOCATION )
	local home     = Asset_Get( self, CharaAssetID.HOME )	
	return home == location
end

function Chara:IsBusy()
	return self:GetTask() ~= nil
end

function Chara:GetStatus( status, default )
	return Asset_GetDictItem( self, CharaAssetID.STATUSES, status ) or default
end

function Chara:SetStatus( status, value )
	if status == CharaStatus.TASK then
		self:SetTask( value )
	else
		Asset_SetDictItem( self, CharaAssetID.STATUSES, status, value )
	end
end

function Chara:AffectStatus( status, value )
	if not value then return end
	local cur = Asset_GetDictItem( self, CharaAssetID.STATUSES, status ) or 0
	cur = cur + value
	Asset_SetDictItem( self, CharaAssetID.STATUSES, status, value )
end

function Chara:HasPotential()
	local level     = Asset_Get( self, CharaAssetID.LEVEL )
	local potential = Asset_Get( self, CharaAssetID.POTENTIAL )
	local hasSkill  = Asset_GetListSize( self, CharaAssetID.SKILLS )

	local ca = 0
	--level: [1,20]*2 + 5 = [7,45]
	ca = ca + level * 2 + 5
	--skill: ( 1 + skill_num ) * skill_num / 2 = [ 1, 55 ]
	ca = ca + ( 1 + hasSkill ) * hasSkill * 0.5

	--print( self.name, "ca=" .. ca .. " pot=" .. potential )

	return ca < potential
end

function Chara:CanLevelUp()
	if not self:HasPotential() then return false end
	local exp = self:GetStatus( CharaStatus.EXP ) or 0
	local lvupExp = 100
	return exp and exp >= lvupExp or false
end

function Chara:LevelUp()
	--print( self:ToString("ALL"))

	local exp = self:GetStatus( CharaStatus.EXP ) or 0
	local lvupExp = 100
	exp = math.max( exp - lvupExp, 0 )
	self:SetStatus( CharaStatus.EXP, exp )
	Asset_Plus( self, CharaAssetID.LEVEL, 1 )

	--print( self:ToString() .. " lvup=" .. Asset_Get( self, CharaAssetID.LEVEL ), exp )

	Stat_Add( "CharaLevelUp@" .. self.name, 1, StatType.TIMES )
	return true
end

-------------------------------------------

--check wheter red has relation-type with b
--@usage Chara_HasRelation( father, son, CharaRelation.FATHER )
function Chara:HasRelation( target, relationType )
	return Asset_FindItem( self, CharaAssetID.RELATIONS, function ( data )
		if data.relation == relationType and data.chara == target.id then			
			return true
		end
	end )
end

-------------------------------------------

function Chara:Update()	
	--update statuses
	Asset_Foreach( self, CharaAssetID.STATUSES, function( value, status )
		if status > CharaStatus.CD_STATUS_BEG then
			self:SetStatus( status, value > 1 and value - 1 or nil )
		end
	end )

	--update loyality
	Asset_Foreach( self, CharaAssetID.LOYALITY, function ( data, type )
		if type == CharaLoyalityType.SENIORITY then
			data = data + g_elapsed
		elseif type == CharaLoyalityType.BONUS then
			data = math.max( 0, data - 1 )
		elseif type == CharaLoyalityType.BLAME then
			data = math.max( 0, data - 1 )
		end
		self:SetLoyalityValue( type, data )
	end )
end

-------------------------------------------
-- For easily to make misunderstand

function Chara:JoinCity( city, isEnterCity )
	Asset_Set( self, CharaAssetID.HOME, city )
	
	if isEnterCity then Asset_Set( self, CharaAssetID.LOCATION, city ) end

	if city then
		Debug_Log( self:ToString(), "set home=", city.name )
	else
		Debug_Log( self:ToString(), "set nohome" )
	end
end

function Chara:EnterCity( city )
	Asset_Set( self, CharaAssetID.LOCATION, city )
end

function Chara:LeadCorps( corps )
	Asset_Set( self, CharaAssetID.CORPS, corps )
end

-------------------------------------------

function Chara:AffectExp( status, value )
	if not value then return end
	local cur = Asset_GetDictItem( self, CharaAssetID.STATUSES, status ) or 0
	cur = cur + value
	Asset_SetDictItem( self, CharaAssetID.STATUSES, status, value )
	self:AffectStatus( CharaStatus.EXP, value )
	--for debug
	self:AffectStatus( CharaStatus.TOTAL_EXP, value )
	--InputUtil_Pause( "affect exp", self.name, value, MathUtil_FindName( CharaStatus, status ))
end

function Chara:Contribute( value )
	Asset_Plus( self, CharaAssetID.CONTRIBUTION, value )
	Stat_Add( "Chara@Contribute", value, StatType.ACCUMULATION )
end

function Chara:GainTrait( trait )
	Asset_SetDictItem( self, CharaAssetID.TRAITS, trait, 100 )

	--InputUtil_Pause( self:ToString( "BRIEF" ), "gain trait=" .. MathUtil_FindName( CharaTraitType, trait ) .. "/" .. trait, "size=" .. Asset_GetDictSize( self, CharaAssetID.TRAITS ) )
	Stat_Add( "Trait@Gain", self.name .. "+" .. MathUtil_FindName( CharaTraitType, trait ), StatType.LIST )
	Stat_Add( "Trait@GainTimes", 1, StatType.TIMES )
end

function Chara:LearnSkill( skill )
	Asset_AppendList( self, CharaAssetID.SKILLS, skill )
	--print( self:ToString(), "gain skill=" .. skill.name )

	Stat_Add( "Skill@Learn", g_Time:ToString() .. " " .. self.name .. "->" .. skill.name, StatType.LIST )
	Stat_Add( "Skill@Times", 1, StatType.TIMES )
end

-------------------------------------------
-- Action Point Relate

function Chara:GetAPLimit( type )
	--skill effect
	local value = 1000
	if type == CharaActionPoint.STAMINA then
		value = value + self:GetEffectValue( CharaSkillEffect.STAMINA_LIMIT )
	elseif type == CharaActionPoint.TACTIC then
		value = value + self:GetEffectValue( CharaSkillEffect.TACTIC_LIMIT )		
	elseif type == CharaActionPoint.STRATEGY then
		value = value + self:GetEffectValue( CharaSkillEffect.STRATEGY_LIMIT )
	elseif type == CharaActionPoint.POLITICS then
		value = value + self:GetEffectValue( CharaSkillEffect.POLITICS_LIMIT )
	end
	return value
end

function Chara:GetAPBonus( type )
	--skill effect
	local value = 1
	if type == CharaActionPoint.STAMINA then
		value = value + self:GetEffectValue( CharaSkillEffect.STAMINA_BONUS )
	elseif type == CharaActionPoint.TACTIC then
		value = value + self:GetEffectValue( CharaSkillEffect.TACTIC_BONUS )		
	elseif type == CharaActionPoint.STRATEGY then
		value = value + self:GetEffectValue( CharaSkillEffect.STRATEGY_BONUS )
	elseif type == CharaActionPoint.POLITICS then
		value = value + self:GetEffectValue( CharaSkillEffect.POLITICS_BONUS )
	end
	return value
end

function Chara:GetAP( type )
	return Asset_GetDictItem( self, CharaAssetID.ACTION_POINT, type ) or 0
end

function Chara:UseAP( type, value )
	local cur = self:GetAP( type )
	if cur < value then
		DBG_Error( "why no enough ap?" )
	else
		cur = cur - value
	end
	Asset_SetDictItem( self, CharaAssetID.ACTION_POINT, type, cur )
end

function Chara:GainAP( type, value )
	local cur = self:GetAP( type )
	if not cur then cur = 0 end
	cur = math.min( self:GetAPLimit( type ), cur + value )
	Asset_SetDictItem( self, CharaAssetID.ACTION_POINT, type, cur )
end

function Chara:UpdateAP( elapsed )	
	for _, type in pairs( CharaActionPoint ) do
		self:GainAP( type, elapsed * self:GetAPBonus( type ) )
	end
end

function Chara:PromoteTitle( title )
	Asset_Set( self, CharaAssetID.TITLE, title )

	Stat_Add( "Promote@" .. self.name, title.name, StatType.LIST )
end

function Chara:Captured()
	local corps = Asset_Get( self, CharaAssetID.CORPS )
	if corps then
		corps:LoseOfficer( self )
	end
end