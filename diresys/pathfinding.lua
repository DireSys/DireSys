--[[
	Pathfinding, and proximity-based functions
]]

local pathfinding = {}

function pathfinding.inProximity(pos1, pos2, distance)
	local xt = pos2.x - pos1.x
	local xt = xt * xt
	local yt = pos2.y - pos2.y
	local yt = yt * yt
	local tot = xt + yt
	return tot <= (distance * distance)
end

function pathfinding.findPath(map, pos1, pos2)
	local tilelist = map:getTileList()
	
	for _, tile in pairs(tilelist) do
		
	end
end

return pathfinding
