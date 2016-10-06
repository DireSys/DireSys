--[[
	A Vertical Door Tile
]]
config = require "config"
f = require "diresys/func"
Tile = require "diresys/Tile"

local VerticalDoorTile = {}

function VerticalDoorTile:new(parent, physics_world, options)
	local obj = Tile:new(parent, physics_world, options)
	obj.graphics:setForeground({key="vdoor_upper0"})
	obj.graphics:setBackground({key="vdoor_lower0", offset={0, 2}})

	obj.type = "doortile"
	obj.init_physics = VerticalDoorTile.init_physics
	obj.update = VerticalDoorTile.update
	obj.action_use = VerticalDoorTile.action_use

	obj:init_physics()
	return obj
end

function VerticalDoorTile:init_physics()
	local position = self:getPosition()
	self.physics.body = love.physics.newBody(self.physics_world, position.x, position.y, "static")
	local dims = self:getDimensions()
	pp.print(dims)
	local width, height = dims.w, dims.h

	local rectwidth = width
	local rectheight = height
	local offsetx = rectwidth/2
	local offsety = height/2

	self.physics.shape = love.physics.newRectangleShape(
		offsetx, offsety,
		rectwidth, rectheight)
	self.physics.fixture = love.physics.newFixture(
		self.physics.body, self.physics.shape)
	self.physics.fixture:setUserData(self)
end

function VerticalDoorTile:update(dt)
	-- nothing here yet
end

function VerticalDoorTile:action_use()
	-- nothing here yet
end

return VerticalDoorTile
