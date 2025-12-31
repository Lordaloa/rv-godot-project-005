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

func _process(_delta: float) -> void:
	super._ready()
	if is_damage_damage_area_enabled():
		for collision_object in damage_area_3d.get_overlapping_bodies():
			if collision_object != entity_owner and collision_object is Entity:
				collision_object.apply_damage(damage)
				print(collision_object.get_current_health())


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

func enable_damage_area() -> void:
	damage_area_3d.monitoring = true
	damage_area_3d.monitorable = true

func disable_damage_area() -> void:
	damage_area_3d.monitoring = false
	damage_area_3d.monitorable = false

func is_damage_damage_area_enabled() -> bool:
	return damage_area_3d.monitoring and damage_area_3d.monitorable
