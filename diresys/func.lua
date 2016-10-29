--[[
	This is a module that contains a lot of utility functions that
	resemble undersore.js.
	The functions are typically used on tables
]] 

local func = {}

func.range = function(startIndex, endIndex, increment)
	--[[
		
		Keyword Arguments:

		startIndex -- start index
		
		endIndex -- end index
	
		increment -- the increment of the range [default: 1]

	]]
	local t = {}
	index = 1
	increment = increment or 1
	for i = startIndex, endIndex, increment do
		table.insert(t, index, i)
		index = index + 1
	end
	return t
end

func.map = function(t, f)
	--[[

		Keyword Arguments:

		t -- array of elements

		f -- transformation function of the form f(element), where
		element is every element in 't', and the return value is what
		that element is transformed into.

		Return Value:

		New array table with each element of 't' transformed by 'f'
		
	]]
	local resultTable = {}
	for i,v in ipairs(t) do
		resultTable[i] = f(v)
	end
	return resultTable
end

func.filter = function(t, f)
	--[[

		Keyword Arguments:

		t -- array of elements

		f -- conditional function of the form f(element), where the
		return value is whether the given element should remain in the
		array. Where true would keep the value in the array returned,
		and false will remove the value from the returned array.

		Return Value:

		New array table with each element of 't' filtered by the
		conditional function 'f'

	]]
	local resultTable = {}
	for i,v in ipairs(t) do
		if f(v) then 
			table.insert(resultTable, v)
		end
	end
	return resultTable
end

func.reduce = function(t, f)
	--[[

		Keyword Arguments:

		t -- an array of elements

		f -- a reduction function of the form f(a, b), where the
		entire array of elements is consumed from 'b' into 'a'.

	]]
	local result = t[1]
	for _,v in ipairs(func.rest(t)) do
		result = f(result, v)
	end
	return result
end

func.find = function(t, f)
	--[[

		Keyword Argument:

		t -- array of elements

		f -- function of the form f(element), which returns True if
		the functions condition is true.

		Return Value:

		Returns the first element within 't' which is conditionally
		true when iterating over 't' with 'f'

	]]
	for i,v in ipairs(t) do
		if f(v) then
			return v
		end
	end
	return nil
end

func.findall = function(t, f)
	-- Same as func.filter
	local resultTable = {}
	for i,v in ipairs(t) do
		if f(v) then
			table.insert(resultTable, v)
		end
	end
	return resultTable
end

func.contains = function(t, val)
	--[[
		
		Keyword Arguments:
		
		t -- Array of elements

		val -- the value we are determining whether it exists in 't'

		Return Value:

		Returns true if 'val' exists within the array of elements 't',
		otherwise false.

	]]
	for i,v in ipairs(t) do
		if v == val then
			return true
		end
	end
	return false
end

func.any = function(t, f)
	for i,v in ipairs(t) do
		if f(v) then return true end
	end
	return false
end

func.all = function(t, f)
	for i,v in ipairs(t) do
		if not f(v) then return false end
	end
	return true
end

func.first = function(t)
	return t[1]
end

func.rest = function(t)
	local resultTable = {}
	for i=2,#t do
		table.insert(resultTable, t[i])
	end
	return resultTable
end

func.last = function(t)
	return t[#t]
end

func.keys = function(t)
	local resultTable = {}
	for k,v in pairs(t) do
		table.insert(resultTable, k)
	end
	return resultTable
end

func.values = function(t)
	local resultTable = {}
	for i,v in pairs(t) do
		table.insert(resultTable, v)
	end
	return resultTable
end

func.has = function(t, val)
	for i,v in pairs(t) do
		if v == val then return true end
	end
	return false
end

func.pluck = function(t, key)
	local resultTable = {}
	for i,v in ipairs(t) do
		table.insert(resultTable, v[key])
	end
	return resultTable
end

func.identity = function(i)
	return i
end

func.sortby = function(t, key)
	local resultTable = func.map(t, func.identity)
	local orderFunc = function(i, j)
		if i[key] < j[key] then
			return true
		end
		return false
	end

	table.sort(resultTable, orderFunc)
	return resultTable
end

func.declass = function(f, obj)
	return function(...)
		local obj = obj
		return f(obj, unpack(arg)) 
	end
end

return func
