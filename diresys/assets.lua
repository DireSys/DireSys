--[[
	Used to retrieve the sprites from the sprite_image
]]
config = require("config")
pp = require("diresys/pp")

local assets = {
    sprite_image = nil,
    sprites = {},
    sounds = {},
    music = {}
}

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
	assets.sprites[sprite_name] = quad
end

function assets.get_sprite(sprite_name)
	if not sprite_name then return end
	local sprite = assets.sprites[sprite_name]
	if not sprite then
		print("Warning: Unable to get sprite '" ..
				  tostring(sprite_name) .. "', returning default sprite")
		return assets.sprites["default"]
	end
	return sprite
end

function load_music(asset_name, path, loop)

    local music = love.audio.newSource(path)
    music:setLooping(loop)
    assets.music[asset_name] = music

end

function assets.get_music(asset_name)
    return assets.music[asset_name]
end

function load_sound(asset_name, path)

    local sound = love.audio.newSource(path, "static")
    assets.sounds[asset_name] = sound

end

function assets.get_sound(asset_name)
    return assets.sounds[asset_name]
end

function assets.load_assets()
	assets.sprite_image = love.graphics.newImage(config.SPRITESHEET_FILENAME)
	assets.sprite_image:setFilter("nearest", "nearest")

	-- Default Sprite, when the one asked for isn't found
	load_sprite("default", 0, 18)

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
    -- cutaway portions of walls
	load_sprite("wall_____", 4, 13)
	load_sprite("wall_T___", 4, 14)
	load_sprite("wall__R__", 3, 13)
    load_sprite("wall___B_", 4, 12)
    load_sprite("wall____L", 5, 13)
	load_sprite("wall_TR__", 2, 12)
	load_sprite("wall_T_B_", 1, 12)
	load_sprite("wall_T__L", 0, 12)
    load_sprite("wall__RB_", 2, 14)
	load_sprite("wall__R_L", 0, 13)
	load_sprite("wall___BL", 0, 14)
	load_sprite("wall_TRB_", 5, 12)
	load_sprite("wall_TR_L", 3, 14)
	load_sprite("wall_T_BL", 3, 12)
	load_sprite("wall__RBL", 5, 14)
	load_sprite("wall_TRBL", 6, 12)

    -- front-facing portion of walls
	load_sprite("wall_front_____", 1, 13)
    load_sprite("wall_front__RB_", 2, 16)
	load_sprite("wall_front___BL", 0, 16)
	load_sprite("wall_front____L", 0, 15)
	load_sprite("wall_front__R__", 2, 15)
	load_sprite("wall_front___B_", 1, 16)

	--
	-- Door Tiles (Horizontal)
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

	--
	-- Door Tiles (Vertical)
	--
	load_sprite("vdoor_upper0", 9, 17, 4, 8)
	load_sprite("vdoor_upper1", 10, 17, 4, 8)
	load_sprite("vdoor_upper2", 11, 17, 4, 8)
	load_sprite("vdoor_upper3", 12, 17, 4, 8)
	load_sprite("vdoor_lower0", 9, 19, 4, 4)
	load_sprite("vdoor_lower1", 10, 19, 4, 4)
	load_sprite("vdoor_lower2", 11, 19, 4, 4)
	load_sprite("vdoor_lower3", 12, 19, 4, 4)

	--
	-- Table Tiles
	--
	load_sprite("table_upper0", 28, 18, 12, 4)
	load_sprite("table_upper1", 25, 18, 12, 4)
	load_sprite("table_lower0", 28, 19, 12, 8)
	load_sprite("table_lower1", 25, 19, 12, 8)

	--
	-- Plant Tiles
	--
	load_sprite("plant_upper0", 20, 8, 8, 4)
	load_sprite("plant_upper1", 22, 8, 8, 4)
	load_sprite("plant_lower0", 20, 9, 8, 4)
	load_sprite("plant_lower1", 22, 9, 8, 4)

	--
	-- Closet Tiles
	--
	load_sprite("closet_upper_hiding0", 13, 21, 8, 8)
	load_sprite("closet_upper_hiding1", 15, 21, 8, 8)
	load_sprite("closet_upper_hiding2", 17, 21, 8, 8)
	load_sprite("closet_upper_hiding3", 19, 21, 8, 8)
	load_sprite("closet_upper0", 19, 18, 8, 8)
	load_sprite("closet_upper1", 21, 18, 8, 8)
	load_sprite("closet_upper2", 23, 18, 8, 8)

	load_sprite("closet_lower_hiding0", 13, 23, 8, 4)
	load_sprite("closet_lower_hiding1", 15, 23, 8, 4)
	load_sprite("closet_lower_hiding2", 17, 23, 8, 4)
	load_sprite("closet_lower_hiding3", 19, 23, 8, 4)
	load_sprite("closet_lower0", 19, 20, 8, 4)
	load_sprite("closet_lower1", 21, 20, 8, 4)
	load_sprite("closet_lower2", 23, 20, 8, 4)

	--
	-- Alien
	--

	-- idle - down-left
	load_sprite("alien_idle_DL_0", 24, 4, 8, 8)
	load_sprite("alien_idle_DL_1", 26, 4, 8, 8)
    -- idle - down-right
	load_sprite("alien_idle_DR_0", 20, 4, 8, 8)
	load_sprite("alien_idle_DR_1", 22, 4, 8, 8)
    -- idle - up-left
	load_sprite("alien_idle_UL_0", 32, 4, 8, 8)
	load_sprite("alien_idle_UL_1", 34, 4, 8, 8)
    -- idle - up-right
	load_sprite("alien_idle_UR_0", 28, 4, 8, 8)
	load_sprite("alien_idle_UR_1", 30, 4, 8, 8)

    -- run - down-left
	load_sprite("alien_run_DL_0", 24, 6, 8, 8)
	load_sprite("alien_run_DL_1", 26, 6, 8, 8)
    -- run - down-right 
	load_sprite("alien_run_DR_0", 20, 6, 8, 8)
	load_sprite("alien_run_DR_1", 22, 6, 8, 8)
    -- run - up-left
	load_sprite("alien_run_UL_0", 32, 6, 8, 8)
	load_sprite("alien_run_UL_1", 34, 6, 8, 8)
    -- run - up-right
	load_sprite("alien_run_UR_0", 28, 6, 8, 8)
	load_sprite("alien_run_UR_1", 30, 6, 8, 8)

	--
	-- Light Intensities
	--
	load_sprite("light_intensity_0", 0, 0)
	load_sprite("light_intensity_1", 1, 0)
	load_sprite("light_intensity_2", 2, 0)
	load_sprite("light_intensity_3", 3, 0)
	load_sprite("light_intensity_4", 4, 0)
	load_sprite("light_intensity_5", 0, 1)
	load_sprite("light_intensity_6", 1, 1)
	load_sprite("light_intensity_7", 2, 1)
	load_sprite("light_intensity_8", 3, 1)
	load_sprite("light_intensity_9", 4, 1)
	load_sprite("light_intensity_10", 0, 2)
	load_sprite("light_intensity_11", 1, 2)
	load_sprite("light_intensity_12", 2, 2)
	load_sprite("light_intensity_13", 3, 2)
	load_sprite("light_intensity_14", 4, 2)
	load_sprite("light_intensity_15", 0, 3)

    -- Background music
    load_music("ambient_safe", "assets/ambient_safe.ogg", true)

    -- Load sounds
    load_sound("door_open", "assets/door_open_move.ogg")
end

return assets
