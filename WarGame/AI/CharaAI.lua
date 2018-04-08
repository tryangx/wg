----------------------------------------
-- Enviroment & Variables

local _proposer = nil
local _city  = nil
local _group = nil

local _meeting = nil
local _topic   = nil

local _registers = {}

local function pause()
	InputUtil_Pause( "debug chara ai" )
	return true
end

local bp = { type = "FILTER", condition = pause }

local stop = { type = "FILTER", condition = function ( ... )
	return false
end }

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
	
	elseif params.type == "HARASS_CITY" or params.type == "ATTACK_CITY" then		
		Asset_Set( proposal, ProposalAssetID.DESTINATION, _registers["TARGET_CITY"] )
	elseif params.type == "INTERCEPT" then
		local enemyCorps = _registers["TARGET_CORPS"]
		local city = Asset_Get( enemyCorps, CorpsAssetID.LOCATION )
		Asset_Set( proposal, ProposalAssetID.DESTINATION, city )
		Asset_Set( proposal, ProposalAssetID.DESTINATION, _registers["TARGET_CITY"] )
		--InputUtil_Pause( "inter", _city.name, city.name, enemyCorps.name )
	
	elseif params.type == "REINFORCE_CORPS"
		or params.type == "DISMISS_CORPS"
		or params.type == "TRAIN_CORPS"
		or params.type == "UPGRADE_CORPS"
		or params.type == "DISPATCH_CORPS" then
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

	local soldier = math.min( 1000, Asset_GetListItem( _city, CityAssetID.POPU_STRUCTURE, CityPopu.SOLDIER ) or 0 )
	if soldier < Scenario_GetData( "TROOP_PARAMS" ).MIN_TROOP_SOLDIER then
		print( "not enough soldier" )
		return false
	end

	if Corps_CanEstablishCorps( _city, soldier ) == false then
		print( "cann't est corps" )
		return false
	end

	--InputUtil_Pause( "can est corps" )

	return true
end

local function CanReinforceCorps()
	local findCorps = nil
	Asset_FindListItem( _city, CityAssetID.CORPS_LIST, function ( corps )
		if corps:IsAtHome() == false then return false end
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

	local soldier = Asset_GetListItem( _city, CityAssetID.POPU_STRUCTURE, CityPopu.SOLDIER )
	if soldier < Scenario_GetData( "TROOP_PARAMS" ).MIN_TROOP_SOLDIER then
		InputUtil_Pause( "no corps" )
		return false
	end

	_registers["CORPS"] = findCorps

	return true
end

local function CanTrainCorps()
	local findCorps = nil
	Asset_FindListItem( _city, CityAssetID.CORPS_LIST, function ( corps )
		if corps:IsAtHome() == false then return false end
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

	return true
end

local function CanDispatchCorps()
	return false
end

local function CanHarassCity()	
	if 1 then return false end

	--check free corps
	local list = _city:FindFreeCorps()
	if #list == 0 then return false end

	--check & find target
	local cities = _city:FindHarassCityTargets()
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
	local list = _city:FindFreeCorps()
	if #list == 0 then
		local numofcorps = Asset_GetListSize( _city, CityAssetID.CORPS_LIST )
		--print( _city.name, "has corps=" .. numofcorps )
		return false
	end
	
	local cities = _city:FindAttackCityTargets()
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

local function CanIntercept()
	local list = _city:FindFreeCorps()
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

----------------------------------------

local function CanBuildCity()
	return false
end
local function CanLevyTax()
	return false
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
			{ type = "FILTER", condition = CanHireChara },
			{ type = "ACTION", action = SubmitProposal, params = { type = "HIRE_CHARA" } },
		},
	},	
	{ type = "SEQUENCE", children = 
		{
			{ type = "FILTER", condition = CanPromoteChara },
			{ type = "ACTION", action = SubmitProposal, params = { type = "PROMOTE_CHARA" } },
		},
	},

		--HIRE NEW CHAR
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
			{ type = "FILTER", condition = CanDispatchCorps },
			{ type = "ACTION", action = SubmitProposal, params = { type = "DISPATCH_CORPS" } },
		},
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
		_QualificationChecker,
		_PriorityProposals,
		_SubmitTechnicianProposal,
		_SubmitDiplomaticProposal,
		_SubmitHRProposal,
		_SubmitAffairsProposal,
		_SubmitStaffProposal,
		_SubmitMilitaryProposal,
		--_SubmitStrategyProposal,
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
		return _behavior:Run( _meetingProposal )
	end
	print( "chara=", chara.name, " cann't submit proposal" )
	return false
end