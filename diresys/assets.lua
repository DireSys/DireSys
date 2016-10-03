--[[
	Used to retrieve the sprites from the spritesheet
]]
config = require("config")

local assets = {}

function load_sprite(sprite_name, tilex, tiley, width, height)
	local image_width = assets.sprite_image:getWidth()
	local image_height = assets.sprite_image:getHeight()
	local quad = love.graphics.newQuad(
		tilex * config.TILE_SIZE,
		tiley * config.TILE_SIZE,
		width, height,
		image_width, image_height)
	assets[sprite_name] = quad
end

function assets.get_sprite(sprite_name)
	return assets[sprite_name]
end

function assets.load_assets()
	assets.sprite_image = love.graphics.newImage(config.SPRITESHEET_FILENAME)
	assets.sprite_image:setFilter("nearest", "nearest")

	-- Player
	load_sprite("player_down0", 0, 4, 8, 8)
	load_sprite("player_down1", 1, 4, 8, 8)
	load_sprite("player_down2", 2, 4, 8, 8)
	load_sprite("player_down3", 3, 4, 8, 8)

end

return assets
