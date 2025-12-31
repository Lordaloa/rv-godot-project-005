class_name Weapon
extends Node
## "Abstract" Weapon class for all weapon objects. Handles all Weapon related actions.

## The entity who owns this weapon (prevents self and team-damage).
@export var entity_owner: Entity

# -----------------------------------------------------------------------------
# Virtuals
# -----------------------------------------------------------------------------

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

# -----------------------------------------------------------------------------
# Constructors
# -----------------------------------------------------------------------------

func init_weapon(new_entity_owner: Entity) -> Weapon:
	entity_owner = new_entity_owner
	return self