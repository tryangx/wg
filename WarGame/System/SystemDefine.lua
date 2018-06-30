require "System/MessageSystem"
require "System/CharaSystem"
require "System/CorpsSystem"
require "System/CitySystem"
require "System/GroupSystem"
require "System/CharaCreatorSystem"
require "System/MoveSystem"
require "System/WarfareSystem"
require "System/ConsumeSystem"
require "System/IntelSystem"
require "System/LogisticsSystem"
require "System/SupplySystem"
require "System/TaskSystem"
require "System/EventSystem"
require "System/MeetingSystem"
require "System/DiplomacySystem"
require "System/GoalSystem"
require "System/ReportSystem"
require "System/RankingSystem"

--System running sequence as follow
SystemType =
{
	MESSAGE_SYS       = 1,
	REPORT_SYS        = 2,
	RANKING_SYS       = 3,

	CHARA_SYS         = 100,
	CITY_SYS          = 101,
	GROUP_SYS         = 102,
	CORPS_SYS         = 103,
	MOVE_SYS          = 110,
	WARFARE_SYS       = 111,
	DIPLOMACY_SYS     = 112,

	CHARA_CREATOR_SYS = 300,	
	CONSUME_SYS       = 301,
	SUPPLY_SYS        = 302,
	LOGISTICS_SYS     = 303,
	INTEL_SYS         = 304,	
	EVENT_SYS         = 305,
	MEETING_SYS       = 306,
	TASK_SYS          = 307,
	GOAL_SYS          = 308,
}