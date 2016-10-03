--[[
	Tile object, which is drawn to the screen
]]
config = require "config"
assets = require "diresys/assets"

local Tile = {
	
}

function Tile:new(position, options)
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	obj.position = position
	obj.type = "empty"

	-- TODO: add physics fixture
	obj.physics = nil
	obj.graphics = {
		key = nil
	}

	return obj
end

function Tile:init_physics()
	
end

function Tile:get_position()
	return self.position
end

function Tile:set_position(x, y)
	self.position.x = x
	self.position.y = y
end

function Tile:set_graphic(key)
	--set a graphic based on asset key in assets
	self.graphics.key = key
end

function Tile:get_graphic()
	local key = self.graphics.key
	return assets.get_sprite(key)
end

return Tile
