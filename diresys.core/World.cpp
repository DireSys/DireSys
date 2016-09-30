#include "World.h"

World::World(int width, int height) {
	this->width = width;
	this->height = height;

	// Initialize Physics World
	b2Vec2 gravity(0.0f, 0.0f);
	this->physics_world = new b2World(gravity);

	// Populate World with empty tiles
	for (int i = 0; i < (width * height); i++) {
		this->tile_map.push_back(static_cast<Tile*>(new EmptyTile(physics_world)));
	}
}

World::~World() {
	//Remove all tiles
	for (int i = 0; i < (width * height); i++) {
		delete this->tile_map[i];
	}

	//Remove all actors
	for (auto* actor : actor_list) {
		this->removeActor(actor);
	}

	//Delete the box2d world.
	delete this->physics_world;

	//Delete the Camera
	delete this->camera;

	this->player = nullptr;
}

b2World * World::getPhysicsWorld() {
	assert(this->physics_world != nullptr);
	return this->physics_world;
}

void World::setWindow(sf::RenderWindow* window) {
	assert(this->window == nullptr);
	this->window = window;
}

void World::setTile(int tile_x, int tile_y, Tile* tile) {
	int index = tile_x + width * tile_y;
	//delete the old tile
	delete this->tile_map[index];

	this->tile_map[index] = tile;
}

Tile* World::getTile(int tile_x, int tile_y) {
	int index = tile_x + this->height * tile_y;
	return this->tile_map[index];
}

void World::addActor(Actor* actor) {
	this->actor_list.push_back(actor);
}

void World::removeActor(Actor* actor) {
	remove_if(this->actor_list.begin(), this->actor_list.end(),
		[&actor](auto _actor) {return actor != _actor;});
}

void World::handleEvents() {
	for (auto* event : EventManager::getInstance()->getEvents()) {
		//process events
	}
}

void World::clearMap() {
	for (int i = 0; i < (width); i++) {
		for (int j = 0; j < height; j++) {
			this->setTile(i, j, static_cast<Tile*>(new EmptyTile(physics_world)));
		}
	}
}

void World::setPlayer(Actor * player) {
	this->player = player;
	this->camera->linkActor(player);
}

void World::draw() {
	this->positionCamera();
	this->draw_tiles();
	this->draw_actors();
	this->draw_shadows();
}

void World::step() {
	this->physics_world->Step(TIME_STEP, VELOCITY_ITERATIONS, POSITION_ITERATIONS);
	this->positionCamera();
	this->draw();
	this->handleEvents();
}

void World::positionCamera() {
	this->camera->reposition();
}

void World::draw_actors() {
	for (auto* actor : actor_list) {
		actor->draw(this->window);
	}
}

void World::draw_tiles() {
	for (int i = 0; i < width; i++) {
		for (int j = 0; j < height; j++) {
			auto* tile = this->getTile(i, j);
			tile->draw(window, i, j);
		}
	}
}

void World::draw_shadows() {
	for (int i = 0; i < width; i++) {
		for (int j = 0; j < height; j++) {
			auto* tile = getTile(i, j);
			tile->draw_shadow(window, i, j);
		}
	}
}
