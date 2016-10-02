test = require "test/test"

local test_func = {}

test_func.test_test = function()
	test.assert(true, "This passes")
	test.assert(false, "This fails")
end

return test_func
