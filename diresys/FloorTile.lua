--[[
	Represents a Floor Tile
]]

class = require "diresys/class"
Tile = require "diresys/Tile"

local FloorTile = class.create(Tile)

function FloorTile:new(parent, physics_world, options)
	local obj = Tile.new(self, parent, physics_world, options)
	obj.type = "floortile"	

	-- Graphics
	obj.graphics:setBackground({key="floor0"})
	
	-- Physics
	obj.physics:setEnabled(false)

    -- Light

	return obj
end

return FloorTile
