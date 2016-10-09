test = require "test/test"
pp = require "diresys/pp"
f = require "diresys/func"
pathfinding = require "diresys/pathfinding"

local test_pathfinding = {}

test_pathfinding.test_in_proximity = function()
	local p1 = {x=0.0, y=0.0}
	local p2 = {x=5.0, y=0.0}
	test.assert(pathfinding.inProximity(p1, p2, 5), "test inProximity 1")
	test.assert(pathfinding.inProximity(p2, p1, 5), "test inProximity 2")
	test.assert(not pathfinding.inProximity(p1, p2, 4), "test inProximity 3")
	test.assert(not pathfinding.inProximity(p2, p1, 4), "test inProximity 4")
end

return test_pathfinding
