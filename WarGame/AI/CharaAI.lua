----------------------------------------
-- Enviroment & Variables

--who try to submit proposal
local _proposer = nil
--who is the one should do the job
local _actor    = nil

local _city  = nil
local _group = nil

local _meeting = nil
local _topic   = nil

local _registers = {}

local function pause()
	--print( "topic=", MathUtil_FindName( MeetingTopic, _topic ) )
	InputUtil_Pause( "debug chara ai", _city.name, MathUtil_FindName( MeetingTopic, _topic ) )
	return true
end

local function ai_log( params )
	Debug_Log( params.log )
end

local bp = { type = "FILTER", condition = pause }

local stop = { type = "FILTER", condition = function ( ... )
	return false
end }

local function dbg( content )
	InputUtil_Pause( content )
end

----------------------------------------

local function PassProposal()
end

local function SubmitProposal( params )
	--check actor
	if _registers["ACTOR"] then
		_actor = _registers["ACTOR"]
	end

	local proposal = Entity_New( EntityType.PROPOSAL )
	Asset_Set( proposal, ProposalAssetID.TYPE,        ProposalType[params.type] )
	Asset_Set( proposal, ProposalAssetID.PROPOSER,    _proposer )	
	Asset_Set( proposal, ProposalAssetID.LOCATION,    _city )
	Asset_Set( proposal, ProposalAssetID.DESTINATION, _city )
	Asset_Set( proposal, ProposalAssetID.TIME,        g_Time:GetDateValue() )
	Asset_Set( proposal, ProposalAssetID.ACTOR,       _actor )

	if _actor:IsBusy() then
		error( _actor:ToString(), "already has task" )
	end
	
	if params.type == "ATTACK_CITY" then		
		Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "corps_list", _registers["ATTACK_CORPS"] )
		Asset_Set( proposal, ProposalAssetID.DESTINATION, _registers["TARGET_CITY"] )
	
	elseif params.type == "HARASS_CITY" then
		Asset_Set( proposal, ProposalAssetID.DESTINATION, _registers["TARGET_CITY"] )
	
	elseif params.type == "INTERCEPT" then
		local enemyCorps = _registers["TARGET_CORPS"]
		local city = Asset_Get( enemyCorps, CorpsAssetID.LOCATION )
		Asset_Set( proposal, ProposalAssetID.DESTINATION, city )
		Asset_Set( proposal, ProposalAssetID.DESTINATION, _registers["TARGET_CITY"] )
	
	elseif params.type == "DISPATCH_CORPS" then
		Asset_Set( proposal, ProposalAssetID.DESTINATION, _registers["TARGET_CITY"] )
		Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "corps", _registers["CORPS"] )

	elseif params.type == "ESTABLISH_CORPS" then
		Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "plan", TaskType.ESTABLISH_CORPS )

	elseif params.type == "DISMISS_CORPS"
		or params.type == "TRAIN_CORPS"
		or params.type == "UPGRADE_CORPS"
		then
		Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "corps", _registers["CORPS"] )

	elseif params.type == "REINFORCE_CORPS"
		or params.type == "ENROLL_CORPS" then
		Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "corps", _registers["CORPS"] )
		Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "plan", TaskType.COMMANDER_TASK )
	
	elseif params.type == "RECRUIT"
		or params.type == "CONSCRIPT" 
		or params.type == "HIRE_GUARD" then
		Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "plan", TaskType.COMMANDER_TASK )

	elseif params.type == "PROMOTE_CHARA" then
		Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "job", _registers["JOB"] )
	
	elseif params.type == "HIRE_CHARA" then
		Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "plan", TaskType.HR_TASK )
	
	elseif params.type == "DISPATCH_CHARA" then
		Asset_Set( proposal, ProposalAssetID.DESTINATION, _registers["TARGET_CITY"] )
	
	elseif params.type == "CALL_CHARA" then		
		Asset_Set( proposal, ProposalAssetID.LOCATION, _registers["TARGET_CITY"] )
	
	elseif params.type == "MOVE_CAPITAL" then
		Asset_Set( proposal, ProposalAssetID.LOCATION, _registers["TARGET_CITY"] )
	
	elseif params.type == "DEV_AGRICULTURE" or params.type == "DEV_COMMERCE" or params.type == "DEV_PRODUCTION" 
		or params.type == "LEVY_TAX"
		then
		Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "plan", TaskType.AFFAIRS_TASK )
	
	elseif params.type == "BUILD_CITY"
		then
		Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "construction", _registers["CONSTRUCTION"] )
		Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "plan", TaskType.BUILD_CITY )

	elseif params.type == "TRANSPORT" then
		Asset_Set( proposal, ProposalAssetID.DESTINATION, _registers["TARGET_CITY"] )
		Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "plan", TaskType.TRANSPORT )

	elseif params.type == "RECONNOITRE" 
		or params.type == "SABOTAGE"
		then
		Asset_Set( proposal, ProposalAssetID.DESTINATION, _registers["TARGET_CITY"] )

	elseif params.type == "RESEARCH" then
		Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "tech", _registers["TARGET_TECH"] )
		Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "plan", TaskType.RESEARCH )

	elseif params.type == "IMPROVE_RELATION"	
		or params.type == "DECLARE_WAR"
		then
		local oppGroup = _registers["TARGET_GROUP"]
		local capital  = Asset_Get( oppGroup, GroupAssetID.CAPITAL )
		Asset_Set( proposal, ProposalAssetID.DESTINATION, capital )
		Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "group", oppGroup )
		if params.type == "IMPROVE_RELATION" then
			Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "plan", TaskType.IMPROVE_RELATION )
		elseif params.type == "DECLARE_WAR" then
			Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "plan", TaskType.DECLARE_WAR )
		end		

	elseif params.type == "SIGN_PACT" then
		local oppGroup = _registers["TARGET_GROUP"]
		local capital  = Asset_Get( oppGroup, GroupAssetID.CAPITAL )
		Asset_Set( proposal, ProposalAssetID.DESTINATION, capital )
		Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "pact", _registers["PACT"] )		
		Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "time", _registers["TIME"] )
		Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "group", oppGroup )
		Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "plan", TaskType.DIPLOMATIC_TASK )

	elseif params.type == "SET_GOAL" then
		Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "goalType", _registers["GOALTYPE"] )
		Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "goalData", _registers["GOALDATA"] )

	elseif params.type == "INSTRUCT_CITY" then
		Asset_SetDictItem( proposal, ProposalAssetID.PARAMS, "instructCityList", _registers["INSTRUCT_CITY_LIST"] )		

	elseif params.type == "TRAIN_CORPS" then

	elseif params.type == "" then
	end

	DBG_Watch( "Debug_Meeting", "submit proposal=" .. proposal:ToString() )

	Stat_Add( "Proposal@Submit_Times", 1, StatType.TIMES )

	Log_Write( "meeting", "    topic=" .. MathUtil_FindName( MeetingTopic, _topic ) ..  " proposal=" .. proposal:ToString() )

	--InputUtil_Pause( proposal:ToString() )

	Asset_SetDictItem( _proposer, CharaAssetID.STATUSES, CharaStatus.PROPOSAL_CD, Random_GetInt_Sync( 30, 50 ) )
end

----------------------------------------

local function CheckDate( params )
	if params.month then
		if params.month ~= g_Time:GetMonth() then return false end
	end
	if params.day then
		if params.day ~= g_Time:GetMonth() then return false end
	end
	return true
end

--probability unit is 1 per 10000
local function TestProbability( params )
	local ratio = params.prob or 5000
	return Random_GetInt_Sync( 1, 10000 ) < ratio
end

local function IsCityCapital()
	local group = Asset_Get( _city, CityAssetID.GROUP )
	--should consider more, like goverment style
	if not group then return true end
	return Asset_Get( group, GroupAssetID.CAPITAL ) == _city
end

local function IsGroupLeader()
	return _proposer:IsGroupLeader()
end

local function IsTopic( params )
	if not _topic or _topic == MeetingTopic.NONE then
		InputUtil_Pause( "topic pass", _topic )
		return false
	end
	return MeetingTopic[params.topic] == _topic
end

local function IsProposalCD()
	local proposalcd = _proposer:GetStatus( CharaStatus.PROPOSAL_CD )
	return proposalcd and proposalcd > 0 or false
end

local function HasCityStatus( params )
	local ret = _city:GetStatus( CityStatus[params.status] )
	if ret == true then
		--InputUtil_Pause( _city.name, params.status, CityStatus[params.status] )
	end
	return ret
end

local function HasGroupGoal( params )
	if not _group then return false end
	local goalData = _group:GetGoal( GroupGoalType[params.goal] )	
	if params.excludeCity then
		return goalData ~= nil
	end
	--print( params.goal, _group:ToString( "GOAL" ), goalData, goalData.city )
	if not goalData then return false end
	return not goalData.city or goalData.city == city
