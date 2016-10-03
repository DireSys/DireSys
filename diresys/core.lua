--[[
	Main entry to the game
]]
pp = require "diresys/pp"
config = require "config"
assets = require "diresys/assets"
TileEngine = require "diresys/tile_engine"
tile = require "diresys/tile"

local core = {}

function core.load()
	love.window.setMode(config.WINDOW_WIDTH * config.WINDOW_SCALE,
						config.WINDOW_HEIGHT * config.WINDOW_SCALE,
						{})
	love.window.setTitle("DireSys")
	assets.load_assets()

	tileEngine = TileEngine:new()
	playerTile = tile:new({x=0, y=0})
	playerTile:set_graphic("player_down0")
	tileEngine:add_tile(10, 10, playerTile)
end

function core.draw()
	--love.graphics.draw(assets.sprite_image)
	tileEngine:draw_tiles(10, 10)
end

function core.update(dt)

end

return core
