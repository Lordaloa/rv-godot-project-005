class_name Weapon
extends Node
## "Abstract" Weapon class for all weapon objects. Handles all Weapon related actions.

signal has_cooled_down
signal action_delayed
signal action_completed
## The entity who owns this weapon (prevents self and team-damage).
@export var is_debug: bool = true
@export var entity_owner: Entity
@export var cooldown_time: float = 0.5;
@export var action_delay_time: float = 0.4
@export var action_time: float = 0.2
var is_action_delayed: bool = false
var is_action_completed: bool = false
var is_cooling: bool = false
@onready var debug: Node3D = get_node_or_null('Debug')

# -----------------------------------------------------------------------------
# Virtuals
# -----------------------------------------------------------------------------

func _ready() -> void:
	self.connect('action_delayed', run_action)
	self.connect('action_completed', cooldown)
	
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
	delay_action()

func delay_action() -> void:
	is_action_delayed = true
	await get_tree().create_timer(action_delay_time).timeout
	is_action_delayed = false
	emit_signal('action_delayed')

func run_action() -> void:
	is_action_completed = true
	await get_tree().create_timer(action_time).timeout
	is_action_completed = false
	emit_signal('action_completed')

func cooldown() -> void:
	is_cooling = true
	await get_tree().create_timer(cooldown_time).timeout
	is_cooling = false
	emit_signal('has_cooled_down')