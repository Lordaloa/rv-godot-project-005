class_name InputControllerEntityHuman
extends InputControllerEntity
## "Abstract" class for entity human input controller.

func get_input_vector() -> Vector2:
    return Vector2.ZERO

func is_attacking() -> bool:
    return false

func is_blocking() -> bool:
    return false

func get_looking_vector() -> Vector2:
    return Vector2.ZERO
