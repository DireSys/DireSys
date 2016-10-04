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

    -- idle - down-left
	load_sprite("player_idle_DL_0", 4, 4, 8, 8)
	load_sprite("player_idle_DL_1", 6, 4, 8, 8)
    -- idle - down-right
	load_sprite("player_idle_DR_0", 0, 4, 8, 8)
	load_sprite("player_idle_DR_1", 2, 4, 8, 8)
    -- idle - up-left
	load_sprite("player_idle_UL_0", 12, 4, 8, 8)
	load_sprite("player_idle_UL_1", 14, 4, 8, 8)
    -- idle - up-right
	load_sprite("player_idle_UR_0", 8, 4, 8, 8)
	load_sprite("player_idle_UR_1", 10, 4, 8, 8)

    -- run - down-left
	load_sprite("player_run_DL_0", 4, 6, 8, 8)
	load_sprite("player_run_DL_1", 6, 6, 8, 8)
    -- run - down-right
	load_sprite("player_run_DR_0", 0, 6, 8, 8)
	load_sprite("player_run_DR_1", 2, 6, 8, 8)
    -- run - up-left
	load_sprite("player_run_UL_0", 12, 6, 8, 8)
	load_sprite("player_run_UL_1", 14, 6, 8, 8)
    -- run - up-right
	load_sprite("player_run_UR_0", 8, 6, 8, 8)
	load_sprite("player_run_UR_1", 10, 6, 8, 8)

    --
	--
	-- Floor Tiles
	--
	load_sprite("floor0", 0, 3)
	
	--
	-- Wall Tiles
	--
	-- TRBL --> Top, Right, Bottom, Left edge has wall
	load_sprite("wall_T__L", 0, 12)
	load_sprite("wall_T_B_", 1, 12)
	load_sprite("wall_TR__", 2, 12)
	load_sprite("wall___B_", 1, 16)
	load_sprite("wall__R_L", 0, 13)
	load_sprite("wall__R__", 3, 13)
	load_sprite("wall_____", 4, 13)
	load_sprite("wall____L", 5, 13)
	load_sprite("wall___BL", 0, 16)
	load_sprite("wall__RB_", 2, 16)
	load_sprite("wall_TRBL", 7, 13)
	load_sprite("wall_T___", 4, 14)

	--
	-- Door Tiles
	--
	load_sprite("hdoor_upper0", 9, 15, 12, 4)
	load_sprite("hdoor_upper1", 12, 15, 12, 4)
	load_sprite("hdoor_upper2", 15, 15, 12, 4)
	load_sprite("hdoor_upper3", 18, 15, 12, 4)
	load_sprite("hdoor_upper4", 21, 15, 12, 4)
	load_sprite("hdoor_lower0", 9, 16, 12, 4)
	load_sprite("hdoor_lower1", 12, 16, 12, 4)
	load_sprite("hdoor_lower2", 15, 16, 12, 4)
	load_sprite("hdoor_lower3", 18, 16, 12, 4)
	load_sprite("hdoor_lower4", 21, 16, 12, 4)
end

return assets
