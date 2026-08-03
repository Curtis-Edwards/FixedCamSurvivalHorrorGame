extends CanvasLayer
class_name UI

@onready var nav_bar: Control = $MenuNavBar
@onready var inv_screen: InventoryUI = $Inventory/InventoryUI
@onready var map_screen: Control = $MapScreen
@onready var notes_screen: Control = $NotesScreen
@onready var pause_screen: Control = $PauseScreen


func _ready() -> void:
	GameManager.ui = self

func _process(_delta: float) -> void:
	if InputManager.is_inventory_pressed():
		if get_current_state() == UIState.PAUSED:
			pass
		elif get_current_state() == UIState.INVENTORY or get_current_state() == UIState.ITEM_BOX:
			pop_state()
		elif is_inventory_level_state(get_current_state()):
			change_state(UIState.INVENTORY)
		else:
			push_state(UIState.INVENTORY)
	
	
	
	if InputManager.is_map_pressed():
		if get_current_state() == UIState.PAUSED:
			pass
		elif get_current_state() == UIState.MAP:
			pop_state()
		elif is_inventory_level_state(get_current_state()):
			change_state(UIState.MAP)
		else:
			push_state(UIState.MAP)
	
	
	
	if InputManager.is_notes_pressed():
		if get_current_state() == UIState.PAUSED:
			pass
		elif get_current_state() == UIState.NOTES:
			pop_state()
		elif is_inventory_level_state(get_current_state()):
			change_state(UIState.NOTES)
		else:
			push_state(UIState.NOTES)
	
	
	
	if InputManager.is_paused_pressed():
		if get_current_state() == UIState.PAUSED:
			pop_state()
		else:
			push_state(UIState.PAUSED)
	
	
	
	if InputManager.is_cancel_pressed():
		if (get_current_state() == UIState.INVENTORY or get_current_state() == UIState.ITEM_BOX) \
		and inv_screen.is_action_menu_open:
			inv_screen.close_action_menu()
			inv_screen.focus_slot(inv_screen.focused_index)
		elif get_current_state() == UIState.INTERACTING:
			GameManager.player.stop_interaction()
		else:
			pop_state()

"""
State Stack Function(s)
"""
enum UIState {
	CLOSED,
	INTERACTING,
	INVENTORY,
	#ITEM_PICK_UP,
	ITEM_BOX,
	MAP,
	NOTES,
	PAUSED
}
var state_stack: Array[UIState] = [UIState.CLOSED]

func get_current_state() -> UIState:
	return state_stack[-1]

func is_interacting() -> bool:
	if state_stack.size() > 1:
		return state_stack[1] == UIState.INTERACTING
	return false


func is_inventory_level_state(state: UIState) -> bool:
	return state == UIState.INVENTORY or \
		state == UIState.ITEM_BOX or \
		state == UIState.MAP or \
		state == UIState.NOTES

func push_state(new_state: UIState) -> void:
	var prev_state = get_current_state()
	state_stack.append(new_state)
	transition_to(prev_state, new_state)

func pop_state() -> void:
	if state_stack.size() <= 1:
		return
	
	var old_state = state_stack.pop_back()
	var new_state = get_current_state()
	transition_to(old_state, new_state)

func change_state(new_state: UIState) -> void:
	
	var old_state = state_stack.pop_back()
	state_stack.append(new_state)
	transition_to(old_state, new_state)

func transition_to(from: UIState, to: UIState) -> void:
	match from:
		UIState.CLOSED:
			update_pause_state()
			
		UIState.INTERACTING:
			update_pause_state()
			GameManager.player.inteaction_prompt.hide()
		
		UIState.INVENTORY:
			inv_screen.visible = false
			inv_screen.close_action_menu()
			CombinationManager.end_combine_state()
		
		UIState.ITEM_BOX:
			inv_screen.visible = false
			inv_screen.close_item_box_menu()
		
		UIState.MAP:
			map_screen.visible = false
		
		UIState.NOTES:
			notes_screen.visible = false
		
		UIState.PAUSED:
			pause_screen.visible = false
	
	
	match to:
		UIState.CLOSED:
			nav_bar.visible = false
			update_pause_state()
		
		UIState.INTERACTING:
			nav_bar.visible = false
			GameManager.player.inteaction_prompt.show()
			GameManager.player.inteaction_prompt.exit_btn.grab_focus()
			
			update_pause_state()
		
		UIState.INVENTORY:
			nav_bar.visible = true
			inv_screen.visible = true
			inv_screen.focused_index = [0,0]
			inv_screen.focus_slot(inv_screen.focused_index)
		
		UIState.ITEM_BOX:
			nav_bar.visible = true
			inv_screen.visible = true
			inv_screen.open_item_box_menu()
		
		UIState.MAP:
			nav_bar.visible = true
			map_screen.visible = true
			inv_screen.close_action_menu()
			CombinationManager.end_combine_state()
		
		UIState.NOTES:
			nav_bar.visible = true
			notes_screen.visible = true
			inv_screen.close_action_menu()
			CombinationManager.end_combine_state()
		
		UIState.PAUSED:
			nav_bar.visible = false
			pause_screen.visible = true
		
	print(state_stack)

"""
Helper Functions
"""
func update_pause_state() -> void:
	var should_pause: bool = not (get_current_state() == UIState.CLOSED or get_current_state() == UIState.INTERACTING)
	get_tree().paused = should_pause
	
	var mouse_visable: bool = not get_current_state() == UIState.CLOSED
	if mouse_visable:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
