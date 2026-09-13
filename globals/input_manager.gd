extends Node

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

#region Player Inputs
# Movement
func get_player_move_axis() -> float:
	if GameManager.player.is_player_input_locked():
		return 0.0
	
	return float(Input.is_action_pressed("tank_forward")) - float(Input.is_action_pressed("tank_backward"))

func get_player_rotation_axis() -> float:
	if GameManager.player.is_player_input_locked():
		return 0.0
	
	return float(Input.is_action_pressed("tank_right")) - float(Input.is_action_pressed("tank_left"))

func is_quick_turn_inputed()  -> bool:
	if GameManager.player.is_player_input_locked():
		return false
	
	return Input.is_action_just_pressed("quick_turn")


var is_toggle_sprint_on: bool = true
var is_sprinting: bool = false

func is_sprint_pressed() -> bool:
	if GameManager.player.is_player_input_locked():
		return false
	
	return not GameManager.player.current_state == GameManager.player.PlayerState.MOVING_BACKWARD and Input.is_action_just_pressed("sprint")

func is_sprint_held() -> bool:
	if GameManager.player.is_player_input_locked():
		return false
	
	return not GameManager.player.current_state == GameManager.player.PlayerState.MOVING_BACKWARD and Input.is_action_pressed("sprint")

func is_sprint_inputed() -> bool:
	if GameManager.player.is_player_input_locked():
		return false
	
	if is_toggle_sprint_on:
		is_sprinting = !is_sprinting if is_sprint_pressed() else is_sprinting
	else:
		is_sprinting = true if is_sprint_held() else false
	
	return is_sprinting


# Other
func is_interact_pressed() -> bool:
	if GameManager.player.is_player_input_locked():
		return false
	
	return Input.is_action_just_pressed("interact")

func is_shoot_held() -> bool:
	if GameManager.player.is_player_input_locked():
		return false
	
	return Input.is_action_pressed("player_shoot")

func is_aim_pressed() -> bool:
	if GameManager.player.is_player_input_locked():
		return false
	
	return Input.is_action_just_pressed("player_aim")

func is_aim_held() -> bool:
	if GameManager.player.is_player_input_locked():
		return false
	
	return Input.is_action_pressed("player_aim")
#endregion


#region UI Inputs
func is_accept_pressed() -> bool:
	if GameManager.ui.is_cur_state_closed():
		return false
	
	return Input.is_action_just_pressed("ui_accept")

func is_cancel_pressed() -> bool:
	if GameManager.ui.is_cur_state_closed():
		return false
	
	return Input.is_action_just_pressed("ui_cancel")


func is_inventory_pressed() -> bool:
	if GameManager.ui.is_cur_state_paused():
		return false
	
	return Input.is_action_just_pressed("open_inventory")

func is_map_pressed() -> bool:
	if GameManager.ui.is_cur_state_paused():
		return false
	
	return Input.is_action_just_pressed("open_map")

func is_notes_pressed() -> bool:
	if GameManager.ui.is_cur_state_paused():
		return false
	
	return Input.is_action_just_pressed("open_notes")

func is_paused_pressed() -> bool:
	return Input.is_action_just_pressed("open_pause")
#endregion


#region Debug Inputs
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
#endregion
