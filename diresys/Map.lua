--[[
	Represents a map
]]
config = require "config"
TileEngine = require "diresys/TileEngine"
ActorEngine = require "diresys/ActorEngine"
FloorTile = require "diresys/FloorTile"
Player = require "diresys/Player"

local Map = {}

function Map:new(options)
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	
	obj.currentPlayer = nil
	
	love.physics.setMeter(config.PHYSICS_SCALE)
	obj.physics_world = love.physics.newWorld(0, 9.8, true)
	obj.tileEngine = TileEngine:new(obj.physics_world)
	obj.actorEngine = ActorEngine:new(obj.physics_world)
	
	return obj
end

function Map:draw(viewx, viewy)
	self.tileEngine:draw_tiles(viewx, viewy)
	self.actorEngine:draw_actors(viewx, viewy)
	self.tileEngine:draw_shadows(viewx, viewy)
end

function Map:createFloor(tilex, tiley)
	local floorTile = FloorTile:new(self.tileEngine, self.physics_world)
	floorTile:set_position(tilex*config.TILE_SIZE, tiley*config.TILE_SIZE)
	self.tileEngine:add_tile(floorTile)
	return floorTile
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
