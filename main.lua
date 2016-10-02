--[[
	Diresys main file
]]
pp = require "diresys/pp"
f = require "diresys/func"
core = require "diresys/core"

love.load = function(args)
	for _, arg in ipairs(args) do
		if arg == "--test" or arg == "-t" then
			test = require "test/test"
			test.run_tests()
			love.event.quit()
		else
			pp.print({x = "123", y = {z = "abc", a = {1,2,3}}})
		end
	end
end

