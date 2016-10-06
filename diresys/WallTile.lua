--[[
	Represents a Wall Tile
]]

Tile = require "diresys/Tile"

local WallTile = {}

function WallTile:new(parent, physics_world, options)
	local obj = Tile:new(parent, physics_world, options)
	obj.options = options or {}
	obj.graphics:setBackground({key="wall_____", redraw=false})
	obj.type = "walltile"
	obj.init_physics = WallTile.init_physics
	obj.updateWall = WallTile.updateWall
	obj.fixTopBounds = WallTile.fixTopBounds
	obj:init_physics()
	return obj
end

function WallTile:init_physics()
	local position = self:getPosition()
	self.physics.body = love.physics.newBody(self.physics_world, position.x, position.y, "static")
	local dims = self:getDimensions()
	local width, height = dims.w, dims.h
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

    local key = "wall_" .. front .. t .. r .. b .. l

	if layer == 1 then
		self.graphics:setBackground({key=key})
	else
		self.graphics:setKey("background", nil)
		self.graphics:setForeground({key=key})
	end

	self.graphics:set("floor", {key=key, layer=layer})
end

function WallTile:fixTopBounds()
    self.physics.body:setActive(false)
end

return WallTile
