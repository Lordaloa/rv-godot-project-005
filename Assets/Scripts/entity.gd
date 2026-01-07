class_name Entity
extends CharacterBody3D
## "Abstract" Entity class for all entities

## Total amount of health.
@export_range(1.0, 1000.0, 1.0, "or_greater") var total_health = 100.0
## Current amount of health.
@export_range(1.0, 1000.0, 1.0, "or_greater") var health = 100.0
## Top speed the entity can reach
@export_range(0.01, 100.0, 1.0, "or_greater") var speed = 5.0
## How quickly top speed is reached with 1.0 beïng instant and 0.0 not accelerating.
@export_range(0.01, 1.0) var speed_lerp = 0.15
## How quickly rotation is reached with 1.0 beïng instant and 0.0 not rotating.
@export_range(0.01, 1.0) var rotation_lerp = 0.15
## InputController based on the specific entity's class.
@export var input_controller: InputControllerEntity
## Node3D for running any direction based raycasts like is_blocking().
@export var raycast_node: Node3D
var spine_upper_bone_id: int
var input_vector: Vector2 = Vector2.ZERO
var input_looking: Vector2 = Vector2.ZERO
@onready var entity: Node3D = $Skeleton
@onready var armature: Skeleton3D = $Skeleton/Skeleton3D
@onready var look_at_modifier: LookAtModifier3D = $Skeleton/Skeleton3D/LookAtModifier3D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var spring_arm_pivot: Node3D = $SpringArmPivot
@onready var spring_arm: SpringArm3D = $SpringArmPivot/SpringArm3D

# -----------------------------------------------------------------------------
# Virtuals
# -----------------------------------------------------------------------------

func _ready() -> void:
	spine_upper_bone_id = armature.find_bone('Spine_Upper')
	# look_at_modifier.connect('modification_processed',_on_look_at_modified)

func _process(_delta: float) -> void:
	capture_input()

func _physics_process(delta: float) -> void:
	apply_gravity(delta)

# -----------------------------------------------------------------------------
# Publics
# -----------------------------------------------------------------------------

# func try_take_hit(impact_position: Vector3, damage: float) -> bool:
# 	if is_blocking(impact_position):
# 		return false
# 	apply_damage(damage)
# 	return true

func apply_damage(damage: float):
	health -= damage
	# if health <= 0.0:
		# queue_free()

func apply_gravity(delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta

func capture_input():
	input_vector = input_controller.get_input_vector()
	input_looking = input_controller.get_looking_vector()

func apply_looking(delta: float):
	spring_arm_pivot.rotate_y(-input_looking.x * delta * 0.00125)
	spring_arm.rotate_x(-input_looking.y * delta  * 0.00125)
	spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)

func apply_movement():
	var direction := (transform.basis * Vector3(input_vector.x, 0, input_vector.y)).normalized()
	direction = direction.rotated((Vector3.UP), spring_arm_pivot.rotation.y)
	if direction:
		velocity.x = lerp(velocity.x, direction.x * speed, speed_lerp)
		velocity.z = lerp(velocity.z, direction.z * speed, speed_lerp)
		entity.global_rotation.y = lerp_angle(entity.global_rotation.y, atan2(-velocity.x, -velocity.z), rotation_lerp)
	else:
		velocity.x = lerp(velocity.x, 0.0, speed_lerp)
		velocity.z = lerp(velocity.z, 0.0, speed_lerp)
	move_and_slide()

func get_current_health() -> float:
	return health;

# func is_blocking(_impact_position: Vector3) -> bool:
# 	return false

# -----------------------------------------------------------------------------
# Privates
# -----------------------------------------------------------------------------

# func _on_look_at_modified() -> void:
# 	pass
