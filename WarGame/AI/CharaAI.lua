----------------------------------------
-- Enviroment & Variables

local _proposer = nil
local _city  = nil
local _group = nil

local _meeting = nil
local _topic   = nil

local _registers = {}

local function pause()
	--print( "topic=", MathUtil_FindName( MeetingTopic, _topic ) )
	InputUtil_Pause( "debug chara ai" )
	return true
end

local bp = { type = "FILTER", condition = pause }

local stop = { type = "FILTER", condition = function ( ... )
	return false
end }

local function dbg( content )
	InputUtil_Pause( content )
end

----------------------------------------

local function SubmitProposal( params )
	--check actor
	local actor = _registers["ACTOR"]
	if not actor then
		actor = _proposer
	end

	local proposal = Entity_New( EntityType.PROPOSAL )
	Asset_Set( proposal, ProposalAssetID.TYPE,        ProposalType[params.type] )
	Asset_Set( proposal, ProposalAssetID.PROPOSER,    _proposer )	
	Asset_Set( proposal, ProposalAssetID.LOCATION,    _city )
	Asset_Set( proposal, ProposalAssetID.DESTINATION, _city )
	Asset_Set( proposal, ProposalAssetID.TIME,        g_Time:GetDateValue() )
	Asset_Set( proposal, ProposalAssetID.ACTOR,       actor )
	
	if params.type == "ATTACK_CITY" then		
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "corps_list", _registers["ATTACK_CORPS"] )
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
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "corps", _registers["CORPS"] )

	elseif params.type == "ESTABLISH_CORPS" then
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "leader", _registers["CORPS_LEADER"] )
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "plan", CityPlan.COMMANDER )
	
	elseif params.type == "REINFORCE_CORPS"
		or params.type == "DISMISS_CORPS"
		or params.type == "TRAIN_CORPS"
		or params.type == "UPGRADE_CORPS"
		or params.type == "ENROLL_CORPS" then
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "corps", _registers["CORPS"] )
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "plan", CityPlan.COMMANDER )

	elseif params.type == "PROMOTE_CHARA" then
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "job", _registers["JOB"] )
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "plan", CityPlan.HR )
	elseif params.type == "HIRE_CHARA" then
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "plan", CityPlan.HR )
	elseif params.type == "DISPATCH_CHARA" then
		Asset_Set( proposal, ProposalAssetID.DESTINATION, _registers["TARGET_CITY"] )
	elseif params.type == "CALL_CHARA" then		
		Asset_Set( proposal, ProposalAssetID.LOCATION, _registers["TARGET_CITY"] )
	
	elseif params.type == "DEV_AGRICULTURE" or params.type == "DEV_COMMERCE" or params.type == "DEV_PRODUCTION" 
		or params.type == "BUILD_CITY" or params.type == "LEVY_TAX" then
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "plan", CityPlan.AFFAIRS )

	elseif params.type == "RECONNOITRE" 
		or params.type == "SABOTAGE"
		then
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "plan", CityPlan.STAFF )

	elseif params.type == "RESEARCH" then
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "tech", _registers["TARGET_TECH"] )
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "plan", CityPlan.TECHNICIAN )

	elseif params.type == "IMPROVE_RELATION"
		or params.type == "DECLARE_WAR"
		then
		local oppGroup = _registers["TARGET_GROUP"]
		local capital  = Asset_Get( oppGroup, GroupAssetID.CAPITAL )
		Asset_Set( proposal, ProposalAssetID.DESTINATION, capital )
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "group", oppGroup )
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "plan", CityPlan.DIPLOMATIC )

	elseif params.type == "SIGN_PACT" then
		local oppGroup = _registers["TARGET_GROUP"]
		local capital  = Asset_Get( oppGroup, GroupAssetID.CAPITAL )
		Asset_Set( proposal, ProposalAssetID.DESTINATION, capital )
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "pact", _registers["PACT"] )		
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "time", _registers["TIME"] )
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "group", oppGroup )
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "plan", CityPlan.DIPLOMATIC )

	elseif params.type == "" then
	end

	--InputUtil_Pause( "Submit proposal=" .. proposal:ToString() )
	Stat_Add( "Proposal@Submit_Times", 1, StatType.TIMES )

	Asset_SetListItem( _proposer, CharaAssetID.STATUSES, CharaStatus.PROPOSAL_CD, Random_GetInt_Sync( 30, 50 ) )
end

----------------------------------------

