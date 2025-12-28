extends CharacterBody3D

@onready var armature = $Skeleton
@onready var skeleton = $Skeleton/Skeleton3D
@onready var skeleton_look_at_modifier = $Skeleton/Skeleton3D/LookAtModifier3D
@onready var spring_arm_pivot = $SpringArmPivot
@onready var spring_arm = $SpringArmPivot/SpringArm3D
@onready var anim_tree = $AnimationTree

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const LERP_VAL = 0.15
const ATTACKING_COOLDOWN = 1.0
const ATTACKING_LOOKAT_TIME = 0.125
const ATTACKING_LOOKINGAWAY_TIME = 0.125
var cooldown = 0.0
var MOUSE_MODE = Input.MOUSE_MODE_CAPTURED
var IS_ATTACKING = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		if (Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED):
			MOUSE_MODE = Input.MOUSE_MODE_VISIBLE
		else:
			MOUSE_MODE = Input.MOUSE_MODE_CAPTURED
		Input.set_mouse_mode(MOUSE_MODE)
		# Uncomment to quit the game instead of toggling mouse mode
		# get_tree().quit()
	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x * 0.00125)
		spring_arm.rotate_x(-event.relative.y * 0.00125)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)

func _physics_process(delta: float) -> void:
	# Gravity!
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Capture movement input
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated((Vector3.UP), spring_arm_pivot.rotation.y)

	# Calculate direction, velocity and rotate the human towards movement if moving
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, LERP_VAL)
		velocity.z = lerp(velocity.z, direction.z * SPEED, LERP_VAL)
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-velocity.x, -velocity.z), LERP_VAL)
	else:
		velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
		velocity.z = lerp(velocity.z, 0.0, LERP_VAL)

	# Play running animation based on speed, perhaps add extra if prevent callback when not moving.
	anim_tree.set("parameters/Running/blend_position", velocity.length() / SPEED)
	
	if Input.is_action_pressed("attack") and cooldown <= 0.0:
		cooldown = ATTACKING_COOLDOWN
		IS_ATTACKING = true;
		
		anim_tree.set("parameters/Attack/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	elif cooldown <= 0.0:
		skeleton_look_at_modifier.set_influence(lerp(skeleton_look_at_modifier.influence, 0.0, ATTACKING_LOOKINGAWAY_TIME))
		IS_ATTACKING = false;

	if IS_ATTACKING:
		skeleton_look_at_modifier.set_influence(lerp(skeleton_look_at_modifier.influence, 1.0, ATTACKING_LOOKAT_TIME))
	cooldown -= delta
	move_and_slide()

# print("Attack!")
# var new_trans = skeleton.get_bone_global_pose(skeleton.find_bone("Spine_Upper")).looking_at(camera.global_transform.origin, Vector3.FORWARD)
# print(skeleton.get_bone_pose(skeleton.find_bone("Spine_Upper")))
# print(skeleton.get_bone_global_pose(skeleton.find_bone("Spine_Upper")))
# print(spring_arm_pivot.transform)
# print(spring_arm.transform)
# skeleton.set_bone_global_pose(skeleton.find_bone("Spine_Upper"),spring_arm_pivot.transform * spring_arm.transform) 
