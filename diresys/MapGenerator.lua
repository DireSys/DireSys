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

	-- check what parts of the wall tile need edges
	-- top
	local tile_top = map:getTile(tilex, tiley-1)
	if not tile_top 
	    or tile_top.type == "walltile" or tile_top.type == "doortile" then
		wall_edges.top = false
	end

	-- right
	local tile_right = map:getTile(tilex+1, tiley)
	if not tile_right
	    or tile_right.type == "walltile" or tile_right.type == "doortile" then
		wall_edges.right = false
	end

	-- bottom
	local tile_bottom = map:getTile(tilex, tiley+1)
	if not tile_bottom
		or tile_bottom.type == "walltile" or tile_bottom.type == "doortile" then
		wall_edges.bottom = false
	end

	-- left
	local tile_left = map:getTile(tilex-1, tiley)
	if not tile_left
	    or tile_left.type == "walltile" or tile_left.type == "doortile" then
		wall_edges.left = false
	end
	
	tile:updateWall(wall_edges)
end

return MapGenerator
