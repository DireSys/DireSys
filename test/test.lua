--[[
	Includes Test Functions
]]

local test = {}

num_passes = 0
num_errors = 0

test.assert = function(chk, msg)
	if chk then
		print("    PASS: " .. msg)
		num_passes = num_passes + 1
	else
		print("X   FAIL: " .. msg)
		num_errors = num_errors + 1
	end
end

test.run_tests = function()
	--grabs all files of the form test_*.lua and runs any functions of
	--the form test_*
	print ("Running Tests...")
	local files = love.filesystem.getDirectoryItems("test")
	local test_files = {}
	for _, file in ipairs(files) do
		if file:match("^test_[%a%d]+%.lua") then
			test_files[#test_files+1] = file
		end
	end
	for _, test_filename in ipairs(test_files) do
		local test_module_name = test_filename:match("^(.*)%.lua$")
		print("Testing Module: " .. test_module_name)
		local test_module = require("test/" .. test_module_name)
		for name, func in pairs(test_module) do
			if name:match("^test_.*") then
				print("  Test Case: " .. name)
				func()
			end
		end
	end
	if num_errors == 0 then
		print("\nSuccess!!")
	else
		print("\nFail!!")
	end
	print ("  Number Passes: " .. num_passes)
	print ("  Number Fails:  " .. num_errors)
end

return test
