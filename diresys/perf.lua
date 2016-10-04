--[[
	Performance Analysis tooling
]]

analysis_enabled = true
_analysis_list = {}

local perf = {}

function perf.step(tag)
	if not analysis_enabled then return end
	local startTime = _analysis_list[tag]
	_analysis_list[tag] = love.timer.getTime()	
	if not startTime then
		return
	end

	local delta = love.timer.getTime() - startTime
	print("Execution time for '" .. tag .. "' = " .. delta .. " seconds")
end

return perf
