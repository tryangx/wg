FreeCharaAge = 
{
	{ prob = 5,    min = 12, max = 16 },
	{ prob = 80,   min = 16, max = 22 },
	{ prob = 150,  min = 22, max = 32 },
	{ prob = 120,  min = 32, max = 45 },
	{ prob = 50,   min = 45, max = 55 },
	{ prob = 5,    min = 55, max = 60 },
}

FreeCharaLife = 
{
	{ prob = 5,   min = 5,  max = 10 },
	{ prob = 50,  min = 10, max = 15 },
	{ prob = 80,  min = 15, max = 25 },
	{ prob = 100, min = 25, max = 40 },
	{ prob = 5,   min = 40, max = 50 },
}

FreeCharaGender = 
{
	{ prob = 1000, gender = CharaGender.MALE },
	{ prob = 1,    gender = CharaGender.FEMALE },
}

FreeCharaGrade = 
{
	{ prob = 1000,  grade = CharaGrade.NORMAL, 
	  min_talent = 5, max_talent = 15, min_total_talent = 15, max_total_talent = 40,
	  min_lim = 5, max_lim = 20, min_total_lim = 15, max_total_lim = 45,
	  min_potential = 30, max_potential = 45,
	},
	{ prob =  500,  grade = CharaGrade.GOOD,
	  min_talent = 5, max_talent = 20, min_total_talent = 25, max_total_talent = 55,
	  min_lim = 5, max_lim = 25, min_total_lim = 20, max_total_lim = 55,
	  min_potential = 45, max_potential = 65,
	},
	{ prob =  100,  grade = CharaGrade.EXCELLENT,
	  min_talent = 5, max_talent = 25, min_total_talent = 15, max_total_talent = 70,
	  min_lim = 5, max_lim = 30, min_total_lim = 25, max_total_lim = 70,
	  min_potential = 65, max_potential = 85,
	},
	{ prob =   10,  grade = CharaGrade.BEST,
	  min_talent = 5, max_talent = 30, min_total_talent = 15, max_total_talent = 85,
	  min_lim = 5, max_lim = 35, min_total_lim = 30, max_total_lim = 85,
	  min_potential = 85, max_potential = 95,
	},
	{ prob =    1,  grade = CharaGrade.PERFECT,	
	  min_talent = 5, max_talent = 35, min_total_talent = 15, max_total_talent = 100,
	  min_lim = 5, max_lim = 40, min_total_lim = 35, max_total_lim = 100,
	  min_potential = 95, max_potential = 100,
	},
}

local MAX_LIFE_LIMITED = 90

local MIN_ACTION_TALENT = 5
local MIN_ACTION_LIMIT  = 100
local LIMIT_MODULUS     = 100

local MIN_LEVEL_PERCENT = 30
local MAX_LEVEL_PERCENT = 80


-----------------------------------------------------------


CharaCreatorSystem  = class()

local MAX_RETRY_TIMES = 10
local FAMILYNAME_OFFSET = 100000

function CharaCreatorSystem:__init()	
	System_Setup( self, SystemType.CHARA_CREATOR_SYS, "CharaCreatorSystem" )
end

