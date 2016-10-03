--[[
	Shows debug information
]]

_buffer = ""

local dbg = {}

function dbg.print(s)
	_buffer = tostring(s)
	print(s)
end

function dbg.draw()
	love.graphics.print(_buffer, 2, 2)
end

return dbg