end

local function QueryJob( topic )
	local job
	if topic == MeetingTopic.TECHNICIAN then
		job  = CityJob.TECHNICIAN
	elseif topic == MeetingTopic.DIPLOMATIC then
		job  = CityJob.DIPLOMATIC
	elseif topic == MeetingTopic.HR then
		job  = CityJob.HR
	elseif topic == MeetingTopic.AFFAIRS then
		job  = CityJob.AFFAIRS
	elseif topic == MeetingTopic.COMMANDER then
		job  = CityJob.COMMANDER
	elseif topic == MeetingTopic.STAFF then
		job  = CityJob.STAFF
	elseif topic == MeetingTopic.STRATEGY then
		job  = CityJob.COMMANDER
	end
	return job
end

local function CanSubmitPlan( params )
	if IsTopic( params ) == false then
		return false
	end

	--exclusive task checker
	local topic = MeetingTopic[params.topic]
	local job = QueryJob( topic )
	if plan then
		local task = _city:GetPlan( plan )
		if task then return false end
	end

	if _city:IsCharaOfficer( CityJob.EXECUTIVE, _proposer ) == true then
		--find the one who do the job
		local actor = Asset_FindListItem( _city, CityAssetID.CHARA_LIST, function ( chara )
			if not chara:IsAtHome() then return false end
			if chara:IsBusy() then return false end
			if not _city:IsCharaOfficer( job, chara ) then return false end
			return true
		end )
		if actor then
			_actor = actor
			--Log_Write( "meeting", "      " .. _proposer.name .. " find a actor=" .. _actor.name )
		end
	end

	return true
end

local function IsResponsible()		
	if _city:IsCharaOfficer( CityJob.EXECUTIVE, _proposer ) == true then
		return true
	end

	local job = QueryJob( _topic )
	if _city:IsCharaOfficer( job, _proposer ) then
		--print( _proposer.name, "is job=" .. MathUtil_FindName( CityJob, job ) )
		return true
	end

	return false
end

----------------------------------------

local function CanEstablishCorps()
	--print( "limit=" .. Corps_GetLimitByCity( _city ), "corps=" .. Asset_GetListSize( _city, CityAssetID.CORPS_LIST ) )

	--check corps limitation
	local hasCorps   = Asset_GetListSize( _city, CityAssetID.CORPS_LIST )
	local limitCorps = Corps_GetLimitByCity( _city )
	if hasCorps >= limitCorps then
		Debug_Log( _city.name, "EstCorpsFailed! corps limit, cann't est corps", _city.name, hasCorps .. "/" .. limitCorps )
		return false
	end

	--need a leader
	local charaList = _city:FindFreeCharas( function ( chara )
		if Asset_Get( chara, CharaAssetID.CORPS ) then
			return false
		end
		local job = _city:GetCharaJob( chara )
		--Debug_Log( chara.name, MathUtil_FindName( CityJob, job ) )
		return job == CityJob.COMMANDER
	end)
	if #charaList == 0 then
		Debug_Log( _city.name, "EstCorpsFailed! no commander", _city:ToString("OFFICER") )
		return false
	end

	--check minimum soldier available
	local reserves = _city:GetPopu( CityPopu.RESERVES )
	if reserves < Scenario_GetData( "TROOP_PARAMS" ).MIN_TROOP_SOLDIER then
		Debug_Log( _city.name, "EstCorpsFailed! not enough reserves=", reserves )

		--check req corps
		local reqCorps = Corps_GetRequiredByCity( _city )
		if hasCorps < reqCorps then
			_city:SetStatus( CityStatus.RESERVE_UNDERSTAFFED, 1 )
		end

		return false
	end
	if Corps_CanEstablishCorps( _city, reserves ) == false then
		Debug_Log( _city.name, "EstCorpsFailed! cann't est" )
		return false
	end

	local leader = Random_GetListItem( charaList )
	_registers["ACTOR"] = leader

	Debug_Log( "est corps", leader:ToString() )

	return true
end

