--[[
	Represents a Floor Tile
]]

Tile = require "diresys/Tile"

local FloorTile = {}

function FloorTile:new(parent, physics_world, options)
	local obj = Tile:new(parent, physics_world, options)
	obj.type = "floortile"	

	-- Graphics
	obj.graphics:setBackground({key="floor0"})
	
	-- Physics
	obj.physics:setEnabled(false)

	return obj
end

return FloorTile
