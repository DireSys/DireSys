--[[
	Represents a Floor Tile
]]

Tile = require "diresys/Tile"

local FloorTile = {}

function FloorTile:new(parent, physics_world, options)
	local obj = Tile:new(parent, physics_world, options)
	obj:set_graphic("floor0")
	obj.type = "floortile"

	return obj
end

return FloorTile