local function CanReinforceCorps()
	local reserves = _city:GetPopu( CityPopu.RESERVES )
	if reserves < Scenario_GetData( "TROOP_PARAMS" ).MIN_TROOP_SOLDIER then
		return false
	end

	local corpsList = {}
	Asset_FindListItem( _city, CityAssetID.CORPS_LIST, function ( corps )
		if corps:IsAtHome() == false then return false end
		if corps:IsBusy() == true then return false end
		if corps:GetStatus( CorpsStatus.UNDERSTAFFED_LV1 ) then
			table.insert( corpsList, corps )
		elseif corps:GetStatus( CorpsStatus.UNDERSTAFFED_LV2 ) and Random_GetInt_Sync( 1, 100 ) < 60 then
			table.insert( corpsList, corps )
		elseif corps:GetStatus( CorpsStatus.UNDERSTAFFED_LV3 ) and Random_GetInt_Sync( 1, 100 ) < 30 then
			table.insert( corpsList, corps )
		end
	end )
	if #corpsList == 0 then return false end

	local findCorps = corpsList[Random_GetInt_Sync( 1, #corpsList )]

	_registers["CORPS"] = findCorps
	_registers["ACTOR"] = findCorps

	return true
end

local function CanEnrollCorps()
	local findCorps = nil	
	Asset_FindListItem( _city, CityAssetID.CORPS_LIST, function ( corps )
		if corps:IsAtHome() == false then return false end
		if corps:IsBusy() == true then return false end
		--print( "check corps", Asset_GetListSize( corps, CorpsAssetID.TROOP_LIST ), Scenario_GetData( "CORPS_PARAMS" ).REQ_TROOP_NUMBER )
		if Asset_GetListSize( corps, CorpsAssetID.TROOP_LIST ) < Scenario_GetData( "CORPS_PARAMS" ).REQ_TROOP_NUMBER then
			findCorps = corps
			return true
		end
	end)
	if not findCorps then
		--print( "no rein corps" )
		return false
	end

	local reserves = _city:GetPopu( CityPopu.RESERVES )
	if reserves < Scenario_GetData( "TROOP_PARAMS" ).MIN_TROOP_SOLDIER then
		return false
	end
	if Corps_CanEstablishCorps( _city, reserves ) == false then
		--print( "cann't enroll corps" )
		return false
	end

	_registers["CORPS"] = findCorps
	_registers["ACTOR"] = findCorps

	return true
end

local function CanTrainCorps()
	local findCorps = nil
	Asset_FindListItem( _city, CityAssetID.CORPS_LIST, function ( corps )
		if corps:IsAtHome() == false then return false end
		if corps:IsBusy() == true then return false end
		--check corps can train
		if corps:CanTrain() then
			findCorps = corps
			return true
		end
	end)
	if not findCorps then
		--print( "no train corps" )
		return false
	end

	_registers["CORPS"] = findCorps
	_registers["ACTOR"] = findCorps

	return true
end

local function CheckEnemyCity( targetCity, city, soldier, scores )
	if targetCity:GetStatus( CityStatus.STARVATION ) then
		return true
	end

	local citySoldier = Intel_Get( targetCity, city, CityIntelType.DEFENDER )
	--unknown
	if citySoldier == -1 then
		return false
	end
	
	--TODO: should consider about the officer ability

	local ratio = soldier / citySoldier
	local item = MathUtil_Approximate( ratio, scores, "ratio", true )
	
	Debug_Log( "enemy_compare", city.name .."=" .. soldier, targetCity.name .."="..citySoldier )

	if Random_GetInt_Sync( 1, 100 ) > item.score then
		return false
	end
	
	return true
end

local function FindEnemyCityList( city, soldier, scores )
	local group = Asset_Get( city, CityAssetID.GROUP )
	return city:FilterAdjaCities( function ( adja )
		local adjaGroup = Asset_Get( adja, CityAssetID.GROUP )		
		if Dipl_IsAtWar( group, adjaGroup ) == false then
			return false
		end
		return CheckEnemyCity( adja, city, soldier, scores )
	end )
end

local function CanHarassCity()
	--check free corps
	local list, soldier, power = _city:GetMilitaryCorps()
	if #list == 0 then
		return false
	end

	local canHarassScores = 
	{
		{ ratio = 0.5, score = 0 },
		{ ratio = 1,   score = 10 },
		{ ratio = 1.5, score = 20 },
		{ ratio = 2,   score = 50 },
		{ ratio = 4,   score = 90 },
	}
	local cities = FindEnemyCityList( _city, soldier, canHarassScores )

	local number = #cities
	if number == 0 then return false end

	local corps = list[Random_GetInt_Sync( 1, #list )]
	local destcity = cities[Random_GetInt_Sync( 1, number )]

	--check food
	if Supply_HasEnoughFoodForCorps( _city, destcity, corps ) == false then
		return false
	end

	_registers["ACTOR"] = corps
	_registers["TARGET_CITY"] = destcity

	return true
end

local function CanAttackCity()
	--check free corps
	local list, soldier, power = _city:GetMilitaryCorps()
	if #list == 0 then
		local numofcorps = Asset_GetListSize( _city, CityAssetID.CORPS_LIST )
		--print( _city.name, "has corps=" .. numofcorps )
		return false
	end

	local canAttackScores = 
	{
		{ ratio = 1.5, score = 0 },
		{ ratio = 2,   score = 20 },
		{ ratio = 3,   score = 50 },
		{ ratio = 4,   score = 90 },
	}
	local cities = FindEnemyCityList( _city, soldier, canAttackScores )

	local number = #cities
	if number == 0 then
		--print( "no enemy city" )
		return false
	end

	local corps = list[Random_GetInt_Sync( 1, #list )]
	local destcity = cities[Random_GetInt_Sync( 1, number )]

	--check food
	if Supply_HasEnoughFoodForCorps( _city, destcity, corps ) == false then
		return false
	end

	Debug_Log( "check attack" .. corps:ToString( "STATUS" ) )
	Debug_Log( "CombatCompare", corps:ToString( "MILITARY" ), destcity:ToString( "MILITARY" ) )

	_registers["ACTOR"] = corps
	_registers["TARGET_CITY"] = destcity
	_registers["ATTACK_CORPS"] = list

	--InputUtil_Pause( "attack", destcity.name, #list, corps:ToString("MILITARY"),soldier )

	return true
end

local function CanExpedition()
	--check free corps
	local list, soldier, power = _city:GetMilitaryCorps()
	if #list == 0 then
		return false
	end

	local canAttackScores = 
	{
		{ ratio = 1.5, score = 0 },
		{ ratio = 2,   score = 20 },
		{ ratio = 3,   score = 50 },
		{ ratio = 4,   score = 90 },
	}

	local goal = _group:GetGoal( GroupGoalType.OCCUPY_CITY )
	if not goal then
		return false
	end
	local destcity = goal.city
	if not CheckEnemyCity( destcity, _city, soldier, canAttackScores ) then
		return false
	end
	
	local corps = list[Random_GetInt_Sync( 1, #list )]

	--check food
	if Supply_HasEnoughFoodForCorps( _city, destcity, corps ) == false then
		return false
	end

	Debug_Log( "CombatCompare", corps:ToString( "MILITARY" ), destcity:ToString( "MILITARY" ) )--, "enemy=" .. Intel_Get( destcity, _city, CityIntelType.DEFENDER ) )

	_registers["ACTOR"] = corps
	_registers["TARGET_CITY"] = destcity
	_registers["ATTACK_CORPS"] = list

	--InputUtil_Pause( "expedition", destcity.name, #list, corps:ToString("MILITARY"),soldier )

	return true
end

local function CanIntercept()
	local list = _city:GetMilitaryCorps()
	if #list == 0 then
		--print( _city:ToString( "CORPS" ) )
		--InputUtil_Pause( "intercept", _city.name .. " no corps=", Asset_GetListSize( _city, CityAssetID.CORPS_LIST ) )
		return false
	end

	local target = Asset_Get( _meeting, MeetingAssetID.TARGET )
	local destcity = Asset_Get( target, CorpsAssetID.LOCATION )
	local corps = list[Random_GetInt_Sync( 1, #list )]

	--check food
	if Supply_HasEnoughFoodForCorps( _city, destcity, corps ) == false then
		return false
	end

	--print( target:ToString() )
	--InputUtil_Pause( "intercept", _city:ToString(), destcity.name )

	_registers["ACTOR"]  = corps
	_registers["TARGET_CORPS"] = target
	_registers["TARGET_CITY"]  = destcity	

	return true
end

--1. in danger
--2. not enough reserves
--3. corps understaffed
local function NeedMoreReserves()
	if _city:GetStatus( CityStatus.BUDGET_DANGER ) then
		--print( "budget danger, cann't conscript" )
		Stat_Add( "BudgetDanger", 1, StatType.TIMES )
		return false
	end

	if _city:GetStatus( CityStatus.RESERVE_UNDERSTAFFED ) then
		return true
	end
	
	--default score
	local score = 0
	--check "in danger"
	if _group:GetGoal( GroupGoalType.OCCUPY_CITY ) then
		if _city:GetStatus( CityStatus.AGGRESSIVE_WEAK ) then
			--print( _city.name, "AGGRESSIVE wek", score )
			return true
		end
		if _city:GetStatus( CityStatus.AGGRESSIVE_ADV ) then
			score = score - 10
			--print( _city.name, "AGGRESSIVE adv", score )
		end
		if _city:GetStatus( CityStatus.MILITARY_BASE ) then
			score = score + 30
		end
	elseif _group:GetGoal( GroupGoalType.DEFEND_CITY ) then
		if _city:GetStatus( CityStatus.DEFENSIVE_DANGER ) then
			--print( _city.name, "DEFENSIVE_DANGER", score )
			return true
		end
		if _city:GetStatus( CityStatus.DEFENSIVE_WEAK ) then
			score = score + 20
			--print( _city.name, "DEFENSIVE_WEAK", score )
		end
	else
		if _city:GetStatus( CityStatus.AGGRESSIVE_WEAK ) then
			score = score + 30
		end
		if _city:GetStatus( CityStatus.AGGRESSIVE_ADV ) then
			return false
		end
		if _city:GetStatus( CityStatus.DEFENSIVE_DANGER ) then
			score = score + 50
		end
		if _city:GetStatus( CityStatus.DEFENSIVE_WEAK ) then
			score = score + 30
		end
		if _city:GetStatus( CityStatus.MILITARY_BASE ) then
			score = score + 20
		end
	end

	if _city:GetStatus( CityStatus.BATTLEFRONT ) then
		score = score + 30
	end

	--corps understaffed
	local soldier, maxSoldier = _city:GetSoldier()
	local needSoldier = maxSoldier - soldier
	local reserves = _city:GetPopu( CityPopu.RESERVES )
	local ratio = reserves / needSoldier

	local reservesScores = 
	{
		{ ratio = 0.3, score = 100 },
		{ ratio = 0.4, score = 90 },
		{ ratio = 0.5, score = 70 },
		{ ratio = 0.7, score = 50 },
		{ ratio = 0.9, score = 30 },
		{ ratio = 1, score = 0 },
	}
	local item = MathUtil_Approximate( ratio, reservesScores, "ratio", true )
	score = score + item.score
	
	--print( score, reserves, needSoldier )

	if Random_GetInt_Sync( 1, 100 ) > score then		
		Debug_Log( _city:ToString( "STATUS" ) )
		Debug_Log( g_Time:ToString(), _city.name, "failed reserve " .. item.score .. "->" .. score, "needsol=" .. reserves .. "/" .. needSoldier )
		return false
	end

	--starve check
	if _city:GetStatus( CityStatus.STARVATION ) then
		--InputUtil_Pause( _city.name, "is starvation" )		
	end

	Debug_Log( g_Time:ToString(), _city.name, "need reserve score=" .. score )
	--print( _city:ToString( "POPULATION" ) )
	--print( _group:ToString( "DIPLOMACY" ) )
	--print( _city:ToString( "STATUS" ) )
	--print( "reserves=" .. reserves, "need=" .. needSoldier, maxSoldier, soldier )	
	return true
end

--force conscript, 
local function CanConscript()
	if _actor:IsBusy() then return false end	
	if NeedMoreReserves() == false then
		return false
	end
	return true
end

--use money to recruit
local function CanRecruit()
	if _actor:IsBusy() then return false end
	if NeedMoreReserves() == false then		
		return false
	end
	return true
end

local function CanHireGuard()
	if _actor:IsBusy() then return false end

	local hasGuard  = _city:GetPopu( CityPopu.GUARD )
	local needGuard = _city:GetReqPopu( CityPopu.GUARD )
	if needGuard < hasGuard then
		return false
	end

	local money = ( needGuard - hasGuard ) * _city:GetPopuValue( "POPU_SALARY", CityPopu.GUARD )
	if Asset_Get( _city, CityAssetID.MONEY ) < money then
		InputUtil_Pause( "no money hire guard", money )
		return false
	end

	local score = 50

	if _group:GetGoal( GroupGoalType.DEFEND_CITY ) then
		if _city:GetStatus( CityStatus.DEFENSIVE_DANGER ) then
			InputUtil_Pause( _city.name, "DEFENSIVE_DANGER", score )
			return true
		end
		if _city:GetStatus( CityStatus.DEFENSIVE_WEAK ) then
			score = score + 30
		end
	end

	if Random_GetInt_Sync( 1, 100 ) > score then
		Debug_Log( g_Time:ToString(), _city.name, "failed hireguard score=" .. score )
		return false
	end

	Debug_Log( _city.name, "hire guard", hasGuard .. "/" .. needGuard )

	return true
end

local function CanReinforceAdvancedBase()
	local corpsList = _city:GetFreeCorps()
	if #corpsList == 0 then
		--print( "no corps" )
		return false
	end

	local goalData = _group:GetGoal( GroupGoalType.DEFEND_CITY )
	if not goalData or not goalData.city then
		print( "no goal", _group:ToString( "GOAL" ) )
		return false
	end

	if goalData.city == _city then
		return false
	end

	_registers["ACTOR"] = Random_GetListItem( corpsList )
	_registers["CORPS"] = _registers["ACTOR"]
	_registers["TARGET_CITY"] = goalData.city

	--InputUtil_Pause( "reinforce military base", _registers["TARGET_CITY"].name, _registers["CORPS"].name )

	return true
end

local function NeedCorps( city, score )
	if not score then score = 0 end
	if city:GetStatus( CityStatus.DEFENSIVE_WEAK ) then
		score = score + 20
	end
	if city:GetStatus( CityStatus.DEFENSIVE_DANGER ) then
		score = score + 35
	end
	if city:GetStatus( CityStatus.BATTLEFRONT ) then
		score = score + 50
	end
	--Debug_Log( "dis corps", city.name, score )
	return Random_GetInt_Sync( 1, 100 ) < score
end

local function CanCorpsBack2Capital()
	if not _proposer:IsGroupLeader() then
		return false
	end

	local corps = Asset_Get( _proposer, CharaAssetID.CORPS )
	if not corps then
		return false
	end
	if not corps:IsAtHome() or corps:IsBusy() then
		return false
	end

	_registers["ACTOR"] = corps
	_registers["CORPS"] = _registers["ACTOR"]
	_registers["TARGET_CITY"] = Asset_Get( _group, GroupAssetID.CAPITAL )

	InputUtil_Pause( "corps=" .. corps:ToString() .. " back to capital" .. capital:ToString() )

	return true
end

local function CanDispatchCorps()	
	if _city:IsCapital() == false then
		return false
	end

	local corpsList = _city:GetMilitaryCorps()
	if #corpsList == 0 then
		return false
	end

	local score = 0
	if Asset_GetDictItem( _city, CityAssetID.STATUSES, CityStatus.SAFETY ) == true then
		score = score + 50
	end
	if Asset_GetDictItem( _city, CityAssetID.STATUSES, CityStatus.BATTLEFRONT ) == true then
		score = score - 50
	end	
	if Asset_GetDictItem( _city, CityAssetID.STATUSES, CityStatus.DEFENSIVE_WEAK ) == true then
		score = score - 10
	end
	if Asset_GetDictItem( _city, CityAssetID.STATUSES, CityStatus.DEFENSIVE_DANGER ) == true then
		score = score - 20
	end

	local cityList = {}
	Asset_Foreach( _group, GroupAssetID.CITY_LIST, function ( city )
		if city:IsCapital() == true then return end
		if Corps_GetLimitByCity( city ) <= Asset_GetListSize( city, CityAssetID.CORPS_LIST ) then return end
		if NeedCorps( city, score ) == false then return end		
		table.insert( cityList, city )
	end)
	if #cityList == 0 then return false end

	local corps    = Random_GetListItem( corpsList )
	local destCity = Random_GetListItem( cityList )
	_registers["ACTOR"] = corps
	_registers["CORPS"] = _registers["ACTOR"]
	_registers["TARGET_CITY"] = destCity

	return true
end

----------------------------------------

local function CanBuildCity()
	if _actor:IsBusy() then return false end

	local area = _city:GetMaxBulidArea()
	local has = Asset_GetListSize( _city, CityAssetID.CONSTR_LIST )
	if has >= area then
		return false
	end

	local list = Asset_GetList( _city, CityAssetID.CONSTRTABLE_LIST )
	if #list == 0 then
		return false
	end

	local constr = Random_GetListItem( list )
	_registers["CONSTRUCTION"] = constr

	--InputUtil_Pause( "build", constr.name )

	return true
end

function NeedLevyTax( score )
	if not score then score = 0 end
	local security = Asset_Get( _city, CityAssetID.SECURITY )
	if security > 80 then
		score = score + 20
	elseif security > 60 then
		score = score + 10
	elseif security < 30 then
		score = score - 20
	elseif security < 40 then
		score = score - 10
	end
	local money = Asset_Get( _city, CityAssetID.MONEY )
	--if money < then 	end
	return Random_GetInt_Sync( 1, 100 ) < score
end
local function CanLevyTax()
	return false
end

local function CanTransport()
	if _actor:IsBusy() then return false end

	--has enough corvee to do this job
	if _city:GetPopu( CityPopu.CORVEE ) < Scenario_GetData( "TROOP_PARAMS" ).MIN_TROOP_SOLDIER then		
		--print( "not enough corvee")
		return false
	end

	--has enough food/moeny for self
	if _city:GetStatus( CityStatus.BUDGET_DANGER ) then
		--print( "budget danger")
		return false
	end

	--find advanced base
	local cityList = {}
	Asset_Foreach( _group, GroupAssetID.CITY_LIST, function ( city )
		if _city ~= city and city:GetStatus( CityStatus.ADVANCED_BASE ) then
			table.insert( cityList, city )
		end
	end )

	if #cityList <= 0 then
		return false
	end

	local city = Random_GetListItem( cityList )

	_registers["TARGET_CITY"] = city

	return true
end

local function CanHireChara()
	if _actor:IsBusy() then return false end

	local limit
	if _city then		
		local groupHas = Asset_GetListSize( _group, GroupAssetID.CHARA_LIST )
		limit = Chara_GetLimitByGroup( _group )
		if limit > 0 and limit <= groupHas then
			return false
		end

		local cityHas  = Asset_GetListSize( _city, CityAssetID.CHARA_LIST )
		limit = Chara_GetLimitByCity( _city )
		if limit > 0 and limit <= cityHas then
			return false
		end
		--print( _city.name, "has="..has, "lim=" .. limit )
	end
	return true
end
local function CanPromoteChara()
	local job = Chara_FindPromoteJob( _proposer )
	if job then
		_registers["JOB"]   = job
		_registers["ACTOR"] = _proposer
		--InputUtil_Pause( "promote=" .. MathUtil_FindName( CharaJob, job ) )
		return true
	end
	return false
end

local function CanDispatchChara()
	if _city:IsCapital() == false then
		return false
	end

	local charaList = _city:FindNonOfficerFreeCharas()
	if #charaList == 0 then
		return false
	end

	local cityList = _group:GetVacancyCityList()
	if #cityList == 0 then
		return false
	end

	--simply random
	local city  = Random_GetListItem( cityList )	
	local chara = Random_GetListItem( charaList )

	_registers["TARGET_CITY"] = city
	_registers["ACTOR"]       = chara

	--print( _city:ToString( "OFFICER") )

	return true
end

local function CanMoveCapital()
	local leader  = Asset_Get( _group, GroupAssetID.LEADER )
	if _proposer ~= leader then
		--only leader can submit move capital
		return false
	end

	local capital = Asset_Get( _group, GroupAssetID.CAPITAL )	
	local city    = Asset_Get( leader, CharaAssetID.HOME )	
	if city == capital then
		return false
	end

	--move to battlefront
	local targetCity
	if not targetCity and _group:HasGoal( GroupGoalType.OCCUPY_CITY ) then
		local goalData = _group:GetGoal( GroupGoalType.OCCUPY_CITY )
		local list = goalData.city:FindNearbyEnemyCities()
		targetCity = Random_GetListItem( list )
	end
	if not targetCity and _group:HasGoal( GroupGoalType.DEFEND_CITY ) then
		local goalData = _group:GetGoal( GroupGoalType.DEFEND_CITY )
		targetCity = goalData.city
	end
	if not targetCity and _proposer:GetTrait( CharaTraitType.AGGRESSIVE ) then
		local list = _group:GetStatusCityList( CityStatus.BATTLEFRONT )
		targetCity = Random_GetListItem( list )
	end

	--move to the biggest city
	if not targetCity and _proposer:GetTrait( CharaTraitType.CONSERVATIVE ) then
		local curLv = Asset_Get( capital, CityAssetID.LEVEL )
		Asset_Foreach( _group, GroupAssetID.CITY_LIST, function ( city )
			local lv = Asset_Get( city, CityAssetID.LEVEL )
			if curLv < lv then
				targetCity = city
				curLv      = lv
			end
		end )
	end

	if not targetCity or capital == targetCity then
		return false
	end

	_registers["TARGET_CITY"] = targetCity

	return true
end

local function CanCharaBack2Capital()
	if not _proposer:IsGroupLeader() then
		return false
	end

	local chara = _proposer

	if chara:IsBusy() then
		return false
	end

	if Asset_Get( chara, CharaAssetID.CORPS ) then
		return false
	end

	local capital = Asset_Get( _group, GroupAssetID.CAPITAL )
	if capital == _city then
		return false
	end

	_registers["TARGET_CITY"] = capital
	_registers["ACTOR"]       = chara

	InputUtil_Pause( "leader=" .. chara:ToString() .. " back to capital" .. capital:ToString() )

	return true
end

local function CanCallChara()
	if _city:IsCapital() == false then
		return false
	end

	local numOfChara = Asset_GetListSize( _city, CityAssetID.CHARA_LIST )
	if numOfChara > _city:GetNumOfOfficerSlot() + _city:GetNumOfOfficerSlot() then
		--has enough chara
		return false
	end

	local limit = Chara_GetLimitByCity( _city )
	if numOfChara >= limit then return false end

	local charaList = {}	
	Asset_Foreach( _group, GroupAssetID.CITY_LIST, function ( city )
		if city:IsCapital() then return end
		local num = Asset_GetListSize( city, CityAssetID.OFFICER_LIST )		
		if num > city:GetNumOfOfficerSlot() then
			charaList = city:FindNonOfficerFreeCharas( charaList )
		end
	end)

	if #charaList == 0 then
		return false
	end

	local chara = Random_GetListItem( charaList )
	local city = Asset_Get( chara, CharaAssetID.HOME )

	_registers["TARGET_CITY"] = city
	_registers["ACTOR"]       = chara

	return true
end

local function CanDevelop( params )
	if _actor:IsBusy() then return false end

	local score = 0
	local ratio

	local tax      = City_GetMonthTax( _city, g_Time:GetMonth( g_Time:GetMonth() + 1 ) )
	local salary   = _city:GetSalary()
	local cost     = _city:GetDevelopCost()
	local hasMoney = Asset_Get( _city, CityAssetID.MONEY )
	local totalHas = tax + hasMoney
	local totalUse = cost + salary
	
	ratio = totalHas * 100 / totalUse
	if ratio < 1 then
		return false
	end

	local item

	local feeScores = 
	{
		{ ratio = 110, score = -10 },
		{ ratio = 120, score = 0   },
		{ ratio = 150, score = 20  },
	}
	item = MathUtil_Approximate( ratio, feeScores, "ratio", true )
	score = score + item.score
	
	ratio = _city:GetDevelopScore( params.assetId )
	local devScores = 
	{
		{ ratio = 40,   score = 100 },
		{ ratio = 50,   score = 80 },
		{ ratio = 60,   score = 60 },
		{ ratio = 70,   score = 40 },
		{ ratio = 80,   score = 30 },
		{ ratio = 90,   score = 20 },
	}
	item = MathUtil_Approximate( ratio, devScores, "ratio", true )
	score = score + item.score

	if Random_GetInt_Sync( 1, 100 ) < score then
		return true 
	end

	--InputUtil_Pause( "dev", score, totalHas / totalUse, ratio )

	return false
end

local function CanResearch()
	if _actor:IsBusy() then return false end

	if _city:IsCapital() == false then return false end

	if Asset_Get( _city, CityAssetID.RESEARCH ) ~= nil then return false end
	
	if _proposer:IsGroupLeader() == false and not _city:IsCharaOfficer( CityJob.TECHNICIAN, _proposer ) then
		return false
	end

	local techList = {}
	local techData = Scenario_GetData( "TECH_DATA" )
	for _, tech in pairs( techData ) do
		local valid = true
		if tech.prerequisite then
			if valid == true and tech.prerequisite.tech then
				for _, id in ipairs( tech.prerequisite.tech ) do
					if _group:HasTech( id ) == false then
						valid = false
						break
					end
				end
			end
		end
		if valid == true then
			table.insert( techList, tech )
		end
	end

	if #techList == 0 then return false end

	--print( "resear", g_Time:CreateCurrentDateDesc(), _city.name, _proposer.name )

	local tech = techList[Random_GetInt_Sync( 1, #techList )]
	_registers["TARGET_TECH"] = tech

	return true
end

------------------------------

local function CanReconnoitre()
	if _actor:IsBusy() then return false end

	--whether to reconnoitre
	local list = {}
	Asset_Foreach( _city, CityAssetID.SPY_LIST, function( spy )
		if spy.grade <= CitySpyParams.REQ_GRADE then
			table.insert( list, spy )
		end
	end )
	if #list == 0 then return false end

	local index = Random_GetInt_Sync( 1, #list )
	local spy   = list[index]
	_registers["TARGET_CITY"] = spy.city

	return true
end

local function CanSabotage()
	if _actor:IsBusy() then return false end

	local list = {}
	Asset_Foreach( _city, CityAssetID.SPY_LIST, function( spy )
		if _city:IsEnemeyCity( spy.city ) == false then return end
		if spy.grade >= CitySpyParams.REQ_GRADE then
			table.insert( list, spy )
		end
	end )
	if #list == 0 then return false end

	local index = Random_GetInt_Sync( 1, #list )
	local spy   = list[index]
	_registers["TARGET_CITY"] = spy.city

	return true
end



local function DetermineDefendGoal( ... )
	local goalData = _group:GetGoal( GroupGoalType.DEFEND_CITY )
	if not goalData or not goalData then
		return false
	end

	local baseList = {}
	Asset_Foreach( _group, GroupAssetID.CITY_LIST, function ( city )
		--print( city:ToString( "STATUS" ) )
		--InputUtil_Pause( city.name, goalData.city.name )
		if goalData.city == city then
			table.insert( baseList, { city = city, type = CityStatus.ADVANCED_BASE } )
		
		elseif city:GetStatus( CityStatus.SAFETY ) then
			--where support the advanced base
			if city:IsAdjaCity( goalData.city ) then
				table.insert( baseList, { city = city, type = CityStatus.MILITARY_BASE } )
			elseif city:GetStatus( CityStatus.SAFETY ) then
				table.insert( baseList, { city = city, type = CityStatus.PRODUCTION_BASE } )
			end

		else
			table.insert( baseList, { city = city, type = nil } )
		end
	end)

	_registers["INSTRUCT_CITY_LIST"] = baseList

	return true	
end

local function DetermineEnhanceGoal( ... )
	local goalData = _group:GetGoal( GroupGoalType.ENHANCE_CITY )
	if not goalData or not goalData then
		return false
	end

	local baseList = {}
	Asset_Foreach( _group, GroupAssetID.CITY_LIST, function ( city )
		if goalData.city == city then
			table.insert( baseList, { city = city, type = CityStatus.MILITARY_BASE } )

		elseif city:GetStatus( CityStatus.SAFETY ) then
			table.insert( baseList, { city = city, type = CityStatus.PRODUCTION_BASE } )

		else
			table.insert( baseList, { city = city, type = nil } )
		end
	end)

	_registers["INSTRUCT_CITY_LIST"] = baseList

	return true
end


local function DetermineDevelopGoal( ... )
	local goalData = _group:GetGoal( GroupGoalType.DEVELOP_CITY )
	if not goalData or not goalData then
		return false
	end

	local baseList = {}
	Asset_Foreach( _group, GroupAssetID.CITY_LIST, function ( city )
		if goalData.city == city then
			table.insert( baseList, { city = city, type = CityStatus.PRODUCTION_BASE } )

		elseif city:GetStatus( CityStatus.SAFETY ) then
			table.insert( baseList, { city = city, type = CityStatus.PRODUCTION_BASE } )
		
		else
			table.insert( baseList, { city = city, type = nil } )
		end
	end)

	_registers["INSTRUCT_CITY_LIST"] = baseList

	return true
end

local function DetermineOccupyGoal( ... )
	local goalData = _group:GetGoal( GroupGoalType.OCCUPY_CITY )
	if not goalData or not goalData.city then
		return false
	end

	local baseList = {}	
	local cityList = {}

	--set advanced base
	local advanceBase = Asset_FindListItem( goalData.city, CityAssetID.ADJACENTS, function ( adjaCity )
		if Asset_Get( adjaCity, CityAssetID.GROUP ) ~= _group then
			return
		end
		if adjaCity:GetStatus( CityStatus.ADVANCED_BASE ) then
			return true
		end
		table.insert( cityList, adjaCity )
		return false
	end )
	if not advanceBase then
		advanceBase = Random_GetListItem( cityList )
		table.insert( baseList, { city = advanceBase, type = CityStatus.ADVANCED_BASE } )
	end

	--for all city, determine what kind of base they are.
	--basically, battlefront is none, safety is production, frontier is military
	cityList = {}
	Asset_Foreach( _group, GroupAssetID.CITY_LIST, function ( city )
		if city == goalData.city then
			return
		end

		if city:GetStatus( CityStatus.SAFETY ) then
			table.insert( baseList, { city = city, type = CityStatus.PRODUCTION_BASE } )
		
		elseif city:GetStatus( CityStatus.BATTLEFRONT ) then
			table.insert( baseList, { city = city, type = CityStatus.MILITARY_BASE } )
		
		elseif city:GetStatus( CityStatus.FRONTIER ) then
			table.insert( baseList, { city = city, type = nil } )
		
		else
			table.insert( baseList, { city = city, type = nil } )	
		end
	end)

	_registers["INSTRUCT_CITY_LIST"] = baseList	

	return true
end

local function CanImproveRelation()
	if 1 then return false end

	if _actor:IsBusy() then return false end

	--1. self isn't at war
	--2. target isn't at war
	if Dipl_IsAtWar( _group ) == true then return false end	

	--only group leader or diplomatic can execute the task
	if _proposer:IsGroupLeader() == false and not _city:IsCharaOfficer( CityJob.DIPLOMATIC, _proposer ) then return false end

	local list = Dipl_GetRelations( _group )
	if not list then return false end
	local groupList = {}
	for _, relation in pairs( list ) do
		local opp = relation:GetOppGroup( _group )
		if Dipl_IsAtWar( opp ) == false then
			table.insert( groupList, opp )
		end
	end
	if #groupList == 0 then return false end

	local target = Random_GetListItem( groupList )
	_registers["TARGET_GROUP"] = target

	--InputUtil_Pause( "find dip target" )

	return true
end

local function CanDeclareWar()
	if _actor:IsBusy() then return false end

	local list = Dipl_GetRelations( _group )
	if not list then return false end
	local groupList = {}
	for _, relation in pairs( list ) do
		if Dipl_CanDeclareWar( relation, _group ) == true then
			local opp = relation:GetOppGroup( _group )
			table.insert( groupList, opp )
		end
	end
	if #groupList == 0 then return false end

	local target = Random_GetListItem( groupList )
	_registers["TARGET_GROUP"] = target

	--InputUtil_Pause( "find dip target" )
end

local function CanSignPact()
	if _actor:IsBusy() then return false end

	local list = Dipl_GetRelations( _group )
	if not list then return  false end	

	local pactList = {}
	for _, relation in pairs( list ) do
		Dipl_GetPossiblePact( relation, pactList )
	end
	if #pactList == 0 then return false end

	local sign     = Random_GetListItem( pactList )
	local oppGroup = relation:GetOppGroup( _group )

	--local target = Random_GetListItem( groupList )
	_registers["TARGET_GROUP"] = oppGroup
	_registers["PACT"]         = RelationPact[sign.pact]
	_registers["TIME"]         = sign.time

	--InputUtil_Pause( "find pact", MathUtil_FindName( RelationPact, RelationPact[pact] ), oppGroup:ToString() )

	return true
end

------------------------------

local function DetermineGoal()
	local goals = {}
	local totalProb = 0

	local devScore   = _city:GetDevelopScore()
	local soldier    = _city:GetSoldier()
	local incScore
	local incSoldier

	function AddGoal( goalType, prob )
		--[[
		if goalType == GroupGoalType.DEVELOP_CITY then
			if not incScore then
				local item = MathUtil_Approximate( devTargets, scores, "dev" )
				if item.target <= 0 then
					InputUtil_Pause( "too high" )
					return
				end
				incScore = item.target
			end
			if incScore <= 0 then
				return
			end
			
		elseif goalType == GroupGoalType.ENHANCE_CITY then
			if not incSoldier then
				incSoldier = _city:GetPopu( CityPopu.RESERVES )
			end
			if incSoldier and incSoldier <= Scenario_GetData( "TROOP_PARAMS" ).MIN_TROOP_SOLDIER then
				return
			end
			
		end
		]]
		if goals[goalType] then
			goals[goalType] = goals[goalType] + prob
		else
			goals[goalType] = prob			
		end
		totalProb = totalProb + prob
	end

	local trait
	
	trait = _proposer:GetTrait( CharaTraitType.AGGRESSIVE )
	if trait then AddGoal( GroupGoalType.OCCUPY_CITY, trait ) end

	trait = _proposer:GetTrait( CharaTraitType.CONSERVATIVE )
	if trait then AddGoal( GroupGoalType.OCCUPY_CITY, trait ) end

	AddGoal( GroupGoalType.OCCUPY_CITY, 50 )

	local job = _city:GetCharaJob( _proposer )		
	if job == CityJob.COMMANDER then
		AddGoal( GroupGoalType.OCCUPY_CITY,  100 )
	
	elseif job == CityJob.STAFF then
		AddGoal( GroupGoalType.ENHANCE_CITY, 50 )
	
	elseif job == CityJob.HR then
	
	elseif job == CityJob.AFFAIRS then
		AddGoal( GroupGoalType.DEVELOP_CITY, 100 )
	
	elseif job == CityJob.DIPLOMATIC then
		AddGoal( GroupGoalType.DEFEND_CITY, 50 )
	
	elseif job == CityJob.TECHNICIAN then
		AddGoal( GroupGoalType.DEVELOP_CITY, 50 )
	
	elseif job == CityJob.EXECUTIVE then
		AddGoal( GroupGoalType.ENHANCE_CITY, 50 )
		AddGoal( GroupGoalType.DEFEND_CITY, 50 )
	end

	--choice one
	--print( "totalProb =", totalProb )

	--MathUtil_Dump( goals )

	local findGoalType
	local prob = Random_GetInt_Sync( 1, totalProb )
	for goalType, goalProb in pairs( goals ) do
		if prob < goalProb then
			findGoalType = goalType
			break
		else
			prob = prob - goalProb
		end
	end

	if not findGoalType then
		return false
	end

	local goalData = {}
	goalData.time = DAY_IN_YEAR

	if findGoalType == GroupGoalType.OCCUPY_CITY then
		local cityList = {}
		Asset_Foreach( _group, GroupAssetID.CITY_LIST, function ( city )
			if not city:GetStatus( CityStatus.BATTLEFRONT ) then
				return
			end
			Asset_Foreach( city, CityAssetID.ADJACENTS, function ( adjaCity )
				if city:IsEnemeyCity( adjaCity ) then
					table.insert( cityList, adjaCity )
				end
			end)
		end)
		if #cityList > 0 then
			goalData.city = Random_GetListItem( cityList )
		else
			findGoalType = GroupGoalType.DEFEND_CITY
		end
	end

	if findGoalType == GroupGoalType.DEFEND_CITY then
		local cityList = {}
		Asset_Foreach( _group, GroupAssetID.CITY_LIST, function ( city )
			if city:GetStatus( CityStatus.BATTLEFRONT ) == true then
				table.insert( cityList, city )
			end
		end)
		if #cityList > 0 then
			goalData.city = Random_GetListItem( cityList )
		else
			findGoalType = GroupGoalType.DEVELOP_CITY
		end
	end
	
	if findGoalType == GroupGoalType.ENHANCE_CITY then
		local cityList = {}
		local minSoldier = Scenario_GetData( "TROOP_PARAMS" ).MIN_TROOP_SOLDIER
		Asset_Foreach( _group, GroupAssetID.CITY_LIST, function ( city )
			--print( "enhance", city:GetPopu( CityPopu.RESERVES ), minSoldier )
			if city:GetStatus( CityStatus.FRONTIER ) == true or city:GetStatus( CityStatus.BATTLEFRONT ) == true then
				table.insert( cityList, city )
			end
		end )
		if #cityList > 0 then
			goalData.city    = Random_GetListItem( cityList )
			goalData.soldier = soldier + goalData.city:GetPopu( CityPopu.RESERVES )
			--InputUtil_Pause( "find enhance CITY", goalData.city.name, goalData.soldier )
		else
			findGoalType = GroupGoalType.DEVELOP_CITY
		end
	end

	local devTargets = 
	{
		{ dev = 100, target = 10 },
		{ dev = 150, target = 8 },
		{ dev = 200, target = 5 },
		{ dev = 240, target = 3 },
		{ dev = 270, target = 0 },
		{ dev = 300, target = 0 },
	}
	if findGoalType == GroupGoalType.DEVELOP_CITY then
		local cityList = {}
		Asset_Foreach( _group, GroupAssetID.CITY_LIST, function ( city )
			local developScore = city:GetDevelopScore()
			local item = MathUtil_Approximate( developScore, devTargets, "dev", true )
			if item.target > 0 then
				table.insert( cityList, { city = city, target = item.target } )
			end
		end )
		if #cityList > 0 then
			local item = Random_GetListItem( cityList )
			goalData.city     = item.city
			goalData.devScore = devScore + item.target
		else
			findGoalType = nil
		end
	end

	if not findGoalType then
		--InputUtil_Pause( "none goal" )
		return
	end

	goalData.time = DAY_IN_YEAR
	--InputUtil_Pause( "goal", MathUtil_FindName( GroupGoalType, findGoalType ), goalData )
	
	_registers["GOALTYPE"] = findGoalType
	_registers["GOALDATA"] = goalData

	return true
end

------------------------------
-- AI

local EstablishCorpsProposal = 
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanEstablishCorps },
		{ type = "ACTION", action = SubmitProposal, params = { type = "ESTABLISH_CORPS" } },
	},
}

local ReinforceProposal = 
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanReinforceCorps },
		{ type = "ACTION", action = SubmitProposal, params = { type = "REINFORCE_CORPS" } },
	},
}

local EnrollProposal = 
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanEnrollCorps },
		{ type = "ACTION", action = SubmitProposal, params = { type = "ENROLL_CORPS" } },
	},
}

local TrainProposal = 
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanTrainCorps },
		{ type = "ACTION", action = SubmitProposal, params = { type = "TRAIN_CORPS" } },
	},
}

local EnhanceMilitaryBaseProposal =
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanEnhanceAdavanceBase },
		{ type = "ACTION", action = SubmitProposal, params = { type = "DISPATCH_CORPS" } },
	},
}

