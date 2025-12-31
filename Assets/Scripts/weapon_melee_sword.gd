class_name WeaponMeleeSword
extends WeaponMelee
## WeaponMeleeSword class for melee sword objects, handles all Sword related actions.

# -----------------------------------------------------------------------------
# Virtuals
# -----------------------------------------------------------------------------

func _ready() -> void:
	super._ready()

func _process(delta: float) -> void:
	super._process(delta)

# -----------------------------------------------------------------------------
# Constructors
# -----------------------------------------------------------------------------

func init_weapon_melee_sword(new_entity_owner: Entity) -> WeaponMeleeSword:
	var weapon_melee_sword: WeaponMeleeSword = super.init_weapon_melee(new_entity_owner)
	return weapon_melee_sword