#pragma once
#include <tuple>
#include <memory>
using namespace std;

#include "Box2D.h"
#include "SFML/Graphics.hpp"

#include "DSConstants.h"

typedef pair<float, float> ActorPosition;

class Actor {
private:
	 sf::Sprite sprite;

	 //Physics
	 shared_ptr<b2World> physics_world;
	 shared_ptr<b2Body> physics_body;
public:
	Actor(shared_ptr<b2World> physics_world, ActorPosition position);
	virtual ~Actor();

	virtual void initPhysicsBody(ActorPosition position);
	virtual void initPhysicsFixture();

	void setPosition(float x, float y);
	ActorPosition getPosition();

	void applyForce(float x, float y);
	void applyImpulse(float x, float y);

	virtual void draw(shared_ptr<sf::RenderWindow> window);
};

