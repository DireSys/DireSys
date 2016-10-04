--[[
	Represents a Wall Tile
]]

Tile = require "diresys/Tile"

local WallTile = {}

function WallTile:new(parent, physics_world, options)
	local obj = Tile:new(parent, physics_world, options)
	obj:set_graphic("wall_____")
	obj.type = "walltile"
	obj.init_physics = WallTile.init_physics
	obj.updateWall = WallTile.updateWall
	obj.fixTopBounds = WallTile.fixTopBounds
	obj:init_physics()
	return obj
end

function WallTile:init_physics()
	self.physics.body = love.physics.newBody(self.physics_world, 0, 0, "static")
	local width, height = self:get_dimensions()
	self.physics.shape = love.physics.newRectangleShape(
		width/2, height/2,
		width, height)
	self.physics.fixture = love.physics.newFixture(
		self.physics.body, self.physics.shape)

	-- body settings
end

function WallTile:updateWall(walls)
	local t = walls.top and "T" or "_"
	local r = walls.right and "R" or "_"
	local b = walls.bottom and "B" or "_"
	local l = walls.left and "L" or "_"
	
	local layer = 1
	if walls.top then
		layer = 2
		self:fixTopBounds()
	end
	local layer = walls.top and 2 or 1

	local key = "wall_" .. t .. r .. b .. l
	self:set_graphic(nil, 1)
	self:set_graphic(nil, 2)
	self:set_graphic(key, layer)
end

function WallTile:fixTopBounds()
	local width, height = self:get_dimensions()
	local rectwidth = width
	local rectheight = height-2
	local offsetx = rectwidth/2
	local offsety = height/2 + rectheight/2

	self.physics.fixture:destroy()
	self.physics.shape = love.physics.newRectangleShape(
		offsetx, offsety,
		rectwidth, rectheight)
	self.physics.fixture = love.physics.newFixture(
		self.physics.body, self.physics.shape)
    self.physics.body:setActive(false)
end

return WallTile
