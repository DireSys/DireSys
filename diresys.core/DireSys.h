#pragma once

#define APP_NAME "DireSys"

#include <vector>

#include "World.h"

class DireSys {
private:
	vector<World> stages;
	int stageIndex = 0;
	bool brunning = false;
public:
	DireSys();
	~DireSys();

	void addStage(World world);
	void loadStage(int index);
	void run();
};