--probability unit is 1 per 10000
local function TestProbability( params )
	local ratio = params.prob or 5000
	return Random_GetInt_Sync( 1, 10000 ) < ratio
end

local function IsCityInstruction( params )
	local citydata = Asset_Get( _city, CityAssetID.INSTRUCTION )
	return citydata == CityInstruction[params.instruction]
end

local function IsTopic( params )
	if not _topic or _topic == MeetingTopic.NONE then
		InputUtil_Pause( "topic pass", _topic )
		return false
	end
	return MeetingTopic[params.topic] == _topic
end

local function IsProposalCD()
	local proposalcd = Asset_GetListItem( _proposer, CharaAssetID.STATUSES, CharaStatus.PROPOSAL_CD )
	return proposalcd and proposalcd > 0 or false
end

local function HasCityStatus( params )
	local ret = Asset_GetListItem( _city, CityAssetID.STATUSES, CityStatus[params.status] )
	return ret == true
end

local function HasGroupGoal( params )
	if not _group then return false end
	if _group:HasGoal( GroupGoalType[params.goal] ) == false then return false end
	return true
end

local function CanSubmitPlan( params )
	if IsTopic( params ) == false then
		return false
	end

	--exclusive task	
	local topic = MeetingTopic[params.topic]
	local plan
	if topic == MeetingTopic.TECHNICIAN then
		plan = CityPlan.TECHNICIAN
	elseif topic == MeetingTopic.DIPLOMATIC then
		plan = CityPlan.DIPLOMATIC
	elseif topic == MeetingTopic.HR then
		plan = CityPlan.HR
	elseif topic == MeetingTopic.AFFAIRS then
		plan = CityPlan.AFFAIRS
	elseif topic == MeetingTopic.COMMANDER then
		plan = CityPlan.COMMANDER
	elseif topic == MeetingTopic.STAFF then		
		plan = CityPlan.STAFF
	elseif topic == MeetingTopic.STRATEGY then
	end
	if plan then
		local task = Asset_GetListItem( _city, CityAssetID.PLANS, plan ) 
		if task then
			--print( MathUtil_FindName( CityPlan, plan ), "exist", task:ToString() )
			return false
		end
	end

	--check proposer status who shouldn't be busy
	if topic ~= MeetingTopic.AFFAIRS then
		if _proposer:IsBusy() then
			--print( _proposer.name .. " is busy" )
			return false
		end
	end

	--if true then return true end
	if _city:IsCharaOfficer( CityJob.CHIEF_EXECUTIVE, _proposer ) == true or _city:IsCharaOfficer( params.position, _proposer ) then
		return true
	end
	return true
end

----------------------------------------

local function CanEstablishCorps()
	--print( "limit=" .. Corps_GetLimityByCity( _city ), "corps=" .. Asset_GetListSize( _city, CityAssetID.CORPS_LIST ) )

	--check corps limitation
	if Corps_GetLimityByCity( _city ) <= Asset_GetListSize( _city, CityAssetID.CORPS_LIST ) then
		--print( "corps limit, cann't est corps" )
		return false
	end

	--need a leader
	--to do	
	local charaList = _city:FindFreeCharas()
	if #charaList == 0 then return end

	--check minimum soldier available
	local reserves = Asset_GetListItem( _city, CityAssetID.POPU_STRUCTURE, CityPopu.RESERVES )
	if reserves < Scenario_GetData( "TROOP_PARAMS" ).MIN_TROOP_SOLDIER then
		return false
	end
	if Corps_CanEstablishCorps( _city, reserves ) == false then
		print( "cann't est corps" )
		return false
	end

	local leader = Random_GetListItem( charaList )
	_registers["CORPS_LEADER"] = leader

	Stat_Add( "Corps@Leader", leader:ToString(), StatType.LIST )
	--InputUtil_Pause( "est corps", leader:ToString() )

	return true
end

