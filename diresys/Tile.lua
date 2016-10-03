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
		{key = nil, offset = {0, 0}}, -- layer 1
		{key = nil, offset = {0, 0}}, -- layer 2
	}

	return obj
end

function Tile:update(dt)
	--nothing here
end

function Tile:init_physics()
	return nil
end

function Tile:get_tile_position()
	local position = self:get_position()
	return math.floor(position.x / config.TILE_SIZE),
	math.floor(position.y / config.TILE_SIZE)
end

function Tile:get_tile_dimensions()
	local startx, starty = self:get_tile_position()
	local width1, height1 = self:get_dimensions(1)
	width1 = (width1 and math.floor(width1 / config.TILE_SIZE) or 1) - 1
	width1 = width1 + self.graphics[1].offset[1]
	height1 = (height1 and math.floor(height1 / config.TILE_SIZE) or 1) - 1
	height1 = height1 + self.graphics[1].offset[2]

	local width2, height2 = self:get_dimensions(2)
	width2 = (width2 and math.floor(width2 / config.TILE_SIZE) or 1) - 1
	width2 = width2 + self.graphics[2].offset[1]
	height2 = (height2 and math.floor(height2 / config.TILE_SIZE) or 1) - 1
	height2 = height2 + self.graphics[2].offset[2]

	local width = width1 > width2 and width1 or width2
	local height = height1 > height2 and height1 or height2
	return {
		startx = startx, endx = startx + width,
		starty = starty, endy = starty + height,
	}
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

function Tile:set_graphic(key, layer)
	local layer = layer or 1
	self.graphics[layer].key = key
	if self.parent then self.parent:reset(layer) end
	return self
end

function Tile:get_graphic(layer)
	local layer = layer or 1
	local key = self.graphics[layer].key
	return assets.get_sprite(key)
end

function Tile:get_dimensions(layer)
	local layer = layer or 1
	local quad = self:get_graphic(layer)
	if quad then
		local x, y, w, h = quad:getViewport()
		return w, h
	else
		return nil
	end
end

return Tile
