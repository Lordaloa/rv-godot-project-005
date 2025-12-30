class_name Sword
extends Weapon

## Sword class for sword objects, handles all sword related actions

@onready var damage_collision_shape_3d = $Area3D/Damage_CollisionShape3D

# -----------------------------------------------------------------------------
# Virtuals
# -----------------------------------------------------------------------------

func _ready() -> void:
	super._ready()

func _process(delta: float) -> void:
	super._process(delta)
