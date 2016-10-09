--[[
	Represents the Alien
]]
config = require "config"
Actor = require "diresys/Actor"
ai = require "diresys/ai"
random = require "diresys/random"
pp = require "diresys/pp"
f = require "diresys/func"
pathfinding = require "diresys/pathfinding"

local Alien = {}

function Alien:new(parent, physicsWorld, options)
	local obj = Actor:new(parent, physicsWorld, options)
	obj.type = "alien"
	obj.parent_type = "actor"

	-- Methods
	obj.init_physics = Alien.init_physics
	obj.update = Alien.update
	obj.checkPlayerProximity = Alien.checkPlayerProximity

	-- Graphics
	obj.graphics:setBackground({key="alien_idle_DR_0"})

	-- Movement
	obj.movement.speed = 40

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
      "alien_idle_DL_0", "alien_idle_DL_1"
    }

    obj.animation.idle_DR = {
      "alien_idle_DR_0", "alien_idle_DR_1"
    }

    obj.animation.idle_UL = {
      "alien_idle_UL_0", "alien_idle_UL_1"
    }

    obj.animation.idle_UR = {
      "alien_idle_UR_0", "alien_idle_UR_1"
    }

    -- .. run
    obj.animation.run_DL = {
      "alien_run_DL_0", "alien_run_DL_1"
    }

    obj.animation.run_DR = {
      "alien_run_DR_0", "alien_run_DR_1"
    }

    obj.animation.run_UL = {
      "alien_run_UL_0", "alien_run_UL_1"
    }

    obj.animation.run_UR = {
      "alien_run_UR_0", "alien_run_UR_1"
    }

    -- Map animations to standard animations
    obj.animation.idle = obj.animation.idle_DR
    obj.animation.up = obj.animation.run_UL
    obj.animation.left = obj.animation.run_DL
    obj.animation.down = obj.animation.run_DR
    obj.animation.right = obj.animation.run_UR

	-- AI
	obj.ai = ai.StateMachine:new(obj)
	obj.ai:addState("idle", Alien.state_idle, nil, 0.3)
	obj.ai:addState("wander", Alien.state_wander, nil, 0.1)
	obj.ai:addState("patrol", Alien.state_patrol, nil, 1.0)
	obj.ai:addState("chase", Alien.state_chase, nil, 0.3)
	obj.ai:addState("return", Alien.state_return, nil, 1.0)
	obj.ai.currentState = "idle"

	return obj
end

function Alien:init_physics()
	local dims = self:getDimensions()
	local rectwidth = dims.w - 2
	local rectheight = dims.h / 2
	local offsetx = rectwidth/2 + 1
	local offsety = dims.h/2 + rectheight/2

	self.physics:setMainBounds(offsetx, offsety, rectwidth, rectheight)
	self.physics:init()
end

function Alien:update(dt)
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
	
	-- Check if the alien is close to the player, will automatically
	-- set it to 'chasing' state.
	self:checkPlayerProximity()

	self.ai:update(dt)
end

function Alien:checkPlayerProximity()
	if not self.activePlayer then
		self.activePlayer = f.find(self.parent.actorList,
								   function(i) return i.type == "player" end)
	end

	-- don't attempt chase if the player is hidden
	if self.activePlayer:isHidden() then
		return
	end

	local aliendims = self:getDimensions()
	local alienpos = self:getPosition()
	alienpos.x = alienpos.x + aliendims.w/2
	alienpos.y = alienpos.y + aliendims.h/2

	local playerdims = self.activePlayer:getDimensions()
	local playerpos = self.activePlayer:getPosition()
	playerpos.x = playerpos.x + playerdims.w/2
	playerpos.y = playerpos.y + playerdims.h/2

	if pathfinding.inProximity(alienpos, playerpos, 12) then
		self.ai.currentState = "chase"
	end
end

function Alien:state_idle(sm)
	local look_direction = random.getRandDist({
			{1, {"up", "left"}},
			{1, {"up", "right"}},
			{1, {"down", "left"}},
			{1, {"down", "right"}},
		})
	self.movement = {speed=40}

	self.facing = {up=false, right=false, down=false, left=false}
	self.facing[look_direction[1]] = true
	self.facing[look_direction[2]] = true

	return random.getRandDist({
			{15, "wander"},
			{85, "idle"},
	})
end

function Alien:state_wander(sm)
	local movement_direction = random.getRandDist({
			{1, {"up"}},
			{1, {"up", "left"}},
			{1, {"up", "right"}},
			{1, {"down"}},
			{1, {"down", "left"}},
			{1, {"down", "right"}},
			{1, {"left"}},
			{1, {"right"}},
	})
	self.movement = {speed=30}
	for _, v in ipairs(movement_direction) do
		self.movement[v] = true
	end
	
	return "idle"
end

function Alien:state_patrol(sm)
	return "idle"
end

function Alien:state_chase(sm)
	if not self.activePlayer then
		return "idle"
	end
	local epsilon = 4.0

	local playerPos = self.activePlayer:getPosition()
	local alienPos = self:getPosition()

	local pos = {}
	pos.x = playerPos.x - alienPos.x
	pos.y = playerPos.y - alienPos.y

	self.movement = {speed=40}
	if pos.x > epsilon then
		self.movement.right = true
	elseif pos.x < -epsilon then
		self.movement.left = true
	end
	
	if pos.y > epsilon then
		self.movement.down = true
	elseif pos.y < -epsilon then
		self.movement.up = true
	end

	return "idle"
end

function Alien:state_return(sm)
	return "idle"
end

return Alien	
