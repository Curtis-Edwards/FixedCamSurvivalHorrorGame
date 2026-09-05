extends Resource
class_name DoorInstance

@export var room_1: StringName = &""
@export var room_2: StringName = &""

enum LockTypes {
	UNLOCKED,
	LOCKED_ALWAYS,
	LOCKED_FROM_SIDE_1,
	LOCKED_FROM_SIDE_2,
	LOCKED_NEEDS_KEY,
	OTHER
}
@export var lock_type: LockTypes = LockTypes.UNLOCKED

@export_category("ONLY FOR \"LOCKED_NEEDS_KEY\"")
@export var required_key: ItemDefinition = null
@export_multiline var locked_key_hint: String = "Needs ___ key."

func unlock_door() -> void:
	lock_type = LockTypes.UNLOCKED