local DispatchCorpsProposal =
{
	type = "SEQUENCE", children = 
	{
		{ type = "SELECTOR", children = 
			{
				{ type = "SEQUENCE", children = 
					{
						{ type = "FILTER", condition = HasCityStatus, params = { status = "MILITARY_BASE" } },
						{ type = "FILTER", condition = HasGroupGoal, params = { goal = "DEFEND_CITY", excludeCity = true } },						
						{ type = "FILTER", condition = CanReinforceAdvancedBase },
						{ type = "ACTION", action = SubmitProposal, params = { type = "DISPATCH_CORPS" } },
					}
				},
				{ type = "SEQUENCE", children = 
					{
						{ type = "FILTER", condition = CanCorpsBack2Capital },
						{ type = "ACTION", action = SubmitProposal, params = { type = "DISPATCH_CORPS" } },
					}
				},
				{ type = "SEQUENCE", children = 
					{
						{ type = "FILTER", condition = CanDispatchCorps },
						{ type = "ACTION", action = SubmitProposal, params = { type = "DISPATCH_CORPS" } },
					}
				},
			},
		}
	},
}

local ConscriptProposal =
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanConscript },
		{ type = "ACTION", action = SubmitProposal, params = { type = "CONSCRIPT" } },
	},
}

local RecruitProposal = 
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanRecruit },
		{ type = "ACTION", action = SubmitProposal, params = { type = "RECRUIT" } },
	},
}

