--[[
	Door Tile
]]
config = require "config"
f = require "diresys/func"
Tile = require "diresys/Tile"

local DoorTile = {}

function DoorTile:new(parent, physics_world, options)
	local obj = Tile:new(parent, physics_world, options)
	obj:set_graphic("hdoor_upper0", 2, {0, 0})
	obj:set_graphic("hdoor_lower0", 1, {0, 1})
	obj.type = "doortile"
	obj.init_physics = DoorTile.init_physics

	obj:init_physics()
	return obj
end

function DoorTile:init_physics()
	self.physics.body = love.physics.newBody(self.physics_world, 0, 0, "static")
	local width, height = self:get_dimensions()
	local width, height = 12, 8

	local rectwidth = width
	local rectheight = height/2
	local offsetx = rectwidth/2
	local offsety = height/2 + rectheight/2

	self.physics.shape = love.physics.newRectangleShape(
		offsetx, offsety,
		rectwidth, rectheight)
	self.physics.fixture = love.physics.newFixture(
		self.physics.body, self.physics.shape)

	-- body settings
end

return DoorTile
