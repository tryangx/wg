package.path = package.path .. ";Utility/?.lua"
package.path = package.path .. ";Common/?.lua"
package.path = package.path .. ";Scenario/?.lua"
package.path = package.path .. ";WarGame/?.lua"

require "unclasslib"
require "Utility"
require "Common"
require "Scenario"
require "Main"

---------------------------------------------

_game = WarGame()
_game:Start()