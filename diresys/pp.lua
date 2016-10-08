--[[
	pretty print functions
]]
f = require "diresys/func"

local pp = {}

print_table = function(t, indent, embeded, depth, max_depth)
	local indent = indent or 0
	local sindent = ""

	for i=1,indent do sindent = sindent .. " " end

	if embeded then
		print ("{")
	else
		print(sindent .. "{")
	end

	for k,v in pairs(t) do
		if type(v) == "table" and depth >= max_depth then
			print(sindent .. " " .. k .. " = <table>")
		elseif type(v) == "table" then
			io.write(sindent .. " " .. k .. " = ")
			print_table(v, indent+1, true, depth+1, max_depth)
		elseif type(v) == "userdata" then
			print(sindent .. " " .. k .. " = <userdata>")
		elseif type(v) == "function" then
			print(sindent .. " " .. k .. " = <function>")
		else
			print(sindent .. " " .. tostring(k) .. " = " .. tostring(v))
		end
	end
	print(sindent .. "}")
end

pp.print = function(t, max_depth)
	local max_depth = max_depth or 3
	if type(t) == "table" then
		print_table(t, 0, false, 1, max_depth)
	else
		print(t)
	end
end

return pp
