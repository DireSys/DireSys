#pragma once

#include <vector>
#include <cassert>
#include <iostream>
using namespace std;

#include "SFML/Graphics.hpp"

#include "DSConstants.h"
#include "World.h"
#include "EventManager.h"

class DireSys {
private:
	vector<unique_ptr<World>> stages;
	int stageIndex = 0;
	bool brunning = false;
	EventManager* eventManager;
	shared_ptr<sf::RenderWindow> window;
public:
	DireSys();
	~DireSys();

	void handleEvents();

	// Worlds are placed as stages
	void addStage(unique_ptr<World> world);
	void loadStage(int index);
	void runGameLoop();
	bool nextStage();

	void startGame();
	void endGame();
};
