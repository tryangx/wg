package.path = package.path .. ";Lib/?.lua"
package.path = package.path .. ";Utility/?.lua"
package.path = package.path .. ";Common/?.lua"
package.path = package.path .. ";Scenario/?.lua"
package.path = package.path .. ";WarGame/?.lua"
package.path = package.path .. ";WarGame/Entity/?.lua"
package.path = package.path .. ";WarGame/Table/?.lua"
package.path = package.path .. ";WarGame/System/?.lua"
package.path = package.path .. ";WarGame/Module/?.lua"
package.path = package.path .. ";WarGame/AI/?.lua"

--native
require "unclasslib"

--Utility always the lower
require "Utility"

--Common may use some Utility
require "Common"

--Scenario has datas
require "Scenario"

--Main has codes of game
require "GameMain"

---------------------------------------------

Game_Start()
