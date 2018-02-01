----------------------------------------
-- Enviroment & Variables

local _chara = nil
local _city  = nil
local _group = nil

local _meeting = nil
local _topic = nil

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
		actor = _chara
	end

	local proposal = Entity_New( EntityType.PROPOSAL )
	Asset_Set( proposal, ProposalAssetID.TYPE,        ProposalType[params.type] )
	Asset_Set( proposal, ProposalAssetID.PROPOSER,    _chara )
	Asset_Set( proposal, ProposalAssetID.ACTOR,       actor )
	Asset_Set( proposal, ProposalAssetID.DESTINATION, _city )
	Asset_Set( proposal, ProposalAssetID.TIME,        g_calendar:GetDateValue() )

	if params.type == "ISSUE_POLICY" then
		--MathUtil_Dump( Asset_GetList( proposal, ProposalAssetID.PARAMS ) )
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "CITY_POLICY", _registers["POLICY"] )
	elseif params.type == "PROMOTE_CHARA" then
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "job", _registers["JOB"] )
	elseif params.type == "HARASS_CITY" or params.type == "ATTACK_CITY" then
		Asset_Set( proposal, ProposalAssetID.DESTINATION, _registers["TARGET_CITY"] )
	elseif params.type == "REINFORCE_CORPS"
		or params.type == "DISMISS_CORPS"
		or params.type == "TRAIN_CORPS"
		or params.type == "UPGRADE_CORPS"
		or params.type == "DISPATCH_CORPS" then
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, "corps", _registers["CORPS"] )
	end

	--InputUtil_Pause( "Submit proposal=" .. proposal:ToString() )

	Asset_SetListItem( _chara, CharaAssetID.STATUSES, CharaStatus.PROPOSAL_CD, Random_GetInt_Sync( 30, 50 ) )
end

local function IsCityInstruction( params )
	local citydata = Asset_Get( _city, CityAssetID.INSTRUCTION )
	return citydata == CityInstruction[params.instruction]
end

local function CheckTopic( params )
	if not _topic or _topic == MeetingTopic.NONE then return true end	
	return params.topic == MeetingTopic[_topic]
end

----------------------------------------

