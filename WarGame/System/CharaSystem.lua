-------------------------------------------

local _SkillEnviroments = {}

function Chara_ResetSkillEnvironment()
	_SkillEnviroments = {}
end

--name is CharaSkillEffectCondition
function Chara_SetSkillEnvironment( name, data )
	--print( "setskillenv--> " .. MathUtil_FindName( CharaSkillEffectCondition, name ) .."=", data )
	_SkillEnviroments[name] = data
end

function Chara_GetSkillEnvironment( name )
	return _SkillEnviroments[name]
end

function Chara_GetEffectValueBySkill( skill, effectType, default )
	local function CheckConditions( effect )		
		if effect.prob then
			if Random_GetInt_Sync( 1, 100 ) > effect.prob then
				--probability test failed
				return default
			end
		end
		if effect.conditions then
			for _, condType in ipairs( effect.conditions ) do
				--print( "check env=", condType, Chara_GetSkillEnvironment( CharaSkillEffectCondition[condType] ) )
				if Chara_GetSkillEnvironment( CharaSkillEffectCondition[condType] ) == false then					
					return false
				end				
			end
			return true
		elseif effect.condition then
			InputUtil_Pause( "check env=" .. CharaSkillEffectCondition[condType] )
			return Chara_GetSkillEnvironment( CharaSkillEffectCondition[condType] )
		end
		return true
	end
	for _, effect in ipairs( skill.effects ) do		
		if CharaSkillEffect[effect.type] == effectType and CheckConditions( effect ) == true then
			--InputUtil_Pause( "get skill effect", effect.type, effect.value, skill.name )			
			return effect.value
		end
	end
	return default
end

--return the effect value( all skills )
function Chara_GetSkillEffectValue( chara, effectType )
	if not chara then return 0 end
	return chara:GetEffectValue( effectType )
end

-------------------------------------------
-- Chara Job Relative 

function Chara_GetRatingCharaSuitJob( chara, job )
	local score = 100

	--job
	if job == CityJob.EXECUTIVE then

	elseif job == CityJob.COMMANDER then
		score = score + chara:HasSkillType( CharaSkillType.COMMANDER ) * 100
		score = score + chara:HasSkillType( CharaSkillType.OFFICER ) * 100

	elseif job == CityJob.STAFF then
		score = score + chara:HasSkillType( CharaSkillType.STAFF ) * 100

	elseif job == CityJob.HR then
		score = score + chara:HasSkillType( CharaSkillType.HR ) * 100

	elseif job == CityJob.OFFICIAL then
		score = score + chara:HasSkillType( CharaSkillType.OFFICIALS ) * 100

	elseif job == CityJob.DIPLOMATIC then
		score = score + chara:HasSkillType( CharaSkillType.DIPLOMAT ) * 100

	elseif job == CityJob.TECHNICIAN then
		score = score + chara:HasSkillType( CharaSkillType.TECHNICIAN ) * 100

	end

	return score
end

function Chara_FindBestCharaForJob( job, charaList )
	local bestChara, bestIndex, bestRating
	for inx, chara in ipairs( charaList ) do			
		local rating = Chara_GetRatingCharaSuitJob( chara, job )
		if not bestChara or bestRating < rating then
			bestChara  = chara
			bestIndex  = inx
			bestRating = rating
		end
	end
	table.remove( charaList, bestIndex )
	return bestChara
end

-------------------------------------------
-- Determine the number of Chara in the city

--Group Limitation
--  
function Chara_GetLimitByGroup( group )
	if not group then return 0 end

	local government = Asset_Get( group, GroupAssetID.GOVERNMENT )
	local typeName = MathUtil_FindName( GroupGovernment, government )
	local number = CharaParams.LIMIT_NUMBER.GOVENRMENT[typeName]

	Asset_Foreach( group, GroupAssetID.CITY_LIST, function ( city )
		if city:IsCapital() then return end
		number = number + math.floor( Asset_Get( city, CityAssetID.LEVEL ) * 0.25 )
	end )

	return number
end

function Chara_GetReqNumOfOfficer( city )
	local number = CharaParams.REQUIRE_NUMBER.MIN_NUMBER	
	
	local level = Asset_Get( city, CityAssetID.LEVEL )
	number = number + ( CharaParams.REQUIRE_NUMBER.LEVEL_BNOUS[level] or 0 )

	if city:IsCapital() then
		number = number + CharaParams.REQUIRE_NUMBER.CAPITAL_BONUS
	end	
	--[[
	if city:GetStatus( CityStatus.FRONTIER ) then
		number = number + ( CharaParams.REQUIRE_NUMBER.FRONTIER_BONUS or 0 )
	elseif city:GetStatus( CityStatus.BATTLEFRONT ) then
		number = number + ( CharaParams.REQUIRE_NUMBER.BATTLEFRONT_BONUS or 0 )
	end
	if city:GetStatus( CityStatus.ADVANCED_BASE ) then
		number = number + ( CharaParams.REQUIRE_NUMBER.ADVANCED_BASE_BONUS or 0 )
	end
	if city:GetStatus( CityStatus.PRODUCTION_BASE ) then
		number = number + ( CharaParams.REQUIRE_NUMBER.PRODUCTION_BASE_BONUS or 0 )
	end
	if city:GetStatus( CityStatus.MILITARY_BASE ) then
		number = number + ( CharaParams.REQUIRE_NUMBER.MILITARY_BASE_BONUS or 0 )
	end
	]]
	--print( city.name, number )
	return number
