----------------------------------------
-- Enviroment & Variables

local _chara = nil
local _city  = nil
local _group = nil
local _meeting = nil

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
	local proposal = Entity_New( EntityType.PROPOSAL )
	Asset_Set( proposal, ProposalAssetID.TYPE,     ProposalType[params.type] )
	Asset_Set( proposal, ProposalAssetID.PROPOSER, _chara )
	Asset_Set( proposal, ProposalAssetID.ACTOR,    _registers["ACTOR"] )
	Asset_Set( proposal, ProposalAssetID.LOCATION, _city )
	Asset_Set( proposal, ProposalAssetID.TIME,     g_calendar:GetDateValue() )

	if params.type == "ISSUE_POLICY" then
		--MathUtil_Dump( Asset_GetList( proposal, ProposalAssetID.PARAMS ) )
		Asset_SetListItem( proposal, ProposalAssetID.PARAMS, IssuePolicyParams.CITY_POLICY, _registers["POLICY"] )
	end

	InputUtil_Pause( "Submit proposal=" .. proposal:ToString() )

	Asset_SetListItem( _chara, CharaAssetID.STATUSES, CharaStatus.PROPOSAL_CD, Random_GetInt_Sync( 30, 50 ) )
end

local function IsCityInstruction( params )
	local citydata = Asset_Get( _city, CityAssetID.INSTRUCTION )
	return citydata == CityInstruction[params.instruction]
end

----------------------------------------

local function CanEstablishCorps()
	--print( "limit=" .. City_GetCorpsLimit( _city ), "corps=" .. Asset_GetListSize( _city, CityAssetID.CORPS_LIST ) )

	--check corps limitation
	if City_GetCorpsLimit( _city ) <= Asset_GetListSize( _city, CityAssetID.CORPS_LIST ) then
		return false
	end

	local soldier = math.min( 1000, Asset_GetListItem( _city, CityAssetID.POPU_STRUCTURE, CityPopu.SOLDIER ) or 0 )
	if soldier < 100 then
		return false
	end

	if Corps_CanEstablishCorps( _city, soldier ) == false then
		return false
	end

	--InputUtil_Pause( "can est corps" )

	_registers["ACTOR"] = _chara
	return true
end

local function CanReinforceCorps()
	local findCorps = nil
	Asset_ForeachList( _city, CityAssetID.CORPS_LIST, function ( corps )
		if Asset_Get( corps, CorpsAssetID.LOCATION ) == Asset_Get( corps, CorpsAssetID.ENCAMPMENT ) then
			findCorps = corps
		end
	end)
	if not findCorps then return false end

	local soldier = Asset_GetListItem( _city, CityAssetID.POPU_STRUCTURE, CityPopu.SOLDIER )
	if soldier < 100 then return false end
	return true
end

local function CanHarassCity()	
	--check free corps
	if _city:GetNumOfFreeCorps() == 0 then return false end

	--find target
	local cities = _city:FindHarassCityTargets()
	local number = #cities
	if number == 0 then return false end
	local index = Random_GetInt_Sync( 1, number )
	local city = cities[index]
	return city
end

local function CanAttackCity()
	--check free corps
	if _city:GetNumOfFreeCorps() == 0 then return false end

	local cities = _city:FindAttackCityTargets()
	local number = #cities
	if number == 0 then return false end
	local index = Random_GetInt_Sync( 1, number )
	local city = cities[index]
	return city
end

--[[
	FRIENDLY        = 200,
--]]
local CombatAI_SubmitMilitaryProposal = stop
local _CombatAI_SubmitMilitaryProposal =
{
	type = "SELECTOR", children = 
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
		--[[
		DISMISS_CORPS   = 102,
		TRAIN_CORPS     = 103,
		UPGRADE_CORPS   = 104,
		DISPATCH_CORPS  = 105,
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


	},
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
	if Group_GetCharaLimit( _group ) <= Asset_GetListSize( _group, GroupAssetID.CHARA_LIST ) then
		return false
	end
	return true
end
local function CanPromoteChara()
	return false
end

local CombatAI_SelectPolicy = 
{
	type = "RANDOM_SELECTOR", children = 
	{
		--DEV_AGRICULTURE = 10,
		{ type = "FILTER", condition = function ()
			if Asset_Get( _city, CityAssetID.AGRICULTURE ) < Asset_Get( _city, CityAssetID.MAX_AGRICULTURE ) * 0.5 then				
				_registers["POLICY"] = CityPolicy.DEV_AGRICULTURE
				return true
			end
			return false
		end
		},

		--DEV_COMMERCE
		{ type = "FILTER", condition = function ()
			if Asset_Get( _city, CityAssetID.COMMERCE ) < Asset_Get( _city, CityAssetID.MAX_COMMERCE ) * 0.5 then				
				_registers["POLICY"] = CityPolicy.DEV_COMMERCE
				return true
			end
			return false
		end
		},

		--DEV_PRODUCTION
		{ type = "FILTER", condition = function ()
			if Asset_Get( _city, CityAssetID.PRODUCTION ) < Asset_Get( _city, CityAssetID.MAX_PRODUCTION ) * 0.5 then				
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

		--SERVICE
		{ type = "FILTER", condition = function ()
			local attrib = Entity_GetAssetAttrib( _city, CityAssetID.SATISFACTION )
			if Asset_Get( _city, CityAssetID.SATISFACTION ) < attrib.max * 0.5 then
				_registers["POLICY"] = CityPolicy.SERVICE
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

local CombatAI_SubmitDevelopProposal =
{
	type = "SELECTOR", children = 
	{		
		{ type = "SEQUENCE", children = 
			{				
				{ type = "FILTER", condition = CanExecutePolicy },
				{ type = "ACTION", action = SubmitProposal, params = { type = "EXECUTE_POLICY" } },				
			},
		},
		{ type = "SEQUENCE", children = 
			{
				{ type = "FILTER", condition = CanIssuePolicy },
				CombatAI_SelectPolicy,
				{ type = "ACTION", action = SubmitProposal, params = { type = "ISSUE_POLICY" } },
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
	},
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


local CombatAI_MeetingProposal =
{
	
}

----------------------------------------

local _behavior = Behavior()

--personal proposal 
_charaSubmitProposal = BehaviorNode()
_charaSubmitProposal:BuildTree( CombatAI_SubmitProposal )

--submit proposal in meeting
_charaMeetingProposal = BehaviorNode()
_charaSubmitProposal:BuildTree( CombatAI_MeetingProposal )

function CombatAI_SetEnviroment( type, data )
	
end

local function Init( params )
	_registers = {}

	_chara = params.chara
	_meeting = params.meeting
	_city  = Asset_Get( _chara, CharaAssetID.HOME )
	_group = Asset_Get( _chara, CharaAssetID.GROUP )
	if typeof( _chara ) == "number" then
		return false
	end
	if not _city or typeof( _city ) == "number" then
		print( "invalid city data", _chara.name )
		return false
	end
	if not _group or typeof( _group ) == "number" then
		print( "invalid group data" )
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
		_behavior:Run( _charaSubmitProposal )
	else
		print( "chara=", chara.name, " cann't submit proposal" )
	end	
end

function CharaAI_SubmitMeetingProposal( chara, meeting )
	if not chara then
		InputUtil_Pause( "invalid chara" )
		return
	end
	if Init( { chara = chara, meeting = meeting } ) then
		_behavior:Run( _charaMeetingProposal )
	else
		print( "chara=", chara.name, " cann't submit proposal" )
	end	
end