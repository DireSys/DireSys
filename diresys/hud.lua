--[[
	Represents the HUD overlay for the player
]]
config = require "config"

hud = {
	text = "test text"
}

function hud.draw()
	--love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle(
		"fill", 0, 0,
		config.WINDOW_WIDTH * config.WINDOW_SCALE,
		8 * config.WINDOW_SCALE)
	love.graphics.print(hud.text, 2, 2)
end

function hud.setText(text)
	hud.text = text
end

return hud
