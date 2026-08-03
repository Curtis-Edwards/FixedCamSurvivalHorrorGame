extends Control
class_name InventoryUI

@onready var inventory_slots_ui: HBoxContainer = $InventoryScreen/InventorySlots

@onready var name_label: Label = $InventoryScreen/ItemInspector/ItemInfo/ItemText/Name
@onready var description_label: Label = $InventoryScreen/ItemInspector/ItemInfo/ItemText/Description
@onready var item_texture: TextureRect = $InventoryScreen/ItemInspector/ItemViewer/ItemTexture


"""
Slots UI Functions
"""
var focused_index: Array[int] = [0,0] # [inv_type, index]

func focus_slot(_focused_index: Array[int]) -> void:
	var data: Dictionary = GameManager.inventory.get_inventory_type(_focused_index[0])
	var _inv = data["slots"]
	var _inv_size = data["size"]
	var inv_ui = data["ui"]
	
	var slot = inv_ui.get_child(_focused_index[1])
	if slot:
		get_viewport().gui_release_focus()
		slot.grab_focus()

func update_slots_ui() -> void:
	for item in inventory_slots_ui.get_children():
		item.update_slot()
	
	for item in item_box_slots_ui.get_children():
		item.update_slot()

func disable_slots(_disable_slot: bool = true):
	for item in inventory_slots_ui.get_children():
		item.disable_slot(_disable_slot)
	
	for item in item_box_slots_ui.get_children():
		item.disable_slot(_disable_slot)



"""
Sub Menu Functions
"""
@onready var sub_menu: VBoxContainer = $InventoryScreen/ItemInspector/SubMenu

func hide_item_action_menu_btns() -> void:
	equip_btn.hide()
	use_btn.hide()
	examine_btn.hide()
	combine_btn.hide()
	discard_btn.hide()
	
	close_btn.hide()

func update_action_menu_neighbors():
	var visible_buttons: Array = []
	for btn in sub_menu.get_children():
		if btn.visible:
			visible_buttons.append(btn)
	
	if visible_buttons.size() <= 1:
		return
	
	# Assign neighbors (wrap around)
	for i in visible_buttons.size():
		var current = visible_buttons[i]
		var top = visible_buttons[(i - 1 + visible_buttons.size()) % visible_buttons.size()]
		var bottom = visible_buttons[(i + 1) % visible_buttons.size()]
		
		current.focus_neighbor_top = top.get_path()
		current.focus_neighbor_bottom = bottom.get_path()



"""
Item Action Menu Functions
"""
@onready var close_btn: Button = $InventoryScreen/ItemInspector/SubMenu/CloseButton

@onready var equip_btn: Button = $InventoryScreen/ItemInspector/SubMenu/EquipButton
@onready var use_btn: Button = $InventoryScreen/ItemInspector/SubMenu/UseButton
@onready var examine_btn: Button = $InventoryScreen/ItemInspector/SubMenu/ExamineButton
@onready var combine_btn: Button = $InventoryScreen/ItemInspector/SubMenu/CombineButton
@onready var discard_btn: Button = $InventoryScreen/ItemInspector/SubMenu/DiscardButton

var action_item: ItemInstance = null
var action_slot_index : int
var action_inv_type: int

var transfer_amount: int
var max_transfer_amount: int

var is_action_menu_open: bool = false

func toggle_action_menu(type: int, slot: ItemInstance, index: int):
	if not is_action_menu_open or (is_action_menu_open and slot != action_item):
		open_action_menu(type, slot, index)
	else:
		close_action_menu()

func open_action_menu(type: int, slot: ItemInstance, index: int):
	is_action_menu_open = true
	action_item = slot
	action_slot_index = index
	action_inv_type = type
	
	if not action_item:
		return
	
	hide_item_action_menu_btns()

	equip_btn.visible = action_item.item_def.can_equip and action_inv_type == 0
	use_btn.visible = action_item.item_def.can_use and action_inv_type == 0
	examine_btn.show()
	combine_btn.show()
	discard_btn.visible = action_item.item_def.can_discard
	close_btn.show()
	
	
	transfer_btn.visible = (GameManager.ui.get_current_state() == GameManager.ui.UIState.ITEM_BOX)
	var num_of_item: int = GameManager.inventory.get_item_count(action_inv_type, action_item.item_def)
	
	max_transfer_amount = min(
		GameManager.inventory.can_add_item(1 - action_inv_type, action_item.item_def, num_of_item),
		num_of_item
	)
	transfer_amount = max_transfer_amount
	update_transfer_button_text()
	
	if equip_btn.visible:
		equip_btn.grab_focus()
	elif use_btn.visible:
		use_btn.grab_focus()
	else:
		examine_btn.grab_focus()
	
	update_action_menu_neighbors()
	disable_slots(true)
	sub_menu.show()

func close_action_menu():
	is_action_menu_open = false
	action_item = null
	disable_slots(false)
	sub_menu.hide()
	focus_slot([action_inv_type, action_slot_index])

# Buttons
func _on_equip_button_pressed() -> void:
	close_action_menu()
	focus_slot([action_inv_type, action_slot_index])

func _on_use_button_pressed() -> void:
	if not GameManager.ui.is_interacting():
		print("Not Interaction on  use  button press.")
		return
	
	GameManager.player.active_interactable.try_use_item(action_item.item_def)
	#remove_item(action_inv_type, action_slot_index)
	#close_action_menu()
	#focus_slot([action_inv_type, action_slot_index])

