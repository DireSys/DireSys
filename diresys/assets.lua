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

	--
	-- Player
	--

	-- down movement
	load_sprite("player_down0", 0, 4, 8, 8)
	load_sprite("player_down1", 2, 4, 8, 8)
	load_sprite("player_down2", 4, 4, 8, 8)
	load_sprite("player_down3", 6, 4, 8, 8)

	-- up movement
	load_sprite("player_up0", 8, 4, 8, 8)
	load_sprite("player_up1", 10, 4, 8, 8)
	load_sprite("player_up2", 12, 4, 8, 8)
	load_sprite("player_up3", 14, 4, 8, 8)
	
	-- right movement
	load_sprite("player_right_down0", 0, 6, 8, 8)
	load_sprite("player_right_down1", 2, 6, 8, 8)
	load_sprite("player_right_up0", 8, 6, 8, 8)
	load_sprite("player_right_up1", 10, 6, 8, 8)

	-- left movement
	load_sprite("player_left_down0", 4, 6, 8, 8)
	load_sprite("player_left_down1", 6, 6, 8, 8)
	load_sprite("player_left_up0", 12, 6, 8, 8)
	load_sprite("player_left_up1", 14, 6, 8, 8)

	--
	-- Floor Tiles
	--
	load_sprite("floor0", 0, 3)
	
	--
	-- Wall Tiles
	--
	load_sprite("wall0", 7, 13)

end

return assets
