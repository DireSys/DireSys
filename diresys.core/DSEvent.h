#pragma once
enum class EventType {
	collision_on,
	collision_off,
	keypress,
	keydown,
	keyup,
};

//Abstract Event
class DSEvent {
private:
	EventType event_type;
public:
	DSEvent();
	virtual ~DSEvent();
};

