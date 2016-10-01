#include "Tile.h"

Tile::Tile(b2World* physics_world, pair<float, float> position = make_pair(0,0)) :
	physics_world(physics_world) {
	this->initPhysicsBody(position);
	this->initPhysicsFixture();
}

Tile::~Tile() {
	assert(physics_body != nullptr);
	this->physics_body->GetWorld()->DestroyBody(this->physics_body);
	//this->physics_world->DestroyBody(physics_body);
}

void Tile::initPhysicsBody(pair<float, float> position) {
	b2BodyDef bodydef;
	bodydef.position.Set(
		position.first * PHYSICS_SCALE(),
		position.second * PHYSICS_SCALE());
	bodydef.type = b2_staticBody;
	bodydef.fixedRotation = false;
	bodydef.active = false;
	this->physics_body = this->physics_world->CreateBody(&bodydef);
}

void Tile::initPhysicsFixture() {
	//default, is a static block
	b2PolygonShape boxshape;
	boxshape.SetAsBox(
		4 * PHYSICS_SCALE(),
		4 * PHYSICS_SCALE());
	b2FixtureDef fixturedef;
	fixturedef.shape = &boxshape;
	this->physics_body->CreateFixture(&fixturedef);
}

void Tile::draw(sf::RenderWindow* window, int tile_x, int tile_y) {}

void Tile::draw_shadow(sf::RenderWindow * window, int tile_x, int tile_y) {

}
