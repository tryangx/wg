-------------------------------------------

function Skill_GetEffectValue( skill, effect, default )
	for type, value in ipairs( skill.effects ) do
		if type == effect then
			InputUtil_Pause( "get skill effect", MathUtil_FindName( CharaSkillEffect, value) )
			return value
		end
	end
	return default
end

-------------------------------------------

function Chara_GetSkillEffectValue( chara, effect )
	if not chara then return 0 end
	return chara:GetEffectValue( effect )
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

function Chara_GetRatingCharaSuitJob( chara, job )
	--to do
	return 100
end

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
		if not findChara or Asset_Get( findChara, CharaAssetID.JOB ) < Asset_Get( chara, CharaAssetID.JOB ) then
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

	--remove from corps
	local corps = Asset_Get( chara, CharaAssetID.CORPS )
	if corps then
		corps:LoseOfficer( chara )
		Debug_Log( corps:ToString("OFFICER"))
	else
		Debug_Log( chara.name .. "die, no corps" )
	end

	--remove from city
	local home = Asset_Get( chara, CharaAssetID.HOME )
	if home then
		--print( home.name, "leave", chara.name )
		home:CharaLeave( chara )
		Debug_Log( home:ToString("CHARA"))		
	else
		error( "no home?" .. chara.name )
	end

	--remove task
	local task = chara:GetTask()
	if task then
		Task_Terminate( task, chara )
	end

	--remove from group
	local group = Asset_Get( chara, CharaAssetID.GROUP )
	if group then
		group:LoseChara( chara )
		Debug_Log( group:ToString("CHARA"))
	else
		Debug_Log( chara.name .. "die, no group" )
	end

	Debug_Log( chara:ToString(), "died" )

	Stat_Add( "Chara@Die", chara:ToString(), StatType.LIST )

	Entity_Remove( chara )

	--if chara.name == "Qian XII" then error( "" ) end
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

local function Chara_LearnSkill( chara )
	if not chara:CanLearnSkill() then
		return false
	end

	local skills = SkillTable_QuerySkillList( chara )
	local skill = Random_GetListItem( skills )
	if not skill then
		--should diagnose what situation( triats ) won't gain new skill
		Stat_Add( "GainSkill@Failed", chara:ToString( "TRAITS" ), StatType.LIST )
		return false
	end
	chara:LearnSkill( skill )
end

local function Chara_LevelUp( chara )
	if chara:LevelUp() == true then
		if Chara_LearnSkill( chara ) then
			if Random_GetInt_Sync( 1, 100 ) < 20 then
				Chara_GainTrait( chara )
			end
		end
	end
end

local function Chara_GainTrait( chara )
	local numOfTrait = Asset_GetDictSize( chara, CharaAssetID.TRAITS )
	local reqNumOfTrait = 6
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
		end
		
		Chara_WorkForJob( chara )
	end )
end