local HireGuardProposal = 
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanHireGuard },
		{ type = "ACTION", action = SubmitProposal, params = { type = "HIRE_GUARD" } },
	},
}

local _BuildProposal = 
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanBuildCity },
		{ type = "ACTION", action = SubmitProposal, params = { type = "BUILD_CITY" } },
	},
}

local _BuildDefensiveProposal = 
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanBuildCity },
		{ type = "ACTION", action = SubmitProposal, params = { type = "BUILD_CITY" } },
	},	
}

local _TransportProposal = 
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = HasCityStatus, params = { status = "PRODUCTION_BASE" } },
		{ type = "FILTER", condition = CanTransport },
		{ type = "ACTION", action = SubmitProposal, params = { type = "TRANSPORT" } },
	},
}

local _TaxProposal =
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanLevyTax },
		{ type = "ACTION", action = SubmitProposal, params = { type = "LEVY_TAX" } },
	},
}

local _DevelopProposal = 
{
	type = "SELECTOR", children =
	{
		{ type = "SEQUENCE", children = 
			{
				{ type = "FILTER", condition = CanDevelop, params = { assetId = CityAssetID.AGRICULTURE } },
				{ type = "ACTION", action = SubmitProposal, params = { type = "DEV_AGRICULTURE" } },
			},
		},
		{ type = "SEQUENCE", children = 
			{
				{ type = "FILTER", condition = CanDevelop, params = { assetId = CityAssetID.COMMERCE } },
				{ type = "ACTION", action = SubmitProposal, params = { type = "DEV_COMMERCE" } },
			},
		},
		{ type = "SEQUENCE", children = 
			{
				{ type = "FILTER", condition = CanDevelop, params = { assetId = CityAssetID.PRODUCTION } },
				{ type = "ACTION", action = SubmitProposal, params = { type = "DEV_PRODUCTION" } },
			},
		},
	}
}

