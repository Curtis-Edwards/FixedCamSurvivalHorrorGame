
extends Control
class_name InventoryUI

@onready var inventory_slots_ui: GridContainer = $InventoryScreen/Inventory/InventorySlots/Slots
@onready var item_box_slots_ui: GridContainer = $InventoryScreen/Inventory/ItemBoxSlots/ScrollContainer/Slots

func _ready() -> void:
	inventory_slots_ui.show()
	item_box_slots_ui.hide()
	action_menu.hide()
	transfer_menu.hide()
	self.hide()

#region Inventory UI Functions
var is_item_box_open: bool = false

func open_inventory(open_item_box: bool = false) -> void:
	self.show()
	
	if open_item_box:
		is_item_box_open = true
		item_box_slots_ui.show()
		focus_slot([1,0])
	else:
		is_item_box_open = false
		item_box_slots_ui.hide()
		focus_slot([0,0])

func close_inventory() -> void:
	self.hide()
	is_item_box_open = false
	
	close_action_menu()
	CombinationManager.end_combine_state()
#endregion


#region Slots Functions
var focused_index: Array[int] = [0,0] # NOTE [inv_type, index]

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
#endregion


#region Item Action Menu Functions
@onready var action_menu: GridContainer = $InventoryScreen/Inventory/ActionMenu/Menus/ActionMenu

@onready var use_btn: Button = $InventoryScreen/Inventory/ActionMenu/Menus/ActionMenu/UseBtn
@onready var equip_btn: Button = $InventoryScreen/Inventory/ActionMenu/Menus/ActionMenu/EquipBtn
@onready var discard_btn: Button = $InventoryScreen/Inventory/ActionMenu/Menus/ActionMenu/DiscardBtn
@onready var consume_btn: Button = $InventoryScreen/Inventory/ActionMenu/Menus/ActionMenu/ConsumeBtn
@onready var combine_btn: Button = $InventoryScreen/Inventory/ActionMenu/Menus/ActionMenu/CombineBtn
@onready var close_btn: Button = $InventoryScreen/Inventory/ActionMenu/Menus/ActionMenu/CloseBtn

var action_item: ItemInstance = null
var action_slot_index: int
var action_inv_type: int

var is_action_menu_open: bool = false

func toggle_action_menu(type: int, slot: ItemInstance, index: int)  -> void:
	if not is_action_menu_open or (is_action_menu_open and slot != action_item):
		open_action_menu(type, slot, index)
	else:
		close_action_menu()

func open_action_menu(type: int, slot: ItemInstance, index: int)  -> void:
	is_action_menu_open = true
	action_item = slot
	action_slot_index = index
	action_inv_type = type
	
	if not action_item:
		return
	
	action_menu.show()
	transfer_menu_show()
	
	use_btn.disabled = false if GameManager.ui.is_interacting() else true
	equip_btn.disabled = false if action_item.item_def.can_equip and action_inv_type == 0 else true
	consume_btn.disabled = false if action_item.item_def.can_consume else true
	discard_btn.disabled = false if action_item.item_def.can_discard else true
	
	use_btn.grab_focus()
	
	disable_slots(true)
	action_menu.show()

func close_action_menu():
	is_action_menu_open = false
	action_item = null
	disable_slots(false)
	action_menu.hide()
	transfer_menu.hide()
	focus_slot(focused_index)


# Buttons
func _on_use_btn_pressed() -> void:
	GameManager.player.active_interactable.try_use_item(action_item.item_def)

func _on_equip_btn_pressed() -> void:
	# TODO: Implement consume btn
	focused_index = [action_inv_type, action_slot_index]
	close_action_menu()

func _on_discard_btn_pressed() -> void:
	GameManager.inventory.remove_item(action_inv_type, action_slot_index)
	focused_index = [action_inv_type, action_slot_index]
	close_action_menu()

func _on_consume_btn_pressed() -> void:
	# TODO: Implement consume btn
	focused_index = [action_inv_type, action_slot_index]
	close_action_menu()

func _on_combine_btn_pressed() -> void:
	CombinationManager.start_combine_state(action_inv_type, action_slot_index, action_item)
	focused_index = [action_inv_type, action_slot_index]
	close_action_menu()

func _on_close_btn_pressed() -> void:
	if is_action_menu_open:
		focused_index = [action_inv_type, action_slot_index]
		close_action_menu()
#endregion


#region Transfer Menu Functions
@onready var transfer_menu: GridContainer = $InventoryScreen/Inventory/ActionMenu/Menus/TransferMenu

@onready var increase_btn: Button = $InventoryScreen/Inventory/ActionMenu/Menus/TransferMenu/DecreaseBtn
@onready var transfer_btn: Button = $InventoryScreen/Inventory/ActionMenu/Menus/TransferMenu/TransferBtn
@onready var decrease_btn: Button = $InventoryScreen/Inventory/ActionMenu/Menus/TransferMenu/IncreaseBtn

var transfer_amount: int
var max_transfer_amount: int

func transfer_menu_show() -> void:
	if not is_item_box_open:
		transfer_menu.hide()
		return
	
	transfer_menu.show()
	max_transfer_amount = min(
		GameManager.inventory.can_add_item(1 - action_inv_type, action_item.item_def, action_item.item_amount),
		action_item.item_amount
	)
	transfer_amount = max_transfer_amount
	
	if max_transfer_amount == 0:
		transfer_btn.disabled = true
		increase_btn.disabled = true
		decrease_btn.disabled = true
		update_transfer_btn_text(true)
	else:
		transfer_btn.disabled = false
		
		if action_item.item_def.max_stack == 1:
			increase_btn.disabled = true
			decrease_btn.disabled = true
			update_transfer_btn_text(true)
			
		else:
			increase_btn.disabled = false
			decrease_btn.disabled = false
			update_transfer_btn_text(false)

func update_transfer_btn_text(not_statckable: bool) -> void:
	if not_statckable:
		transfer_btn.text = "Transfer"
	
	elif transfer_amount == max_transfer_amount:
		transfer_btn.text = "Transfer All"
	else:
		transfer_btn.text = "Transfer " + str(transfer_amount)


# Buttons
func _on_increase_btn_pressed() -> void:
	transfer_amount = min(max_transfer_amount, transfer_amount + 1)
	update_transfer_btn_text(false)

func _on_decrease_btn_pressed() -> void:
	transfer_amount = max(1, transfer_amount - 1)
	update_transfer_btn_text(false)

func _on_transfer_btn_pressed() -> void:
	GameManager.inventory.reduce_item(action_inv_type, action_item.item_def, transfer_amount)
	GameManager.inventory.add_item(1 - action_inv_type, action_item.item_def, transfer_amount)
	
	focused_index = [action_inv_type, action_slot_index]
	close_action_menu()
#endregion


#region Item Viewer Functions
@onready var item_viewer: ItemViewer = $InventoryScreen/ItemDisplay/ItemViewer/SubViewportContainer/SubViewport/ItemViewer
@onready var main_label: Label = $InventoryScreen/ItemDisplay/ItemDetails/Panel/Labels/MainLabel
@onready var sub_label: Label = $InventoryScreen/ItemDisplay/ItemDetails/Panel/Labels/SubLabel

func update_item_display(item: ItemInstance) -> void:
	if item:
		item_viewer.update_viewer(item.item_def)
		update_main_label(item.item_def.name)
		update_sub_label(item.item_def.description)

	else:
		item_viewer.update_viewer(null)
		update_main_label("")
		update_sub_label("")


func update_main_label(text: String) -> void:
	main_label.text = text

func update_sub_label(text: String) -> void:
	sub_label.text = text
#endregion
