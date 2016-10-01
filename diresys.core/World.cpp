#include "World.h"

World::World(int width, int height) {
	this->width = width;
	this->height = height;
	// Initialize Physics World
	b2Vec2 gravity(0.0f, 0.0f);
	this->physics_world = make_shared<b2World>(b2World(gravity));
	for (int i = 0; i < width; i++) {
		for (int j = 0; j < height; j++) {
			/*auto position = make_pair(
				i * TILE_SIZE,
				j * TILE_SIZE);
			auto tile = make_shared<Tile>(Tile(physics_world, position));
			this->tile_map.push_back(tile);*/
			this->tile_map.push_back(shared_ptr<Tile>(nullptr));
		}
	}

}

World::~World() {}

shared_ptr<b2World> World::getPhysicsWorld() {
	assert(this->physics_world != nullptr);
	return this->physics_world;
}

void World::setWindow(shared_ptr<sf::RenderWindow> window) {
	assert(this->window == nullptr);
	this->window = window;
	this->camera = make_shared<Camera>(Camera(window));
}

void World::setTile(int tile_x, int tile_y, shared_ptr<Tile> tile) {
	int index = tile_x + width * tile_y;
	this->tile_map[index] = tile;
}

shared_ptr<Tile> World::getTile(int tile_x, int tile_y) {
	int index = tile_x + this->height * tile_y;
	return this->tile_map[index];
}

void World::addActor(int tile_x, int tile_y, shared_ptr<Actor> actor) {
	this->actor_list.push_back(actor);
}

void World::removeActor(shared_ptr<Actor> actor) {
	remove_if(this->actor_list.begin(), this->actor_list.end(),
		[&actor](auto _actor) {return actor != _actor;});
}

void World::handleEvents() {
	for (auto& event : EventManager::getInstance()->getEvents()) {
		//process events
	}
}

void World::clearMap() {
	for (int i = 0; i < (width); i++) {
		for (int j = 0; j < height; j++) {
			auto position = make_pair(
				i*TILE_SIZE, j*TILE_SIZE);
			auto tile = make_shared<Tile>(EmptyTile(physics_world, position));
			this->setTile(i, j, tile);
		}
	}
}

shared_ptr<Camera> World::getCamera()
{
	return camera;
}

void World::setPlayer(shared_ptr<Player> player) {
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
	for (auto actor : actor_list) {
		actor->draw(this->window);
	}
}

void World::draw_tiles() {
	for (int i = 0; i < width; i++) {
		for (int j = 0; j < height; j++) {
			auto tile = this->getTile(i, j);
			tile->draw(window, i, j);
		}
	}
}

void World::draw_shadows() {
	for (int i = 0; i < width; i++) {
		for (int j = 0; j < height; j++) {
			auto tile = getTile(i, j);
			tile->draw_shadow(window, i, j);
		}
	}
}
