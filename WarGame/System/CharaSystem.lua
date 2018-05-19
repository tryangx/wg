-------------------------------------------

function Chara_GetLimitByGroup( group )
	if not group then return 0 end
	local government = Asset_Get( group, GroupAssetID.GOVERNMENT )
	--print( "gov=" .. MathUtil_FindName( GroupGovernment, government ) )
	return GroupGovernmentData[government].CAPITAL_CHARA_LIMIT
end

function Chara_GetLimitByCity( city )
	if not city then return 0 end
	if city:IsCapital() then
		return Chara_GetLimitByGroup( Asset_Get( city, CityAssetID.GROUP ) )
	end
	local lv = Asset_Get( city, CityAssetID.LEVEL )	
	local ret = math.ceil( lv / 4 ) + 1
	--DBG_Warning( "chara_limit_bycity", ret )
	return ret
end

function Chara_GetReqNumOfOfficer( city )
	return 2
end

function Chara_GetSurplusNumOfChara( city )
	local list = city:FindVacancyOfficerPositions()
	return #list - city:GetNumOfOfficerSlot()
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
	local group = Asset_Get( chara, CharaAssetID.GROUP )
	if group then		
		group:LoseChara( chara )
	end

	local home = Asset_Get( chara, CharaAssetID.HOME )
	if home then
		home:CharaLeave( chara )
	end

	--remove task
	local task = Asset_GetListItem( chara, CharaAssetID.STATUSES, CharaStatus.IN_TASK )
	if task then
		Task_Terminate( task )
	end

	Debug_Log( chara:ToString(), "died" )

	Stat_Add( "Chara@Die", chara:ToString(), StatType.LIST )

	Entity_Remove( chara )

	--InputUtil_Pause( "die")
end

function Chara_Join( chara, city )
	local oldHome = Asset_Get( chara, CharaAssetID.HOME )
	if oldHome == city then return end

	if oldHome then
		oldHome:CharaLeave( chara )
	end

	city:CharaJoin( chara )
end

-------------------------------
-- Hire chara relative

function Chara_Serve( chara, group, city )
	if not chara then return end

	if group then
		Asset_AppendList( group, GroupAssetID.CHARA_LIST, chara )
		DBG_Trace( "chara_serve", chara.name .. " serve " .. group.name )

		Asset_Set( chara, CharaAssetID.GROUP, group )
	end

	if city then
		Asset_AppendList( city, CityAssetID.CHARA_LIST, chara )
		DBG_Trace( "chara_serve", chara.name .. " serve " .. city.name )

		--set home & location
		Asset_Set( chara, CharaAssetID.HOME, city )
		Asset_Set( chara, CharaAssetID.LOCATION, city )

		--set job
		Asset_Set( chara, CharaAssetID.JOB, CharaJob.OFFICER )

		--to set relation
		local executive = Asset_GetListItem( Asset_Get( chara, CharaAssetID.LOCATION ), CityAssetID.OFFICER_LIST, CityJob.CHIEF_EXECUTIVE )
		if executive then
			Asset_Set( chara, CharaAssetID.SUPERIOR, executive )
			DBG_Trace( "chara_serve", executive.name .. " manage " .. chara.name )
			
			Asset_AppendList( executive, CharaAssetID.SUBORDINATES, chara )
			DBG_Trace( "chara_serve", chara.name .. " serve " .. executive.name )
		end

		Stat_Add( "Chara@Hire", chara.name, StatType.LIST )
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
					local findSkill = Asset_FindListItem( chara, CharaAssetID.SKILLS, function( skill )
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

function Chara_JobToPlan( job )
	if job == CityJob.CHIEF_EXECUTIVE then
		return CityPlan.ALL
	elseif job == CityJob.CHIEF_COMMANDER then
		return CityPlan.COMMANDER
	elseif job == CityJob.CHIEF_STAFF then
		return CityPlan.STAFF		
	elseif job == CityJob.CHIEF_HR then
		return CityPlan.HR
	elseif job == CityJob.CHIEF_AFFAIRS then
		return CityPlan.AFFAIRS
	elseif job == CityJob.CHIEF_DIPLOMATIC then
		return CityPlan.DIPLOMATIC
	elseif job == CityJob.CHIEF_TECHNICIAN then
		return CityPlan.TECHNICIAN
	end
	return CityPlan.NONE
end

local function Chara_WorkForJob( chara )
	if chara:IsAtHome() == false then return end

	local home = Asset_Get( chara, CharaAssetID.HOME )
	if not home then return end
	local job = home:GetCharaJob( chara )
	plan = Chara_JobToPlan( job )	
	local task
	if plan == CityPlan.NONE then
		return
	elseif plan == CityPlan.ALL then
		task = Random_GetDictData( home, CityAssetID.PLANS )
	else
		task = Asset_GetListItem( home, CityAssetID.PLANS, plan )
	end
	if not task then return end
	--print( MathUtil_FindName( CityJob, job ), MathUtil_FindName( CityPlan, plan ), task  )
	--InputUtil_Pause( chara.name, "work on" .. task:ToString() )
	Task_Do( task, chara )
end

local function Chara_ExecuteTask( chara )
	local loc = Asset_Get( chara, CharaAssetID.LOCATION )

	local list = {}
	Asset_ForeachList( chara, CharaAssetID.TASKS, function( task )
		if Asset_Get( task, TaskAssetID.DESTINATION ) == loc then
			table.insert( list, task )
		end
	end )

	if #list == 0 then return end

	local task = list[Random_GetInt_Sync(1, #list)]
	Task_Do( task, chara )
end

local function Chara_LearnSkill( chara )
	local numOfSkill = Asset_GetListSize( chara, CharaAssetID.SKILLS )
	local reqNumOfSkill = math.floor( Asset_Get( chara, CharaAssetID.LEVEL ) * 0.1 )
	if reqNumOfSkill > numOfSkill then
		return false
	end

	local skills = SkillTable_QuerySkillList( chara )
	local skill = Random_GetListItem( skills )
	if not skill then
		--should diagnose what situation( triats ) won't gain new skill
		Stat_Add( "GainSkill@Failed", chara:ToString( "TRAITS" ), StatType.LIST )
		return false
	end
	InputUtil_Pause( "has")
	chara:LearnSkill( skill )	
end

local function Chara_LevelUp( chara )
	if chara:LevelUp() == true then
		if Chara_LearnSkill( chara ) then
			Chara_GainTrait( chara )
		end
	end
end

local function Chara_GainTrait( chara )
	if Random_GetInt_Sync( 1, 100 ) < 20 then
		return
	end

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
	DBG_SetWatcher( "chara_proposal", DBGLevel.NORMAL )

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
		
		--Chara_ExecuteTask( chara )

		Chara_WorkForJob( chara )
	end )
end