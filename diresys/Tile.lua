--[[
	Tile object, which is drawn to the screen
]]
require "diresys/utils"
config = require "config"
f = require "diresys/func"
assets = require "diresys/assets"
gfx = require "diresys/gfx"

local Tile = {
	
}

function Tile:new(parent, physics_world, options)
	local options = options or {}
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	obj.options = options or {}
	obj.parent = parent
	obj.physics_world = physics_world
	obj.position = options.position or {x=0, y=0}
	obj.parent_type = "tile"
	obj.type = "tile"

	obj.physics = {}
	obj.graphics = gfx.TileGraphics:new(obj, parent)

	-- list of actors in proximity
	obj.proximity = {}

	return obj
end

function Tile:update(dt)
	--Runs in love.update(dt)
end

function Tile:init_physics()
	--Should be called in order to initialize any physics body with
	--fixtures
	return nil
end

function Tile:getTilePosition()
	--Returns the tilex, tiley location of the current tile
	local position = self:getPosition()
	return TILE_UNIT(position.x), TILE_UNIT(position.y)
end

function Tile:getPosition()
	if self.physics.body then
		return {x=self.physics.body:getX(), y=self.physics.body:getY()}
	end
	return self.position
end

function Tile:setPosition(x, y)
	if self.physics.body then
		self.physics.body:setPosition(x, y)
	end
	self.position.x = x
	self.position.y = y
	if self.parent then self.parent:reset() end
	return self
end

function Tile:getDimensions()
	--TODO: determine a tile's dimensions from the accumulation of
	--graphics quads
	local startx = nil
	local endx = nil
	local starty = nil
	local endy = nil
	local tags = f.pluck(self.graphics:getAll(), "tag")
	for _, tag in ipairs(tags) do
		local dim = self.graphics:getDimensions(tag)
		if startx == nil or dim.x < startx then
			startx = dim.x
		end

		if starty == nil or dim.y < starty then
			starty = dim.y
		end

		if endx == nil or (dim.x + dim.w) > endx then
			endx = (dim.x + dim.w)
		end

		if endy == nil or (dim.y + dim.h) > endy then
			endy = (dim.y + dim.h)
		end
	end

	return {
		x = startx,
		y = starty,
		w = endx - startx,
		h = endy - starty,
	}
end

function Tile:getTileDimensions()
	local dims = self:getDimensions()
	return {
		x = TILE_UNIT(dims.x),
		y = TILE_UNIT(dims.y),
		w = TILE_UNIT(dims.w),
		h = TILE_UNIT(dims.h),
	}
end

function Tile:action_proximity_in(actor)
	if not f.find(self.proximity, function(i) return i == actor end) then
		table.insert(self.proximity, actor)
	end
end

function Tile:action_proximity_out(actor)
	self.proximity = f.filter(self.proximity, function(i) return i ~= actor end)
end

function Tile:action_use()
	-- if the tile is useable by an actor, it should overload this.
end

return Tile
