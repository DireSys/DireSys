#include "World.h"



World::World(size_t width, size_t height) {
	mMapWidth = width;
	mMapHeight = height;
	mTileMap = new Tile[width][height][1];
}


World::~World(){

}
