class_name WeaponMelee
extends Weapon
## "Abstract" WeaponMelee class for melee weapons, handles all Melee related actions.

@export var damage: float = 5.0
@onready var damage_area_3d: Area3D = $Damage_Area3D
@onready var damage_collision_shape_3d: CollisionShape3D = $Damage_Area3D/Damage_CollisionShape3D
@onready var blocking_area_3d: Area3D = $Blocking_Area3D
@onready var blocking_collision_shape_3d: CollisionShape3D = $Blocking_Area3D/Blocking_CollisionShape3D

# -----------------------------------------------------------------------------
# Virtuals
# -----------------------------------------------------------------------------

func _ready() -> void:
	super._ready()

func _process(delta: float) -> void:
	super._process(delta)
	if is_damage_area_enabled() and has_cooled_down():
		var target_is_blocking = false
		var target = false
		for area in damage_area_3d.get_overlapping_areas():
			if area.get_parent() is Weapon:
				target_is_blocking = true
		for body in damage_area_3d.get_overlapping_bodies():
			if body != entity_owner and body is Entity:
				target = body

		if target and !target_is_blocking and target is Entity:
			target.apply_damage(damage)
			print(target.get_current_health())
			reset_cooldown()
		elif target and target_is_blocking and target is Entity:
			print("BLOCKED")
			reset_cooldown()
		# print(target_is_blocking)
		# print(target)



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

func disable_blocking_area() -> void:
	blocking_area_3d.monitoring = false
	blocking_area_3d.monitorable = false

func enable_blocking_area() -> void:
	blocking_area_3d.monitoring = true
	blocking_area_3d.monitorable = true

func is_blocking_area_enabled() -> bool:
	return blocking_area_3d.monitoring and blocking_area_3d.monitorable

func disable_damage_area() -> void:
	damage_area_3d.monitoring = false
	damage_area_3d.monitorable = false

func enable_damage_area() -> void:
	damage_area_3d.monitoring = true
	damage_area_3d.monitorable = true

func is_damage_area_enabled() -> bool:
	return damage_area_3d.monitoring and damage_area_3d.monitorable
	
