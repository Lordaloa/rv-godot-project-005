class_name InputControllerEntityHumanBot
extends InputControllerEntityHuman
## Class for bot controlled input on a human entity.

func get_input_vector() -> Vector2:
    return Vector2.ZERO

func is_right_hand_action() -> bool:
    return true

func is_right_hand_action_released() -> bool:
    return false

func is_left_hand_action() -> bool:
    return false

func is_left_hand_action_released() -> bool:
    return false

func get_looking_vector() -> Vector2:
    return Vector2.ZERO