#include "DSEvent.h"



DSEvent::DSEvent(EventType type) {
	this->event_type = type;
}

DSEvent::~DSEvent(){
}

EventType DSEvent::getType() {
	return event_type;
}
