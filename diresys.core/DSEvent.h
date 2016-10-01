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
	DSEvent(EventType event = EventType::test);
	virtual ~DSEvent();

	EventType getType();
};