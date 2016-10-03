--[[
	Represents a Floor Tile
]]

Tile = require "diresys/Tile"

local FloorTile = {}

function FloorTile:new(parent, physics_world, options)
	local obj = Tile:new(parent, physics_world, options)
	obj:set_graphic("floor0")
	obj.type = "floortile"
	obj.updateFloorGraphics = FloorTile.updateFloorGraphics

	return obj
end

function FloorTile:updateFloorGraphics(walls)
	--pass
end

return FloorTile
