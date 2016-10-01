#pragma once
#include <string>
#include <tuple>
#include <fstream>
#include <sstream>
#include <streambuf>
#include <memory>
using namespace std;

#include "World.h"
#include "Tile.h"
#include "EmptyTile.h"

class WorldGenerator {
public:
	WorldGenerator();
	~WorldGenerator();

	static unique_ptr<World> loadFromFile(string filename);
	static pair<size_t, size_t> getWorldExtents(string input);
	static unique_ptr<World> generateWorld(string input);
};

