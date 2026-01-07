class_name WeaponMelee
extends Weapon
## "Abstract" WeaponMelee class for melee weapons, handles all Melee related actions.

@export var damage: float = 35.0
@onready var damage_area_3d: Area3D = $Damage_Area3D
@onready var damage_collision_shape_3d: CollisionShape3D = $Damage_Area3D/Damage_CollisionShape3D

# -----------------------------------------------------------------------------
# Virtuals
# -----------------------------------------------------------------------------

func _ready() -> void:
	super._ready()

func _process(delta: float) -> void:
	super._process(delta)
	## TODO let's move this as part of the signal chain so we don't check every frame but x times per action run.
	_test_damage_area()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

# -----------------------------------------------------------------------------
# Constructors
# -----------------------------------------------------------------------------

func init_weapon_melee(new_entity_owner: Entity) -> WeaponMelee:
	var weapon_melee: WeaponMelee = super.init_weapon(new_entity_owner)
	return weapon_melee

# -----------------------------------------------------------------------------
# Publics
# -----------------------------------------------------------------------------

func action(delta: float) -> void:
	super.action(delta)

func disable_damage_area() -> void:
	damage_area_3d.monitoring = false
	damage_area_3d.monitorable = false

func enable_damage_area() -> void:
	damage_area_3d.monitoring = true
	damage_area_3d.monitorable = true

func is_damage_area_enabled() -> bool:
	return damage_area_3d.monitoring and damage_area_3d.monitorable

func run_action() -> void:
	is_action_completed = true
	enable_damage_area()
	await get_tree().create_timer(action_time).timeout
	disable_damage_area()
	is_action_completed = false
	emit_signal('action_completed')

# -----------------------------------------------------------------------------
# Privates
# -----------------------------------------------------------------------------

func _test_damage_area() -> void:
	if is_damage_area_enabled():
		var target_is_blocking = false
		var target = false
		for area in damage_area_3d.get_overlapping_areas():
			if area.get_parent() is Weapon:
				target_is_blocking = true
		for body in damage_area_3d.get_overlapping_bodies():
			if body != entity_owner and body is Entity:
				target = body
		if target:
			disable_damage_area()
			if !target_is_blocking and target is Entity:
				target.apply_damage(damage)
				print(target.get_current_health())
			elif target_is_blocking and target is Entity:
				print("BLOCKED")
			

		# for entity in damage_area_3d.get_overlapping_bodies():
		# 	if entity != entity_owner and entity is Entity:
		# 		if entity.try_take_hit(damage_area_3d.global_position, damage):
		# 			print(entity.get_current_health())
		# 		else:
		# 			print("BLOCKED")
		# 		disable_damage_area()
