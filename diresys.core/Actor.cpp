#include "Actor.h"

Actor::Actor(b2World * physics_world) : 
	physics_world(physics_world) {

}

Actor::~Actor() {
	this->physics_world->DestroyBody(this->physics_body);
}

void Actor::initPhysicsBlock() {
	//create body from bodydef
	//create fixture from fixturedef
	//apply to this->physics_body
}

void Actor::setPosition(int x, int y) {
	b2Vec2 position((float)x, (float)y);
	this->physics_body->SetTransform(position, 0.0f);
}

pair<float, float> Actor::getPosition() {
	auto position = this->physics_body->GetPosition();
	return pair<float, float>(position.x, position.y);
}

void Actor::applyForce(float x, float y) {
	this->physics_body->ApplyForceToCenter(b2Vec2(x, y), true);
}

void Actor::applyImpulse(float x, float y) {
	this->physics_body->ApplyLinearImpulseToCenter(b2Vec2(x, y), true);
}

void Actor::draw(sf::RenderWindow * window) {
	//grab the sprite and draw it based on the current position
	auto position = getPosition();
	float x = position.first;
	float y = position.second;
	//...
}
