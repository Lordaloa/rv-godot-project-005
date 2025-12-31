class_name InputControllerEntityHumanPlayer
extends InputControllerEntityHuman
## Class for player controlled input on a human entity.

func get_input_vector() -> Vector2:
	return Input.get_vector("left", "right", "forward", "back")

func is_attacking() -> bool:
	return Input.is_action_pressed("attack")

func is_blocking() -> bool:
	return Input.is_action_pressed("block")

func get_looking_vector() -> Vector2:
	return Input.get_last_mouse_velocity()
