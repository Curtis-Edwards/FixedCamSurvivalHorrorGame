extends Control
class_name MenuNavBar

@onready var inventory_btn: Button = $HBoxContainer/InventoryButton
@onready var map_btn: Button = $HBoxContainer/MapButton
@onready var notes_btn: Button = $HBoxContainer/NotesButton

#region Nav Bar Functions
func open_nav_bar() -> void:
	self.show()

func close_nav_bar() -> void:
	self.hide()


func in_inventory() -> void:
	inventory_btn.disabled = true
	inventory_btn.text = "Inventory"
	
	map_btn.disabled = false
	notes_btn.disabled = false

func in_item_box() -> void:
	inventory_btn.disabled = true
	inventory_btn.text = "Item Box"
	
	map_btn.disabled = false
	notes_btn.disabled = false

func in_map() -> void:
	map_btn.disabled = true
	
	inventory_btn.disabled = false
	notes_btn.disabled = false

func in_notes() -> void:
	notes_btn.disabled = true
	
	inventory_btn.disabled = false
	map_btn.disabled = false
#endregion


#region Buttons Pressed Functions
func _on_inventory_button_pressed() -> void:
	if GameManager.ui.inv_screen.is_item_box_open:
		GameManager.ui.change_state(GameManager.ui.UIState.ITEM_BOX)
	else:
		GameManager.ui.change_state(GameManager.ui.UIState.INVENTORY)


func _on_map_button_pressed() -> void:
	GameManager.ui.change_state(GameManager.ui.UIState.MAP)


func _on_notes_button_pressed() -> void:
	GameManager.ui.change_state(GameManager.ui.UIState.NOTES)


func _on_close_button_pressed() -> void:
	GameManager.ui.pop_state()
#endregion
