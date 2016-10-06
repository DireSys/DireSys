--[[
	List of utility functions
]]
config = require("config")

function TILE_UNIT(x)
	return math.floor(x / config.TILE_SIZE)
end

function WORLD_UNIT(x)
	return math.floor(x * config.TILE_SIZE)
end

function _I(x, y)
	-- Represents a unique index between two coordinates
	return x .. "," .. y
end
