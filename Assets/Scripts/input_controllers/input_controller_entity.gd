class_name InputControllerEntity
extends InputController
## "Abstract" class for entity input_controllers.

func get_input_vector() -> Vector2:
    return Vector2.ZERO

func get_looking_vector() -> Vector2:
    return Vector2.ZERO