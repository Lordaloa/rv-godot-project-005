class_name Weapon
extends Node
## "Abstract" Weapon class for all weapon objects. Handles all Weapon related actions.

signal has_cooled_down
## The entity who owns this weapon (prevents self and team-damage).
@export var entity_owner: Entity
@export var cooldown_time: float = 1.0;
var is_cooling: bool = false

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

# -----------------------------------------------------------------------------
# Publics
# -----------------------------------------------------------------------------

func action(_delta: float) -> void:
	cooldown()

func cooldown() -> void:
	is_cooling = true
	await get_tree().create_timer(cooldown_time).timeout
	is_cooling = false
	emit_signal('has_cooled_down')