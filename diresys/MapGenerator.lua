--[[
	Used to create maps
]]
config = require "config"
pp = require "diresys/pp"
Map = require "diresys/Map"

local MapGenerator = {}

function lines(str)
  local t = {}
  local function helper(line) table.insert(t, line) return "" end
  helper((str:gsub("(.-)\r?\n", helper)))
  return t
end

function MapGenerator.load(lines)
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
	return map
end

function MapGenerator.load_string(mapString)
	return MapGenerator.load(lines(mapString))
end

function MapGenerator.load_file(filename)
	local f = assert(io.open(filename, "r"))
	local s = f:read("*all")
	f:close()
	return MapGenerator.load_string(s)
end

function MapGenerator.process_map_intermediate(map)
	for _, tile in ipairs(map:getTileList()) do
		if tile.type == "walltile" then
			MapGenerator.process_wallTile(map, tile)
		end
	end
end

function MapGenerator.process_wallTile(map, tile)
	local dims = tile:get_tile_dimensions()
	local wall_edges = {
		top = true,
		right = true,
		bottom = true,
		left = true,
	}

	-- check what parts of the wall tile need edges
	-- top
	local tile_top = map:getTile(dims.startx, dims.starty-1)
	if not tile_top 
	    or tile_top.type == "walltile" or tile_top.type == "doortile" then
		wall_edges.top = false
	end

	-- right
	local tile_right = map:getTile(dims.endx+1, dims.starty)
	if not tile_right
	    or tile_right.type == "walltile" or tile_right.type == "doortile" then
		wall_edges.right = false
	end

	-- bottom
	local tile_bottom = map:getTile(dims.startx, dims.endy+1)
	if not tile_bottom
		or tile_bottom.type == "walltile" or tile_bottom.type == "doortile" then
		wall_edges.bottom = false
	end

	-- left
	local tile_left = map:getTile(dims.startx-1, dims.endy)
	if not tile_left
	    or tile_left.type == "walltile" or tile_left.type == "doortile" then
		wall_edges.left = false
	end
	
	tile:updateWall(wall_edges)
end

return MapGenerator
