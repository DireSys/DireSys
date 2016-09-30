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

	vector<DSEvent*> event_list;
	sf::Window* window = nullptr;
	b2World* physics_world = nullptr;
public:
	static EventManager* getInstance() {
		static EventManager _instance = EventManager();
		return &_instance;
	}

	void setWindow(sf::RenderWindow* window);
	void setPhysics(b2World* physics_world);

	void processEvents();
	void addEvent(DSEvent* event);
	const vector<DSEvent*>& getEvents();
	void clearEvents();
};

