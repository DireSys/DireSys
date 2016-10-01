#include "EventManager.h"


void EventManager::setWindow(shared_ptr<sf::RenderWindow> window) {
	this->window = window;
}

void EventManager::setPhysics(shared_ptr<b2World> physics_world) {
	this->physics_world = physics_world;
}

void EventManager::processEvents() {
	assert(this->window != nullptr);
	assert(this->physics_world != nullptr);

	sf::Event sfml_event;
	//Generate Events from the SFML events
	while (window->pollEvent(sfml_event)) {
		if (sfml_event.type == sf::Event::Closed) {
			this->generateQuit();
		}
	}

	//Generate Events from Box2D Physics Contacts
	for (b2Contact* c = physics_world->GetContactList(); c; c->GetNext()) {
		auto first_fixture = c->GetFixtureA();
		auto second_fixture = c->GetFixtureB();
		//generate event
	}

	//Generate one test event
#ifndef NDEBUG
	this->addEvent(DSEvent());
#endif

}

void EventManager::addEvent(DSEvent event) {
	this->event_list.push_back(event);
}

vector<DSEvent>& EventManager::getEvents() {
	return this->event_list;
}

void EventManager::clearEvents() {
	event_list.clear();
}

void EventManager::generateQuit() {
	auto instance = EventManager::getInstance();
	instance->addEvent(DSEvent(EventType::quit));
}
