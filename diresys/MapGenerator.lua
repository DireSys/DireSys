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
	return MapGenerator.load_string(s)
end

function MapGenerator.process_map_intermediate(map)
	
end

return MapGenerator
