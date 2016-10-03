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
	
	map = Map:new()
	for i = 0, 5 do
		for j = 0, 5 do
			map:createFloor(i, j)
		end
	end
	map:createPlayer(3, 3)
end

function core.draw()
	map:draw(0, 0)
	dbg.draw()
end

function core.update(dt)
	map.physics_world:update(dt)
end

function core.keypressed(key)
	dbg.print("Key Pressed: " .. key)
	if key == "space" then

	end
end

return core
