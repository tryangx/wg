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
	JOB             = 111,
	HOME            = 120,
	LOCATION        = 121,
	CORPS           = 122,
	TROOP           = 123,
	STATUSES        = 130,
	TASKS           = 131,

	--action
	POLITICS        = 200,
	POLITICS_TALENT = 201,
	POLITICS_LIMIT  = 202,
	STRATEGY        = 203,
	STRATEGY_TALENT = 204,
	STRATEGY_LIMIT  = 205,	
	TACTIC          = 206,
	TACTIC_TALENT   = 207,
	TACTIC_LIMIT    = 208,

	--GROWTH
	GRADE           = 300,
	POTENTIAL       = 301,
	LOYALITY        = 303,
	CONTRIBUTION    = 304,
	LEVEL           = 305,
	EXP             = 306,
	SERVICE_DAY     = 307,
	SKILLS          = 311,
	PURPOSE         = 321,

	--relationship
	SUPERIOR        = 401,
	SUBORDINATES    = 402,

}

CharaAssetAttrib = 
{
	--base
	age        = AssetAttrib_SetNumber ( { id = CharaAssetID.AGE,        type = CharaAssetType.BASE_ATTRIB, min = 1, max = 120 } ),
	birth      = AssetAttrib_SetNumber ( { id = CharaAssetID.BIRTH,      type = CharaAssetType.BASE_ATTRIB } ),
	life       = AssetAttrib_SetNumber ( { id = CharaAssetID.LIFE,       type = CharaAssetType.BASE_ATTRIB, min = 1, max = 100 } ),
	gender     = AssetAttrib_SetNumber ( { id = CharaAssetID.GENDER,     type = CharaAssetType.BASE_ATTRIB, enum = CharaGender } ),
	origin     = AssetAttrib_SetNumber ( { id = CharaAssetID.ORIGIN,     type = CharaAssetType.BASE_ATTRIB, enum = CharaOrigin } ),	
	group      = AssetAttrib_SetPointer( { id = CharaAssetID.GROUP,      type = CharaAssetType.BASE_ATTRIB, setter = Entity_SetChara } ),
	job        = AssetAttrib_SetNumber ( { id = CharaAssetID.JOB,        type = CharaAssetType.BASE_ATTRIB, enum = CharaJob, default = CharaJob.NONE } ),
	home       = AssetAttrib_SetPointer( { id = CharaAssetID.HOME,       type = CharaAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	location   = AssetAttrib_SetPointer( { id = CharaAssetID.LOCATION,   type = CharaAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	corps      = AssetAttrib_SetPointer( { id = CharaAssetID.CORPS,      type = CharaAssetType.BASE_ATTRIB, setter = Entity_SetCorps } ),
	troop      = AssetAttrib_SetPointer( { id = CharaAssetID.TROOP,      type = CharaAssetType.BASE_ATTRIB, setter = Entity_SetTroop } ),
	statuses   = AssetAttrib_SetList   ( { id = CharaAssetID.STATUSES,   type = CityAssetType.BASE_ATTRIB } ),
	tasks      = AssetAttrib_SetPointerList( { id = CharaAssetID.TASKS,  type = CityAssetType.BASE_ATTRIB } ),

	--action
	politics     = AssetAttrib_SetNumber( { id = CharaAssetID.POLITICS,        type = CharaAssetType.ACTION_ATTRIB, min = 0, max = 9999 } ),
	politics_tal = AssetAttrib_SetNumber( { id = CharaAssetID.POLITICS_TALENT, type = CharaAssetType.ACTION_ATTRIB, min = 0, max = 100 } ),
	politics_lim = AssetAttrib_SetNumber( { id = CharaAssetID.POLITICS_LIMIT,type = CharaAssetType.ACTION_ATTRIB, min = 0, max = 9999 } ),
	strategy     = AssetAttrib_SetNumber( { id = CharaAssetID.STRATEGY,        type = CharaAssetType.ACTION_ATTRIB, min = 0, max = 9999 } ),
	strategy_tal = AssetAttrib_SetNumber( { id = CharaAssetID.STRATEGY_TALENT, type = CharaAssetType.ACTION_ATTRIB, min = 0, max = 100 } ),
	strategy_lim = AssetAttrib_SetNumber( { id = CharaAssetID.STRATEGY_LIMIT,type = CharaAssetType.ACTION_ATTRIB, min = 0, max = 9999 } ),
	tactic       = AssetAttrib_SetNumber( { id = CharaAssetID.TACTIC,          type = CharaAssetType.ACTION_ATTRIB, min = 0, max = 9999 } ),
	tactic_tal   = AssetAttrib_SetNumber( { id = CharaAssetID.TACTIC_TALENT,   type = CharaAssetType.ACTION_ATTRIB, min = 0, max = 100 } ),
	tactic_lim   = AssetAttrib_SetNumber( { id = CharaAssetID.TACTIC_LIMIT,  type = CharaAssetType.ACTION_ATTRIB, min = 0, max = 9999 } ),

	grade        = AssetAttrib_SetNumber     ( { id = CharaAssetID.GRADE,        type = CharaAssetType.GROWTH_ATTRIB, enum = CharaGrade, default = CharaGrade.NORMAL } ),
	potential    = AssetAttrib_SetNumber     ( { id = CharaAssetID.POTENTIAL,    type = CharaAssetType.GROWTH_ATTRIB, min = 0, max = 100 } ),
	loyality     = AssetAttrib_SetNumber     ( { id = CharaAssetID.LOYALITY,     type = CharaAssetType.GROWTH_ATTRIB, min = 0, max = 100 } ),
	contribution = AssetAttrib_SetNumber     ( { id = CharaAssetID.CONTRIBUTION, type = CharaAssetType.GROWTH_ATTRIB, min = 0 } ),
	level        = AssetAttrib_SetNumber     ( { id = CharaAssetID.LEVEL,        type = CharaAssetType.GROWTH_ATTRIB, min = 0, max = 100 } ),
	exp          = AssetAttrib_SetNumber     ( { id = CharaAssetID.EXP,          type = CharaAssetType.GROWTH_ATTRIB, min = 0, max = 9999 } ),
	service_day  = AssetAttrib_SetNumber     ( { id = CharaAssetID.SERVICE_DAY,  type = CharaAssetType.GROWTH_ATTRIB } ),
	skills       = AssetAttrib_SetPointerList( { id = CharaAssetID.SKILLS,       type = CharaAssetType.GROWTH_ATTRIB, setter = Entity_SetSkill } ),

	superior     = AssetAttrib_SetPointer    ( { id = CharaAssetID.SUPERIOR,     type = CharaAssetType.RELATION_ATTRIB } ),
	subdordinate = AssetAttrib_SetPointerList( { id = CharaAssetID.SUBORDINATES, type = CharaAssetType.RELATION_ATTRIB } ),
}


-------------------------------------------


Chara = class()

function Chara:__init()
	Entity_Init( self, EntityType.CHARA, CharaAssetAttrib )
end

function Chara:Remove()
	Asset_ForeachList( self, CharaAssetID.TASKS, function ( task )
		Asset_RemoveIndexItem( task, TaskAssetID.CONTRIBUTORS, self )
	end)
end

function Chara:Load( data )
	self.id = data.id
	self.name = data.name

	Asset_Set( self, CharaAssetID.BIRTH,     data.birth )
	Asset_Set( self, CharaAssetID.AGE,       g_calendar:CalcDiffYear( data.birth, data.birth < 0 and true or false ) )
	Asset_Set( self, CharaAssetID.JOB,       CharaJob[data.job] )
	Asset_Set( self, CharaAssetID.GENDER,    data.gender )
	Asset_Set( self, CharaAssetID.LIFE,      data.life )
	Asset_Set( self, CharaAssetID.ORIGIN,    data.origin )
	Asset_Set( self, CharaAssetID.GROUP,     data.group )
	Asset_Set( self, CharaAssetID.HOME,      data.home )
	Asset_Set( self, CharaAssetID.LOCATION,  data.location )
	Asset_Set( self, CharaAssetID.CORPS,     data.corps )
	Asset_Set( self, CharaAssetID.TROOP,     data.troop )

	--action
	Asset_Set( self, CharaAssetID.POLITICS,        data.politics[0] )
	Asset_Set( self, CharaAssetID.POLITICS_TALENT, data.politics[1] )
	Asset_Set( self, CharaAssetID.POLITICS_LIMIT,  data.politics[2] )
	Asset_Set( self, CharaAssetID.STRATEGY,        data.strategy[0] )
	Asset_Set( self, CharaAssetID.STRATEGY_TALENT, data.strategy[1] )
	Asset_Set( self, CharaAssetID.STRATEGY_LIMIT,  data.strategy[2] )
	Asset_Set( self, CharaAssetID.TACTIC,          data.tactic[0] )
	Asset_Set( self, CharaAssetID.TACTIC_TALENT,   data.tactic[1] )
	Asset_Set( self, CharaAssetID.TACTIC_LIMIT,    data.tactic[2] )

	--growth
	Asset_Set( self, CharaAssetID.GRADE, CharaGrade[data.grade] )
	Asset_Set( self, CharaAssetID.POTENTIAL, data.potential )
	Asset_Set( self, CharaAssetID.LOYALITY, data.loyality )
	Asset_Set( self, CharaAssetID.CONTRIBUTION, data.contribution )
	Asset_Set( self, CharaAssetID.LEVEL, data.level )
	Asset_Set( self, CharaAssetID.EXP, data.exp )
	Asset_CopyList( self, CharaAssetID.SKILLS, data.skills )

	--FOR TEST
	if data.politics[2] + data.strategy[2] + data.tactic[2] <= 0 then
		System_Get( "CHARA_CREATOR_SYS" ):GenerateCharaActionData( self, Asset_Get( self, CharaAssetID.GRADE ) )
	end
end

function Chara:VerifyData()
	--default location is home
	if not Asset_Get( self, CharaAssetID.LOCATION ) then		
		--print( self.name, "location data repaired", Asset_Get( self, CharaAssetID.HOME ) )
		Asset_Set( self, CharaAssetID.LOCATION, Asset_Get( self, CharaAssetID.HOME ) )
	end

	--default job is officer
	local job = Asset_Get( self, CharaAssetID.JOB )
	if not job or job == CharaJob.NONE then
		Asset_Set( self, CharaAssetID.JOB, CharaJob.OFFICER )
	end
end

function Chara:Update()
	local proposalcd = Asset_GetListItem( self, CharaAssetID.STATUSES, CharaStatus.PROPOSAL_CD )
	if proposalcd and proposalcd > 0 then
		Asset_SetListItem( self, CharaAssetID.STATUSES, CharaStatus.PROPOSAL_CD, proposalcd - 1 )
	end

	Asset_Plus( self, CharaAssetID.SERVICE_DAY, g_elapsed )
end


-------------------------------------------

function Chara:IsAtHome()
	local location = Asset_Get( self, CharaAssetID.LOCATION )
	local home     = Asset_Get( self, CharaAssetID.HOME )	
	return home == location
end

function Chara:IsBusy()
	return Asset_GetListItem( self, CharaAssetID.STATUSES, CharaStatus.IN_TASK ) ~= nil
end

-------------------------------------------

function Chara_GetLimitByGroup( group )
	if not group then return 0 end
	local government = Asset_Get( group, GroupAssetID.GOVERNMENT )
	--print( "gov=" .. MathUtil_FindName( GroupGovernment, government ) )
	return GroupGovernmentData[government].CAPITAL_CHARA_LIMIT
end

function Chara_GetLimitByCity( city )
	if not city then return 0 end
	if city:IsCapital() then return -1 end
	local lv = Asset_Get( city, CityAssetID.LEVEL )	
	local ret = math.ceil( lv / 4 ) + 1
	DBG_Warning( "chara_limit_bycity", ret )
	return ret
end