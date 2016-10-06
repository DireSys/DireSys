--[[
	Tile object, which is drawn to the screen
]]
require "diresys/utils"
config = require "config"
f = require "diresys/func"
assets = require "diresys/assets"
gfx = require "diresys/gfx"
phys = require "diresys/phys"
local Tile = {
	
}

function Tile:new(parent, physicsWorld, options)
	local options = options or {}
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	obj.options = options or {}
	obj.parent = parent
	obj.physics_world = physicsWorld
	obj.position = options.position or {x=0, y=0}
	obj.bounds_type = "plain" -- "plain", "wall"
	obj.parent_type = "tile"
	obj.type = "tile"

	obj.physics = phys.TilePhysics:new(obj, physicsWorld)
	obj.graphics = gfx.TileGraphics:new(obj, parent)

	-- list of actors in proximity
	obj.proximity = {}

	return obj
end

function Tile:update(dt)
	--Runs in love.update(dt)
end

function Tile:init_physics()
	self.physics:init()
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
	self:redraw()
	return self
end

function Tile:redraw()
	self.graphics:redraw()
end

function Tile:getDimensions()
	local startx = nil
	local endx = nil
	local starty = nil
	local endy = nil
	local tags = f.pluck(self.graphics:getAll(), "tag")
	for _, tag in ipairs(tags) do
		local dim = self.graphics:getDimensions(tag)
		if dim ~= nil then
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

function Tile:checkPoint(x, y)
	-- checks if the given world coordinate point is within the tile
	local dims = self:getDimensions()
	if x < dims.x or x >= (dims.x + dims.w) then
		return false
	end

	if y < dims.y or x >= (dims.x + dims.h) then
		return false
	end

	return true
end

function Tile:checkTilePoint(tilex, tiley)
	-- same as Tile:checkPoint, but in tile units
	return self:checkPoint(WORLD_UNIT(tilex), WORLD_UNIT(tiley))
end

function Tile:updateBounds(walls, front)

end

return Tile
