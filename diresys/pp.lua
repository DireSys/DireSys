--[[
	pretty print functions
]]
f = require "diresys/func"

local pp = {}

print_table = function(t, indent, embeded)
	local indent = indent or 0
	local sindent = ""

	for i=1,indent do sindent = sindent .. " " end

	if embeded then
		print ("{")
	else
		print(sindent .. "{")
	end

	for k,v in pairs(t) do
		if type(v) ~= "table" then
			print(sindent .. " " .. k .. " = " .. v)
		else
			io.write(sindent .. " " .. k .. " = ")
			print_table(v, indent+1, true)
		end
	end
	print(sindent .. "}")
end

pp.print = function(t)
	if type(t) == "table" then
		print_table(t)
	else
		print(t)
	end
end

return pp
