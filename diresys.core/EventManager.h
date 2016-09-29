#pragma once
#include <vector>
#include <memory>
using namespace std;

#include "DSEvent.h"
class EventManager {
private:
	vector<unique_ptr<DSEvent>> event_list;
public:
	EventManager();
	~EventManager();

	void addEvent(DSEvent* event);
	const vector<unique_ptr<DSEvent>>& getEvents();
	void clearEvents();
};

