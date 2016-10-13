--[[

	Includes the class 'Actor' which represents a moveable object on
	the screen.

	Notes:
	
	- Actor's have dynamic physics, and use ActorPhysicsComponent to
      manage the actor's physics.

	- Actor's are usually drawn with the ActorEngine, and should be
      registered with the ActorEngine:add_actor method.

]]
require "diresys/utils"
config = require "config"
f = require "diresys/func"
assets = require "diresys/assets"
phys = require "diresys/phys"
gfx = require "diresys/gfx"

local Actor = {}

function Actor:new(parent, physicsWorld, options)
	--[[

		Creates an Actor instance

		Keyword Arguments:

		parent -- An ActorEngine instance, which has the current actor
		registered.

		physicsWorld -- An love.World instance.

		Optional Arguments:

		position -- an object of the form {x=<int>, y=<int>}
		containing the starting position within the
		world. [default:{x=0, y=0}]
		
	]]
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
	--[[
		
		Actor Initialization function, for functionality that needs to
		be called after an Actor instance has been created.

		Return Value:

		- Returns the actor instance (Builder Pattern)

		Notes:

		- This gets called in World:create* for objects which inherit
          actor instances.

	]]
	
	self:init_physics()
	return self
end

function Actor:init_physics()
	--[[

		The physics component initialization. This gets called within
		Actor:init().

	]]
	self.physics:init()
end

function Actor:update(dt)
	--[[

		Actor's receive calls from love:update(dt)

	]]

	self:update_animation(dt)
	self:move()
end

function Actor:update_animation(dt)
	--[[
		
		Includes animation management, with respect to the current
		actor's movement and direction.

	]]
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
	--[[
		
		Returns the position of the actor in the form {x=<val>,
		y=<val>}

		Notes:

		- Creating an actor with self.physics:setEnabled(false) does
          not generate a self.physics.body. Thus, the included actor
          property.

	]]
	if self.physics.body then
		return {x=self.physics.body:getX(), y=self.physics.body:getY()}
	end
	return self.position
end

function Actor:setPosition(x, y)
	--[[

		Set the position of the actor

	]]
	if self.physics.body then
		self.physics.body:setPosition(x, y)
	end
	self.position.x = x
	self.position.y = y
	self:redraw()
	return self
end

function Actor:redraw()
	--[[

		Tells the graphics engine to redraw the actor. This should be
		called after changes made in the self.graphics component.
		
		Notes:

		- This is somewhat deprecated in favour of
          self.graphics:set(... performing a ActorEngine:redrawTile
          automatically.

	]]
	self.graphics:redraw()
end

function Actor:getDimensions()
	--[[

		Gets the actor dimensions in world units. This is returned in
		the form {w=<width>, h=<height>, x=<x-position>,
		y=<y-position>}

	]]

	return self.graphics:getDimensions()
end

function Actor:getTileDimensions()
	--[[

		Same as Actor:getDimensions(), except the returned dimensions
		are expressed in an approximate tile position.

	]]
	local dims = self:getDimensions()
	return {
		x = TILE_UNIT(dims.x),
		y = TILE_UNIT(dims.y),
		w = TILE_UNIT(dims.w),
		h = TILE_UNIT(dims.h),
	}
end

function Actor:action_proximity_in(collidable)
	--[[

		Represents an action callback for physics contacts, when this
		object collides with, and is currently making contact with
		another collidable object.

		Keyword Arguments:

		collidable -- represents another object that is current
		colliding with this actor.

		Notes:

		- Thie method currently maintains a self.proximity list, which
          is useful for Actor:action_use()

		- actors and tiles can become collidable when they are both
          'useable' and come into contact with eachother. Given the
          tile, t, t.physics:setUseable(true).

		- Actors by default are useable.

	]]
	if not f.has(self.proximity, collidable) then
		table.insert(self.proximity, collidable)
	end
end

function Actor:action_proximity_out(collidable)
	--[[

		Represents an action callback for physics contacts, when this
		object stops colliding with, and is currently not making
		contact with another collidable object.

		Keyword Arguments:

		collidable -- represents another object that is a currently
		colliding with this actor.

	]]
	self.proximity = f.filter(
		self.proximity,
		function(i) return i ~= collidable end)
end

function Actor:action_use()
	--[[
		
		Actors which are 'useable' should overload this to provide
		functionality. This action is called when another actor
		performs an Actor:use_proximity() call.

	]]
end

function Actor:use_proximity()
	--[[

		Uses all collidables that are within proximity.

	]]
	
	-- use a collidable that is within proximity
	for _, collidable in ipairs(self.proximity) do
		collidable:action_use(self)
	end
end

function Actor:isHidden()
	--[[

		Returns whether the current actor is hidden (ie. not being
		drawn, and not collidable or moveable)

	]]
	return self.graphics:isHidden()
end

function Actor:setHidden(bool)
	--[[

		Sets whether the current actor is hidden.

		Notes:

		- Actors that are hidden are not collidable, cannot be moved,
		and are not drawn on the screen.

	]]
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
	--[[
		
		Moves the current actor with respect to the property
		self.movement.

		Notes:

		- Modifying the values within self.movement allows you to
          change the movement direction and speed.

	]]
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
