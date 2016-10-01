#pragma once
#include <tuple>
using namespace std;

#include "Box2D.h"
#include "SFML/Graphics.hpp"

#include "DSConstants.h"

b2BodyDef actor_createBodyDefinition(b2World* world);
b2FixtureDef actor_createBodyFixtureDefinition(b2Body* body);

class Actor {
private:
	 sf::Sprite sprite;

	 //Physics
	 b2World* physics_world;
	 b2Body* physics_body;
public:
	Actor(b2World* physics_world);
	virtual ~Actor();

	virtual void initPhysicsBody();
	virtual void initPhysicsFixture();

	void setPosition(int x, int y);
	pair<float, float> getPosition();

	void applyForce(float x, float y);
	void applyImpulse(float x, float y);

	virtual void draw(sf::RenderWindow* window);
};

