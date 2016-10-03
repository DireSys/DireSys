--[[
	Represents a Wall Tile
]]

Tile = require "diresys/Tile"

local WallTile = {}

function WallTile:new(parent, physics_world, options)
	local obj = Tile:new(parent, physics_world, options)
	obj:set_graphic("wall___B_")
	obj.type = "walltile"
	obj.init_physics = WallTile.init_physics
	obj.updateWall = WallTile.updateWall
	obj:init_physics()
	return obj
end

function WallTile:init_physics()
	self.physics.body = love.physics.newBody(self.physics_world, 0, 0, "static")
	local width, height = self:get_dimensions()
	self.physics.shape = love.physics.newRectangleShape(
		width/2, height/2,
		width-1, height-1)
	self.physics.fixture = love.physics.newFixture(
		self.physics.body, self.physics.shape)

	-- body settings
end

function WallTile:updateWall(walls)
	local t = walls.top and "T" or "_"
	local r = walls.right and "R" or "_"
	local b = walls.bottom and "B" or "_"
	local l = walls.left and "L" or "_"
	
	local key = "wall_" .. t .. r .. b .. l

	self:set_graphic(key)
end

return WallTile
