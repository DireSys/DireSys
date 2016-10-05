--[[
	Represents a Floor Tile
]]

Tile = require "diresys/Tile"

local FloorTile = {}

function FloorTile:new(parent, physics_world, options)
	local obj = Tile:new(parent, physics_world, options)
	obj.options = options or {}
	obj:set_graphic("floor0")
	obj.type = "floortile"
	obj.updateFloorGraphics = FloorTile.updateFloorGraphics

	local position = obj.options.position or {x=0, y=0}
	obj:set_position(position.x, position.y)
	return obj
end

function FloorTile:updateFloorGraphics(walls)
	--pass
end

return FloorTile
