--[[
	Represents the Player
]]
config = require "config"
Actor = require "diresys/Actor"

local Player = {}

function Player:new(parent, physics_world, options)
	local obj = Actor:new(parent, physics_world, options)
	obj:set_graphic("player_down0")
	obj.type = "player"
	obj.init_physics = Player.init_physics
	obj.update = Player.update

	-- Movement
	obj.movement.speed = 30
	
	-- Animations
	obj.animation.idle = {
		"player_down0", "player_down1",
		"player_down2", "player_down3",
	}
	obj.animation.up = {
		"player_up0", "player_up1",
		"player_up2", "player_up3",
	}
	obj.animation.right = {
		"player_right_down0", "player_right_down1",
		"player_right_up0", "player_right_up1",
	}
	obj.animation.left = {
		"player_left_down0", "player_left_down1",
		"player_left_up0", "player_left_up1",
	}
	obj.animation.down = obj.animation.left
	obj.animation.up = obj.animation.right

	obj:init_physics()
	return obj
end

function Player:init_physics()
	self.physics.body = love.physics.newBody(self.physics_world, 0, 0, "dynamic")
	local width, height = self:get_dimensions()
	self.physics.shape = love.physics.newRectangleShape(
		width/2, height/2,
		width, height)
	self.physics.fixture = love.physics.newFixture(
		self.physics.body, self.physics.shape)

	-- body settings
	self.physics.body:setMassData(self.physics.shape:computeMass(1))
	self.physics.body:setFixedRotation(true)
	self.physics.body:setLinearDamping(0.1)
end

function Player:update(dt)
	Actor.update(self, dt)
end

return Player