local function CanEstablishCorps()
	--print( "limit=" .. City_GetCorpsLimit( _city ), "corps=" .. Asset_GetListSize( _city, CityAssetID.CORPS_LIST ) )

	--check corps limitation
	if City_GetCorpsLimit( _city ) <= Asset_GetListSize( _city, CityAssetID.CORPS_LIST ) then
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
	Asset_FindList( _city, CityAssetID.CORPS_LIST, function ( corps )
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
	Asset_FindList( _city, CityAssetID.CORPS_LIST, function ( corps )
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

	--find target
	local cities = _city:FindHarassCityTargets()
	local number = #cities
	if number == 0 then return false end

	_registers["ACTOR"] = list[Random_GetInt_Sync( 1, #list )]
	_registers["TARGET_CITY"] = cities[Random_GetInt_Sync( 1, number )]

	return true
end

local function CanAttackCity()
	--check free corps
	local list = _city:FindFreeCorps()
	if #list == 0 then return false end
	
	local cities = _city:FindAttackCityTargets()
	local number = #cities
	if number == 0 then return false end

	_registers["ACTOR"] = list[Random_GetInt_Sync( 1, #list )]
	_registers["TARGET_CITY"] = cities[Random_GetInt_Sync( 1, number )]

	return true
end

--[[
	FRIENDLY        = 200,
--]]
local _MilitaryProposals = 
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
	--[[
	DISMISS_CORPS   = 102,
	UPGRADE_CORPS   = 104,
	]]
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
local CombatAI_SubmitMilitaryProposal =
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CheckTopic, params = { topic = "MILITARY_PREPARATION" } },
		{ type = "RANDOM_SELECTOR", children = _MilitaryProposals },
	}
}


local function CanExecutePolicy()
	local policy = Asset_Get( _city, CityAssetID.POLICY )
	--is policy valid
	if policy.type == CityPolicy.NONE then return false end
	--is policy finished
	if policy.progress == 0 then return false end
	return true
end

local function CanIssuePolicy()
	local policy = Asset_Get( _city, CityAssetID.POLICY )
	if policy.type ~= CityPolicy.NONE then return false end

	if _city:GetOfficer( CityOfficer.EXECUTIVE ) ~= _chara then return false end

	return true
end

local function CanBuildCity()
	return false
end
local function CanLevyTax()
	return false
end

local function CanHireChara()
	local limit
	if _group then 
		limit = Chara_GetLimitByGroup( _group )
		if limit > 0 and limit <= Asset_GetListSize( _group, GroupAssetID.CHARA_LIST ) then
			return false
		end
	end
	if _city then
		limit = Chara_GetLimitByCity( _city )
		if limit > 0 and limit <= Asset_GetListSize( _city, CityAssetID.CHARA_LIST ) then
			return false
		end
	end
	return true
end
local function CanPromoteChara()
	local job = Chara_FindPromoteJob( _chara )
	if job then
		_registers["JOB"]   = job
		_registers["ACTOR"] = _chara
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

--[[
local CombatAI_SelectPolicy = 
{
	type = "RANDOM_SELECTOR", children = 
	{
		{ type = "FILTER", condition = function ()
			if CanDevelop( CityAssetID.AGRICULTURE ) then
				_registers["POLICY"] = CityPolicy.DEV_AGRICULTURE
				return true
			end
			return false
		end
		},

		{ type = "FILTER", condition = function ()
			if CanDevelop( CityAssetID.COMMERCE ) then
				_registers["POLICY"] = CityPolicy.DEV_COMMERCE
				return true
			end
			return false
		end
		},

		{ type = "FILTER", condition = function ()
			if CanDevelop( CityAssetID.PRODUCTION ) then
				_registers["POLICY"] = CityPolicy.DEV_PRODUCTION
				return true
			end
			return false
		end
		},

		--PATROL
		{ type = "FILTER", condition = function ()
			local attrib = Entity_GetAssetAttrib( _city, CityAssetID.SECURITY )
			if Asset_Get( _city, CityAssetID.SECURITY ) < attrib.max * 0.5 then
				_registers["POLICY"] = CityPolicy.PATROL
				return true
			end
			return false
		end
		},

		--RECRUIT
		{ type = "FILTER", condition = function ()
			local soldier = Asset_GetListItem( _city, CityAssetID.POPU_STRUCTURE, CityPopu.SOLDIER )
			local need = City_NeedPopu( _city, "SOLDIER" )
			if Asset_Get( _city, CityAssetID.SATISFACTION ) < attrib.max * 0.5 then
				_registers["POLICY"] = CityPolicy.RECRUIT
				return true
			end
			return false
		end
		},
		--CONSCRIPT
		{ type = "FILTER", condition = function ()
			--only at war
			return false
		end
		},
		--CALL_VOLUNTEER
		{ type = "FILTER", condition = function ()
			--only guerrilla
			return false
		end
		},
	},
}
]]

local _DevelopmentProposals = 
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
}

local CombatAI_SubmitDevelopProposal =
{
	type = "SEQUENCE", children = 
	{
		{ type = "FILTER", condition = CheckTopic, params = { topic = "CITY_DEVELOPMENT" } },
		{ type = "RANDOM_SELECTOR", children = _DevelopmentProposals },	
	}
}

local function IsProposalCD()
	local proposalcd = Asset_GetListItem( _chara, CharaAssetID.STATUSES, CharaStatus.PROPOSAL_CD )
	return proposalcd and proposalcd > 0 or false
end

local CombatAI_SubmitProposal = 
{
	type = "SELECTOR", children = 
	{
		--check CD
		{ type = "SEQUENCE", children = 
			{
				{ type = "FILTER", condition = IsProposalCD },
			},
		},
		-----------------------------
		--status priority		
		{ type = "SEQUENCE", children = 
			{
				{ type = "FILTER", condition = HasCityStatus, params = { status = "MILITARY_DANGER" } },
				CombatAI_SubmitMilitaryProposal,
			},
		},
		{ type = "SEQUENCE", children = 
			{
				{ type = "FILTER", condition = HasCityStatus, params = { status = "DEVELOPMENT_DANGER" } },
				CombatAI_SubmitDevelopProposal,
			}
		},
		-----------------------------

		-----------------------------
		--priority proposal
		{ type = "SEQUENCE", children = 
			{
				{ type = "FILTER", condition = IsCityInstruction, params = { instruction = "MILITARY_PRIORITY" } },
				CombatAI_SubmitMilitaryProposal,
			},
		},
		{ type = "SEQUENCE", children = 
			{
				{ type = "FILTER", condition = IsCityInstruction, params = { instruction = "DEVELOPMENT_PRIORITY" } },
				CombatAI_SubmitDevelopProposal,
			}
		},
		-----------------------------
		--default
		{ type = "RANDOM_SELECTOR", children = 
			{
				CombatAI_SubmitMilitaryProposal,
				CombatAI_SubmitDevelopProposal,
			}
		}
	},
}

----------------------------------------

local CombatAI_MeetingProposal = CombatAI_SubmitProposal

----------------------------------------

local _behavior = Behavior()

--personal proposal 
_charaSubmitProposal = BehaviorNode()
_charaSubmitProposal:BuildTree( CombatAI_SubmitProposal )

--submit proposal in meeting
_charaMeetingProposal = BehaviorNode()
_charaMeetingProposal:BuildTree( CombatAI_MeetingProposal )

local function Init( params )
	_registers = {}

	_chara = params.chara	
	_city  = Asset_Get( _chara, CharaAssetID.HOME )
	_group = Asset_Get( _chara, CharaAssetID.GROUP )

	_meeting = params.meeting	
	if _meeting then
		_topic = Asset_Get( _meeting, MeetingAssetID.TOPIC )
	else
		_topic = nil
	end	
	if typeof( _chara ) == "number" then
		return false
	end
	if not _city or typeof( _city ) == "number" then
		print( "invalid city data", _chara.name )
		return false
	end
	if not _group or typeof( _group ) == "number" then
		print( "invalid group data", _group, _chara.name )
		return false
	end
	return true
end

function CharaAI_SubmitProposal( chara )
	if not chara then
		InputUtil_Pause( "invalid chara" )
		return
	end
	if Init( { chara = chara } ) then
		return _behavior:Run( _charaSubmitProposal )
	end
--		print( "chara=", chara.name, " cann't submit proposal" )
	return false
end

function CharaAI_SubmitMeetingProposal( chara, meeting )
	if not chara then
		InputUtil_Pause( "invalid chara" )
		return
	end
	if Init( { chara = chara, meeting = meeting } ) then
		return _behavior:Run( _charaMeetingProposal )
	end
	print( "chara=", chara.name, " cann't submit proposal" )
	return false
end