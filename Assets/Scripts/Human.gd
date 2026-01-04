class_name Human
extends Entity
## Human Entity class for human actions and abilities

## How quickly the right_hand_action animation is in full motion with 1.0 beïng instant and 0.0 doing nothing.
@export_range(0.01, 1.0) var right_hand_action_lerp = 0.25
## How quickly the left_hand_action animation is in full motion with 1.0 beïng instant and 0.0 doing nothing.
@export_range(0.01, 1.0) var left_hand_action_lerp = 0.25
## How quickly the human is looking at to the look_at target with 1.0 beïng instant and 0.0 doing nothing.
@export_range(0.01, 1.0) var looking_lerp = 0.25
@export var right_hand_weapon: Weapon
@export var left_hand_weapon: Weapon
var input_is_right_hand_action: bool = false
var input_is_left_hand_action: bool = false
@onready var skeleton_look_at_modifier = $Skeleton/Skeleton3D/LookAtModifier3D
@onready var skeleton_right_hand_target = $Skeleton/Skeleton3D/Right_Hand_Target
@onready var skeleton_left_hand_target = $Skeleton/Skeleton3D/Left_Hand_Target

# -----------------------------------------------------------------------------
# Virtuals
# -----------------------------------------------------------------------------

func _ready() -> void:
	super._ready()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	super._process(delta)

func _unhandled_input(event: InputEvent) -> void:
	if input_controller is InputControllerEntityHumanPlayer:
		if event.is_action_pressed("escape"):
			get_tree().quit()
		if event.is_action_pressed('control'):
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	apply_looking(delta)
	apply_movement()
	apply_right_hand_action(delta)
	apply_left_hand_action(delta)
	apply_spine_modifier()

# -----------------------------------------------------------------------------
# Constructors
# -----------------------------------------------------------------------------



# -----------------------------------------------------------------------------
# Publics
# -----------------------------------------------------------------------------

func apply_right_hand_action(delta: float) -> void:
	if input_is_right_hand_action and right_hand_weapon is Weapon:
		if right_hand_weapon.has_cooled_down():
			animation_tree.set("parameters/Right_Hand/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		right_hand_weapon.action(delta)
	# 	if equiped_weapon is WeaponMelee and !equiped_weapon.is_damage_area_enabled():
	# 		equiped_weapon.enable_damage_area()	
	# 	anim_tree.set("parameters/Attack/blend_amount", lerp(anim_tree.get("parameters/Attack/blend_amount"), 1.0, right_hand_action_lerp))
	# else:
	# 	if equiped_weapon is WeaponMelee and equiped_weapon.is_damage_area_enabled():
	# 		equiped_weapon.disable_damage_area()			
	# 	anim_tree.set("parameters/Attack/blend_amount", lerp(anim_tree.get("parameters/Attack/blend_amount"), 0.0, right_hand_action_lerp))
	# 	if (anim_tree.get("parameters/Attack/blend_amount") <= 0.1):
	# 		anim_tree.set("parameters/Attack_TimeSeek/seek_request", 0.0)
		

func apply_left_hand_action(delta: float):
	if input_is_left_hand_action and left_hand_weapon is Weapon:
		if left_hand_weapon.has_cooled_down():
			animation_tree.set("parameters/Left_Hand/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		left_hand_weapon.action(delta)
	# if input_is_left_hand_action:
	# 	if equiped_weapon is WeaponShield and !equiped_weapon.is_blocking_area_enabled():
	# 		equiped_weapon.enable_blocking_area()	
	# 	anim_tree.set("parameters/Block/blend_amount",lerp(anim_tree.get("parameters/Block/blend_amount"), 1.0, left_hand_action_lerp))
	# else:
	# 	if equiped_weapon is WeaponShield and equiped_weapon.is_blocking_area_enabled():
	# 		equiped_weapon.disable_blocking_area()
	# 	anim_tree.set("parameters/Block/blend_amount",lerp(anim_tree.get("parameters/Block/blend_amount"), 0.0, left_hand_action_lerp))
	# 	if (anim_tree.get("parameters/Block/blend_amount") <= 0.1):
	# 		anim_tree.set("parameters/Block_TimeSeek/seek_request", 0.0)

func apply_looking(delta: float):
	super.apply_looking(delta)

func apply_movement():
	super.apply_movement()
	animation_tree.set("parameters/Running/blend_position", velocity.length() / speed)


func apply_spine_modifier():
	if input_is_right_hand_action or input_is_left_hand_action:
		skeleton_look_at_modifier.set_influence(lerp(skeleton_look_at_modifier.influence, 1.0, looking_lerp))
	else:
		skeleton_look_at_modifier.set_influence(lerp(skeleton_look_at_modifier.influence, 0.0, looking_lerp))

func apply_damage(damage: float):
	super.apply_damage(damage)
	animation_tree.set("parameters/Block/blend_amount", 1.0)
	animation_tree.set("parameters/Attack/blend_amount", 1.0)

func capture_input():
	super.capture_input()
	input_is_right_hand_action = input_controller.is_right_hand_action()
	input_is_left_hand_action = input_controller.is_left_hand_action()

# -----------------------------------------------------------------------------
# Privates
# -----------------------------------------------------------------------------
