--[[

	Used to represent and draw all of the lights within the game.

]]
require "diresys/utils"
class = require "diresys/class"
config = require "config"
f = require "diresys/func"
pp = require "diresys/pp"
shaders = require "diresys/shaders"
perf = require "diresys/perf"

local LightEngine = class.create()

function LightEngine:new(map, options)
	--[[

		Keyword Arguments:

		map -- Map instance containing this instance.

		Optional Arguments:

		/none so far/

	]]
	local obj = self:classInit()

	obj.type = "lightengine"
	obj.lightSources = {}

	return obj
end

function LightEngine:update(dt)
	for _, light in ipairs(self.lightSources) do
		light:update(dt)
	end
end

function LightEngine:addLight(light)
	self.lightSources[#self.lightSources + 1] = light
end

function LightEngine:draw(viewx, viewy)
    local shader = shaders.render_lights

    love.graphics.setShader(shader)

    shader:send("scale", 4)
    shader:send("viewport_offset", {-viewx, -viewy})

	
	-- for each light...
	local light_positions = {}
	local light_falloffs = {}
	local light_limits = {}
	local obstructions = {}
	
	for _, light in ipairs(self.lightSources) do
		
		local light_position = light:getPosition()
		
		local light_falloff = 0
		local light_limit = 0
		
		light_falloff = WORLD_UNIT(light:getFalloffDistance())
		light_limit = WORLD_UNIT(light:getMaxDistance())

		light_positions[#light_positions+1] = {
			WORLD_UNIT(light_position.x),
			WORLD_UNIT(light_position.y)
		}

		light_falloffs[#light_falloffs+1] = light_falloff
		light_limits[#light_limits+1] = light_limit

		perf.step("GFX Transfer")
        shader:send("light_positions", unpack(light_positions))
        shader:send("light_falloffs", unpack(light_falloffs))
        shader:send("light_limits", unpack(light_limits))
        shader:sendInt("light_count", #light_positions)
		perf.step("GFX Transfer", {once=true})
    end

	local c = love.graphics.newCanvas(config.WINDOW_WIDTH * config.WINDOW_SCALE,
									  config.WINDOW_HEIGHT * config.WINDOW_SCALE)
	love.graphics.draw(c, viewx, viewy, 0,
					   config.WINDOW_SCALE, config.WINDOW_SCALE)

    love.graphics.setShader()
end

return LightEngine
