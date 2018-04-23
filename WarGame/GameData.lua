--------------------------------------------------------------
--
-- Game
--
--------------------------------------------------------------

-------------------------
-- Global Game Details

--initialized time, always is daily
g_turnIdx  = 1

--maximum end time, always is daily
g_turnEnd  = 360 * 4

--every step update in main(), always is daily
g_turnStep = 1

--elapsed in last update
g_elapsed = 1

-------------------------
-- Game 

--Calendar
g_calendar = Calendar()

--Map
g_map = Map()


-------------------------

g_winner = nil


function Game_IsRunning()
	if g_winner then return false end
	return g_turnIdx < ( g_turnEnd or g_turnIdx + 1 )
end

function Game_NextTurn()
	--map
	g_map:Update( g_turnStep )

	--calendar
	g_calendar:ElapseDay( g_turnStep )

	g_turnIdx = math.min( g_turnIdx + g_turnStep, g_turnEnd )

	--InputUtil_Pause()
	--Debug_Log( "Turn=" .. g_turnIdx .. " Date=" .. g_calendar:CreateDesc( true ) )
end

-------------------------------------------------
