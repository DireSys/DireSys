--[[
	Represents the Player
]]
config = require "config"
Actor = require "diresys/Actor"

local Player = {}

function Player:new(parent, physicsWorld, options)
	local obj = Actor:new(parent, physicsWorld, options)
	obj.type = "player"
	obj.parent_type = "actor"

	-- Methods
	obj.init_physics = Player.init_physics
	obj.update = Player.update

	-- Graphics
	obj.graphics:setBackground({key="player_idle_DR_0"})

	-- Physics
	obj:init_physics()

	-- Movement
	obj.movement.speed = 30

    -- Facing direction
    obj.facing = {
        up = false,
        down = true,
        left = false,
        right = true,
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

	return obj
end

function Player:init_physics()
	local dims = self:getDimensions()
	local rectwidth = dims.w - 2
	local rectheight = dims.h / 2
	local offsetx = rectwidth/2 + 1
	local offsety = dims.h/2 + rectheight/2

	self.physics:setMainBounds(offsetx, offsety, rectwidth, rectheight)
	self.physics:init()
end

function Player:update(dt)
    -- Update facing direction
    if self.movement.up or self.movement.down then
        self.facing.up = self.movement.up
        self.facing.down = self.movement.down
    elseif self.movement.left or self.movement.right then
        -- face down if moving purely left/right
        self.facing.up = false
        self.facing.down = true
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
