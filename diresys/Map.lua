--[[
	Represents a map
]]
config = require "config"
f = require "diresys/func"
TileEngine = require "diresys/TileEngine"
ActorEngine = require "diresys/ActorEngine"
FloorTile = require "diresys/FloorTile"
WallTile = require "diresys/WallTile"
DoorTile = require "diresys/DoorTile"
Player = require "diresys/Player"

local Map = {}

function Map:new(options)
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	
	obj.currentPlayer = nil
	obj.viewport = {x=0, y=0}	

	love.physics.setMeter(config.PHYSICS_SCALE)
	obj.physics_world = love.physics.newWorld(0, 0, true)
	obj.tileEngine = TileEngine:new(obj.physics_world)
	obj.actorEngine = ActorEngine:new(obj.physics_world)
	return obj
end

function Map:updateViewport()
	local playerPosition = self.currentPlayer:get_position()
	local playerWidth, playerHeight = self.currentPlayer:get_dimensions()
	-- viewport needs to be in the center of the player
	self.viewport.x = (-playerPosition.x +
						   config.WINDOW_WIDTH/2 - playerWidth/2) *
		config.WINDOW_SCALE
	self.viewport.y = (-playerPosition.y +
						   config.WINDOW_HEIGHT/2 - playerHeight/2) *
		config.WINDOW_SCALE
end

function Map:draw()
	local viewx = self.viewport.x
	local viewy = self.viewport.y

	self.tileEngine:draw_tiles(viewx, viewy, 1)
	self.actorEngine:draw_actors(viewx, viewy)
	self.tileEngine:draw_tiles(viewx, viewy, 2)
	self.tileEngine:draw_shadows(viewx, viewy)
end

function Map:update(dt)
	self.physics_world:update(dt)
	self.tileEngine:update(dt)
	self.actorEngine:update(dt)
	self:updateViewport()
end

function Map:getTileList()
	return self.tileEngine.tilemap
end

function Map:getTile(tilex, tiley)
	local tile = f.find(
		self:getTileList(),
		function(t)
			local dims = t:get_tile_dimensions()
			if tilex < dims.startx or tilex > dims.endx then
				return false
			end

			if tiley < dims.starty or tiley > dims.endy then
				return false
			end
			
			return true
	end)

	return tile or nil
end

function Map:createFloor(tilex, tiley)
	local floorTile = FloorTile:new(self.tileEngine, self.physics_world)
	floorTile:set_position(tilex*config.TILE_SIZE, tiley*config.TILE_SIZE)
	self.tileEngine:add_tile(floorTile)
	return floorTile
end

function Map:createDoor(tilex, tiley)
	local doorTile = DoorTile:new(self.tileEngine, self.physics_world)
	doorTile:set_position(tilex*config.TILE_SIZE, tiley*config.TILE_SIZE)
	self.tileEngine:add_tile(doorTile)
	return doorTile
end

function Map:createWall(tilex, tiley)
	local wallTile = WallTile:new(self.tileEngine, self.physics_world)
	wallTile:set_position(tilex*config.TILE_SIZE, tiley*config.TILE_SIZE)
	self.tileEngine:add_tile(wallTile)
	return wallTile
end

function Map:createPlayer(tilex, tiley)
	local player = Player:new(self.actorEngine, self.physics_world)
	player:set_position(tilex*config.TILE_SIZE, tiley*config.TILE_SIZE)
	self.actorEngine:add_actor(player)
	self.currentPlayer = player
	return player
end

return Map
