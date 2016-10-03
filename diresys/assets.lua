--[[
	Used to retrieve the sprites from the spritesheet
]]
config = require("config")

local assets = {}

function load_sprite(sprite_name, tilex, tiley, width, height)
	local width = width or 4
	local height = height or 4
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
	load_sprite("player_down1", 2, 4, 8, 8)
	load_sprite("player_down2", 4, 4, 8, 8)
	load_sprite("player_down3", 6, 4, 8, 8)

	-- Floor Tiles
	load_sprite("floor0", 0, 3)
	

end

return assets
