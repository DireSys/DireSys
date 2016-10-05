--[[
	Used to create maps
]]
config = require "config"
pp = require "diresys/pp"
Map = require "diresys/Map"
perf = require "diresys/perf"

local MapGenerator = {}

function lines(str)
  local t = {}
  local function helper(line) table.insert(t, line) return "" end
  helper((str:gsub("(.-)\r?\n", helper)))
  return t
end

function MapGenerator.load(lines)
	perf.step("MapGenerator.load")
	local map = Map:new()
	for j = 1, #lines do
		local line = lines[j]
		for i = 1, #line do
			local character = line:sub(i, i)
			if character == "." then
				map:createFloor(i-1, j-1)
			elseif character == "+" then
				map:createWall(i-1, j-1)
			elseif character == "@" then
				map:createFloor(i-1, j-1)
				map:createPlayer(i-1, j-1)
			elseif character == "D" then
				map:createDoor(i-1, j-1)
			end
		end
	end
	MapGenerator.process_map_intermediate(map)
	map:refreshTiles()
	perf.step("MapGenerator.load")
	return map
end

function MapGenerator.load_string(mapString)
	perf.step("MapGenerator.load_string")
	local mapLines = lines(mapString)
	perf.step("MapGenerator.load_string")
	return MapGenerator.load(mapLines)
end

function MapGenerator.load_file(filename)
	local f = assert(io.open(filename, "r")); perf.step("MapGenerator.load_file")
	local s = f:read("*all")
	f:close(); perf.step("MapGenerator.load_file")
	return MapGenerator.load_string(s)
end

function MapGenerator.process_map_intermediate(map)
	perf.step("MapGenerator.process_map_intermediate")
	for _, tile in pairs(map:getTileList()) do
		if tile.type == "walltile" then
			MapGenerator.process_wallTile(map, tile)
		end
	end
	perf.step("MapGenerator.process_map_intermediate")
end

function MapGenerator.process_wallTile(map, tile)
	-- We know wall tiles are 1x1
	-- local dims = tile:get_tile_dimensions()
	local tilex, tiley = tile:get_tile_position()
	local wall_edges = {
		top = true,
		right = true,
		bottom = true,
		left = true,
	}

    local front_facing = false

	-- check what parts of the wall tile need edges
	-- top
	local tile_top = map:getTile(tilex, tiley-1)
	if not tile_top 
	    or tile_top.type == "walltile" then
		wall_edges.top = false
	end

	-- right
	local tile_right = map:getTile(tilex+1, tiley)
	if not tile_right
	    or tile_right.type == "walltile" then
		wall_edges.right = false
	end

	-- bottom
	local tile_bottom = map:getTile(tilex, tiley+1)
	if not tile_bottom
		or tile_bottom.type == "walltile" then
		wall_edges.bottom = false
	end

	-- left
	local tile_left = map:getTile(tilex-1, tiley)
	if not tile_left
	    or tile_left.type == "walltile" then
		wall_edges.left = false
	end
	
    -- check whether bottom of tile meets with floor, or two down meets with floor
    local tile_bottom_2 = map:getTile(tilex, tiley+2)

    if (tile_bottom and tile_bottom.type == "floortile")
        or (tile_bottom and tile_bottom.type == "walltile" and tile_bottom_2 and tile_bottom_2.type == "floortile")
    then
        front_facing = true
    end
        
    -- check whether tile to the left meets the "front_facing" criteria
    local tile_left_bottom = map:getTile(tilex-1, tiley+1)
    local tile_left_bottom_2 = map:getTile(tilex-1, tiley+2)

    if not front_facing and
       ((tile_left_bottom and tile_left_bottom.type == "floortile")
        or (tile_left_bottom and tile_left_bottom.type == "walltile" and tile_left_bottom_2 and tile_left_bottom_2.type == "floortile"))
    then
        wall_edges.left = true
    end

    -- check whether tile to the left meets the "front_facing" criteria
    local tile_right_bottom = map:getTile(tilex+1, tiley+1)
    local tile_right_bottom_2 = map:getTile(tilex+1, tiley+2)

    if not front_facing and
        ((tile_right_bottom and tile_right_bottom.type == "floortile")
        or (tile_right_bottom and tile_right_bottom.type == "walltile" and tile_right_bottom_2 and tile_right_bottom_2.type == "floortile"))
    then
        wall_edges.right = true
    end

    -- check whether tile to below meets the "front_facing" criteria
    local tile_bottom_3 = map:getTile(tilex, tiley+3)

    if not front_facing and
        (tile_bottom_2 and tile_bottom_2.type == "walltile" and tile_bottom_3 and tile_bottom_3.type == "floortile")
    then
        wall_edges.bottom = true
    end

	tile:updateWall(wall_edges, front_facing)
end

return MapGenerator
