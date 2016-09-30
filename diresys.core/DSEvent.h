#pragma once
enum class EventType {
	test,
	collision_on,
	collision_off,
	keypress,
	keydown,
	keyup,
	quit,
};

//Event
class DSEvent {
private:
	EventType event_type;
public:
	DSEvent();
	virtual ~DSEvent();

	EventType getType();
};