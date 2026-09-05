extends TextureButton

@export var slot_index: int
@export var inventory_type: int = 0

@onready var amount_label: Label = $Amount
@onready var index_label: Label = $Index

var empty_texture: AtlasTexture = preload("res://assets/textures/empty.tres") 


func update_slot():
	var item = GameManager.inventory.get_item(inventory_type, slot_index)
	
	index_label.text = str(slot_index + 1)
	
	if item == null:
		texture_normal = empty_texture
		amount_label.text = ""

	else:
		texture_normal = item.item_def.inventory_texture
		if item.item_amount > 1:
			amount_label.text = str(item.item_amount)
		else:
			amount_label.text = ""

func disable_slot(_disable_slot: bool = true):
	disabled = _disable_slot

# This is when clicking on an iventory slot while in the combine state
func _on_pressed() -> void:
	
	var item: ItemInstance = GameManager.inventory.get_item(inventory_type, slot_index)
	
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
		GameManager.ui.inv_screen.focused_index = [inventory_type, slot_index]
		modulate.a = 0.6
		
		GameManager.ui.inv_screen.update_item_display(
			GameManager.inventory.get_item(inventory_type, slot_index)
		)


func _on_focus_exited() -> void:
	if not disabled:
		modulate.a = 1.0
		pass


func _on_mouse_entered() -> void:
	if not disabled:
		grab_focus()