local function CanReinforceCorps()
	--[[
	local soldier = Asset_GetListItem( _city, CityAssetID.POPU_STRUCTURE, CityPopu.RESERVES )	
	if soldier < Scenario_GetData( "TROOP_PARAMS" ).MIN_TROOP_SOLDIER then
		--print( "not enough soldier" )
		return false
	end
	]]

	local corpsList = {}
	Asset_FindListItem( _city, CityAssetID.CORPS_LIST, function ( corps )
		if corps:IsAtHome() == false then return false end
		if corps:IsBusy() == true then return false end
		local num, max = corps:GetSoldier()
		--InputUtil_Pause( num, max )
		--print( corps:ToString(), num, max )
		if num < max then table.insert( corpsList, corps ) end
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

	--[[
	local soldier = Asset_GetListItem( _city, CityAssetID.POPU_STRUCTURE, CityPopu.RESERVES )
	soldier = math.min( soldier, Asset_GetListItem( _city, CityAssetID.POPU_STRUCTURE, CityPopu.RESERVES ) )
	]]
	local reserves = Asset_GetListItem( _city, CityAssetID.POPU_STRUCTURE, CityPopu.RESERVES )
	if reserves < Scenario_GetData( "TROOP_PARAMS" ).MIN_TROOP_SOLDIER then
		return false
	end
	if Corps_CanEstablishCorps( _city, reserves ) == false then
		print( "cann't est corps" )
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
		if corps:GetTraining() < 50 then
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

local function CanHarassCity()
	--check free corps
	local list, soldier, power = _city:GetFreeCorps()
	if #list == 0 then
		return false
	end

	--check & find target
	local cities = _city:FindHarassCityTargets( function ( city )
		local citySoldier = Intel_GetSoldier( city, _city )
		--ignore when enemy is two times than self
		if citySoldier > soldier + soldier then
			return false
		end
		if Random_GetInt_Sync( 1, citySoldier ) < soldier then
			return false
		end
		return true
	end )
	local number = #cities
	if number == 0 then return false end

	local corps = list[Random_GetInt_Sync( 1, #list )]
	local destcity = cities[Random_GetInt_Sync( 1, number )]

	--check food
	if Supply_CorpsHasEnoughFood( _city, destcity, corps ) == false then return false end

	_registers["ACTOR"] = corps
	_registers["TARGET_CITY"] = destcity

	return true
end

local function CanAttackCity()
	--check free corps
	local list, soldier, power = _city:GetFreeCorps()
	if #list == 0 then
		--local numofcorps = Asset_GetListSize( _city, CityAssetID.CORPS_LIST )
		--print( _city.name, "has corps=" .. numofcorps )
		return false
	end

	local cities = _city:FindAttackCityTargets( function ( city )
		local citySoldier = Intel_GetSoldier( city, _city )
		if soldier < citySoldier then
			return false
		end
		if Random_GetInt_Sync( 1, soldier ) < citySoldier then
			--print( "rand soldier", soldier, citySoldier, city:GetSoldier() )
			return false
		end
		return true
	end )	
	local number = #cities
	if number == 0 then return false end
	local corps = list[Random_GetInt_Sync( 1, #list )]
	local destcity = cities[Random_GetInt_Sync( 1, number )]

	--check food
	if Supply_CorpsHasEnoughFood( _city, destcity, corps ) == false then return false end

	_registers["ACTOR"] = corps
	_registers["TARGET_CITY"] = destcity
	_registers["ATTACK_CORPS"] = list

	return true
end

local function CanIntercept()
	local list = _city:GetFreeCorps()
	if #list == 0 then return false end

	local target = Asset_Get( _meeting, MeetingAssetID.TARGET )
	local destcity = Asset_Get( target, CorpsAssetID.LOCATION )
	local corps = list[Random_GetInt_Sync( 1, #list )]

	--check food
	if Supply_CorpsHasEnoughFood( _city, destcity, corps ) == false then return false end

	_registers["ACTOR"]  = corps
	_registers["TARGET_CORPS"] = target
	_registers["TARGET_CITY"]  = destcity	

	return true
end

--1. in danger
--2. not enough reserves
--3. corps understaffed
local function NeedMoreReserves( score )
	local reserves   = Asset_GetListItem( _city, CityAssetID.POPU_STRUCTURE, CityPopu.RESERVES )
	local limit      = _city:GetLimitPopu( CityPopu.RESERVES )	
	local ratio      = reserves * 100 / limit
	if Random_GetInt_Sync( 1, 100 ) > ratio then
		return false
	end
	--print( "need" .. reserves .. "/" .. limit .. "=" .. ratio .. "%" )

	if not score then score = 0 end

	if Asset_GetListItem( _city, CityAssetID.STATUSES, CityStatus.MILITARY_DANGER ) then
		score = score + 50
	end
	if Asset_GetListItem( _city, CityAssetID.STATUSES, CityStatus.MILITARY_WEAK ) then
		score = score + 35
	end

	local soldier, maxSoldier = _city:GetSoldier()
	local needSoldier = maxSoldier - soldier
	local reserves = Asset_GetListItem( _city, CityAssetID.POPU_STRUCTURE, CityPopu.RESERVES )
	if reserves < needSoldier * 0.5 then
		score = score + 35
	elseif reserves < needSoldier then
		score = score + 25
	end

	--if score > 0 then InputUtil_Pause( score ) end
	score = 100

	return Random_GetInt_Sync( 1, 100 ) < score
end

--force conscript, 
local function CanConscript()
	local score = 0
	local security = Asset_Get( _city, CityAssetID.SECURITY )
	if security < 30 then
		return false
	elseif security < 40 then
		score = score - 20
	elseif security < 60 then
		score = score - 10
	elseif security > 80 then
		score = score + 20
	end
	if NeedMoreReserves( score ) == false then
		return false
	end
	return true
end

--use money to recruit
local function CanRecruit()
	--enough reserves	
	local needMoney = 1000
	if Asset_Get( _city, CityAssetID.MONEY ) < needMoney then
		return false
	end
	if NeedMoreReserves() == false then
		return false
	end
end

local function NeedCorps( city, score )
	if not score then score = 0 end
	if Asset_GetListItem( city, CityAssetID.STATUSES, CityStatus.MILITARY_WEAK ) == true then
		score = score + 20
	end
	if Asset_GetListItem( city, CityAssetID.STATUSES, CityStatus.MILITARY_DANGER ) == true then
		score = score + 35
	end
	if Asset_GetListItem( city, CityAssetID.STATUSES, CityStatus.BATTLEFRONT ) == true then
		score = score + 50
	end
	--Debug_Log( "dis corps", city.name, score )
	return Random_GetInt_Sync( 1, 100 ) < score
end

local function CanDispatchCorps()
	if _city:IsCapital() == false then
		return false
	end

	local corpsList = _city:GetFreeCorps()
	if #corpsList == 0 then return false end

	local score = 0
	if Asset_GetListItem( _city, CityAssetID.STATUSES, CityStatus.SAFETY ) == true then
		score = score + 50
	end
	if Asset_GetListItem( _city, CityAssetID.STATUSES, CityStatus.BATTLEFRONT ) == true then
		score = score - 50
	end	
	if Asset_GetListItem( _city, CityAssetID.STATUSES, CityStatus.MILITARY_WEAK ) == true then
		score = score - 10
	end
	if Asset_GetListItem( _city, CityAssetID.STATUSES, CityStatus.MILITARY_DANGER ) == true then
		score = score - 20
	end

	local cityList = {}
	Asset_ForeachList( _group, GroupAssetID.CITY_LIST, function ( city )
		if city:IsCapital() == true then return end
		if Corps_GetLimityByCity( city ) <= Asset_GetListSize( city, CityAssetID.CORPS_LIST ) then return end
		if NeedCorps( city, score ) == false then return end		
		table.insert( cityList, city )
	end)
	if #cityList == 0 then return false end

	_registers["ACTOR"] = Random_GetListItem( corpsList )
	_registers["CORPS"] = _registers["ACTOR"]
	_registers["TARGET_CITY"] = Random_GetListItem( cityList )

	return true
end

----------------------------------------

local function CanBuildCity()
	local area = _city:GetMaxBulidArea()
	local numOfConstrs = Asset_GetListSize( _city, CityAssetID.CONSTR_LIST )
	if numOfConstrs >= area then
		return false
	end

	return false
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
	if NeedMoreReserves() == false then
		return false
	end
	return true
end

local function CanHireChara()
	local limit
	if _city then
		limit = Chara_GetLimitByCity( _city )		
		if limit > 0 and limit <= Asset_GetListSize( _city, CityAssetID.CHARA_LIST ) then
			return false
		end
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
	if _city:IsCapital() == false then return false end

	local charaList = _city:FindNonOfficerFreeCharas()
	if #charaList == 0 then return false end

	local cityList = _group:GetVacancyCityList()
	if #cityList == 0 then return false end	

	--simply random
	local city  = Random_GetListItem( cityList )	
	local chara = Random_GetListItem( charaList )

	_registers["TARGET_CITY"] = city
	_registers["ACTOR"]         = chara

	--print( _city:ToString( "OFFICER") )

	return true
end

local function CanCallChara()
	if _city:IsCapital() == false then return false end

	if Chara_GetSurplusNumOfChara( _city ) > 1 then return false end

	local limit = Chara_GetLimitByCity( _city )
	if Asset_GetListSize( _city, CityAssetID.CHARA_LIST ) >= limit then return false end

	local charaList = {}	
	Asset_ForeachList( _group, GroupAssetID.CITY_LIST, function ( city )
		if city:IsCapital() then return end
		--print( city.name, Asset_GetListSize( city, CityAssetID.CHARA_LIST ), Asset_GetListSize( city, CityAssetID.OFFICER_LIST ), Chara_GetReqNumOfOfficer( city ) )
		if Asset_GetListSize( city, CityAssetID.OFFICER_LIST ) >= Chara_GetReqNumOfOfficer( city ) then
			charaList = city:FindNonOfficerFreeCharas( charaList )
		end
	end)

	if #charaList == 0 then return false end

	local chara = Random_GetListItem( charaList )
	local city = Asset_Get( chara, CharaAssetID.HOME )

	_registers["TARGET_CITY"] = city
	_registers["ACTOR"]          = chara

	return true
end


local function CanDevelop( params )
	local id = params.id
	local cur = Asset_Get( _city, id )
	local need = City_NeedPopu( _city, City_GetPopuTypeByDevIndex( id ) )
	--InputUtil_Pause( "Check " .. MathUtil_FindName( CityAssetID, id ), cur, need )	
	return cur < need
end

------------------------------
-- AI

local _HRPlans = 
{
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

local DispatchCorpsProposal =
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanDispatchCorps },
		{ type = "ACTION", action = SubmitProposal, params = { type = "DISPATCH_CORPS" } },
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

local _AggressivePlans = 
{
	type = "SEQUENCE", children =
	{
		{ type = "FILTER", condition = TestProbability, params = { prob = 5000 } },
		{ type = "FILTER", condition = HasGroupGoal, params = { goal = "DOMINATION_TERRIORITY" } },		
		{ type = "SELECTOR", children = 
			{
				RecruitProposal,
				ConscriptProposal,		
				ReinforceProposal,
				EstablishCorpsProposal,
				EnrollProposal,		
				DispatchCorpsProposal,
				TrainProposal,
			},
		},
	}	
}

local _CommanderPlans = 
{
	type = "RANDOM_SELECTOR", children = 
	{ 
		EstablishCorpsProposal,
		ReinforceProposal,
		EnrollProposal,
		TrainProposal,
		DispatchCorpsProposal,
		ConscriptProposal,
		RecruitProposal,
	},
}

local _StrategyPlans = 
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
}

local _AffairsPlans =
{
	{ type = "SEQUENCE", children = 
		{
			{ type = "FILTER", condition = CanDevelop, params = { id = CityAssetID.AGRICULTURE } },
			{ type = "ACTION", action = SubmitProposal, params = { type = "DEV_AGRICULTURE" } },
		},
	},
	{ type = "SEQUENCE", children = 
		{
			{ type = "FILTER", condition = CanDevelop, params = { id = CityAssetID.COMMERCE } },
			{ type = "ACTION", action = SubmitProposal, params = { type = "DEV_COMMERCE" } },
		},
	},
	{ type = "SEQUENCE", children = 
		{
			{ type = "FILTER", condition = CanDevelop, params = { id = CityAssetID.PRODUCTION } },
			{ type = "ACTION", action = SubmitProposal, params = { type = "DEV_PRODUCTION" } },
		},
	},
	{ type = "SEQUENCE", children = 
		{
			{ type = "FILTER", condition = CanBuildCity },
			{ type = "ACTION", action = SubmitProposal, params = { type = "BUILD_CITY" } },
		},
	},
	{ type = "SEQUENCE", children = 
		{
			{ type = "FILTER", condition = CanLevyTax },
			{ type = "ACTION", action = SubmitProposal, params = { type = "LEVY_TAX" } },
		},
	},
}

local function CanReconnoitre()
	--whether to reconnoitre
	local list = {}
	Asset_ForeachList( _city, CityAssetID.SPY_LIST, function( spy )
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
	local list = {}
	Asset_ForeachList( _city, CityAssetID.SPY_LIST, function( spy )
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

local _StaffPlans = 
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

local function CanImproveRelation()
	if 1 then return false end

	--1. self isn't at war
	--2. target isn't at war
	if Dipl_IsAtWar( _group ) == true then return false end	

	--only group leader or diplomatic can execute the task
	if _proposer:IsGroupLeader() == false and _city:GetOfficer( CityJob.CHIEF_DIPLOMATIC ) ~= _proposer then return false end

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
	local list = Dipl_GetRelations( _group )
	if not list then return false end
	local groupList = {}
	for _, relation in pairs( list ) do
		if Dipl_CanDeclareWar( relation ) == true then
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

local _DiplomatciPlans = 
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

local function CanResearch()
	if _city:IsCapital() == false then return false end

	if Asset_Get( _city, CityAssetID.RESEARCH ) ~= nil then return false end
	
	if _proposer:IsGroupLeader() == false and _city:GetOfficer( CityJob.CHIEF_TECHNICIAN ) ~= _proposer then return false end

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

local _TechnicianPlans = 
{
	{ type = "SEQUENCE", children = 
		{
			{ type = "FILTER", condition = CanResearch },
			{ type = "ACTION", action = SubmitProposal, params = { type = "RESEARCH" } },
		},
	},
}


-------------------------------------------------------

local _SubmitHRProposal =
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanSubmitPlan, params = { topic = "HR" } },
		{ type = "RANDOM_SELECTOR", children = _HRPlans },
	}
}

local _SubmitStaffProposal =
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanSubmitPlan, params = { topic = "STAFF" } },	
		{ type = "RANDOM_SELECTOR", children = _StaffPlans },
	}
}

local _SubmitAffairsProposal =
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanSubmitPlan, params = { topic = "AFFAIRS" } },
		{ type = "RANDOM_SELECTOR", children = _AffairsPlans },	
	}
}

