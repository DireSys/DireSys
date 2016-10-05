--[[
	Represents a Wall Tile
]]

Tile = require "diresys/Tile"

local WallTile = {}

function WallTile:new(parent, physics_world, options)
	local obj = Tile:new(parent, physics_world, options)
	obj.options = options or {}
	obj:set_graphic("wall_____", {redraw=false})
	obj.type = "walltile"
	obj.init_physics = WallTile.init_physics
	obj.updateWall = WallTile.updateWall
	obj.fixTopBounds = WallTile.fixTopBounds
	obj:init_physics()
	return obj
end

function WallTile:init_physics()
	local position = self.options.position or {x=0, y=0}
	self.physics.body = love.physics.newBody(self.physics_world, position.x, position.y, "static")
	local width, height = self:get_dimensions()
	self.physics.shape = love.physics.newRectangleShape(
		width/2, height/2,
		width, height)
	self.physics.fixture = love.physics.newFixture(
		self.physics.body, self.physics.shape)
end

function WallTile:updateWall(wall_edges, front_facing)
	local t = wall_edges.top and "T" or "_"
	local r = wall_edges.right and "R" or "_"
	local b = wall_edges.bottom and "B" or "_"
	local l = wall_edges.left and "L" or "_"
	
    local front = front_facing and "front_" or ""

	local layer = 1
	if wall_edges.top then
		layer = 2
		self:fixTopBounds()
	end
	local layer = wall_edges.top and 2 or 1

    local key = "wall_" .. front .. t .. r .. b .. l
	self:set_graphic(nil, {layer=1, redraw=false})
	self:set_graphic(nil, {layer=2, redraw=false})
	self:set_graphic(key, {layer=layer, redraw=false})
end

function WallTile:fixTopBounds()
	--[[
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
	]]
    self.physics.body:setActive(false)
end

return WallTile