function CharaCreatorSystem:Start()
	self.nameUsedList = {}	
	self.numberOfNames  = 0	
	self.numberOfCharas = 0	

	--initialize name datas
	self.familyNames = Scenario_GetData( "CHARA_FAMILYNAME_DATA" )
	self.givenNames  = Scenario_GetData( "CHARA_GIVENNAME_DATA" )
	
	self.freeHistoricCharas = {}
	--find out free historic chara
	Entity_Foreach( EntityType.CHARA, function ( chara )
		if not Asset_Get( chara, CharaAssetID.GROUP ) then
			table.insert( self.freeHistoricCharas, chara )
		end
	end )
	print( "free chara=" .. #self.freeHistoricCharas )
end

function CharaCreatorSystem:Update( elapsedTime )
end


-----------------------------------------------------------


function CharaCreatorSystem:GenerateName( times )
	if not times then times = 1 end

	local familyNameId = Random_GetIndex_Sync( self.familyNames, "prob" )
	local givenNameId  = Random_GetIndex_Sync( self.givenNames, "prob" )
	local id = givenNameId * FAMILYNAME_OFFSET + familyNameId

	-- check if name is used
	if self.nameUsedList[id] and times < MAX_RETRY_TIMES then
		times = times + 1
		return self:GenerateName( times )
	end

	-- use this name
	self.nameUsedList[id] = true	
	local familyName = self.familyNames[familyNameId].name
	local givenName  = self.givenNames[givenNameId].name
	
	-- Chinese style name
	local finalName = familyName .. " " .. givenName
	
	-- Out of retry times, so add a suffix
	if times > MAX_RETRY_TIMES then
		finalName = finalName .. self.numberOfNames
	end	
	self.numberOfNames = self.numberOfNames + 1

	-- Return full name
	return finalName
end


-------------------------------------------------------

function CharaCreatorSystem:GenerateCharaActionData( chara, grade )	
	local gradeData = MathUtil_FindData( FreeCharaGrade, grade, "grade" )
	local grade = gradeData.grade

	local politics_tal = Random_GetInt_Sync( gradeData.min_talent, gradeData.max_talent )
	local strategy_tal = Random_GetInt_Sync( gradeData.min_talent, gradeData.max_talent )
	local tactic_tal   = Random_GetInt_Sync( gradeData.min_talent, gradeData.max_talent )
	local politics_lim = Random_GetInt_Sync( gradeData.min_lim, gradeData.max_lim )
	local strategy_lim = Random_GetInt_Sync( gradeData.min_lim, gradeData.max_lim )
	local tactic_lim   = Random_GetInt_Sync( gradeData.min_lim, gradeData.max_lim )
	local total_tal    = Random_GetInt_Sync( gradeData.min_total_talent, gradeData.max_total_talent )
	local total_lim    = Random_GetInt_Sync( gradeData.min_total_lim, gradeData.max_total_lim )

	local sum_tal = politics_tal + strategy_tal + tactic_tal
	if sum_tal > total_tal then		
		local avg = math.floor( ( sum_tal - total_tal ) / 3 )		
		politics_tal = politics_tal - avg
		strategy_tal = strategy_tal - avg
		tactic_tal   = tactic_tal - avg
		--print( "over tal", sum_tal, total_tal, avg, politics_tal )
	end
	local sum_lim = politics_tal + strategy_tal + tactic_tal
	if sum_lim > total_lim then
		local avg = math.floor( ( sum_lim - total_lim ) / 3 )		
		politics_lim = politics_lim - avg
		strategy_lim = strategy_lim - avg
		tactic_lim   = tactic_lim - avg
		--print( "over lim", sum_lim, total_lim, avg )
	end

	Asset_Set( chara, CharaAssetID.POLITICS,        0 )
	Asset_Set( chara, CharaAssetID.POLITICS_TALENT, politics_tal )
	Asset_Set( chara, CharaAssetID.POLITICS_LIMIT,  politics_lim * LIMIT_MODULUS )
	Asset_Set( chara, CharaAssetID.STRATEGY,        0 )
	Asset_Set( chara, CharaAssetID.STRATEGY_TALENT, strategy_tal )
	Asset_Set( chara, CharaAssetID.STRATEGY_LIMIT,  strategy_lim * LIMIT_MODULUS )
	Asset_Set( chara, CharaAssetID.TACTIC,          0 )
	Asset_Set( chara, CharaAssetID.TACTIC_TALENT,   tactic_tal )
	Asset_Set( chara, CharaAssetID.TACTIC_LIMIT,    tactic_lim * LIMIT_MODULUS )

end

function CharaCreatorSystem:GenerateFictionalChara( city )
	local chara = Entity_New( EntityType.CHARA )
	chara.name = self:GenerateName()
	Asset_Set( chara, CharaAssetID.HOME, city )
	Asset_Set( chara, CharaAssetID.LOCATION, city )
	Asset_Set( chara, CharaAssetID.ORIGIN, CharaOrigin[FICTIONAL] )

	--age
	local ageRange = Random_GetTable_Sync( FreeCharaAge, "prob" )
	local age = Random_GetInt_Sync( ageRange.min, ageRange.max )
	Asset_Set( chara, CharaAssetID.AGE, age )

	--birth
	local birth = g_calendar:CalcNewYear( -age )
	Asset_Set( chara, CharaAssetID.BIRTH, birth )

	--life
	local lifeRange = Random_GetTable_Sync( FreeCharaLife, "prob" )
	local life = Random_GetInt_Sync( lifeRange.min, lifeRange.max )
	if age + life >= MAX_LIFE_LIMITED then
		life = MAX_LIFE_LIMITED - age
	end
	Asset_Set( chara, CharaAssetID.LIFE, life )
	
	--gender
	local genderData = Random_GetTable_Sync( FreeCharaGender, "prob" )
	Asset_Set( chara, CharaAssetID.GENDER, genderData.gender )

	--generate chara action attribs	
	local gradeData = Random_GetTable_Sync( FreeCharaGrade, "prob" )
	self:GenerateCharaActionData( chara, gradeData.grade )
	
	--generate chara growth attribs
	Asset_Set( chara, CharaAssetID.LOYALITY,     0 )
	local potential = Random_GetInt_Sync( gradeData.min_potential, gradeData.max_potential )
	Asset_Set( chara, CharaAssetID.POTENTIAL,    potential )
	Asset_Set( chara, CharaAssetID.LEVEL,        math.floor( potential * Random_GetInt_Sync( MIN_LEVEL_PERCENT, MAX_LEVEL_PERCENT ) * 0.01 ) )
	Asset_Set( chara, CharaAssetID.CONTRIBUTION, 0 )
	Asset_Set( chara, CharaAssetID.EXP,          0 )

	--skills, to do	

	return chara
end

function CharaCreatorSystem:GenerateHistoricChara( city )
	local index = Random_GetInt_Sync( 1, #self.freeHistoricCharas )	
	local chara = self.freeHistoricCharas[index]
	table.remove( self.freeHistoricCharas, index )
	Asset_Set( chara, CharaAssetID.HOME, city )
	Asset_Set( chara, CharaAssetID.LOCATION, city )
	Asset_Set( chara, CharaAssetID.ORIGIN, CharaOrigin[HISTORIC] )	
	return chara
end