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

	return obj
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

return Actor
