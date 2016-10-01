#include "Tile.h"

Tile::Tile(shared_ptr<b2World> physics_world, TilePosition position = make_pair(0.0f,0.0f)) :
	physics_world(physics_world) {
	this->initPhysicsBody(position);
	this->initPhysicsFixture();
}

Tile::~Tile() {}

void Tile::setType(TileType type) {
	this->type = type;
}

void Tile::initPhysicsBody(TilePosition position) {
	b2BodyDef bodydef;
	bodydef.position.Set(
		position.first * PHYSICS_SCALE(),
		position.second * PHYSICS_SCALE());
	bodydef.type = b2_staticBody;
	bodydef.fixedRotation = true;
	bodydef.active = false;
	auto* rawbody = this->physics_world->CreateBody(&bodydef);

	//we assign a custom deleter, since the pointer is allocated in box2d's memory allocator
	auto body = shared_ptr<b2Body>(rawbody, [=](auto* b) {
		cout << "About to delete body:" << b << endl;
		if (this->physics_world == nullptr) {
			return;
		}
		auto* bodyiter = this->physics_world->GetBodyList();
		while (bodyiter->GetNext()) {
			if (b == bodyiter) {
				this->physics_world->DestroyBody(b);
				cout << "Body deleted" << endl;
				break;
			}
		}
		
	});
	this->physics_body = body;
}

void Tile::initPhysicsFixture() {
	//default, is a static block
	b2PolygonShape boxshape;
	boxshape.SetAsBox(
		TILE_SIZE/2 * PHYSICS_SCALE(),
		TILE_SIZE/2 * PHYSICS_SCALE());
	b2FixtureDef fixturedef;
	fixturedef.shape = &boxshape;
	this->physics_body->CreateFixture(&fixturedef);
}

void Tile::draw(shared_ptr<sf::RenderWindow> window,
	int tile_x, int tile_y) {

}

void Tile::draw_shadow(shared_ptr<sf::RenderWindow> window,
	int tile_x, int tile_y) {

}
