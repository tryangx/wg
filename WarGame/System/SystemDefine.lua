require "System/CharaSystem"
require "System/CorpsSystem"
require "System/CitySystem"
require "System/GroupSystem"
require "System/CharaCreatorSystem"
require "System/MarchSystem"
require "System/WarfareSystem"
require "System/ConsumeSystem"
require "System/IntelSystem"
require "System/LogisticsSystem"
require "System/SupplySystem"
require "System/ProposalSystem"
require "System/TaskSystem"
require "System/EventSystem"

SystemType =
{
	CHARA_SYS       = 100,
	CITY_SYS        = 101,
	GROUP_SYS       = 102,
	CORPS_SYS       = 103,
	MARCH_SYS       = 110,
	WARFARE_SYS     = 111,

	CHARA_CREATOR_SYS = 300,	
	CONSUME_SYS     = 301,
	SUPPLY_SYS      = 302,
	LOGISTICS_SYS   = 303,
	INTEL_SYS       = 304,
	PROPOSAL_SYS    = 305,
	TASK_SYS        = 306,
	EVENT_SYS       = 307,
	MEETING_SYS     = 308,
}