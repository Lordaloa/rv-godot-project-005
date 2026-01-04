class_name InputControllerEntityHumanBot
extends InputControllerEntityHuman
## Class for bot controlled input on a human entity.

func get_input_vector() -> Vector2:
    return Vector2.ZERO

func is_attacking() -> bool:
    return false

func is_blocking() -> bool:
    return true

func get_looking_vector() -> Vector2:
    return Vector2.ZERO