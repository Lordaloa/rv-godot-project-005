class_name Entity
extends CharacterBody3D
## "Abstract" Entity class for all entities

@export var speed = 5.0
@export var speed_lerp = 0.15
@export var rotation_lerp = 0.15
var input_vector: Vector2 = Vector2.ZERO
var input_looking: Vector2 = Vector2.ZERO
var input_is_attacking: bool = false
var input_is_blocking: bool = false
@onready var armature = $Skeleton
@onready var skeleton = $Skeleton/Skeleton3D
@onready var anim_tree = $AnimationTree

# -----------------------------------------------------------------------------
# Virtuals
# -----------------------------------------------------------------------------

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	_capture_input()

func _physics_process(delta: float) -> void:
	apply_gravity(delta)

# -----------------------------------------------------------------------------
# Publics
# -----------------------------------------------------------------------------

func apply_gravity(delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta

# -----------------------------------------------------------------------------
# Privates
# -----------------------------------------------------------------------------

func _capture_input():
	input_vector = Input.get_vector("left", "right", "forward", "back")
	input_is_attacking = Input.is_action_pressed("attack")
	input_is_blocking = Input.is_action_pressed("block")
	input_looking = Input.get_last_mouse_velocity()