-------------------------------------------------------

local _SubmitHRProposal =
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanSubmitPlan, params = { topic = "HR" } },
		{ type = "RANDOM_SELECTOR", children = 
			{
				{ type = "SEQUENCE", children = 
					{
						{ type = "FILTER", condition = CanMoveCapital },
						{ type = "ACTION", action = SubmitProposal, params = { type = "MOVE_CAPITAL" } },
					},
				},
				{ type = "SEQUENCE", children = 
					{
						{ type = "FILTER", condition = CanCharaBack2Capital },
						{ type = "ACTION", action = SubmitProposal, params = { type = "DISPATCH_CHARA" } },
					},
				},
				{ type = "SEQUENCE", children = 
					{
						{ type = "FILTER", condition = CanCallChara },
						{ type = "ACTION", action = SubmitProposal, params = { type = "CALL_CHARA" } },
					},
				},	
				{ type = "SEQUENCE", children = 
					{
						{ type = "FILTER", condition = CanDispatchChara },
						{ type = "ACTION", action = SubmitProposal, params = { type = "DISPATCH_CHARA" } },
					},
				},
				{ type = "SEQUENCE", children = 
					{
						{ type = "FILTER", condition = CanHireChara },
						{ type = "ACTION", action = SubmitProposal, params = { type = "HIRE_CHARA" } },
					},
				},
				--[[
				{ type = "SEQUENCE", children = 
					{
						{ type = "FILTER", condition = CanPromoteChara },
						{ type = "ACTION", action = SubmitProposal, params = { type = "PROMOTE_CHARA" } },
					},
				},
				]]
					--ENCOURGAE CHARA
					--SUPERVISE CHARA
			}
		},
	},
}

