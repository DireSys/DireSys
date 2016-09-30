#pragma once

#define APP_NAME "DireSys"

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
	vector<World*> stages;
	World* current_stage = nullptr;
	int stageIndex = 0;
	bool brunning = false;
	EventManager* eventManager;
	sf::RenderWindow* window;
public:
	DireSys();
	~DireSys();

	void handleEvents();

	// Worlds are placed as stages
	void addStage(World* world);
	void loadStage(int index);
	void runGameLoop();
	bool nextStage();

	void startGame();
	void endGame();
};
