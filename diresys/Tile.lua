--[[
	Tile object, which is drawn to the screen
]]
config = require "config"
assets = require "diresys/assets"

local Tile = {
	
}

function Tile:new(parent, physics_world, options)
	local options = options or {}
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	obj.parent = parent
	obj.physics_world = physics_world
	obj.position = position or {x=0, y=0}
	obj.type = "tile"

	-- TODO: add physics fixture
	obj.physics = {}
	obj.graphics = {
		key = nil,
	}

	return obj
end

function Tile:update(dt)
	--nothing here
end

function Tile:init_physics()
	return nil
end

function Tile:get_position()
	if self.physics.body then
		return {x=self.physics.body:getX(), y=self.physics.body:getY()}
	end
	return self.position
end

function Tile:set_position(x, y)
	if self.physics.body then
		self.physics.body:setPosition(x, y)
	end
	self.position.x = x
	self.position.y = y
	if self.parent then self.parent:reset() end
	return self
end

function Tile:set_graphic(key)
	--set a graphic based on asset key in assets
	self.graphics.key = key
	if self.parent then self.parent:reset() end
	return self
end

function Tile:get_graphic()
	local key = self.graphics.key
	return assets.get_sprite(key)
end

function Tile:get_dimensions()
	local quad = self:get_graphic()
	local x, y, w, h = quad:getViewport()
	return w, h
end

return Tile
