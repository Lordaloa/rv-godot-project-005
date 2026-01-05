class_name WeaponMelee
extends Weapon
## "Abstract" WeaponMelee class for melee weapons, handles all Melee related actions.

signal activation_delayed
@export var damage: float = 5.0
@export var damage_area_activation_delay_time: float = 0.2
@export var damage_area_activation_time: float = 0.4
var damage_area_activation_delayed: bool = false
var damage_area_activated: bool = false
@onready var damage_area_3d: Area3D = $Damage_Area3D
@onready var damage_collision_shape_3d: CollisionShape3D = $Damage_Area3D/Damage_CollisionShape3D

# -----------------------------------------------------------------------------
# Virtuals
# -----------------------------------------------------------------------------

func _ready() -> void:
	super._ready()
	self.connect('activation_delayed', _damage_area_activate)

func _process(delta: float) -> void:
	super._process(delta)
	if is_damage_area_enabled():
		## TODO Refactor for new signal implementation
		var target_is_blocking = false
		var target = false
		for area in damage_area_3d.get_overlapping_areas():
			if area.get_parent() is WeaponShield:
				target_is_blocking = true
		for body in damage_area_3d.get_overlapping_bodies():
			if body != entity_owner and body is Entity:
				target = body
		if target and !target_is_blocking and target is Entity:
			target.apply_damage(damage)
			print(target.get_current_health())
		elif target and target_is_blocking and target is Entity:
			print("BLOCKED")

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
	_damage_area_activation_delay()

func disable_damage_area() -> void:
	damage_area_3d.monitoring = false
	damage_area_3d.monitorable = false

func enable_damage_area() -> void:
	damage_area_3d.monitoring = true
	damage_area_3d.monitorable = true

func is_damage_area_enabled() -> bool:
	return damage_area_3d.monitoring and damage_area_3d.monitorable

# -----------------------------------------------------------------------------
# Privates
# -----------------------------------------------------------------------------

func _damage_area_activation_delay() -> void:
	damage_area_activation_delayed = true
	await get_tree().create_timer(damage_area_activation_delay_time).timeout
	damage_area_activation_delayed = false
	emit_signal('activation_delayed')

func _damage_area_activate() -> void:
	damage_area_activated = true
	enable_damage_area()
	await get_tree().create_timer(damage_area_activation_time).timeout
	disable_damage_area()
	damage_area_activated = false