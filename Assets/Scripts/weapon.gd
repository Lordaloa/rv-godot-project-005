class_name Weapon
extends Node
## "Abstract" Weapon class for all weapon objects. Handles all Weapon related actions.

## The entity who owns this weapon (prevents self and team-damage).
@export var entity_owner: Entity
@export var total_cooldown_time: float = 1.0;
@export var is_continuous_action: bool = false;
var cooldown_time:float = 0.0

# -----------------------------------------------------------------------------
# Virtuals
# -----------------------------------------------------------------------------

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if !has_cooled_down():
		cooldown(delta)

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

func has_continuous_action() -> bool:
	return is_continuous_action

func action(_delta: float) -> void:
	if has_cooled_down():
		reset_cooldown()
	# return true

func cooldown(delta: float) -> void:
	cooldown_time -= delta

func has_cooled_down() -> bool:
	return cooldown_time <= 0.0

func reset_cooldown() -> void:
	cooldown_time = total_cooldown_time