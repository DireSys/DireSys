--[[
	Performance Analysis tooling
]]
f = require "diresys/func"

analysis_enabled = true
_analysis_list = {}
_once_listing = {}

local perf = {}

function perf.step(tag, options)
	options = options or {}
	options.once = options.once or false

	if not analysis_enabled then return end
	local startTime = _analysis_list[tag]
	_analysis_list[tag] = love.timer.getTime()	

	if not startTime or _once_listing[tag] then
		return
	end

	if options.once then
		_once_listing[tag] = true
	end

	local delta = love.timer.getTime() - startTime
	print("Execution time for '" .. tag .. "' = " .. delta .. " seconds")
end

return perf
