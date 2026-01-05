class_name InputControllerEntityHumanPlayer
extends InputControllerEntityHuman
## Class for player controlled input on a human entity.

func get_input_vector() -> Vector2:
	return Input.get_vector("left", "right", "forward", "back")

func is_right_hand_action() -> bool:
	return Input.is_action_pressed("right_hand_action")

func is_right_hand_action_released() -> bool:
	return Input.is_action_just_released("right_hand_action")

func is_left_hand_action() -> bool:
	return Input.is_action_pressed("left_hand_action")

func is_left_hand_action_released() -> bool:
	return Input.is_action_just_released("left_hand_action")

func get_looking_vector() -> Vector2:
	return Input.get_last_mouse_velocity()
