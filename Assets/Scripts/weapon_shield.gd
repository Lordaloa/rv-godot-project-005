class_name WeaponShield
extends Weapon
## "Abstract" WeaponShield class for shield weapons, handles all shield related actions.

@onready var blocking_area_3d: Area3D = $Blocking_Area3D
@onready var blocking_collision_shape_3d: CollisionShape3D = $Blocking_Area3D/Blocking_CollisionShape3D

# -----------------------------------------------------------------------------
# Virtuals
# -----------------------------------------------------------------------------

func _ready() -> void:
	super._ready()

func _process(delta: float) -> void:
	super._process(delta)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

# -----------------------------------------------------------------------------
# Constructors
# -----------------------------------------------------------------------------

func init_weapon_shield(new_entity_owner: Entity) -> WeaponShield:
	var weapon_shield: WeaponShield = super.init_weapon(new_entity_owner)
	return weapon_shield

# -----------------------------------------------------------------------------
# Publics
# -----------------------------------------------------------------------------

func raise_shield() -> void:
	if !is_blocking_area_enabled():
		enable_blocking_area()

func lower_shield() -> void:
	if is_blocking_area_enabled():
		disable_blocking_area()

func action(delta: float) -> void:
	super.action(delta)

func disable_blocking_area() -> void:
	blocking_area_3d.monitoring = false
	blocking_area_3d.monitorable = false

func enable_blocking_area() -> void:
	blocking_area_3d.monitoring = true
	blocking_area_3d.monitorable = true

func is_blocking_area_enabled() -> bool:
	return blocking_area_3d.monitoring and blocking_area_3d.monitorable
	
