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
	Asset_Set( proposal, ProposalAssetID.TIME,        g_calendar:GetDateValue() )
	Asset_Set( proposal, ProposalAssetID.ACTOR,       actor )

	if params.type == "PROMOTE_CHARA" then
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "job", _registers["JOB"] )
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "plan", CityPlan.HR )
	elseif params.type == "HIRE_CHARA" then
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "plan", CityPlan.HR )
	elseif params.type == "DISPATCH_CHARA" then
		Asset_Set( proposal, ProposalAssetID.DESTINATION, _registers["DISPATCH_CITY"] )
	elseif params.type == "CALL_CHARA" then		
		Asset_Set( proposal, ProposalAssetID.LOCATION, _registers["CALL_FROM_CITY"] )
	
	elseif params.type == "ATTACK_CITY" then		
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "corps_list", _registers["ATTACK_CORPS"] )
		Asset_Set( proposal, ProposalAssetID.DESTINATION, _registers["TARGET_CITY"] )
	elseif params.type == "HARASS_CITY" then
		Asset_Set( proposal, ProposalAssetID.DESTINATION, _registers["TARGET_CITY"] )
	elseif params.type == "INTERCEPT" then
		local enemyCorps = _registers["TARGET_CORPS"]
		local city = Asset_Get( enemyCorps, CorpsAssetID.LOCATION )
		Asset_Set( proposal, ProposalAssetID.DESTINATION, city )
		Asset_Set( proposal, ProposalAssetID.DESTINATION, _registers["TARGET_CITY"] )
		--InputUtil_Pause( "inter", _city.name, city.name, enemyCorps.name )
	
	elseif params.type == "ESTABLISH_CORPS" then
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "leader", _registers["CORPS_LEADER"] )
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "plan", CityPlan.COMMANDER )
	elseif params.type == "REINFORCE_CORPS"
		or params.type == "DISMISS_CORPS"
		or params.type == "TRAIN_CORPS"
		or params.type == "UPGRADE_CORPS"
		or params.type == "DISPATCH_CORPS"
		or params.type == "ENROLL_CORPS" then
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "corps", _registers["CORPS"] )
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "plan", CityPlan.COMMANDER )

	elseif params.type == "DEV_AGRICULTURE" or params.type == "DEV_COMMERCE" or params.type == "DEV_PRODUCTION" 
		or params.type == "BUILD_CITY" or params.type == "LEVY_TAX" then
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "plan", CityPlan.AFFAIRS )

	elseif params.type == "COLLECT_INTEL" then
	elseif params.type == "RESEARCH" then
	elseif params.type == "" then
	end

	--InputUtil_Pause( "Submit proposal=" .. proposal:ToString() )
	Stat_Add( "Proposal@Submit_Times", 1, StatType.TIMES )

	Asset_SetListItem( _proposer, CharaAssetID.STATUSES, CharaStatus.PROPOSAL_CD, Random_GetInt_Sync( 30, 50 ) )
end

----------------------------------------

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

local function CanSubmitPlan( params )
	if IsTopic( params ) == false then return false end
	if true then return true end
	return _city:IsCharaOfficer( CityJob.CHIEF_EXECUTIVE, _proposer ) == true or _city:IsCharaOfficer( params.position, _proposer )
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
	local soldier = Asset_GetListItem( _city, CityAssetID.POPU_STRUCTURE, CityPopu.RESERVES )
	if soldier < Scenario_GetData( "TROOP_PARAMS" ).MIN_TROOP_SOLDIER then
		return false
	end
	if Corps_CanEstablishCorps( _city, soldier ) == false then
		print( "cann't est corps" )
		return false
	end

	_registers["CORPS_LEADER"] = Random_GetListItem( charaList )

	--InputUtil_Pause( "can est corps" )

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
	local soldier = Asset_GetListItem( _city, CityAssetID.POPU_STRUCTURE, CityPopu.RESERVES )
	if soldier < Scenario_GetData( "TROOP_PARAMS" ).MIN_TROOP_SOLDIER then
		return false
	end
	if Corps_CanEstablishCorps( _city, soldier ) == false then
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

