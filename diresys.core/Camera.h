#pragma once
#include <cassert>
#include <memory>

#include "SFML\Graphics.hpp"

#include "DSConstants.h"
#include "Player.h"

class Camera {
private:
	shared_ptr<sf::View> view = nullptr; //O
	shared_ptr<Player> linked_actor = nullptr; //R
public:
	Camera(shared_ptr<sf::RenderWindow> window);
	~Camera();

	void linkActor(shared_ptr<Player> actor);
	void unlinkActor();
	void reposition();
};