local _SubmitMilitaryProposal =
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanSubmitPlan, params = { topic = "COMMANDER" } },
		_AggressivePlans,
		_CommanderPlans,
	}
}

local _SubmitDiplomaticProposal =
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanSubmitPlan, params = { topic = "DIPLOMATIC" } },
		{ type = "RANDOM_SELECTOR", children = _DiplomatciPlans },
	}
}

local _SubmitTechnicianProposal =
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanSubmitPlan, params = { topic = "TECHNICIAN" } },
		{ type = "RANDOM_SELECTOR", children = _TechnicianPlans },
	}
}

local _SubmitStrategyProposal =
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanSubmitPlan, params = { topic = "STRATEGY" } },
		{ type = "RANDOM_SELECTOR", children = _StrategyPlans },
	}	
}

local _QualificationChecker = 
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = IsProposalCD },
	},
}

local _PriorityProposals = 
{
	-----------------------------
	--at war
	type = "SELECTOR", children = 
	{
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

--[[
		{ type = "SEQUENCE", children = 
			{
				{ type = "FILTER", condition = HasCityStatus, params = { status = "MILITARY_DANGER" } },
				_SubmitMilitaryProposal,
			},
		},

		{ type = "SEQUENCE", children = 
			{
				{ type = "FILTER", condition = HasCityStatus, params = { status = "DEVELOPMENT_DANGER" } },
				_SubmitAffairsProposal,
			}
		},

		{ type = "SEQUENCE", children = 
			{
				{ type = "FILTER", condition = IsCityInstruction, params = { instruction = "MILITARY_PRIORITY" } },
				_SubmitMilitaryProposal,
			},
		},

		{ type = "SEQUENCE", children = 
			{
				{ type = "FILTER", condition = IsCityInstruction, params = { instruction = "DEVELOPMENT_PRIORITY" } },
				_SubmitAffairsProposal,
			}
		},
		]]
	}
	-----------------------------
}

--Main entrance to submit proposal
local _MeetingProposal = 
{
	type = "SELECTOR", desc = "entrance", children = 
	{	
		--_QualificationChecker,
		_PriorityProposals,

		--test slot

		--[[]]
		_SubmitTechnicianProposal,
		_SubmitDiplomaticProposal,
		_SubmitHRProposal,
		_SubmitAffairsProposal,
		_SubmitStaffProposal,
		_SubmitMilitaryProposal,
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
		print( "invalid city data", _proposer.name )
		return false
	end
	if not _group or typeof( _group ) == "number" then
		print( "invalid group data", _group, _proposer.name )
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
		--print( "enter", MathUtil_FindName( MeetingTopic, _topic ) )
		return _behavior:Run( _meetingProposal )
	end
	print( "chara=", chara.name, " cann't submit proposal" )
	return false
end