local function CanDispatchCorps()
	return false
end

local function CanHarassCity()
	--check free corps
	local list, soldier, power = _city:GetFreeCorps()
	if #list == 0 then
		return false
	end

	--check & find target
	local cities = _city:FindHarassCityTargets( function ( city )
		local citySoldier = City_GetSoldierWithIntel( city, _group )
		if citySoldier > soldier + soldier then return false end
		if Random_GetInt_Sync( 1, citySoldier ) > soldier then return false end
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
		local citySoldier = City_GetSoldierWithIntel( city, _group )
		if soldier < citySoldier then return false end
		if Random_GetInt_Sync( 1, soldier ) >= citySoldier then return false end
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

	_registers["TARGET_CORPS"] = target
	_registers["TARGET_CITY"]  = destcity
	_registers["ACTOR"]  = corps

	return true
end

--1. in danger
--2. not enough reserves
--3. corps understaffed
local function NeedMoreReserves( score )
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
	local needMoney = 1000
	if Asset_Get( _city, CityAssetID.MONEY ) < needMoney then
		return false
	end
	if NeedMoreReserves() == false then
		return false
	end
end

----------------------------------------

local function CanBuildCity()
	return false
end
local function CanLevyTax()
	return false
end

local function CanHireChara()
	if Asset_GetListItem( _city, CityAssetID.PLANS, CityPlan.HR ) then
		return false
	end

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

	_registers["DISPATCH_CITY"] = city
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

	_registers["CALL_FROM_CITY"] = city
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

local _CommanderPlans = 
{
	{ type = "SEQUENCE", children = 
		{
			{ type = "FILTER", condition = CanEstablishCorps },
			{ type = "ACTION", action = SubmitProposal, params = { type = "ESTABLISH_CORPS" } },
		},
	},	
	{ type = "SEQUENCE", children = 
		{
			{ type = "FILTER", condition = CanEnrollCorps },
			{ type = "ACTION", action = SubmitProposal, params = { type = "ENROLL_CORPS" } },
		},
	},
	{ type = "SEQUENCE", children = 
		{
			{ type = "FILTER", condition = CanReinforceCorps },
			{ type = "ACTION", action = SubmitProposal, params = { type = "REINFORCE_CORPS" } },
		},
	},
	{ type = "SEQUENCE", children = 
		{
			{ type = "FILTER", condition = CanTrainCorps },
			{ type = "ACTION", action = SubmitProposal, params = { type = "TRAIN_CORPS" } },
		},
	},

	{ type = "SEQUENCE", children = 
		{
			{ type = "FILTER", condition = CanConscript },
			{ type = "ACTION", action = SubmitProposal, params = { type = "CONSCRIPT" } },
		},
	},
	{ type = "SEQUENCE", children = 
		{
			{ type = "FILTER", condition = CanRecruit },
			{ type = "ACTION", action = SubmitProposal, params = { type = "RECRUIT" } },
		},
	},
	--[[
	{ type = "SEQUENCE", children = 
		{
			{ type = "FILTER", condition = CanDispatchCorps },
			{ type = "ACTION", action = SubmitProposal, params = { type = "DISPATCH_CORPS" } },
		},
	},
	--]]
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

local _StaffPlans = 
{
		--COLLECT INTELS
		--EXECUTE OP
}

local _DiplomatciPlans = 
{	
		--IMPROVE RELATIONSHIP
		--SIGN PACT
		--DECLARE WAR
}

local _TechnicianPlans = 
{
		--RESEARCH TECH
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
		{ type = "RANDOM_SELECTOR", children = _CommanderPlans },
	}
}

local _SubmitDiplomaticProposal =
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CanSubmitPlan, params = { topic = "DIPLOMAT" } },
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
		_SubmitTechnicianProposal,

		--_SubmitDiplomaticProposal,
		_SubmitHRProposal,
		_SubmitAffairsProposal,
		_SubmitStaffProposal,
		_SubmitMilitaryProposal,
		_SubmitStrategyProposal,
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