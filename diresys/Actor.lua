--[[
	Represents an actor on the screen, that can move.
]]

config = require "config"
assets = require "diresys/assets"

local Actor = {
	
}

function Actor:new(parent, physics_world, options)
	local options = options or {}
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	obj.parent = parent
	obj.physics_world = physics_world
	obj.position = position or {x=0, y=0}
	obj.type = "actor"
	obj.physics = {}
	obj.graphics = {
		key = nil,
	}

	obj.movement = {
		speed = 15,
		up = false,
		down = false,
		left = false,
		right = false,
	}

	obj.animation = {
		current_interval = 0.0,
		cycle_interval = 0.4, --ms
		up = {},
		down = {},
		left = {},
		right = {},
	}

	return obj
end

function Actor:update(dt)
	self:update_animation(dt)
	
	local speed = self.movement.speed

	local vx = 0
	local vy = 0
	if self.movement.up then
		vy = vy - speed
	end
	
	if self.movement.down then
		vy = vy + speed
	end
	
	if self.movement.right then
		vx = vx + speed
	end
	
	if self.movement.left then
		vx = vx - speed
	end
	
	self:move(vx, vy)
end

function Actor:update_animation(dt)
	local current_interval = self.animation.current_interval
	local cycle_interval = self.animation.cycle_interval
	local animation = self.animation.down
	
	-- change the animation set based on movement
	if self.movement.up then
		animation = self.animation.up
	elseif self.movement.left then
		animation = self.animation.left
	elseif self.movement.right then
		animation = self.animation.right
	elseif self.movement.down then
		animation = self.animation.down
	end
	
	-- we have no animations
	if #animation == 0 then
		return
	-- just set the graphic, we don't have a cycle
	elseif #animation == 1 then
		self:set_graphic(animation[1])
		return
	end

	local step_interval = cycle_interval / #animation
	local animation_frame = (
		math.floor(current_interval / step_interval)) % #animation + 1
	print("Set Animation Frame: " .. animation_frame)
	self:set_graphic(animation[animation_frame])
	
	if current_interval > cycle_interval then 
		current_interval = 0
	else
		current_interval = current_interval + dt
	end
	self.animation.current_interval = current_interval
end

function Actor:get_position()
	if self.physics.body then
		return {x=self.physics.body:getX(), y=self.physics.body:getY()}
	end
	return self.position
end

function Actor:set_position(x, y)
	if self.physics.body then
		self.physics.body:setPosition(x, y)
	end
	self.position.x = x
	self.position.y = y
	if self.parent then self.parent:reset() end
	return self
end

function Actor:set_graphic(key)
	--set a graphic based on asset key in assets
	self.graphics.key = key
	if self.parent then self.parent:reset() end
	return self
end

function Actor:get_graphic()
	local key = self.graphics.key
	return assets.get_sprite(key)
end

function Actor:get_dimensions()
	local quad = self:get_graphic()
	local x, y, w, h = quad:getViewport()
	return w, h
end

function Actor:move(x, y)
	if self.physics.body then
		self.physics.body:setLinearVelocity(x, y)
	end
end

return Actor