#include "Camera.h"

Camera::Camera(sf::RenderWindow * window) {
	window->setView(*view);
}

Camera::~Camera() {
	delete view;
}

void Camera::linkActor(Player* actor) {
	linked_actor = actor;
}

void Camera::unlinkActor() {
	linked_actor = nullptr;
}

void Camera::reposition() {
	assert(linked_actor != nullptr);
	auto position = linked_actor->getPosition();
	float x = position.first;
	float y = position.second;

	//set viewport
	//view.reset(sf::FloatRect(x, y, WINDOW_WIDTH, WINDOW_HEIGHT);
}
