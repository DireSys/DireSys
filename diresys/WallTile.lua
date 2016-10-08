--[[
	Represents a Wall Tile
]]

Tile = require "diresys/Tile"

local WallTile = {}

function WallTile:new(parent, physics_world, options)
	local obj = Tile:new(parent, physics_world, options)
	obj.options = options or {}
	obj.type = "walltile"
	obj.bounds_type = "wall"

	-- Methods
	obj.updateBounds = WallTile.updateBounds

	-- Graphics
	obj.graphics:setBackground({key="wall_____", redraw=false})

	-- Physics
	obj.physics:setCollidable(true)
	obj.physics:setUseable(false)

	return obj
end

function WallTile:updateBounds(wall_edges, front_facing)
	local t = wall_edges.top and "T" or "_"
	local r = wall_edges.right and "R" or "_"
	local b = wall_edges.bottom and "B" or "_"
	local l = wall_edges.left and "L" or "_"
	
    local front = front_facing and "front_" or ""

	local layer = 1
	if wall_edges.top then
		layer = 2
		self.physics:setEnabled(false)
	end

    local key = "wall_" .. front .. t .. r .. b .. l

	if layer == 1 then
		self.graphics:setBackground({key=key})
	else
		self.graphics:setKey("background", nil)
		self.graphics:setForeground({key=key})
	end
end

return WallTile
