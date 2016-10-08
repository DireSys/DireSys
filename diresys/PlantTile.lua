--[[
	Plant Tile
]]
config = require "config"
f = require "diresys/func"
Tile = require "diresys/Tile"

local PlantTile = {}

function PlantTile:new(parent, physicsWorld, options)
	local obj = Tile:new(parent, physicsWorld, options)
	obj.type = "planttile"

	-- Methods
	obj.update = PlantTile.update
	obj.action_use = PlantTile.action_use

	-- Graphics
	obj.graphics:setForeground({key="plant_upper0", offset={0, -1}})
	obj.graphics:setBackground({key="plant_lower0"})

	-- Set several floor tiles under the plant
	obj.graphics:set("tile10", {key="floor0", offset={0,0}})
	obj.graphics:set("tile11", {key="floor0", offset={1,0}})

	-- Physics
	obj.physics:setCollidable(true)
	obj.physics:setUseable(true)
	obj.physics:setMainBounds(4, 2, 8, 4)

	return obj
end

function PlantTile:update(dt)

end

function PlantTile:action_use()

end

return PlantTile
