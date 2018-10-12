--------------------------------------------------------------
--
-- Game
--
--------------------------------------------------------------

-------------------------
-- Global Game Details

---------------------------------------------------------------
--initialized time, always is daily
---------------------------------------------------------------
g_turnIdx  = 1

---------------------------------------------------------------
--maximum end time, always is daily
---------------------------------------------------------------
g_turnEnd  = 360 * 10

---------------------------------------------------------------
--every step update in main(), always is daily
---------------------------------------------------------------
g_turnStep = 1

---------------------------------------------------------------
--Elapsed in current update, can be changed in every update
--unit: DAY
---------------------------------------------------------------
g_elapsed = 1

---------------------------------------------------------------

-------------------------
-- Game 

--time
g_Time = Time()

--Map
g_map = Map()


-------------------------

g_init   = false

g_winner = nil


function Game_IsRunning()
	if g_winner then return false end
	return g_turnIdx < ( g_turnEnd or g_turnIdx + 1 )
end

function Game_NextTurn()
	--map
	g_map:Update( g_turnStep )

	g_Time:ElapseDay( g_turnStep )

	g_turnIdx = g_turnIdx + g_turnStep
	g_turnIdx = g_turnEnd and math.min( g_turnIdx, g_turnEnd ) or g_turnIdx

	--InputUtil_Pause()
	--print( "turn=" .. g_Time:ToString() )
end

-------------------------------------------------
