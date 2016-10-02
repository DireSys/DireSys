--[[
	Diresys main file
]]
f = require "diresys/func"
core = require "diresys/core"

love.load = function(args)
	for _, arg in ipairs(args) do
		if arg == "--test" or arg == "-t" then
			test = require "test/test"
			test.run_tests()
			love.event.quit()
		end
	end
end