func _on_examine_button_pressed() -> void:
	close_action_menu()
	focus_slot([action_inv_type, action_slot_index])

func _on_combine_button_pressed() -> void:
	#if is_pickup_menu_open:
		#CombinationManager.start_combine_state(0, -1, current_pickup.item_instance)
	#else:
		#CombinationManager.start_combine_state(action_inv_type, action_slot_index, action_item)
	CombinationManager.start_combine_state(action_inv_type, action_slot_index, action_item)
	close_action_menu()
	focus_slot([action_inv_type, action_slot_index])

func _on_discard_button_pressed() -> void:
	GameManager.inventory.remove_item(action_inv_type, action_slot_index)
	close_action_menu()
	focus_slot([action_inv_type, action_slot_index])

func _on_close_button_pressed() -> void:
	if is_action_menu_open:
		close_action_menu()

"""
Item Box Functions
"""
@onready var item_box_container: ScrollContainer = $InventoryScreen/ItemBox
@onready var item_box_slots_ui: HBoxContainer = $InventoryScreen/ItemBox/ItemBoxSlots

@onready var transfer_btn: Button = $InventoryScreen/ItemInspector/SubMenu/TransferButton

const SLOT_PX_SIZE: int = 316

var is_item_box_open: bool = false

func open_item_box_menu():
	is_item_box_open = true
	update_slots_neighbors()
	
	focus_slot([1,0])
	item_box_container.show()
	item_box_container.scroll_horizontal = 0

func close_item_box_menu():
	is_item_box_open = false
	update_slots_neighbors()
	item_box_container.hide()

func update_slots_neighbors():
	@warning_ignore("integer_division")
	var item_box_index_offset: int = floor(item_box_container.scroll_horizontal / SLOT_PX_SIZE)
	
	if is_item_box_open:
		for i in range(GameManager.inventory.INV_SLOT_COUNT):
			inventory_slots_ui.get_child(i).focus_neighbor_top = item_box_slots_ui.get_child(i + item_box_index_offset).get_path()
			item_box_slots_ui.get_child(i + item_box_index_offset).focus_neighbor_bottom = inventory_slots_ui.get_child(i).get_path()

# Buttons
func _on_item_box_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:

		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			item_box_container.scroll_horizontal += SLOT_PX_SIZE
			accept_event()
			update_slots_neighbors()

		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			item_box_container.scroll_horizontal -= SLOT_PX_SIZE
			accept_event()
			update_slots_neighbors()


func _on_transfer_button_pressed() -> void:
	GameManager.inventory.reduce_item(action_inv_type, action_item.item_def, transfer_amount)
	GameManager.inventory.add_item(1 - action_inv_type, action_item.item_def, transfer_amount)
	
	close_action_menu()
	focus_slot([action_inv_type, action_slot_index])

func _on_transfer_button_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right"): # or event.is_action_pressed("scroll_up"):
		transfer_amount += 1
		transfer_amount = 1 if transfer_amount > max_transfer_amount else transfer_amount
		update_transfer_button_text()
		accept_event()

	elif event.is_action_pressed("ui_left"): # or event.is_action_pressed("scroll_down"):
		transfer_amount -= 1
		transfer_amount = max_transfer_amount if transfer_amount < 1 else transfer_amount
		update_transfer_button_text()
		accept_event()

func update_transfer_button_text():
	transfer_btn.text = "Transfer ( " + str(transfer_amount) + " )"



"""
Item Inspector Functions
"""

func update_item_text_from_slot(type: int, slot_index: int):
	var item: ItemInstance = GameManager.inventory.get_item(type, slot_index)
	
	if not item:
		update_item_text(null)
	else:
		update_item_text(item.item_def, item.item_amount)

func update_item_text(selected_item: ItemDefinition = null, selected_amount: int = 1, override_name: String = "", override_description: String = "") -> void:
	var item: ItemDefinition
	var item_name: String
	var item_description: String
	
	if not selected_item:
		update_name_label("")
		update_description_label("")
		update_item_texture(null)
	else:
		item = selected_item
		item_name = override_name if override_name else item.name
		item_description = override_description if override_description else item.description
		
		update_name_label(
			item_name + " (" + str(selected_amount) + ")"
			if selected_amount > 1 and not override_name
			else item_name
		)
		update_description_label(item_description)
		update_item_texture(item.inventory_texture)


func update_name_label(new_name: String) -> void:
	name_label.text = new_name
	name_label.visible_characters = 0
	
	for i in len(new_name):
		name_label.visible_characters += 1
		await get_tree().create_timer(0.05).timeout

func update_description_label(description: String):
	description_label.text = description.replace("\\n", "\n")
	description_label.visible_characters = 0
	
	for i in len(description):
		description_label.visible_characters += 1
		await get_tree().create_timer(0.02).timeout

var item_tween: Tween

func update_item_texture(texture: AtlasTexture):
	item_texture.texture = texture
	item_texture.scale = Vector2(0,0)
	item_texture.rotation_degrees = 0
	
	if item_tween:
		item_tween.kill()
	
	item_tween = create_tween()
	item_tween.tween_property(item_texture, "scale", Vector2(1,1), 0.4)
	item_tween.parallel().tween_property(item_texture, "rotation_degrees", 360, 0.4)
	
	# end early
	if InputManager.is_accept_pressed():
		item_tween.kill()
		item_texture.scale = Vector2(1,1)
		item_texture.rotation_degrees = 360
