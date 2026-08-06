extends CanvasLayer
class_name UI

@onready var nav_bar: MenuNavBar = $MenuNavBar

@onready var inv_screen: InventoryUI = $Inventory/InventoryUI
@onready var map_screen: MapUI = $Map/MapUI
@onready var notes_screen: NotesUI = $Notes/NotesUI
@onready var pause_screen: PauseUI = $Pause/PauseUI


func _ready() -> void:
	GameManager.ui = self

func _process(_delta: float) -> void:
	
	if InputManager.is_inventory_pressed():
		inventory_input_pressed()
	
	if InputManager.is_map_pressed():
		map_input_pressed()
	
	if InputManager.is_notes_pressed():
		notes_input_pressed()
	
	if InputManager.is_paused_pressed():
		pause_input_pressed()
	
	if InputManager.is_cancel_pressed():
		cancel_input_pressed()

"""
Input Pressed Functions
"""

func inventory_input_pressed() -> void:
	if get_current_state() == UIState.PAUSED:
		pass
	elif get_current_state() == UIState.INVENTORY or get_current_state() == UIState.ITEM_BOX:
		pop_state()
	elif is_inventory_level_state(get_current_state()):
		change_state(UIState.INVENTORY)
	else:
		push_state(UIState.INVENTORY)

func map_input_pressed() -> void:
	if get_current_state() == UIState.PAUSED:
		pass
	elif get_current_state() == UIState.MAP:
		pop_state()
	elif is_inventory_level_state(get_current_state()):
		change_state(UIState.MAP)
	else:
		push_state(UIState.MAP)

func notes_input_pressed() -> void:
	if get_current_state() == UIState.PAUSED:
		pass
	elif get_current_state() == UIState.NOTES:
		pop_state()
	elif is_inventory_level_state(get_current_state()):
		change_state(UIState.NOTES)
	else:
		push_state(UIState.NOTES)

func pause_input_pressed() -> void:
	if get_current_state() == UIState.PAUSED:
		pop_state()
	else:
		push_state(UIState.PAUSED)

func cancel_input_pressed() -> void:
	#if (get_current_state() == UIState.INVENTORY or get_current_state() == UIState.ITEM_BOX) \
	#and inv_screen.is_action_menu_open:
	if inv_screen.is_action_menu_open:
		inv_screen.close_action_menu()
	elif get_current_state() == UIState.INTERACTING:
		GameManager.player.stop_interaction()
	else:
		pop_state()


"""
State Stack Functions
"""
enum UIState {
	CLOSED,
	INTERACTING,
	INVENTORY,
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
			GameManager.player.inteaction_prompt.hide()
			update_pause_state()
		
		UIState.INVENTORY:
			inv_screen.close_inventory()
		
		UIState.ITEM_BOX:
			inv_screen.close_inventory()
		
		UIState.MAP:
			map_screen.close_map()
		
		UIState.NOTES:
			notes_screen.close_notes()
		
		UIState.PAUSED:
			pause_screen.close_pause()
	
	
	match to:
		UIState.CLOSED:
			nav_bar.close_nav_bar()
			update_pause_state()
		
		UIState.INTERACTING:
			nav_bar.close_nav_bar()
			GameManager.player.inteaction_prompt.show()
			GameManager.player.inteaction_prompt.exit_btn.grab_focus() # TODO: Focus on last btn, not exit btn
			
			update_pause_state()
		
		UIState.INVENTORY:
			nav_bar.open_nav_bar()
			nav_bar.in_inventory()
			inv_screen.open_inventory()
			
		UIState.ITEM_BOX:
			nav_bar.open_nav_bar()
			nav_bar.in_item_box()
			inv_screen.open_inventory(true)
			
		
		UIState.MAP:
			nav_bar.open_nav_bar()
			nav_bar.in_map()
			map_screen.open_map()
		
		UIState.NOTES:
			nav_bar.open_nav_bar()
			nav_bar.in_notes()
			notes_screen.open_notes()
		
		UIState.PAUSED:
			nav_bar.close_nav_bar()
			pause_screen.open_pause()
		
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
