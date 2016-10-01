#pragma once
#include "Actor.h"
class Player : public Actor {
public:
	Player(shared_ptr<b2World> world, ActorPosition position);
	~Player() { Actor::~Actor(); };
};