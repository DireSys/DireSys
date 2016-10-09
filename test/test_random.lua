test = require "test/test"
pp = require "diresys/pp"
f = require "diresys/func"
random = require "diresys/random"

local test_random = {}

test_random.test_getRandDist = function()
	local range = {{50, "true"}, {50, "false"}}
	val = random.getRandDist(range)
	test.assert(val == "true" or val == "false", "testing getRandDist")
end

return test_random
