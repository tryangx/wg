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
	if job == CityJob.EXECUTIVE then

	elseif job == CityJob.COMMANDER then
		score = score + chara:GetStatus( CharaStatus.MILITARY_EXP, 0 )
	elseif job == CityJob.STAFF then
		score = score + chara:GetStatus( CharaStatus.MILITARY_EXP, 0 )
	elseif job == CityJob.HR then
		score = score + chara:GetStatus( CharaStatus.OFFICER_EXP, 0 )
	elseif job == CityJob.AFFAIRS then
		score = score + chara:GetStatus( CharaStatus.OFFICER_EXP, 0 )
	elseif job == CityJob.DIPLOMATIC then
		score = score + chara:GetStatus( CharaStatus.DIPLOMATIC_EXP, 0 )
	elseif job == CityJob.TECHNICIAN then
	end
	return 100
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

function Chara_GetLimitByGroup( group )
	if not group then return 0 end
	local government = Asset_Get( group, GroupAssetID.GOVERNMENT )
	--print( "gov=" .. MathUtil_FindName( GroupGovernment, government ) )
	local number = GroupGovernmentData[government].CAPITAL_CHARA_LIMIT

	local lv = 0
	Asset_Foreach( group, GroupAssetID.CITY_LIST, function ( city )
		lv = lv + Asset_Get( city, CityAssetID.LEVEL )
	end )
	number = number + math.floor( lv * 0.4 )	
	return number
end

function Chara_GetLimitByCity( city )
	if not city then return 0 end
	--if city:IsCapital() then return Chara_GetLimitByGroup( Asset_Get( city, CityAssetID.GROUP ) ) end
	local lv = Asset_Get( city, CityAssetID.LEVEL )	
	local ret = math.ceil( lv / 4 ) + 1
	if city:IsCapital() then
		ret = ret + 10
	end
	--DBG_Warning( "chara_limit_bycity", ret )
	return ret
end

function Chara_GetReqNumOfOfficer( city )
	if city:IsCapital() then
		return 8
	end
	if city:GetStatus( CityStatus.BATTLEFRONT ) then
		return 6
	elseif city:GetStatus( CityStatus.FRONTIER ) then
		return 4
	elseif city:GetStatus( CityStatus.SAFETY ) then
		return 2
	end
	return 3
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

	if city then
		city:CharaJoin( chara )

		--set home & location
		chara:JoinCity( city, true )

		--set job
		Asset_Set( chara, CharaAssetID.JOB, CharaJob.OFFICER )

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
end

-------------------------------
-- Promote relative

function Chara_Promote( chara, job )
	Asset_Set( chara, CharaAssetID.JOB, job )
	DBG_Warning( "chara_promote", chara.name .. " promote " .. MathUtil_FindName( CharaJob, job ), job )
end

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

-----------------------------------------------------

local function Chara_WorkForJob( chara )
	if chara:IsAtHome() == false then return end

	local home = Asset_Get( chara, CharaAssetID.HOME )
	if not home then return end

	local task = chara:GetTask()
	if not task then return end
	
	--InputUtil_Pause( chara.name, "work on" .. task:ToString() )
	Task_Do( task, chara )
end

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
		return
	end

	chara:LevelUp()
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
		chara:Update()

		if day % 10 == 0 then
			Chara_LevelUp( chara )
			if Chara_LearnSkill( chara ) == false then
				Chara_GainTrait( chara )
			end
		end
		
		Chara_WorkForJob( chara )
	end )
end