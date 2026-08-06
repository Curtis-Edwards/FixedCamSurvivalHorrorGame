extends Node

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

"""
Player Inputs
"""
func get_player_move_axis() -> float:
	if GameManager.player.lock_player_input:
		return 0.0
	
	return float(Input.is_action_pressed("ui_up")) - float(Input.is_action_pressed("ui_down"))

func get_player_rotation_axis() -> float:
	if GameManager.player.lock_player_input:
		return 0.0
	
	return float(Input.is_action_pressed("ui_right")) - float(Input.is_action_pressed("ui_left"))

func get_quick_turn()  -> bool:
	if GameManager.player.lock_player_input:
		return false
	else:
		return Input.is_action_pressed("ui_down") and Input.is_action_just_pressed("sprint")


func is_sprint_pressed() -> bool:
	if GameManager.player.lock_player_input:
		return false
	else:
		return not Input.is_action_pressed("ui_down") and Input.is_action_just_pressed("sprint")

func is_sprint_held() -> bool:
	if GameManager.player.lock_player_input:
		return false
	else:
		return Input.is_action_pressed("sprint")


func is_interact_pressed() -> bool:
	if GameManager.player.lock_player_input:
		return false
	else:
		return Input.is_action_just_pressed("ui_accept")

func is_shoot_pressed() -> bool:
	if GameManager.player.lock_player_input:
		return false
	else:
		return Input.is_action_just_pressed("player_shoot")

func is_shoot_held() -> bool:
	if GameManager.player.lock_player_input:
		return false
	else:
		return Input.is_action_pressed("player_shoot")

func is_aim_pressed() -> bool:
	if GameManager.player.lock_player_input:
		return false
	else:
		return Input.is_action_just_pressed("player_aim")

func is_aim_held() -> bool:
	if GameManager.player.lock_player_input:
		return false
	else:
		return Input.is_action_pressed("player_aim")


"""
UI Inputs
"""
func get_vertical_axis() -> float:
	return Input.get_axis("ui_down", "ui_up")

func get_horizontal_axis() -> float:
	return Input.get_axis("ui_left", "ui_right")

func get_zoom_axis() -> float:
	return Input.get_axis("zoom_out", "zoom_in")


func is_accept_pressed() -> bool:
	return Input.is_action_just_pressed("ui_accept")

func is_cancel_pressed() -> bool:
	return Input.is_action_just_pressed("ui_cancel")


func is_inventory_pressed() -> bool:
	if GameManager.player.lock_menu_input:
		return false
	else:
		return Input.is_action_just_pressed("open_inventory")

func is_map_pressed() -> bool:
	if GameManager.player.lock_menu_input:
		return false
	else:
		return Input.is_action_just_pressed("open_map")

func is_notes_pressed() -> bool:
	if GameManager.player.lock_menu_input:
		return false
	else:
		return Input.is_action_just_pressed("open_notes")

func is_paused_pressed() -> bool:
	return Input.is_action_just_pressed("open_pause")


"""
Debug Inputs
"""
func is_debug_key1_pressed() -> bool:
	return Input.is_action_just_pressed("debug1")

func is_debug_key2_pressed() -> bool:
	return Input.is_action_just_pressed("debug2")

func is_debug_key3_pressed() -> bool:
	return Input.is_action_just_pressed("debug3")

func is_debug_key4_pressed() -> bool:
	return Input.is_action_just_pressed("debug4")

func is_debug_key5_pressed() -> bool:
	return Input.is_action_just_pressed("debug5")

func is_debug_key6_pressed() -> bool:
	return Input.is_action_just_pressed("debug6")

func is_debug_key7_pressed() -> bool:
	return Input.is_action_just_pressed("debug7")

func is_debug_key8_pressed() -> bool:
	return Input.is_action_just_pressed("debug8")

func is_debug_key9_pressed() -> bool:
	return Input.is_action_just_pressed("debug9")
