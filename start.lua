package.path = package.path .. ";Lib/?.lua"
package.path = package.path .. ";Utility/?.lua"
package.path = package.path .. ";Common/?.lua"
package.path = package.path .. ";Constant/?.lua"
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

--Constant
require "Constant"

--Scenario has datas
require "Scenario"

--Main has codes of game
require "GameMain"

---------------------------------------------
--[[
-- PIERCE_DMG    = WP_SHARP * 100 / ( 100 + DF_ARMOR )
-- KINECT_DMG    = WP_WEIGHT * 100 / ( 100 + DF_TOUGHNNESS )
-- DMG_FINAL     = PIERCE_DMG + KINECT_DMG

local bow   = { sharp = 50,  weight = 20 }
local spear = { sharp = 80,  weight = 200 }
local sword = { sharp = 100, weight = 80 }
local fork  = { sharp = 50,  weight = 120 }
local archer  = { name="archer ",  armor = 50,  toughness = 80, weapon = bow }
local cavalry = { name="cavalry",  armor = 120, toughness = 120, weapon = spear, move = 0 }
local regular = { name="regular",  armor = 100, toughness = 100, weapon = sword }
local militia = { name="militia",  armor = 50,  toughness = 50,  weapon = fork }
local soldiers = { archer, cavalry, regular, militia }

function duel( at, df )
	local pierce_dmg = 0
	local kinect_dmg = 0
	local toughness = df.toughness
	if df.move == 1 then
		toughness = toughness * 0.5
	end
	local weight = at.weapon.weight
	if at.move == 1 then
		weight = weight * 1.5
	end
	pierce_dmg = at.weapon.sharp * 100 / ( 100 + df.armor )
	kinect_dmg = weight * 100 / ( 100 + toughness )
	local final_dmg = math.ceil( pierce_dmg + kinect_dmg )
	print( at.name .. "--" .. df.name, "dmg=" .. final_dmg .. " pdmg=" .. math.ceil( pierce_dmg ) .. " kdmg=" .. math.ceil( kinect_dmg ) )
end

for _, s1 in ipairs( soldiers ) do
	for _, s2 in ipairs( soldiers ) do
		duel( s1, s2 )
	end
end
--]]

Game_Start()

