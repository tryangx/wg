CharaAgeProb = 
{
	{ prob = 5,    min = 12, max = 16 },
	{ prob = 80,   min = 16, max = 22 },
	{ prob = 150,  min = 22, max = 32 },
	{ prob = 120,  min = 32, max = 45 },
	{ prob = 50,   min = 45, max = 55 },
	{ prob = 5,    min = 55, max = 60 },
}

CharaLifeProb = 
{
	{ prob = 5,   min = 5,  max = 10 },
	{ prob = 50,  min = 10, max = 15 },
	{ prob = 80,  min = 15, max = 25 },
	{ prob = 100, min = 25, max = 40 },
	{ prob = 5,   min = 40, max = 50 },
}

CharaGenderProb = 
{
	{ prob = 1000, gender = CharaGender.MALE },
	{ prob = 1,    gender = CharaGender.FEMALE },
}

CharaGradeProb = 
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

CharaAtomicTraitProb = 
{
	{ prob  = 80, { IDEAL = 50, REALISM = 50 }, },
	{ prob  = 80, { ACTIVELY = 50, PASSIVE = 50 }, },
	{ prob  = 80, { INTROVERT = 50, EXTROVERT = 50 }, },
	{ prob  = 50, { IDEAL = 50, REALISM = 50 }, },
	{ prob  = 50, { ACTIVELY = 50, PASSIVE = 50 }, },
	{ prob  = 50, { INTROVERT = 50, EXTROVERT = 50 }, },
}

CharaCreatorParams = 
{
	MAX_LIFE_LIMITED = 90,

	MIN_ACTION_TALENT = 5,
	MIN_ACTION_LIMIT  = 100,
	LIMIT_MODULUS     = 100,
}

-----------------------------------------------------------

function CharaCreator_GenerateName()
	return System_Get( SystemType.CHARA_CREATOR_SYS ):GenerateName()
end

function CharaCreator_GenerateCharaActionData( chara, grade )	
	local gradeData = MathUtil_FindData( CharaGradeProb, grade, "grade" )
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
	Asset_Set( chara, CharaAssetID.POLITICS_LIMIT,  politics_lim * CharaCreatorParams.LIMIT_MODULUS )
	Asset_Set( chara, CharaAssetID.STRATEGY,        0 )
	Asset_Set( chara, CharaAssetID.STRATEGY_TALENT, strategy_tal )
	Asset_Set( chara, CharaAssetID.STRATEGY_LIMIT,  strategy_lim * CharaCreatorParams.LIMIT_MODULUS )
	Asset_Set( chara, CharaAssetID.TACTIC,          0 )
	Asset_Set( chara, CharaAssetID.TACTIC_TALENT,   tactic_tal )
	Asset_Set( chara, CharaAssetID.TACTIC_LIMIT,    tactic_lim * CharaCreatorParams.LIMIT_MODULUS )
end

function CharaCreator_GenerateAtomicTrait( chara, num )
	--determine how many atomic trait
	local reqNumOfTrait = num or Random_GetInt_Sync( 1, 3 )
	--print( "Try to trait", reqNumOfTrait )
	while reqNumOfTrait > 0 do
		for _, item in ipairs( CharaAtomicTraitProb ) do
			if Random_GetInt_Sync( 1, 100 ) < item.prob then
				--calculate total probability
				if not item.totalProb then item.totalProb = MathUtil_Sum( item[1] ) end
				local rand = Random_GetInt_Sync( 1, item.totalProb )
				for traitName, prob in pairs( item[1] ) do
					--print( traitName, prob )
					if rand < prob then
						local trait = CharaTraitType[traitName]
						--print( "add atomic", traitName, chara.name, trait )						
						chara:GainTrait( trait )
						reqNumOfTrait = reqNumOfTrait - 1
						break
					end
				end
			end
			if reqNumOfTrait <= 0 then break end
		end
		if reqNumOfTrait <= 0 then break end
	end
end

