test = require "test/test"
pp = require "diresys/pp"
f = require "diresys/func"

local test_func = {}

test_func.test_range = function()
	local arange1 = f.range(1,5)
	test.assert(arange1[1] == 1, "range starts with 1")
	test.assert(arange1[5] == 5, "range ends with 5")
	test.assert(#arange1 == 5, "length is 5")

	local arange2 = f.range(6,10)
	test.assert(arange2[1] == 6, "range starts with 5")
	test.assert(arange2[5] == 10, "range ends with 10")
	test.assert(#arange2 == 5, "length is 5")
	
	local arange3 = f.range(0, 4, 2)
	test.assert(arange3[1] == 0, "range starts with 5")
	test.assert(arange3[3] == 4, "range ends with 10")
	test.assert(#arange3 == 3, "length is 5")
end

test_func.test_map = function()
	local x = {1,2,3,4}
	local y = f.map(x, function(i) return i + 1 end)
	test.assert(y[1] == 2, "map test increment")
end

test_func.test_filter = function()
	local x = {1,2,3,4}
	even_nums = f.filter(x, function(i) return i % 2 == 0 end)
	test.assert(even_nums[1] == 2 and even_nums[2] == 4,
				"test filtering of even nums")
end

test_func.test_reduce = function()
	local x = {1,2,3,4}
	local sum = f.reduce(x, function(a, b) return a + b end)
	test.assert(sum == 10, "test reduce without init")
end

test_func.test_find = function()
	local x = {1,2,3,4}
	local num3 = f.find(x, function(i) return i == 3 end)
	test.assert(num3 == 3, "testing find #1")
end

test_func.test_findall = function()
	local x = {1,2,3,4}
	local odd = f.findall(x, function(i) return i % 2 == 1 end)
	test.assert(odd[1] == 1 and odd[2] == 3, "testing findall")
end

test_func.test_contains = function()
	local x = {0,1,2,3,4}
	test.assert(f.contains(x, 3) == true, "test contains has value")
	test.assert(f.contains(x, 5) == false, "test contains does not have value")
end

test_func.test_any = function()
	test.assert(f.any({1,2,3,4}, function(i) return i > 0 end) == true,
				"test any(true)")
	test.assert(f.any({1,2,3,4}, function(i) return i > 5 end) == false,
				"test any(false)")
end

test_func.test_all = function()
	local iseven = function(i) return i % 2 == 0 end
	local istwo = function(i) return i == 2 end
	local x = {2,4}
	test.assert(f.all(x, iseven) == true, "test all(true)")
	test.assert(f.all(x, istwo) == false, "test all(false)")
end

test_func.test_first = function()
	local x = {1,2,3,4}
	test.assert(f.first(x) == x[1], "test first")
end

test_func.test_rest = function()
	local x = {1,2,3}
	local r = f.rest(x)
	test.assert(r[1] == 2 and r[2] == 3, "test rest")
end

test_func.test_last = function()
	local x = {1,2,3}
	test.assert(x[#x] == f.last(x), "test last")
end

test_func.test_keys = function()
	local x = {x = "123", y = "456"}
	local k = f.keys(x)
	test.assert(f.contains(k, "x") and f.contains(k, "y"), "test keys")
end

test_func.test_values = function()
	local x = {x = "123", y = "456"}
	local v = f.values(x)
	test.assert(f.contains(v, "123") and f.contains(v, "456"), "test values")
end

test_func.test_has = function()
	local x = {x = "123", y = "456"}
	test.assert(f.has(x, "123") and f.has(x, "456"), "test has")
end

test_func.test_pluck = function()
	local x = {
		{index=0, key="test"},
		{index=2, key="test2"},
		{index=4, key="test3"},
	}
	local index = f.pluck(x, "index")
	test.assert(#index == 3, "test pluck has right number of values")
	test.assert(index[1] == 0 and index[2] == 2, "test pluck right values returned")
end

test_func.test_sortby = function()
	local x = {
		{index=4},
		{index=1},
		{index=2},
	}
	local sorted = f.sortby(x, "index")
	test.assert(#sorted == 3, "test sorted returns right number")
	test.assert(sorted[1].index == 1 and sorted[2].index == 2, "test sorted returns right order")
	test.assert(x ~= sorted, "test sorted make sure we retain immutability")
end

test_func.test_thrf_1 = function()
	local x = {1, 2, 3, 4}
	local result = f.thrf{
		x,
		{f.filter, function(i) return i % 2 == 0 end},
		{f.reduce, function(a, b) return a + b end},
	}
	test.assert(result == 6, "threading first test 1")
end

test_func.test_thrf_2 = function()
	local x = {1, 2, 3, 4}
	local sum = function(t)
		return f.reduce(t, function(a, b) return a + b end)
	end
	
	local isOdd = function(i) return i % 2 ~= 0 end

	local result = f.thrf{x, {f.filter, isOdd}, sum}

	test.assert(result == 4, "threading first test 2")
end

test_func.test_lineIntersect = function()

end

return test_func
