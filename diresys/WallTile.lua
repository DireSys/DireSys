--[[
	Represents a Wall Tile
]]

Tile = require "diresys/Tile"

local WallTile = {}

function WallTile:new(parent, physics_world, options)
	local obj = Tile:new(parent, physics_world, options)
	obj:set_graphic("wall0")
	obj.type = "walltile"

	return obj
end

return WallTile
