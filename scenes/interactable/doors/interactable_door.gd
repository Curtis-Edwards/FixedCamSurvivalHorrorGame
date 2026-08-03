@tool
extends Interactable
class_name InteractableDoor

@onready var room_a_marker: Marker3D = $RoomAPoint
@onready var room_b_marker: Marker3D = $RoomBPoint

@export_category("Rooms")
@export var room_a: PackedScene
@export var room_b: PackedScene

@export_category("Door Lock")
enum LockTypes {
	UNLOCKED,
	LOCKED_ALWAYS,
	LOCKED_FROM_SIDE_A,
	LOCKED_NEEDS_KEY,
	OTHER
}
@export var lock_type: LockTypes = LockTypes.UNLOCKED:
	set(value):
		lock_type = value
		notify_property_list_changed()

@export_category("ONLY FOR \"LOCKED_NEEDS_KEY\"")
@export var required_key: ItemDefinition = null
@export_multiline var locked_key_hint: String = ""


var locked_text: String = "The door is locked."
var locked_from_otherside_text: String = "The door is locked from the otherside."
var unlocked_text: String = "You Unlocked it."
var wrong_item_text: String = "That item has no use here."


"""
Interaction Functions
"""
func interact() -> void:
	match lock_type:
		LockTypes.UNLOCKED:
			interact_door_unlocked()
		LockTypes.LOCKED_ALWAYS:
			interact_door_locked_always()
		LockTypes.LOCKED_FROM_SIDE_A:
			interact_door_locked_from_side_a()
		LockTypes.LOCKED_NEEDS_KEY:
			interact_door_locked_needs_key()
		LockTypes.OTHER:
			interact_door_other()

func try_use_item(item: ItemDefinition) -> void:
	if not item:
		return
	
	match item:
		required_key:
			GameManager.ui.pop_state()
			if lock_type == LockTypes.LOCKED_NEEDS_KEY:
				GameManager.player.inteaction_prompt.start_interaction_text(unlocked_text)
				unlock_door()
		_:
			GameManager.ui.pop_state()
			GameManager.player.inteaction_prompt.start_interaction_text(wrong_item_text)


"""
Door Interaction Functions
"""
func interact_door_unlocked() -> void:
	GameManager.player.start_interaction(self)
	walk_through_door()
	GameManager.player.stop_interaction()

func interact_door_locked_always() -> void:
	GameManager.player.start_interaction(self)
	GameManager.player.inteaction_prompt.start_interaction_text(locked_text)

func interact_door_locked_from_side_a() -> void:
	GameManager.player.start_interaction(self)
	if is_player_on_side_a():
		GameManager.player.inteaction_prompt.start_interaction_text(locked_from_otherside_text)
	else:
		GameManager.player.inteaction_prompt.start_interaction_text(unlocked_text)
		unlock_door()
func interact_door_locked_needs_key() -> void:
	GameManager.player.start_interaction(self)
	GameManager.player.inteaction_prompt.start_interaction_text(locked_key_hint)

func interact_door_other() -> void:
	pass # This function is to be overridden


"""
Helper Functions
"""
func walk_through_door() -> void:
	if is_player_on_side_a():
		GameManager.game_world.load_room(room_b)
		GameManager.player.global_transform = room_a_marker.global_transform
		# moving from a to b will eventually be an aniation...
		GameManager.player.global_transform = room_b_marker.global_transform
		GameManager.game_world.unload_room()
	else:
		GameManager.game_world.load_room(room_a)
		GameManager.player.global_transform = room_b_marker.global_transform
		# moving from a to b will eventually be an aniation...
		GameManager.player.global_transform = room_a_marker.global_transform
		GameManager.game_world.unload_room()

func unlock_door() -> void:
	lock_type = LockTypes.UNLOCKED

func is_player_on_side_a() -> bool:
	if global_transform.basis.z.dot(GameManager.player.global_position - global_position) > 0:
		return true
	else:
		return false
