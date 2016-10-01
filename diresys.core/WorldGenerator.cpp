#include "WorldGenerator.h"



WorldGenerator::WorldGenerator()
{
}


WorldGenerator::~WorldGenerator()
{
}

World* WorldGenerator::loadFromFile(string filename) {
	ifstream filehandle(filename);
	string output((istreambuf_iterator<char>(filehandle)),
		istreambuf_iterator<char>());

	auto* world = generateWorld(output);
	return world;
}

pair<int, int> WorldGenerator::getWorldExtents(string input) {
	istringstream stream(input);
	string line;

	int i = 0;
	int j = 0;
	while (getline(stream, line)) {
		i = line.size();
		j++;
	}

	cout << "Width: " << i << endl;
	cout << "Height: " << j << endl;
	return pair<int, int>(i, j);
}

World * WorldGenerator::generateWorld(string input) {
	istringstream stream(input);
	string line;

	//Generate world based on extents
	auto dims = WorldGenerator::getWorldExtents(input);
	int width = dims.first;
	int height = dims.second;
	auto* world = new World(width, height);
	auto* physics = world->getPhysicsWorld();

	int j = 0;
	while (getline(stream, line)) {
		for (int i = 0; i < width; i++) {
			auto position = make_pair(i*TILE_SIZE, j*TILE_SIZE);
			char character = line[i];
			if (character == '.') {
				world->setTile(i, j, static_cast<Tile*>(new EmptyTile(physics, position)));
			}
			else if (character == '+') {
				world->setTile(i, j, static_cast<Tile*>(new FloorTile(physics, position)));
			}
			else if (character == '@') {
				auto* player = new Player(physics);
				world->setTile(i, j, static_cast<Tile*>(new FloorTile(physics, position)));
				world->addActor(i, j, static_cast<Actor*>(player));
				world->setPlayer(player);
			}
		}
		j++;
	}
	return world;
}
