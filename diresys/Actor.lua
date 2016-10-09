--[[
	Represents an actor on the screen, that can move.
]]
require "diresys/utils"
config = require "config"
f = require "diresys/func"
assets = require "diresys/assets"
phys = require "diresys/phys"
gfx = require "diresys/gfx"

local Actor = {}

function Actor:new(parent, physicsWorld, options)
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	local options = options or {}
	obj.parent_type = "actor"
	obj.type = "actor"

	obj.parent = parent
	obj.physicsWorld = physicsWorld
	obj.position = options.position or {x=0, y=0}

	obj.physics = phys.ActorPhysicsComponent:new(obj, physicsWorld)
	obj.graphics = gfx.ActorGraphicsComponent:new(obj, parent)

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
		idle = {},
		up = {},
		down = {},
		left = {},
		right = {},
	}

	-- Proximity of other actors or useable tiles
	obj.proximity = {}

	return obj
end

function Actor:init()
	self:init_physics()
	return self
end

function Actor:init_physics()
	self.physics:init()
end

function Actor:update(dt)
	self:update_animation(dt)
	self:move()
end

function Actor:update_animation(dt)
	local current_interval = self.animation.current_interval
	local cycle_interval = self.animation.cycle_interval
	local animation = self.animation.idle
	
	-- change the animation set based on movement
	if self.movement.up then
		animation = self.animation.up
	elseif self.movement.left then
		animation = self.animation.left
	elseif self.movement.right then
		animation = self.animation.right
	elseif self.movement.down then
		animation = self.animation.down
	else
		-- not moving, so reset our interval and use the default
		-- animation.down
		-- current_interval = 0.0
	end
	
	-- we have no animations
	if #animation == 0 then
		return
	end

	-- just set the graphic, we don't have a cycle
	if #animation == 1 then
		self.graphics:setBackground({key=animation[1]})
		return
	end

	local step_interval = cycle_interval / #animation
	local animation_frame = (
		math.floor(current_interval / step_interval)) % #animation + 1
	self.graphics:setBackground({key=animation[animation_frame]})
	
	if current_interval > cycle_interval then
		current_interval = 0.0
	else
		current_interval = current_interval + dt
	end
	self.animation.current_interval = current_interval
end

function Actor:getPosition()
	if self.physics.body then
		return {x=self.physics.body:getX(), y=self.physics.body:getY()}
	end
	return self.position
end

function Actor:setPosition(x, y)
	if self.physics.body then
		self.physics.body:setPosition(x, y)
	end
	self.position.x = x
	self.position.y = y
	self:redraw()
	return self
end

function Actor:redraw()
	self.graphics:redraw()
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

function Actor:getDimensions()
	return self.graphics:getDimensions()
end

function Actor:getTileDimensions()
	local dims = self:getDimensions()
	return {
		x = TILE_UNIT(dims.x),
		y = TILE_UNIT(dims.y),
		w = TILE_UNIT(dims.w),
		h = TILE_UNIT(dims.h),
	}
end

function Actor:action_proximity_in(actor)
	-- fill proximity
	if not f.has(self.proximity, actor) then
		table.insert(self.proximity, actor)
	end
end

function Actor:action_proximity_out(actor)
	-- remove actor from proximity
	self.proximity = f.filter(self.proximity, function(i) return i ~= actor end)
end

function Actor:action_use()
	-- pass
end

function Actor:use_proximity()
	-- use a tile that is within proximity
	for _, tile in ipairs(self.proximity) do
		tile:action_use(self)
	end
end

function Actor:setActive(bool)
	self.active = bool == nil and true or bool
	self.parent:reset()
end

function Actor:isHidden()
	return self.graphics:isHidden()
end

function Actor:setHidden(bool)
	self.graphics:setHidden(bool)
	if self.graphics:isHidden() then
		self.physics:setCollidable(false)
		self.physics:setMoveable(false)
	else
		self.physics:setCollidable(true)
		self.physics:setMoveable(true)
	end
end

function Actor:move()
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

	self.physics:setVelocity(vx, vy)

end

return Actor
