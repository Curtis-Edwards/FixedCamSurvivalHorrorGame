#@tool
extends Interactable
class_name InteractableDoor

@onready var room_destination_marker: Marker3D = $RoomDestinationPoint

@export var door_instance: DoorInstance = null
@export var is_this_room_1: bool = false

var locked_text: String = "The door is locked."
var locked_from_otherside_text: String = "The door is locked from the otherside."
var unlocked_text: String = "You unlocked it."
var wrong_item_text: String = "That item has no use here."

#region Interaction Functions
func interact() -> void:
	if not door_instance:
		interact_door_locked_always()
		return
	
	match door_instance.lock_type:
		door_instance.LockTypes.UNLOCKED:
			interact_door_unlocked()
		door_instance.LockTypes.LOCKED_ALWAYS:
			interact_door_locked_always()
		door_instance.LockTypes.LOCKED_FROM_SIDE_1:
			interact_door_locked_from_side_1()
		door_instance.LockTypes.LOCKED_FROM_SIDE_2:
			interact_door_locked_from_side_2()
		door_instance.LockTypes.LOCKED_NEEDS_KEY:
			interact_door_locked_needs_key()
		door_instance.LockTypes.OTHER:
			interact_door_other()

func try_use_item(item: ItemDefinition) -> void:
	if not item:
		return
	
	if not door_instance:
		return 
	
	match item:
		door_instance.required_key:
			GameManager.ui.pop_state()
			if door_instance.lock_type == door_instance.LockTypes.LOCKED_NEEDS_KEY:
				GameManager.player.inteaction_prompt.start_interaction_text(unlocked_text)
				door_instance.unlock_door()
		_:
			GameManager.ui.pop_state()
			GameManager.player.inteaction_prompt.start_interaction_text(wrong_item_text)
#endregion


#region Door Interaction Functions
func interact_door_unlocked() -> void:
	#GameManager.player.start_interaction(self)
	walk_through_door()
	#GameManager.player.stop_interaction()

func interact_door_locked_always() -> void:
	GameManager.player.start_interaction(self)
	GameManager.player.inteaction_prompt.start_interaction_text(locked_text)

func interact_door_locked_from_side_1() -> void:
	GameManager.player.start_interaction(self)
	
	if is_this_room_1:
		GameManager.player.inteaction_prompt.start_interaction_text(locked_from_otherside_text)
	else:
		GameManager.player.inteaction_prompt.start_interaction_text(unlocked_text)
		door_instance.unlock_door()

func interact_door_locked_from_side_2() -> void:
	GameManager.player.start_interaction(self)
	
	if is_this_room_1:
		GameManager.player.inteaction_prompt.start_interaction_text(unlocked_text)
		door_instance.unlock_door()
	else:
		GameManager.player.inteaction_prompt.start_interaction_text(locked_from_otherside_text)

func interact_door_locked_needs_key() -> void:
	GameManager.player.start_interaction(self)
	GameManager.player.inteaction_prompt.start_interaction_text(locked_text + "\n\n" + door_instance.locked_key_hint)

func interact_door_other() -> void:
	pass # This function is to be overridden

#endregion


#region Helper Functions
func walk_through_door() -> void:
	if is_this_room_1:
		GameManager.game_world.load_room(door_instance.room_2)
	else:
		GameManager.game_world.load_room(door_instance.room_1)

	GameManager.player.global_transform = room_destination_marker.global_transform
	GameManager.game_world.unload_room()
#endregion
