--[[

	Tile object, which is drawn to the screen at a designated tile
	position.

	Notes:

	- Calling this a Tile can be a bit misleading. A tile can actually
      consist of several sub-tiles, which can exist on different
      layers. Layers are explained in gfx.lua

]]
require "diresys/utils"
config = require "config"
f = require "diresys/func"
assets = require "diresys/assets"
gfx = require "diresys/gfx"
phys = require "diresys/phys"
lights = require "diresys/lights"

local Tile = {}

function Tile:new(parent, physicsWorld, options)
	--[[

		Instantiation of Tile

		Keyword Arguments:

		parent -- A TileEngine instance

		physicsWorld -- a love.World instance (Box2d World)

		Optional Arguments:

		position -- represents the world coordinate position of this
		tile, usually placed at a multiple of
		config.TILE_SIZE. [default: {x=0, y=0}]

	]]
	local options = options or {}
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	obj.options = options or {}
	obj.parent = parent
	obj.physics_world = physicsWorld
	obj.position = options.position or {x=0, y=0}
	
	-- Represents what type of tile this is. Used primarily for
	-- second-pass in map generation.
	obj.bounds_type = "plain" -- "plain", "wall", "none"

	obj.parent_type = "tile"
	obj.type = "tile"

	obj.physics = phys.TilePhysicsComponent:new(obj, physicsWorld)
	obj.graphics = gfx.TileGraphicsComponent:new(obj, parent)
	obj.light = lights.LightComponent:new(obj, parent)

	-- list of actors in proximity
	obj.proximity = {}

	return obj
end

function Tile:update(dt)
	--Runs in love.update(dt)
end

function Tile:init()
	--[[

		Tile initialization occurs in world creation.
		
	]]
	self:init_light()
	self:init_physics()
	return self
end

function Tile:init_light()
	self.light:init()
end

function Tile:init_physics()
	self.physics:init()
end

function Tile:getTilePosition()
	--[[

		Returns the Tile coordinate of the tile.

	]]
	local position = self:getPosition()
	return TILE_UNIT(position.x), TILE_UNIT(position.y)
end

function Tile:getPosition()
	--[[

		Returns the world coordinate location of the tile in the form
		{x=<number>, y=<number>}

	]]
	if self.physics.body then
		return {x=self.physics.body:getX(), y=self.physics.body:getY()}
	end
	return self.position
end

function Tile:setPosition(x, y)
	--[[

		Sets the position of the tile

		Notes:

		- It is not recommended that you change the position of the
          tile, given how tiles are stored in the tile engine.
		
	]]
	if self.physics.body then
		self.physics.body:setPosition(x, y)
	end
	self.position.x = x
	self.position.y = y
	self:redraw()
	return self
end

function Tile:redraw()
	--[[
		
		Redraws the tile.

		Notes:

		-- This is usually drawed after an animation frame has
		changed.

	]]

	self.graphics:redraw()
end

function Tile:getDimensions()
	--[[

		Returns the rectangular dimension bounds of the current tile
		in the form {w=<width>, h=<height>, x=<number>, y=<number>}

		Notes:

		- Returns each of the values in World Coordinates

		- This currently doesn't provide the tile's origin.

	]]
	return self.graphics:getDimensions()
end

function Tile:getTileDimensions()
	--[[
		
		Returns the rectangular dimension bounds of the current tile
		in Tile coordinates.

	]]
	local dims = self:getDimensions()
	return {
		x = TILE_UNIT(dims.x),
		y = TILE_UNIT(dims.y),
		w = TILE_UNIT(dims.w),
		h = TILE_UNIT(dims.h),
	}
end

function Tile:action_proximity_in(actor)
	--[[

		Explained in Actor.lua

	]]
	if not f.find(self.proximity, function(i) return i == actor end) then
		table.insert(self.proximity, actor)
	end
end

function Tile:action_proximity_out(actor)
	--[[

		Explained in Actor.lua
		
	]]
	self.proximity = f.filter(self.proximity, function(i) return i ~= actor end)
end

function Tile:action_use()
	-- if the tile is useable by an actor, it should overload this.
end

function Tile:checkPoint(x, y)
	--[[

		Checks to see if the given world coordinate lies within the
		bounds of this tile. Returns true if it does.
	
		Keyword Arguments:

		x -- The x-coordinate to check in world coordinates

		y -- The y-coordinate to check in world coordinates
	
		Notes:

		- Given that Tiles can extend to cover more than a single
          tile's dimensions, it is possible to have more than one tile
          be truthy on the same world coordinate.

	]]
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
	-- intentionally left blank, overridden. This is called on any
	-- tile that has a bounds_type --> "wall"
end

return Tile