end

function Chara_FindLeader( charaList )
	local findChara
	for _, chara in pairs( charaList ) do
		if not findChara
			or findChara:GetLoyality() < chara:GetLoyality() then
			findChara = chara
		end
	end
	return findChara
end

-------------------------------------------

function Chara_Die( chara )
	if chara:GetStatus( CharaStatus.DEAD ) then
		error( chara.name .. "died twice?" )
	end
	chara:SetStatus( CharaStatus.DEAD, 1 )

	--print( chara.name, "died" )

	--Remove from corps
	local corps = Asset_Get( chara, CharaAssetID.CORPS )
	if corps then
		corps:LoseOfficer( chara )
		Debug_Log( corps:ToString("OFFICER"))
	else
		Debug_Log( chara.name .. "die, no corps" )
	end

	--Remove from city
	local home = Asset_Get( chara, CharaAssetID.HOME )
	if home then
		--print( home.name, "leave", chara.name )
		home:CharaLeave( chara )
		Debug_Log( home:ToString("CHARA"))		
	else
		error( "no home?" .. chara.name )
	end

	--Remove task
	local task = chara:GetTask()
	if task then
		Task_Terminate( task, chara )
	end

	--Remove from group
	local group = Asset_Get( chara, CharaAssetID.GROUP )
	if group then
		group:LoseChara( chara )
		Debug_Log( group:ToString("CHARA"))
	else
		Debug_Log( chara.name .. "die, no group" )
	end

	--Remove moving
	Move_Stop( chara )

	Debug_Log( chara:ToString(), "died" )

	Stat_Add( "Chara@Die", chara:ToString(), StatType.LIST )

	--error( chara:ToString() .. " died" )

	Entity_Remove( chara )

	--InputUtil_Pause( "die")
end

function Chara_Join( chara, city, isEnterCity )
	if chara:GetStatus( CharaStatus.DEAD ) then
		error( chara.name .. " already dead" )
	end

	local home = Asset_Get( chara, CharaAssetID.HOME )
	if home == city then
		error( chara.name .. " already in " ..city.name )
		return
	end
	if home then
		home:CharaLeave( chara )
	end

	city:CharaJoin( chara, isEnterCity )	
end

-------------------------------
-- Hire chara relative

function Chara_Serve( chara, group, city )
	if not chara then return end

	if chara:GetStatus( CharaStatus.DEAD ) then
		error( chara.name .. " already dead" )
	end

	if group then
		group:AddChara( chara )
		DBG_Trace( "chara_serve", chara.name .. " serve " .. group.name )

		Asset_Set( chara, CharaAssetID.GROUP, group )
	end

	if not city then return end

	local isEnterCity = true
	if Asset_Get( city, CityAssetID.GROUP ) ~= group then
		isEnterCity = false
		--find frendly nearby city or capital
		print( "oldcity=" .. city:ToString() )
		city = Random_GetListItem( city:FindNearbyFriendCities( group ) )
		if not city then city = Asset_Get( group, GroupAssetID.CAPITAL ) end
		print( "newcity=" .. city:ToString() )
		--move to new home
		Move_Stop( chara )
		Move_Chara( chara, city )
	end

	city:CharaJoin( chara )
	--set home & location
	chara:JoinCity( city, isEnterCity )

	--[[
	--to set relation		
	local executive = Asset_GetDictItem( , CityAssetID.OFFICER_LIST, CityJob.EXECUTIVE )
	if executive then
		Asset_Set( chara, CharaAssetID.SUPERIOR, executive )
		DBG_Trace( "chara_serve", executive.name .. " manage " .. chara.name )
		
		Asset_AppendList( executive, CharaAssetID.SUBORDINATES, chara )
		DBG_Trace( "chara_serve", chara.name .. " serve " .. executive.name )
	end
	]]

	Stat_Add( "Chara@Hire", chara.name .. " join " .. city.name .. " " .. g_Time:ToString(), StatType.LIST )
end

-------------------------------
-- Promote relative

