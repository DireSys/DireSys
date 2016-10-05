--[[
	For Actor and Tile Animations
]]

local anim = {}

local Animation = {}

function Animation:new(frames, cycleInterval, options)
	--[[
		
		Represents a set of sprites (graphics keys in
		diresys/assets.lua) as frames in an animation loop

		Keyword Arguments:

		frames -- list of sprites (graphics keys) that make up an animation

		cycleInterval -- length in time (in seconds) that it will
		finish showing all of the frames. [default: 0.5 seconds]

		Optional Arguments:

		loop -- If True, will reset the animation loop after it has
		reached the last frame and continue to cycle through the
		animation at the cycleInterval [default: True]

		callback -- If a callback function is present, will call the
		callback before the last frame in the animation sequence is
		returned. [default: nil]

	]]
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	obj.type = "animation"
	obj.options = options or {loop=loop == nil and true or loop, callback=callback or nil}
	obj.frames = {}
	obj.currentInterval = 0.0
	obj.cycleInterval = cycleInterval or 0.5 -- seconds

	return obj
end
anim.Animation = Animation

function Animation:getFrame(index)
	--[[

		gets the current frame in the animation loop.  The frame
		chosen is based on the Animation:update and it's
		currentInterval

		providing an index overrides the frame selection based on the
		currentInterval

	]]
	if index then
		return self.frames[index]
	end

	if #self.frames == 0 then
		return nil
	end
	
	if #self.frames == 1 then
		return self.frames[1]
	end

	if self.currentInterval > self.cycleInterval then
		if self.options.loop then 
			self:reset()
		end

		if options.callback then
			options.callback()
		end

		return self.frames[#self.frames]
	end

	local stepInterval = self.cycleInterval / #self.frames
	local currentFrame = math.floor(self.currentInterval / stepInterval) % #animation + 1

	return self.frames[currentFrame]
end

function Animation:update(dt)
	self.currentInterval = self.currentInterval + dt
end

function Animation:reset()
	self.currentInterval = 0.0
end

local AnimationBatch = {}

function AnimationBatch:new()
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	
	obj.type = "animationbatch"
	obj.animations = {}
	obj.currentAnimation = {}

	return obj
end
anim.AnimationBatch = AnimationBatch

function AnimationBatch:addAnim(name, animation)
	assert(animation.type == "animation")
	self.animations[name] = animation
end

function AnimationBatch:setAnim(name, reset)
	--[[
		sets the current animation frame.

		Keyword Arguments:

		name -- The name of the animation stored in the AnimationBatch

		reset -- If true, will reset the chosen animation to the first
		frame [default:true]

	]]
	local reset = reset == nil and true or reset

	self.currentAnimation = self.animations[name]
	if reset and self.currentAnimation then
		self.currentAnimation:reset()
	end
end

function AnimationBatch:getFrame()
	-- Get the current frame for an animation (graphics key of a
	-- sprite quad)
	if self.currentAnimation then
		return self.currentAnimation:getFrame()
	end
end

function AnimationBatch:update(dt)
	if self.currentAnimation then
		self.currentAnimation:update(dt)
	end
end

return anim