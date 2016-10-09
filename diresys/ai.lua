--[[
	Actors can carry on the roll of an AI
]]

local ai = {}

local StateMachine = {}

function StateMachine:new(parent, options)
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	obj.parent = parent
	obj.options = options or {}
	obj.currentState = obj.options.initstate or "stalled"
	obj.states = {
		stalled={
			-- the state will get called every 1 seconds, until it
			-- makes a state transition
			current_interval = 0.0, --seconds
			state_interval = 1.0, -- seconds a state transition is
			-- performed by returning which state to transition to.
			mainCallback = function(parent, sm) return sm.currentState end,
			transitionCallback = function(parent, sm, nextState) return nil end,
		},
	}
	return obj
end
ai.StateMachine = StateMachine

function StateMachine:addState(name, mainCallback,
							   transitionCallback,
							   state_interval)
	self.states[name] = {
		mainCallback = mainCallback or function(parent, sm)
			return sm.currentState end,
		transitionCallback = transitionCallback or
			function(parent, sm, nextState)
				return nil end,
		state_interval = state_interval or 1.0,
		current_interval = 0.0,
	}
end

function StateMachine:update(dt)
	local state = self.states[self.currentState]
	local current_interval = state.current_interval
	local state_interval = state.state_interval

	-- Have we finished waiting?
	if current_interval < state_interval then
		state.current_interval = current_interval + dt
		return
	end
	-- We have finished waiting, reset the timer
	state.current_interval = 0.0

	-- Call the transition
	state.transitionCallback(self.parent, self, state.currentState)
	self.currentState = state.mainCallback(self.parent, self) or self.currentState
end

return ai
