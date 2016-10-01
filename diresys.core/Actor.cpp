#include "Actor.h"

Actor::Actor(shared_ptr<b2World> physics_world, ActorPosition position) : 
	physics_world(physics_world) {
	this->initPhysicsBody(position);
	this->initPhysicsFixture();
}

Actor::~Actor() {}

void Actor::initPhysicsBody(ActorPosition position) {
	b2BodyDef bodydef;
	bodydef.position.Set(
		position.first * PHYSICS_SCALE(),
		position.second * PHYSICS_SCALE());
	bodydef.type = b2_dynamicBody;
	bodydef.fixedRotation = true;
	bodydef.active = true;
	auto* rawbody = this->physics_world->CreateBody(&bodydef);

	//we assign a custom deleter, since the pointer is allocated in box2d's memory allocation
	auto body = shared_ptr<b2Body>(rawbody, [&](auto* b) {physics_world->DestroyBody(b); });
	this->physics_body = body;
}

void Actor::initPhysicsFixture() {
	//create fixture and add to body
}

void Actor::setPosition(float x, float y) {
	b2Vec2 position(
		x * PHYSICS_SCALE(),
		y * PHYSICS_SCALE());
	this->physics_body->SetTransform(position, 0.0f);
}

ActorPosition Actor::getPosition() {
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

void Actor::draw(shared_ptr<sf::RenderWindow> window) {
	//grab the sprite and draw it based on the current position
	auto position = getPosition();
	float x = position.first;
	float y = position.second;
	//...
}
