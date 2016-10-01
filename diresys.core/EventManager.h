#pragma once
#include <vector>
#include <memory>
#include <cassert>
using namespace std;

#include "SFML/Graphics.hpp"
#include "Box2D.h"

#include "DSEvent.h"
class EventManager {
private:
	//Singleton
	EventManager() {};
	EventManager(EventManager const&) {};
	void operator=(EventManager const&) {};

	vector<DSEvent> event_list;
	shared_ptr<sf::RenderWindow> window = nullptr;
	shared_ptr<b2World> physics_world = nullptr;
public:
	static EventManager* getInstance() {
		static EventManager _instance = EventManager();
		return &_instance;
	}

	void setWindow(shared_ptr<sf::RenderWindow> window);
	void setPhysics(shared_ptr<b2World> physics_world);

	void processEvents();
	void addEvent(DSEvent event);
	vector<DSEvent>& getEvents();
	void clearEvents();

	//
	// Event Generation
	//   Automatically places events in the event manager

	//Person Clicked on the close button
	void generateQuit();
};