--
-- 1. Find 3 list from traits data, essential traits / possible traits
--    1a. Essential traits means it should be added at first
-- 2. 
--
function CharaCreator_GenerateTrait( chara, reqTrait )
	if not reqTrait then reqTrait = 1 end

	local traitData = Scenario_GetData( "CHARA_TRAIT_DATA" )

	--possible traits
	local possibleTraits  = {}
	local totalPossProb = 0
	local essentialTraits = {}
	local traitDict = Asset_GetDict( chara, CharaAssetID.TRAITS )
	for trait, value in pairs( traitDict ) do
		--if trait >= CharaTraitType.ATOMIC_TRAIT and trait < CharaTraitType.TEMPLATE_TRAIT then
		--print( "cp", trait, value )
		if trait <= CharaTraitType.EXTENSION_TRAIT then
			--check catalog by atomic trait 
			local list = traitData[trait]
			--print( "atomic", trait, #list )
			for traitName, value2 in pairs( list ) do
				local trait2 = CharaTraitType[traitName]
				--check that should not exist
				if not MathUtil_IndexOf( traitDict, trait2 ) then
					if value2 >= 100 then
						--add to essential traits list
						table.insert( essentialTraits, trait2 )
						--[[
					elseif trait2 >= CharaTraitType.NORMAL_TRAIT then
						if not noramlTraits[trait2] then noramlTraits[trait2] = 0 end
						noramlTraits[trait2] = noramlTraits[trait2] + value2
						totalPossProb = totalPossProb + value2
						]]
					else
						if not possibleTraits[trait2] then possibleTraits[trait2] = 0 end
						possibleTraits[trait2] = possibleTraits[trait2] + value2
						totalPossProb = totalPossProb + value2
					end
				end
			end
		end
	end

	--process with essential traits
	if #essentialTraits > 0 then
		InputUtil_Pause( "essentialTraits", #essentialTraits )
		essentialTraits = MathUtil_Shuffle_Sync( essentialTraits )
		for i = 1, reqTrait do
			chara:GainTrait( essentialTraits[i] )
		end
		return
	end

	--check if no atmoic trait
	if totalPossProb == 0 then
		--for debug
		DBG_Error( "TRAIT", chara.name .. " don't have atomic trait" )		
		CharaCreator_GenerateAtomicTrait( chara )
		CharaCreator_GenerateTrait( chara, reqTrait )
		return
	end

	--remove impossible
	for trait, prob in pairs( possibleTraits ) do
		if prob <= 0 then
			possibleTraits[trait] = nil
			totalPossProb = totalPossProb - prob
		end
	end

	if totalPossProb <= 0 then
		return
	end

	--InputUtil_Pause( "possibleTraits", #possibleTraits, totalPossProb, reqTrait )
	--try to add
	while reqTrait >= 1 do
		local rand = Random_GetInt_Sync( 1, totalPossProb )
		for trait, prob in pairs( possibleTraits ) do			
			if rand < prob then
				chara:GainTrait( trait )
				possibleTraits[trait] = nil
				totalPossProb = totalPossProb - prob
				reqTrait = reqTrait - 1
				break
			end
		end
	end
end

-----------------------------------------------------------

function CharaCreator_GenerateFictionalChara( city )
	local chara = Entity_New( EntityType.CHARA )
	chara.name = CharaCreator_GenerateName()
	chara:JoinCity( city, true )
	Asset_Set( chara, CharaAssetID.ORIGIN, CharaOrigin[FICTIONAL] )

	--age
	local ageRange = Random_GetTable_Sync( CharaAgeProb, "prob" )
	local age = Random_GetInt_Sync( ageRange.min, ageRange.max )
	Asset_Set( chara, CharaAssetID.AGE, age )

	--birth
	local birth = g_Time:CalcNewYear( -age )
	Asset_Set( chara, CharaAssetID.BIRTH, birth )

	--life
	local lifeRange = Random_GetTable_Sync( CharaLifeProb, "prob" )
	local life = Random_GetInt_Sync( lifeRange.min, lifeRange.max )
	if age + life >= CharaCreatorParams.MAX_LIFE_LIMITED then
		life = CharaCreatorParams.MAX_LIFE_LIMITED - age
	end
	Asset_Set( chara, CharaAssetID.LIFE, life )
	
	--gender
	local genderData = Random_GetTable_Sync( CharaGenderProb, "prob" )
	Asset_Set( chara, CharaAssetID.GENDER, genderData.gender )

	--generate chara action attribs	
	local gradeData = Random_GetTable_Sync( CharaGradeProb, "prob" )
	CharaCreator_GenerateCharaActionData( chara, gradeData.grade )

	--generate atomic traits
	CharaCreator_GenerateAtomicTrait( chara )
	
	--generate chara growth attribs
	Asset_Set( chara, CharaAssetID.LOYALITY,     0 )
	local potential = Random_GetInt_Sync( gradeData.min_potential, gradeData.max_potential )
	Asset_Set( chara, CharaAssetID.POTENTIAL,    potential )
	Asset_Set( chara, CharaAssetID.CONTRIBUTION, 0 )
	Asset_Set( chara, CharaAssetID.LEVEL,        1 )

	--skills, to do	

	return chara
end

function CharaCreator_GenerateHistoricChara( city )
	local index = Random_GetInt_Sync( 1, #self.freeHistoricCharas )	
	local chara = self.freeHistoricCharas[index]
	table.remove( self.freeHistoricCharas, index )
	chara:JoinCity( city, true )
	Asset_Set( chara, CharaAssetID.ORIGIN, CharaOrigin[HISTORIC] )	
	return chara
end

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

	self.familyNames = Scenario_GetData( "CHARA_FAMILYNAME_DATA" )
	self.givenNames  = Scenario_GetData( "CHARA_GIVENNAME_DATA" )

	self.freeHistoricCharas = {}
	--find out free historic chara
	Entity_Foreach( EntityType.CHARA, function ( chara )
		if not Asset_Get( chara, CharaAssetID.GROUP ) then
			table.insert( self.freeHistoricCharas, chara )
		end
	end )
	print( "Free historic chara=" .. #self.freeHistoricCharas )
end

function CharaCreatorSystem:Update()
end

function CharaCreatorSystem:GenerateName( chara )
	if not times then times = 1 end

	--initialize name datas
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

-----------------------------------------------------------

