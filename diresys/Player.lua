--[[
	Represents the Player
]]

Actor = require "diresys/Actor"

local Player = {}

function Player:new(parent, physics_world, options)
	local obj = Actor:new(parent, physics_world, options)
	obj:set_graphic("player_down0")
	obj.type = "player"
	obj.init_physics = Player.init_physics
	obj:init_physics()

	return obj
end

function Player:init_physics()
	self.physics.body = love.physics.newBody(self.physics_world, 0, 0, "dynamic")
	local width, height = self:get_dimensions()
	self.physics.shape = love.physics.newRectangleShape(0, 0, width, height)
	self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
	self.physics.body:setMassData(self.physics.shape:computeMass(1))
end

return Player
