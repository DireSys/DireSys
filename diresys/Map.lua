--[[
	Represents a map
]]
require "diresys/utils"
pp = require "diresys/pp"
config = require "config"
f = require "diresys/func"
assets = require "diresys/assets"
TileEngine = require "diresys/TileEngine"
ActorEngine = require "diresys/ActorEngine"
FloorTile = require "diresys/FloorTile"
WallTile = require "diresys/WallTile"
DoorTile = require "diresys/DoorTile"
VerticalDoorTile = require "diresys/VerticalDoorTile"
TableTile = require "diresys/TableTile"
PlantTile = require "diresys/PlantTile"
ClosetTile = require "diresys/ClosetTile"
Player = require "diresys/Player"
Alien = require "diresys/Alien"
lights = require "diresys/lights"

local Map = {}

function Map:new(options)
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	
	obj.currentPlayer = nil
	obj.viewport = {x=0, y=0}	

	love.physics.setMeter(config.PHYSICS_SCALE)
	obj.physicsWorld = love.physics.newWorld(0, 0, true)
	obj.physicsWorld:setCallbacks(obj.physicsContactBegin,
								   obj.physicsContactEnd)
	obj.tileEngine = TileEngine:new(obj.physicsWorld)
	obj.actorEngine = ActorEngine:new(obj.physicsWorld)
	obj.lightSourceList = {}

    obj.backgroundMusic = nil

	return obj
end

function Map:updateViewport()
	local playerPosition = self.currentPlayer:getPosition()
	local playerDims = self.currentPlayer:getDimensions()
	-- viewport needs to be in the center of the player
	self.viewport.x = (-playerPosition.x +
						   config.WINDOW_WIDTH/2 - playerDims.w/2) *
		config.WINDOW_SCALE
	self.viewport.x = math.floor(self.viewport.x)

	self.viewport.y = (-playerPosition.y +
						   config.WINDOW_HEIGHT/2 - playerDims.h/2) *
		config.WINDOW_SCALE
	self.viewport.y = math.floor(self.viewport.y)
end

function Map:draw()
	local viewx = self.viewport.x
	local viewy = self.viewport.y

    if self.backgroundMusic and not self.backgroundMusic:isPlaying() then
        self.backgroundMusic:play()
    end

	self.tileEngine:draw_tiles(viewx, viewy, 1)
	self.actorEngine:draw_actors(viewx, viewy, 1)
	self.tileEngine:draw_tiles(viewx, viewy, 2)
	self.tileEngine:draw_shadows(viewx, viewy, 3)
end

function Map:update(dt)
	self.physicsWorld:update(dt)
	self.tileEngine:update(dt)
	self.actorEngine:update(dt)
	self:updateViewport()
	self:updateLightSources(dt)
end

function Map:updateLightSources(dt)
	for _, lightSource in ipairs(self.lightSourceList) do
		lightSource:update(dt)
	end
end

function Map:getTileList()
	return self.tileEngine.tilemap
end

function Map:getTile(tilex, tiley)
	return self.tileEngine:get_tile(tilex, tiley)
end

function Map:refreshTiles()
	self.tileEngine:reset(1)
	self.tileEngine:reset(2)
end

function Map:createFloor(tilex, tiley)
	local position = {
		x = WORLD_UNIT(tilex),
		y = WORLD_UNIT(tiley)
	}
	local floorTile = FloorTile:new(self.tileEngine, self.physicsWorld,
									{position=position}):init()
	self.tileEngine:add_tile(floorTile, tilex, tiley)
	return floorTile
end

function Map:createDoor(tilex, tiley)
	local position = {
		x = WORLD_UNIT(tilex),
		y = WORLD_UNIT(tiley)
	}
	local doorTile = DoorTile:new(self.tileEngine, self.physicsWorld,
								  {position=position}):init()
	self.tileEngine:add_tile(doorTile, tilex, tiley)
	return doorTile
end

function Map:createVerticalDoor(tilex, tiley)
	local position = {
		x = WORLD_UNIT(tilex),
		y = WORLD_UNIT(tiley)
	}
	local doorTile = VerticalDoorTile:new(self.tileEngine, self.physicsWorld,
										  {position=position}):init()
	self.tileEngine:add_tile(doorTile, tilex, tiley)
	return doorTile
end

function Map:createWall(tilex, tiley)
	local position = {
		x = WORLD_UNIT(tilex),
		y = WORLD_UNIT(tiley)
	}
	local wallTile = WallTile:new(self.tileEngine, self.physicsWorld,
								  {position=position}):init()
	self.tileEngine:add_tile(wallTile, tilex, tiley)
	return wallTile
end

function Map:createPlayer(tilex, tiley)
	local position = {
		x = WORLD_UNIT(tilex),
		y = WORLD_UNIT(tiley)
	}
	local player = Player:new(self.actorEngine, self.physicsWorld,
							  {position=position}):init()
	self.actorEngine:add_actor(player)
	self.currentPlayer = player
	return player
end

function Map:createAlien(tilex, tiley)
	local position = {
		x = WORLD_UNIT(tilex),
		y = WORLD_UNIT(tiley)
	}
	local alien = Alien:new(self.actorEngine, self.physicsWorld,
							{position=position}):init()
	self.actorEngine:add_actor(alien)
	return alien
end

function Map:createTable(tilex, tiley)
	local position = {
		x = WORLD_UNIT(tilex),
		y = WORLD_UNIT(tiley)
	}
	local tableTile = TableTile:new(self.tileEngine, self.physicsWorld,
									{position=position}):init()
	self.tileEngine:add_tile(tableTile, tilex, tiley)
	return tableTile
end

function Map:createPlant(tilex, tiley)
	local position = {
		x = WORLD_UNIT(tilex),
		y = WORLD_UNIT(tiley)
	}
	local plantTile = PlantTile:new(self.tileEngine, self.physicsWorld,
									{position=position}):init()
	self.tileEngine:add_tile(plantTile, tilex, tiley)
	return plantTile
end

function Map:createCloset(tilex, tiley)
	local position = {
		x = WORLD_UNIT(tilex),
		y = WORLD_UNIT(tiley)
	}
	local closetTile = ClosetTile:new(self.tileEngine, self.physicsWorld,
									{position=position}):init()
	self.tileEngine:add_tile(closetTile, tilex, tiley)
	return closetTile
end

function Map:createOmniLight(tilex, tiley)
	local position = {
		x = WORLD_UNIT(tilex),
		y = WORLD_UNIT(tiley)
	}
	local omniLight = lights.OmniLightSource:new(self.tileEngine, {position=position})
	table.insert(self.lightSourceList, omniLight)
	return omniLight
end

function Map.physicsContactBegin(fixtureA, fixtureB)
	local objecta = fixtureA:getUserData() or nil
	local objectb = fixtureB:getUserData() or nil
	
	-- self.physics:setUseable(true) in tiles or actors that you want
	-- to collide
	if not objecta or not objectb then
		return
	end

	objecta:action_proximity_in(objectb)
	objectb:action_proximity_in(objecta)
end

function Map.physicsContactEnd(fixtureA, fixtureB)
	local objecta = fixtureA:getUserData() or nil
	local objectb = fixtureB:getUserData() or nil
	
	-- self.physics:setUseable(true) in tiles or actors that you want
	-- to collide
	if not objecta or not objectb then
		return
	end

	objecta:action_proximity_out(objectb)
	objectb:action_proximity_out(objecta)
end

function Map:setBackgroundMusic(asset_name)

    self.backgroundMusic = assets.get_music(asset_name)
	self.backgroundMusic:setVolume(0.5)
end

return Map
