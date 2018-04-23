package.path = package.path .. ";Utility/?.lua"
package.path = package.path .. ";Common/?.lua"
package.path = package.path .. ";Scenario/?.lua"
package.path = package.path .. ";WarGame/?.lua"

--native
require "unclasslib"

--Utility always the lower
require "Utility"

--Common may use some Utility
require "Common"

--Scenario has datas
require "Scenario"

--Main has codes of game
require "Main"

---------------------------------------------

Game_Start()