function Chara_FindNewTitle( chara )
	local group = Asset_Get( chara, CharaAssetID.GROUP )
	local leader = group and Asset_Get( group, GroupAssetID.LEADER ) or nil
	local capital = Asset_Get( group, GroupAssetID.CAPITAL )

	function CheckConditions( chara, title )		
		local valid = true
		for _, cond in pairs( title.prerequisite ) do
			if valid == true and cond.contribution and cond.contribution > Asset_Get( chara, CharaAssetID.CONTRIBUTION ) then valid = false end
			if valid == true and cond.limit and group:HasTitle( title.id ) then valid = false end
			if valid == true and cond.leader and leader ~= chara then valid = false end
			if valid == true and cond.capital and not capital then valid = false end
			--print( valid, cond.heir, leader:HasRelation( chara, CharaRelation.SON ), leader:HasRelation( chara, CharaRelation.DAUGHTER ) )
			if valid == true and cond.heir and not leader:HasRelation( chara, CharaRelation.SON ) and not leader:HasRelation( chara, CharaRelation.DAUGHTER ) then valid = false end
			if valid == false then break end
		end
		--InputUtil_Pause( chara.name, title.name, valid )
		return valid
	end

	local currentTitle = Asset_Get( chara, CharaAssetID.TITLE )
	--print( chara.name, "current", currentTitle and currentTitle.name or "" )
	local list = {}
	local datas = Scenario_GetData( "CHARA_TITLE_DATA" )
	for _, title in pairs( datas ) do
		if currentTitle == title then
		elseif not currentTitle 
			or currentTitle.grade < title.grade 
			or ( currentTitle.grade == title.grade and currentTitle.priority and currentTitle.priority <= title.priority ) then
			if CheckConditions( chara, title ) then
				--print( "clear list", title.name )
				currentTitle = title
				list = { title }
			end
		end
	end
	
	if #list == 0 then return end

	currentTitle = Random_GetListItem( list )
	Debug_Log( "settitle", chara.name, currentTitle and currentTitle.name or "" )
	return currentTitle
end

--[[
function Chara_FindPromoteJob( chara )
	--print( chara.name, "job=" .. MathUtil_FindName( CharaJob, Asset_Get( chara, CharaAssetID.JOB ) ) )
	local datas = Scenario_GetData( "CHARA_PROMOTE_DATA" )
	local method = Scenario_GetData( "CHARA_PROMOTE_METHOD" )[Asset_Get( chara, CharaAssetID.JOB )]
	if not method then
		DBG_Error( "no chara promote method" )
		return
	end
	
	local jobs = {}
	for _, id in pairs( method ) do
		local data = datas[id]
		local valid = true
		if valid == true and data.contribution and data.contribution > Asset_Get( chara, CharaAssetID.CONTRIBUTION ) then valid = false end
		if valid == true and data.service and data.service > Asset_Get( chara, CharaAssetID.SERVICE_DAY ) then valid = false end
		if valid == true and data.has_skill then
			for _, bundle in pairs( data.has_skill ) do
				local has = true
				for _, id in pairs( bundle ) do
					local findSkill = Asset_FindItem( chara, CharaAssetID.SKILLS, function( skill )
						return skill.id == id
					end )
					if not findSkill then
						has = false
						break
					end
				end
				valid = has
				if has == true then
					break
				end
			end
		end
		if valid == true then
			table.insert( jobs, id )
		end
	end
	local num = #jobs
	if num == 0 then return nil end
	return jobs[Random_GetInt_Sync( 1, num )]
end
]]

-----------------------------------------------------

function Chara_LearnSkill( chara )
	if not chara:HasPotential() then return false end

	--check prob
	local lv = Asset_Get( chara, CharaAssetID.LEVEL )
	local hasSkill = Asset_GetListSize( chara, CharaAssetID.SKILLS )	
	local prob = 35 + lv * 5 - hasSkill * 10

	if Random_GetInt_Sync( 1, 100 ) > prob then return false end

	--InputUtil_Pause( "try learn", prob )
	
	local skills = SkillTable_QuerySkillList( chara )
	local skill = Random_GetListItem( skills )
	if not skill then
		--should diagnose what situation( triats ) won't gain new skill
		--Stat_Add( "GainSkill@Failed", chara:ToString( "TRAITS" ), StatType.LIST )
		return false
	end
	chara:LearnSkill( skill )
end

function Chara_LevelUp( chara )
	if not chara:CanLevelUp() then return false end

	local lv = Asset_Get( chara, CharaAssetID.LEVEL )
	local attrib = Entity_GetAssetAttrib( chara, CharaAssetID.LEVEL )
	if lv >= attrib.max then
		--InputUtil_Pause( chara:ToString(), "lv out of range", lv, attrib.max )
		return false
	end

	if chara:LevelUp() then
		if Chara_LearnSkill( chara ) == false then
			Chara_GainTrait( chara )
		end
	end
