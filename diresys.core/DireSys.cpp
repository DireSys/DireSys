#include "DireSys.h"

DireSys::DireSys() {
	this->eventManager = EventManager::getInstance();
	this->window = new sf::RenderWindow(sf::VideoMode(WINDOW_WIDTH, WINDOW_HEIGHT), APP_NAME);
	this->eventManager->setWindow(window);
}

DireSys::~DireSys() {
	delete this->window;
}

void DireSys::handleEvents() {
	for (auto* event : eventManager->getEvents()) {
		//process any events
	}
}

void DireSys::addStage(World * world) {
	world->setWindow(window);
	stages.push_back(world);
}

void DireSys::loadStage(int index) {
	assert(index < stages.size());
	stageIndex = index;
}

void DireSys::runGameLoop() {
	while (this->brunning && stageIndex < stages.size()) {
		//Graphics Clear
		window->clear();

		//Generates Events
		eventManager->processEvents();

		//Handle Top-Level Events (Quit, NextStage)
		this->handleEvents();

		//Run the current Stage (World)
		stages[stageIndex]->step();

		//Clear the event manager
		eventManager->clearEvents();
	}
}

bool DireSys::nextStage() {
	stageIndex++;
	if (stageIndex >= stages.size()) {
		return false;
	}
	else {
		loadStage(stageIndex);
		return true;
	}
}

void DireSys::startGame() {
	assert(stages.size() > 0);
	loadStage(0);
	runGameLoop();
	while (nextStage()) {
		runGameLoop();
	}
	endGame();
}

void DireSys::endGame() {
	cout << "Game Ended!" << endl;
}
