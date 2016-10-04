--[[
	Door Tile
]]
config = require "config"
f = require "diresys/func"
Tile = require "diresys/Tile"

local DoorTile = {}

function DoorTile:new(parent, physics_world, options)
	local obj = Tile:new(parent, physics_world, options)
	obj:set_graphic("door0")
	obj.type = "doortile"
	obj.init_physics = DoorTile.init_physics

	obj:init_physics()
	return obj
end

function DoorTile:init_physics()
	self.physics.body = love.physics.newBody(self.physics_world, 0, 0, "static")
	local width, height = self:get_dimensions()
	self.physics.shape = love.physics.newRectangleShape(
		width/2, height/2,
		width, height)
	self.physics.fixture = love.physics.newFixture(
		self.physics.body, self.physics.shape)

	-- body settings
end

return DoorTile
