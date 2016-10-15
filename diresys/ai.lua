--[[

	Actors can carry on the roll of an AI. This is a simple
	statemachine, which can be used to simulate an actor to perform
	simple actions.

]]

local ai = {}
local StateMachine = {}

function StateMachine:new(parent, options)
	--[[

		The statemachine takes several 'states' which have the main
		callback function, and the transition function.

		An initial state is provided, and the maincallback is called
		whenever the 'state_interval' is finished, which is
		represented in seconds.

		Keyword Arguments:

		parent -- The parent instance is passed to the mainCallback as
		the first argument, Essentially rebinding a class method to an
		instance.

		Optional Arguments:

		initstate -- The initial state of the statemachine. By
		default, it will sit in the 'stalled' state, which provides no
		means of transition.

	]]
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
	--[[

		Add a state to the statemachine.

		Keyword Arguments:

		name -- The name given to the current state.

		mainCallback -- The Main callback function representing this
		state, of the form function(parent, sm) ... end, where parent
		is the parent instance passed into the instantiation of the
		StateMachine, and sm is the current StateMachine instance. The
		return value of the statemachine represents the next state
		that the statemachine should go into.

		transitionCallback -- The Transition callback function
		representing this state, of the form function(parent, sm,
		nextState) ... end. It can be used to add additional
		side-effects before the state transition.
		
		state_interval -- Represents the time in seconds for the
		mainCallback to be called while the game is running. By
		default, this is 1.0 seconds.

		Notes:

		- Check out the 'stalled' state for a better understanding of
          state structure.

	]]
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
	--[[

		The statemachine needs to be placed in the love.update path, in
		order to operate correctly.
		
		ie. Within Actor.update, or Tile.update.

	]]
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
