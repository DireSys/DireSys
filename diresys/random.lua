--[[
	Includes functions for randomness...
]]
f = require "diresys/func"
pp = require "diresys/pp"

local random = {}

local distribution_resolution = 100000000

function random.getRandDist(dists)
	--[[
		
		Keyword Arguments:

		distribution -- a list of tuples consisting of
		{{<distribution_piece>, <value>, ...}}

	]]
	local dist_start = 0
	local dist_list = {}
	local dist_ranges = f.map(dists, f.first)
	local dist_sum = f.reduce(dist_ranges, function(i, j) return i + j end)
	for _, v in ipairs(dists) do
		local dist_range = distribution_resolution * (v[1] / dist_sum)
		local dist_value = v[2]
		dist_list[#dist_list + 1] = {dist_start, dist_start + dist_range, v[2]}
		dist_start = dist_start + dist_range
	end

	local chosen_range = math.random(distribution_resolution)
	local val = f.first(
		f.filter(dist_list,
				 function(i) 
					 return chosen_range >= i[1] and
						 chosen_range < i[2] end))
	return val[3]
end

return random
