@icon("res://addons/at-icons/control/push_button.svg")
extends Button
class_name InventorySlotBtn

@export var display_slot_index: int = 1
@export var type: int = 0

var slot_index: int = 0
var inventory_type: InventorySystem

@onready var image_texture: TextureRect = $Panel/HBox/Margin/ImageTexture
@onready var index_label: Label = $Panel/HBox/VBox/Margin/IndexLabel
@onready var amount_label: Label = $Panel/HBox/VBox/Margin2/AmountLabel

const SLOT_NOT_FULL_COL: Color = Color(0.153, 0.59, 0.13, 1.0)
const SLOT_FULL_COL: Color = Color(0.59, 0.329, 0.13, 1.0)

func _ready() -> void:
	slot_index = display_slot_index - 1
	disabled = false
	
	if type == 0:
		inventory_type = GameManager.inventory # But this one is fine???
	else:
		inventory_type = GameManager.item_box # Parser Error: Could not resolve external class member "item_box".


func update_slot():
	var item: ItemInstance = inventory_type.get_item(slot_index)
	
	index_label.text = str(slot_index + 1)
	
	if item == null:
		image_texture.texture = Globals.EMPTY_SLOT_TEXTURE
		amount_label.text = ""

	else:
		image_texture.texture = item.item_def.inventory_texture
		if item.item_amount > 1:
			amount_label.text = str(item.item_amount)
			
			if item.item_amount == item.item_def.max_stack:
				amount_label.add_theme_color_override("font_color", SLOT_FULL_COL)
			else:
				amount_label.add_theme_color_override("font_color", SLOT_NOT_FULL_COL)
			
		else:
			amount_label.text = ""

func disable_slot(_disable_slot: bool = true):
	disabled = _disable_slot

func _on_pressed() -> void:
	print("Pressed!")
	
	var item: ItemInstance = inventory_type.get_item(slot_index)
	
	if not item:
		GameManager.ui.inv_screen.close_action_menu()
		CombinationManager.end_combine_state()
	
	else:
		if CombinationManager.combine_state:
			# COMBINING
			CombinationManager.assign_combine_b(inventory_type, slot_index, item)
			
			if (CombinationManager.combine_index_a != CombinationManager.combine_index_b) or \
			(CombinationManager.combine_type_a != CombinationManager.combine_type_b):
				var combine_success = CombinationManager.combine(
					CombinationManager.combine_item_a,
					CombinationManager.combine_item_b
				)
				if combine_success:
					print("Combine Success.")
			
			CombinationManager.end_combine_state()
			
		else:
			# NOT COMBINING
			GameManager.ui.inv_screen.toggle_action_menu(inventory_type, item, slot_index)


func _on_focus_entered() -> void:
	if not disabled:
		GameManager.ui.inv_screen.set_focused_slot(inventory_type, slot_index)
		modulate.a = 0.6
		
		GameManager.ui.inv_screen.update_item_display(
			inventory_type.get_item(slot_index)
		)


func _on_focus_exited() -> void:
	if not disabled:
		modulate.a = 1.0


func _on_mouse_entered() -> void:
	if not disabled:
		grab_focus()
