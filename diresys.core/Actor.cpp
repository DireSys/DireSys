#include "Actor.h"

Actor::Actor(b2World * physics_world) : 
	physics_world(physics_world) {
	this->initPhysicsBody();
	this->initPhysicsFixture();
}

Actor::~Actor() {
	this->physics_world->DestroyBody(this->physics_body);
}

void Actor::initPhysicsBody() {
	//create body from bodydef
	//apply to this->physics_body
}

void Actor::initPhysicsFixture() {
	//create fixture and add to body
}

void Actor::setPosition(int x, int y) {
	b2Vec2 position(
		(float)x * PHYSICS_SCALE(),
		(float)y * PHYSICS_SCALE());
	this->physics_body->SetTransform(position, 0.0f);
}

pair<float, float> Actor::getPosition() {
	auto position = this->physics_body->GetPosition();
	return pair<float, float>(
		position.x * WORLD_SCALE(),
		position.y * WORLD_SCALE());
}

void Actor::applyForce(float x, float y) {
	b2Vec2 force(x * PHYSICS_SCALE(), y * PHYSICS_SCALE());
	this->physics_body->ApplyForceToCenter(force, true);
}

void Actor::applyImpulse(float x, float y) {
	b2Vec2 impulse(x * PHYSICS_SCALE(), y * PHYSICS_SCALE());
	this->physics_body->ApplyLinearImpulseToCenter(impulse, true);
}

void Actor::draw(sf::RenderWindow * window) {
	//grab the sprite and draw it based on the current position
	auto position = getPosition();
	float x = position.first;
	float y = position.second;
	//...
}
