#include "EventManager.h"


void EventManager::setWindow(sf::RenderWindow* window) {
	this->window = window;
}

void EventManager::setPhysics(b2World * physics_world) {
	this->physics_world = physics_world;
}

void EventManager::processEvents() {
	sf::Event sfml_event;
	//Generate Events from the SFML events
	while (window->pollEvent(sfml_event)) {
		//if (sfml_event.type == ...)
		//generate event
	}

	//Generate Events from Box2D Physics Contacts
	for (b2Contact* c = physics_world->GetContactList(); c; c->GetNext()) {
		auto first_fixture = c->GetFixtureA();
		auto second_fixture = c->GetFixtureB();
		//generate event
	}

	//Generate one test event
#ifndef NDEBUG
	this->addEvent(new DSEvent());
#endif

}

void EventManager::addEvent(DSEvent * event) {
	this->event_list.push_back(event);
}

const vector<DSEvent*>& EventManager::getEvents() {
	return this->event_list;
}

void EventManager::clearEvents() {
	for (auto* event : event_list) {
		delete event;
	}
	event_list.clear();
}
