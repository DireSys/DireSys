--[[
	Represents the Player
]]
config = require "config"
Actor = require "diresys/Actor"

local Player = {}

function Player:new(parent, physics_world, options)
	local obj = Actor:new(parent, physics_world, options)
	obj:set_graphic("player_idle_DR_0")
	obj.type = "player"
	obj.init_physics = Player.init_physics
	obj.update = Player.update

	-- Movement
	obj.movement.speed = 30

    -- Facing direction
    obj.facing = {
        up = false,
        down = true,
        left = false,
        right = true 
    }
	
	-- Animations
    
    -- .. idle
    obj.animation.idle_DL = {
      "player_idle_DL_0", "player_idle_DL_1"
    }

    obj.animation.idle_DR = {
      "player_idle_DR_0", "player_idle_DR_1"
    }

    obj.animation.idle_UL = {
      "player_idle_UL_0", "player_idle_UL_1"
    }

    obj.animation.idle_UR = {
      "player_idle_UR_0", "player_idle_UR_1"
    }

    -- .. run
    obj.animation.run_DL = {
      "player_run_DL_0", "player_run_DL_1"
    }

    obj.animation.run_DR = {
      "player_run_DR_0", "player_run_DR_1"
    }

    obj.animation.run_UL = {
      "player_run_UL_0", "player_run_UL_1"
    }

    obj.animation.run_UR = {
      "player_run_UR_0", "player_run_UR_1"
    }

    -- Map animations to standard animations
    obj.animation.idle = obj.animation.idle_DR
    obj.animation.up = obj.animation.run_UL
    obj.animation.left = obj.animation.run_DL
    obj.animation.down = obj.animation.run_DR
    obj.animation.right = obj.animation.run_UR

	obj:init_physics()
	return obj
end

function Player:init_physics()
	self.physics.body = love.physics.newBody(self.physics_world, 0, 0, "dynamic")
	local width, height = self:get_dimensions()

	local rectwidth = width-2
	local rectheight = height/2
	local offsetx = rectwidth/2 + 1
	local offsety = height/2 + rectheight/2
	
	self.physics.shape = love.physics.newRectangleShape(
		offsetx, offsety,
		rectwidth, rectheight)
	self.physics.fixture = love.physics.newFixture(
		self.physics.body, self.physics.shape)
	self.physics.fixture:setUserData(self)

	-- body settings
	self.physics.body:setMassData(self.physics.shape:computeMass(1))
	self.physics.body:setFixedRotation(true)
	self.physics.body:setLinearDamping(0.1)
end

function Player:update(dt)
    -- Update facing direction
    if self.movement.up or self.movement.down then
        self.facing.up = self.movement.up
        self.facing.down = self.movement.down
    end

    if self.movement.left or self.movement.right then
        self.facing.left = self.movement.left
        self.facing.right = self.movement.right
    end
    
    if self.facing.left and self.facing.up then
        self.animation.idle = self.animation.idle_UL
        self.animation.up = self.animation.run_UL
        self.animation.left = self.animation.run_UL
    elseif self.facing.left and self.facing.down then
        self.animation.idle = self.animation.idle_DL
        self.animation.down = self.animation.run_DL
        self.animation.left = self.animation.run_DL
    elseif self.facing.right and self.facing.up then
        self.animation.idle = self.animation.idle_UR
        self.animation.up = self.animation.run_UR
        self.animation.right = self.animation.run_UR
    elseif self.facing.right and self.facing.down then
        self.animation.idle = self.animation.idle_DR
        self.animation.down = self.animation.run_DR
        self.animation.right = self.animation.run_DR
    end

    -- Call base
	Actor.update(self, dt)
end

return Player
