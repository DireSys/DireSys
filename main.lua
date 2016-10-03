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
			core.load()
			love.draw = core.draw
			love.update = core.update
			love.keypressed = core.keypressed
			love.keyreleased = core.keyreleased
		end
	end
end
