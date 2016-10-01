#pragma once
#include "Actor.h"
class Player : public Actor {
public:
	Player(b2World* world);
	~Player();
};

