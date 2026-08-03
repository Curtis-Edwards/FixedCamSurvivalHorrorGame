extends Control

@onready var inventory_btn: Button = $HBoxContainer/InventoryButton
@onready var map_btn: Button = $HBoxContainer/MapButton
@onready var notes_btn: Button = $HBoxContainer/NotesButton

func _on_inventory_button_pressed() -> void:
	if GameManager.ui.get_current_state() != GameManager.ui.UIState.INVENTORY:
		GameManager.ui.change_state(GameManager.ui.UIState.INVENTORY)


func _on_map_button_pressed() -> void:
	if GameManager.ui.get_current_state() != GameManager.ui.UIState.MAP:
		GameManager.ui.change_state(GameManager.ui.UIState.MAP)


func _on_notes_button_pressed() -> void:
	if GameManager.ui.get_current_state() != GameManager.ui.UIState.NOTES:
		GameManager.ui.change_state(GameManager.ui.UIState.NOTES)
