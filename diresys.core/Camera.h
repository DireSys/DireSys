#pragma once
#include <cassert>

#include "SFML\Graphics.hpp"

#include "DSConstants.h"
#include "Actor.h"

class Camera {
private:
	sf::View* view = nullptr; //O
	Actor* linked_actor = nullptr; //R
public:
	Camera(sf::RenderWindow* window);
	~Camera();

	void linkActor(Actor* actor);
	void unlinkActor();
	void reposition();
};