local _SubmitStaffProposal =
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanSubmitPlan, params = { topic = "STAFF" } },	
		{ type = "RANDOM_SELECTOR", children = 
			{
				--COLLECT INTELS
				--EXECUTE OP
				{ type = "SEQUENCE", children = 
					{		
						{ type = "FILTER", condition = CanReconnoitre },
						{ type = "ACTION", action = SubmitProposal, params = { type = "RECONNOITRE" } },
					},
				},
				{ type = "SEQUENCE", children = 
					{
						{ type = "FILTER", condition = CanSabotage },
						{ type = "ACTION", action = SubmitProposal, params = { type = "SABOTAGE" } },
					},
				},
			}
		},
	}
}

local _SubmitAffairsProposal =
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanSubmitPlan, params = { topic = "AFFAIRS" } },

		{ type = "SELECTOR", children = 
			{
				{ type = "SEQUENCE", children =
					{
						{ type = "FILTER", condition = HasCityStatus, params = { status = "PRODUCTION_BASE" } },
						_DevelopProposal,
					},
				},
				{ type = "SEQUENCE", children = 
					{
						{ type = "FILTER", condition = HasCityStatus, params = { status = "PRODUCTION_BASE" } },
						{ type = "FILTER", condition = HasGroupGoal, params = { goal = "DEFEND_CITY" , excludeCity = true } },
						_TransportProposal,
					}
				},
				{ type = "RANDOM_SELECTOR", children =
					{
						_TransportProposal,
						_DevelopProposal,
						_BuildProposal,
						_TransportProposal,
						_TaxProposal,
					}
				},	
			},
		},
	}
}

local _SubmitCommanderProposal =
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanSubmitPlan, params = { topic = "COMMANDER" } },		
		{ type = "SELECTOR", children = 
			{
				--self security
				EstablishCorpsProposal,
				ReinforceProposal,				
				EnrollProposal,
				ConscriptProposal,
				RecruitProposal,
				HireGuardProposal,				
				TrainProposal,
				DispatchCorpsProposal,				
			},
		},
		--[[
		{ type = "RANDOM_SELECTOR", children = 
			{
			}
		},
		]]
	}
}

