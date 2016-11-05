--[[
	Diresys main file
]]
pp = require "diresys/pp"
f = require "diresys/func"
core = require "diresys/core"

love.load = function(args)
	for i, arg in ipairs(args) do
		if arg == "--test" or arg == "-t" then
			test = require "test/test"
			test.run_tests()
			love.event.quit()
		elseif arg == "--shader" or arg == "-s" then
			--TODO: run test bench
		else
			core.load()
			love.draw = core.draw
			love.update = core.update
			love.keypressed = core.keypressed
			love.keyreleased = core.keyreleased
		end
	end
end
