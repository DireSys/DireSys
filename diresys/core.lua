--[[
	Main entry to the game
]]
pp = require "diresys/pp"
config = require "config"
assets = require "diresys/assets"
dbg = require "diresys/dbg"
TileEngine = require "diresys/TileEngine"
Tile = require "diresys/Tile"
Map = require "diresys/Map"
MapGenerator = require "diresys/MapGenerator"

local core = {}

local viewport = {
	x = 0,
	y = 0,
}

function core.load()
	love.graphics.setFont(love.graphics.newFont(10))
	love.window.setMode(config.WINDOW_WIDTH * config.WINDOW_SCALE,
						config.WINDOW_HEIGHT * config.WINDOW_SCALE,
						{})
	love.window.setTitle("DireSys")
	assets.load_assets()
	
	map = MapGenerator.load_file("./assets/map0.txt")
	--[[map = Map:new()
	for i = 0, 5 do
		for j = 0, 5 do
			map:createFloor(i, j)
		end
	end
	
	for i = 0, 5 do
		map:createWall(i, 6)
	end
	
	map:createPlayer(3, 3)
	]]
end

function core.draw()
	map:draw(0, 0)
	dbg.draw()
end

function core.update(dt)
	map:update(dt)
end

function core.keypressed(key)
	dbg.print("Key Pressed: " .. key)
	if key == "up" then
		map.currentPlayer.movement.up = true
	elseif key == "down" then
		map.currentPlayer.movement.down = true
	elseif key == "left" then
		map.currentPlayer.movement.left = true
	elseif key == "right" then
		map.currentPlayer.movement.right = true
	elseif key == "space" then
		map.currentPlayer:use_proximity()
	end
end

function core.keyreleased(key)
	dbg.print("Key Released: " .. key)
	if key == "up" then
		map.currentPlayer.movement.up = false
	elseif key == "down" then
		map.currentPlayer.movement.down = false
	elseif key == "left" then
		map.currentPlayer.movement.left = false
	elseif key == "right" then
		map.currentPlayer.movement.right = false
	end
end
return core
