#include "Tile.h"

Tile::Tile(b2World* physics_world) : 
	physics_world(physics_world) {
}

Tile::~Tile() {
	this->physics_world->DestroyBody(physics_body);
}

void Tile::draw(sf::RenderWindow* window, int tile_x, int tile_y) {}

void Tile::draw_shadow(sf::RenderWindow * window, int tile_x, int tile_y) {

}
