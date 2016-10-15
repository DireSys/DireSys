--[[

	Represents a playable Map. This brings together the tiles, actors,
	sounds, physics, etc.

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
hud = require "diresys/hud"

local Map = {}

function Map:new(options)
	--[[

		Instantiates a map

		Optional Arguments:

		/nothing here/

	]]
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	-- Player instance, which is currently playing on the map.
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
	--[[

		Updates the viewport based on the current player's position.

	]]
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
	--[[

		passed to love.draw. This draws the map, with all of the
		actors and tiles

		Notes:

		- Note the order of draw calls between the tile engine and the
          actor engine.

	]]
	local viewx = self.viewport.x
	local viewy = self.viewport.y

    if self.backgroundMusic and not self.backgroundMusic:isPlaying() then
        self.backgroundMusic:play()
    end

	self.tileEngine:draw_tiles(viewx, viewy, 1)
	self.actorEngine:draw_actors(viewx, viewy, 1)
	self.tileEngine:draw_tiles(viewx, viewy, 2)
	self.tileEngine:draw_shadows(viewx, viewy, 3)
	hud.draw()
end

function Map:update(dt)
	--[[

		Update function passed to love.update.

	]]
	self.physicsWorld:update(dt)
	self.tileEngine:update(dt)
	self.actorEngine:update(dt)
	self:updateViewport()
	self:updateLightSources(dt)
end

function Map:updateLightSources(dt)
	--[[
		
		Passes along love.update() to the Tile Light Components.

	]]
	for _, lightSource in ipairs(self.lightSourceList) do
		lightSource:update(dt)
	end
end

function Map:getTileList()
	--[[

		Retrieves the map's list of tiles
		
	]]
	return self.tileEngine.tilemap
end

function Map:getTile(tilex, tiley)
	--[[

		Gets a tile at the given tile coordinate. Returns nil if the
		tile does not exist.

		Notes:

		- More info on this can be found in TileEngine:get_tile

	]]
	return self.tileEngine:get_tile(tilex, tiley)
end

function Map:refreshTiles()
	--[[

		Refreshes all of the tiles on the screen.

		Notes:
		
		- This is an expensive operation.

	]]
	self.tileEngine:reset(1)
	self.tileEngine:reset(2)
end

function Map:createFloor(tilex, tiley)
	--[[

		Create a FloorTile instance, and place it at the provided Tile
		Coordinate.

	]]
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
	--[[

		Create a DoorTile instance, and place it at the provided Tile
		Coordinate.

	]]
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
	--[[

		Create a VerticalDoorTile instance, and place it at the provided Tile
		Coordinate.

	]]
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
	--[[

		Create a WallTile instance, and place it at the provided Tile
		Coordinate.

	]]
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
	--[[

		Create an Player instance, and place it at the provided Tile
		Coordinate.

		Notes:

		- This will also assign the player to the map's
          self.currentPlayer.

	]]
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
	--[[

		Create an Alien instance, and place it at the provided Tile
		Coordinate.

	]]
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
	--[[

		Creates a TableTile instance, and places it at the provided
		Tile Coordinate.

	]]
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
	--[[

		Creates a PlantTile instance, and places it at the provided
		Tile Coordinate.

	]]
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
	--[[

		Creates a ClosetTile instance, and places it at the provided
		Tile Coordinate.

	]]
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
	--[[

		Creates an OmniLight instance, and places it at the provided
		Tile Coordinate.

		Notes:

		- This will also assign the light source to the
          self.lightSourceList.

	]]
	local position = {
		x = WORLD_UNIT(tilex),
		y = WORLD_UNIT(tiley)
	}
	local omniLight = lights.OmniLightSource:new(self.tileEngine, {position=position})
	table.insert(self.lightSourceList, omniLight)
	return omniLight
end

function Map.physicsContactBegin(fixtureA, fixtureB)
	--[[

		This is the callback function for when love.World begins
		contact between two body fixtures.
		
		Tiles and Actors can overload .action_proximity_in in order to
		change their behaviour for this situation.

		Notes:
		
		- Please also look at Tile:action_use and Actor:action_use.

	]]
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
	--[[

		This is the callback function for when love.World ends contact
		between two body fixtures.
		
		Tiles and Actors can overload .action_proximity_out in order to
		change their behaviour for this situation.

	]]
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
	--[[

		Sets the background music to the asset with the given name

		Keyword Arguments:

		asset_name -- name of the asset within assets.lua

	]]
    self.backgroundMusic = assets.get_music(asset_name)
	self.backgroundMusic:setVolume(0.5)
end

return Map
