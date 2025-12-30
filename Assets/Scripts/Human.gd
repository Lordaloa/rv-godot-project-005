class_name Human
extends Entity
## Human Entity class for human actions and abilities

@onready var skeleton_look_at_modifier = $Skeleton/Skeleton3D/LookAtModifier3D
@onready var spring_arm_pivot = $SpringArmPivot
@onready var spring_arm = $SpringArmPivot/SpringArm3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const LERP_VAL = 0.15
const BLOCKING_TIME = 0.25
const ATTACKING_TIME = 0.25
const LOOKING_TIME = 0.125

var mouse_mode = Input.MOUSE_MODE_CAPTURED

# -----------------------------------------------------------------------------
# Virtuals
# -----------------------------------------------------------------------------

func _ready() -> void:
	super._ready()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	super._process(delta)
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		get_tree().quit()
	if event.is_action_pressed('control'):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	apply_looking(delta)
	apply_movement()
	apply_attacking()
	apply_blocking()
	apply_spine_modifier()

# -----------------------------------------------------------------------------
# Constructors
# -----------------------------------------------------------------------------



# -----------------------------------------------------------------------------
# Publics
# -----------------------------------------------------------------------------

func apply_movement():
	var direction := (transform.basis * Vector3(input_vector.x, 0, input_vector.y)).normalized()
	direction = direction.rotated((Vector3.UP), spring_arm_pivot.rotation.y)
	if direction:
		velocity.x = lerp(velocity.x, direction.x * speed, speed_lerp)
		velocity.z = lerp(velocity.z, direction.z * speed, speed_lerp)
		armature.global_rotation.y = lerp_angle(armature.global_rotation.y, atan2(-velocity.x, -velocity.z), rotation_lerp)
	else:
		velocity.x = lerp(velocity.x, 0.0, speed_lerp)
		velocity.z = lerp(velocity.z, 0.0, speed_lerp)
	anim_tree.set("parameters/Running/blend_position", velocity.length() / SPEED)
	move_and_slide()

func apply_looking(delta: float):
	spring_arm_pivot.rotate_y(-input_looking.x * delta * 0.00125)
	spring_arm.rotate_x(-input_looking.y * delta  * 0.00125)
	spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)

func apply_attacking():
	if input_is_attacking:
		anim_tree.set("parameters/Attack/blend_amount",lerp(anim_tree.get("parameters/Attack/blend_amount"), 1.0, ATTACKING_TIME))
	else:
		anim_tree.set("parameters/Attack/blend_amount",lerp(anim_tree.get("parameters/Attack/blend_amount"), 0.0, ATTACKING_TIME))
		if (anim_tree.get("parameters/Attack/blend_amount") <= 0.1):
			anim_tree.set("parameters/Attack_TimeSeek/seek_request", 0.0)

func apply_blocking():
	if input_is_blocking:
		anim_tree.set("parameters/Block/blend_amount",lerp(anim_tree.get("parameters/Block/blend_amount"), 1.0, BLOCKING_TIME))
	else:
		anim_tree.set("parameters/Block/blend_amount",lerp(anim_tree.get("parameters/Block/blend_amount"), 0.0, BLOCKING_TIME))
		if (anim_tree.get("parameters/Block/blend_amount") <= 0.1):
			anim_tree.set("parameters/Block_TimeSeek/seek_request", 0.0)

func apply_spine_modifier():
	if input_is_attacking or input_is_blocking:
		skeleton_look_at_modifier.set_influence(lerp(skeleton_look_at_modifier.influence, 1.0, LOOKING_TIME))
	else:
		skeleton_look_at_modifier.set_influence(lerp(skeleton_look_at_modifier.influence, 0.0, LOOKING_TIME))

# -----------------------------------------------------------------------------
# Privates
# -----------------------------------------------------------------------------
