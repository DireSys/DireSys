#pragma once
#include <cassert>

#include "SFML\Graphics.hpp"

#include "DSConstants.h"
#include "Player.h"

class Camera {
private:
	sf::View* view = nullptr; //O
	Player* linked_actor = nullptr; //R
public:
	Camera(sf::RenderWindow* window);
	~Camera();

	void linkActor(Player* actor);
	void unlinkActor();
	void reposition();
};