local _SubmitDiplomaticProposal =
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = IsCityCapital },
		{ type = "FILTER", condition = CanSubmitPlan, params = { topic = "DIPLOMATIC" } },
		{ type = "RANDOM_SELECTOR", children =
			{
				{ type = "SEQUENCE", children = 
					{
						{ type = "FILTER", condition = CanImproveRelation },
						{ type = "ACTION", action = SubmitProposal, params = { type = "IMPROVE_RELATION" } },
					},
				},
				{ type = "SEQUENCE", children = 
					{
						{ type = "FILTER", condition = CanDeclareWar },
						{ type = "ACTION", action = SubmitProposal, params = { type = "DECLARE_WAR" } },
					},
				},
				{ type = "SEQUENCE", children = 
					{
						{ type = "FILTER", condition = CanSignPact },
						{ type = "ACTION", action = SubmitProposal, params = { type = "SIGN_PACT" } },
					},
				},
			}
		},
	}
}

local _SubmitTechnicianProposal =
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanSubmitPlan, params = { topic = "TECHNICIAN" } },
		{ type = "RANDOM_SELECTOR", children = 
			{
				{ type = "SEQUENCE", children = 
					{
						{ type = "FILTER", condition = CanResearch },
						{ type = "ACTION", action = SubmitProposal, params = { type = "RESEARCH" } },
					},
				},
			}
		},
	},
}

local _SubmitStrategyProposal =
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanSubmitPlan, params = { topic = "STRATEGY" } },
		{ type = "RANDOM_SELECTOR", children = 
			{
				{ type = "SEQUENCE", children = 
					{
						{ type = "FILTER", condition = CanHarassCity },
						{ type = "ACTION", action = SubmitProposal, params = { type = "HARASS_CITY" } },
					},
				},
				{ type = "SEQUENCE", children = 
					{		
						{ type = "FILTER", condition = CanAttackCity },
						{ type = "ACTION", action = SubmitProposal, params = { type = "ATTACK_CITY" } },
					},
				},
				{ type = "SEQUENCE", children = 
					{		
						{ type = "FILTER", condition = CanExpedition },
						{ type = "ACTION", action = SubmitProposal, params = { type = "ATTACK_CITY" } },
					},
				},
			},
		},
	}
}

local _QualificationChecker = 
{
	type = "SEQUENCE", children = 
	{
		--{ type = "FILTER", condition = IsProposalCD },
		{ type = "NEGATE", children = 
			{
				{ type = "FILTER", condition = IsResponsible },
			}
		},
		{ type = "FAILURE" },
	},
}

local _UnderAttackProposal =
{
	type = "SELECTOR", children = 
	{
		-----------------------------
		--under attack
		{ type = "SEQUENCE", children = 
			{
				{ type = "FILTER", condition = IsTopic, params = { topic = "UNDER_HARASS" } },
				{ type = "FILTER", condition = CanIntercept },
				{ type = "ACTION", action = SubmitProposal, params = { type = "INTERCEPT" } },
			},
		},

		{ type = "SEQUENCE", children = 
			{
				{ type = "FILTER", condition = IsTopic, params = { topic = "UNDER_ATTACK" } },				
				{ type = "FILTER", condition = CanIntercept },
				{ type = "ACTION", action = SubmitProposal, params = { type = "INTERCEPT" } },
			},
		},
	}
}

local _GoalProposal = 
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = IsCityCapital },
		{ type = "FILTER", condition = IsTopic, params = { topic = "DETERMINE_GOAL" } },				
		{ type = "FILTER", condition = DetermineGoal },	
		{ type = "ACTION", action = SubmitProposal, params = { type = "SET_GOAL" } },
	},
}

local _PriorityProposals = 
{
	type = "SELECTOR", children = 
	{
		-----------------------------
		-- goal priority

		--startegy priority
		--build defensive in DEFEND_CITY goal	
		--receive resources
		{ type = "SELECTOR", children =
			{
				{ type = "SEQUENCE", children = 
					{
						{ type = "FILTER", condition = HasCityStatus, params = { status = "ADVANCED_BASE" } },
						{ type = "FILTER", condition = HasGroupGoal, params = { goal = "DEFEND_CITY" } },
						_BuildDefensiveProposal,
					}
				},
				{ type = "SEQUENCE", children = 
					{
						{ type = "FILTER", condition = HasCityStatus, params = { status = "ADVANCED_BASE" } },
						{ type = "FILTER", condition = HasGroupGoal, params = { goal = "OCCUPY_CITY", excludeCity = true } },
						_SubmitStrategyProposal,
					}
				},
			}
		},

		--affairs priority
		--transport resource to advanced_base
		{ type = "SEQUENCE", children = 
			{
				{ type = "FILTER", condition = HasCityStatus, params = { status = "MILITARY_BASE" } },
				_SubmitCommanderProposal,
			},
		},

		--commander priority
		--dispatch corps to adanvaced_base
		{ type = "SEQUENCE", children = 
			{
				{ type = "FILTER", condition = HasCityStatus, params = { status = "PRODUCTION_BASE" } },
				_SubmitAffairsProposal,
			}
		},

		-----------------------------
		-- status priority
		{ type = "SEQUENCE", children = 
			{
				{ type = "FILTER", condition = HasCityStatus, params = { status = "DEFENSIVE_DANGER" } },
				_SubmitCommanderProposal,
			},
		},

		{ type = "SEQUENCE", children = 
			{
				{ type = "FILTER", condition = HasCityStatus, params = { status = "DEVELOPMENT_DANGER" } },
				_SubmitAffairsProposal,
			}
		},
	}
	-----------------------------
}

local _InstructProposal =
{
	type = "SELECTOR", children = 			
	{
		{ type = "SEQUENCE", children = 
			{
				{ type = "FILTER", condition = DetermineOccupyGoal },
				{ type = "ACTION", action = SubmitProposal, params = { type = "INSTRUCT_CITY" } }
			}
		},
		{ type = "SEQUENCE", children = 
			{
				{ type = "FILTER", condition = DetermineDefendGoal },
				{ type = "ACTION", action = SubmitProposal, params = { type = "INSTRUCT_CITY" } }
			}
		},
		{ type = "SEQUENCE", children = 
			{
				{ type = "FILTER", condition = DetermineEnhanceGoal },
				{ type = "ACTION", action = SubmitProposal, params = { type = "INSTRUCT_CITY" } }
			}
		},
		{ type = "SEQUENCE", children = 
			{
				{ type = "FILTER", condition = DetermineDevelopGoal },
				{ type = "ACTION", action = SubmitProposal, params = { type = "INSTRUCT_CITY" } }
			}
		},
	},
}

local _CapitalProposal =
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = IsTopic, params = { topic = "CAPITAL" } },
		{ type = "FILTER", condition = CheckDate, params = { day="1" } },
		_InstructProposal,
	}
}

--Main entrance to submit proposal
local _MeetingProposal = 
{
	type = "SELECTOR", desc = "entrance", children = 
	{
		_QualificationChecker,

		_UnderAttackProposal,

		_GoalProposal,

		_CapitalProposal,

		--_PriorityProposals,

		--test slot

		--default
		--[[]]
		_SubmitTechnicianProposal,
		_SubmitDiplomaticProposal,
		_SubmitHRProposal,
		_SubmitAffairsProposal,
		_SubmitStaffProposal,
		_SubmitCommanderProposal,
		_SubmitStrategyProposal,
		--]]
	},
}

----------------------------------------

local _behavior = Behavior()

--submit proposal in meeting
_meetingProposal = BehaviorNode( true )
_meetingProposal:BuildTree( _MeetingProposal )

local function Init( params )
	_registers = {}

	_proposer = params.chara
	_actor    = _proposer
	_city  = Asset_Get( _proposer, CharaAssetID.HOME )
	_group = Asset_Get( _proposer, CharaAssetID.GROUP )

	_meeting = params.meeting	
	if _meeting then				
		_topic = Asset_Get( _meeting, MeetingAssetID.TOPIC )
	else
		_topic = nil
	end
	if typeof( _proposer ) == "number" then
		print( "propoer is number" )
		return false
	end
	if not _city or typeof( _city ) == "number" then
		error( "invalid city data", _proposer.name, _city )
		return false
	end
	if not _group or typeof( _group ) == "number" then
		error( "invalid group data," .. _proposer.name )
		return false
	end
	return true
end

function CharaAI_SubmitMeetingProposal( chara, meeting )
	if not chara then
		InputUtil_Pause( "invalid chara" )
		return
	end
	if Init( { chara = chara, meeting = meeting } ) then
		Stat_Add( "CharaAI@Run_Times", nil, StatType.TIMES )
		--DBG_Watch( "Debug_Meeting", chara.name .. " try proposal, topic=" .. MathUtil_FindName( MeetingTopic, _topic ) )
		return _behavior:Run( _meetingProposal )
	end
	Log_Write( "meeting", "    chara=" .. chara.name .. " cann't submit proposal" )
	return false
end