end

function Chara_GainTrait( chara )	
	local numOfTrait = Asset_GetDictSize( chara, CharaAssetID.TRAITS )
	if Random_GetInt_Sync( 1, 100 ) > 25 - numOfTrait * 3 then return end
	
	local reqNumOfTrait = 8
	if numOfTrait > reqNumOfTrait then
		return
	end
	CharaCreator_GenerateTrait( chara, 1 )-- reqNumOfTrait - numOfTrait )
end

-----------------------------------------------------

function Chara_UpdateLoyality( chara )
	local loyality = 0
	Asset_Foreach( chara, CharaAssetID.LOYALITY, function ( data, type )
		if type == CharaLoyalityType.SENIORITY then
			if data < DAY_IN_YEAR then loyality = loyality + 20
			elseif data < DAY_IN_YEAR * 2 then loyality = loyality + 25
			elseif data < DAY_IN_YEAR * 3 then loyality = loyality + 30
			elseif data < DAY_IN_YEAR * 5 then loyality = loyality + 40
			elseif data < DAY_IN_YEAR * 10 then loyality = loyality + 50
			else loyality = loyality + 60
			end
		else
			--print( chara.name, MathUtil_FindName( CharaLoyalityType, type ), data, type )
			loyality = loyality + data
		end
	end )
	chara._loyality = loyality
	--print( chara.name, "loy=" .. chara._loyality )
	--if g_init == true and chara._loyality == 0 then InputUtil_Pause( chara.name, chara._loyality, loyality ) k.p = 1 end
end

--Call this function when
--  1.change group
--  2.new scenario
function Chara_ResetLoyality( chara )
	--reset all untunable loyality
	for type, id in pairs( CharaLoyalityType ) do
		if id < CharaLoyalityType.TUNABLE_SEPERATOR then
			chara:SetLoyalityValue( id )
		end
	end

	local leader
	local group = Asset_Get( chara, CharaAssetID.GROUP )
	if group then
		leader = Asset_Get( group, GroupAssetID.LEADER )
	end
	if not leader then
		if group then DBG_Error( "why group no leader?", group:ToString() ) end
		chara:SetLoyalityValue( CharaLoyalityType.NEUTRAL, 30 )
	elseif leader == chara then
		chara:SetLoyalityValue( CharaLoyalityType.NEUTRAL, 100 )
	else
		local datas = Scenario_GetData( "CHARA_TRAIT_CONGENIALITY" )		
		local loyality = Asset_Get( leader, CharaAssetID.LEVEL ) * 2 + 20
		local traitDict1 = Asset_GetDict( leader, CharaAssetID.TRAITS )
		local traitDict2 = Asset_GetDict( chara, CharaAssetID.TRAITS )
		--print( chara:ToString( "TRAITS"), leader:ToString( "TRAITS" ) )
		for traitType, value in pairs( traitDict1 ) do
			if datas[traitType] then
				--has relative congeniality datas
				for typeName, value in pairs( datas[traitType] ) do				
					local traitType2 = CharaTraitType[typeName]
					if traitType2 == CharaTraitType.ALL then
						loyality = loyality + value
					else
						if traitDict2[traitType2] then
							--InputUtil_Pause( "check", MathUtil_FindName( CharaTraitType, traitType ), MathUtil_FindName( CharaTraitType, traitType2 ),  ldTraitDict[traitType2] )	
							loyality = loyality + value
						end
					end
				end
			end
		end
		chara:SetLoyalityValue( CharaLoyalityType.TRAIT_SUITED, loyality )

		--seniority
		local seniority = chara:GetLoyalityValue( CharaLoyalityType.SENIORITY )
		if seniority == 0 then
			chara:SetLoyalityValue( CharaLoyalityType.SENIORITY, 1 )
		end
	end

	--update tunable loyality
	Chara_UpdateLoyality( chara )
end

-----------------------------------------------------

-----------------------------------------------------


-----------------------------------------------------

CharaSystem = class()

function CharaSystem:__init()
	System_Setup( self, SystemType.CHARA_SYS )
end

function CharaSystem:Start()
	--init trait->skills caches
	local datas = Scenario_GetData( "CHARA_SKILL_DATA" )
	for _, skill in pairs( datas ) do
		
	end
end

function CharaSystem:Update()
	local day   = g_Time:GetDay()
	Entity_Foreach( EntityType.CHARA, function ( chara )
		if day % 10 == 0 then
			Chara_LevelUp( chara )
		end

		if day == 1 then
			Chara_UpdateLoyality( chara )
		end

		--reudce the pressure
		if day == 1 then
			chara:UpdateAP( DAY_IN_MONTH )
		end

		chara:Update()
		
		chara:Todo()
	end )
end