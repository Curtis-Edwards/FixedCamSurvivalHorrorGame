extends Node
class_name Inventory

@onready var inv_ui: InventoryUI = $InventoryUI

func _ready() -> void:
	GameManager.inventory = self
	inventory_slots.resize(INV_SLOT_COUNT)
	item_box_slots.resize(BOX_SLOT_COUNT)
	
	# Adding starting items for testing
	add_item(0, Globals.ITEMS["pistol"],1)
	add_item(0, Globals.ITEMS["pistol_ammo"],10)
	
	add_item(1, Globals.ITEMS["shotgun"],1)
	add_item(1, Globals.ITEMS["shotgun_ammo"],4)

func _process(_delta: float) -> void:
	# HACK: debug filling items for testing
	if InputManager.is_debug_key7_pressed():
		print("|  DEBUG  | Clear Inventory.")
		clear_inventory(0)
	
	if InputManager.is_debug_key8_pressed():
		print("|  DEBUG  | Clear ItemBox.")
		clear_inventory(1)
	
	if InputManager.is_debug_key9_pressed():
		print("|  DEBUG  | Clear Inventory And ItemBox.")
		clear_inventory(0)
		clear_inventory(1)
	
	if InputManager.is_debug_key1_pressed():
		print("|  DEBUG  | Loading item set 1.")
		add_item(1, Globals.ITEMS["shotgun"],1)
		add_item(1, Globals.ITEMS["shotgun_ammo"],8)
		
		add_item(0, Globals.ITEMS["pistol"],1)
		add_item(0, Globals.ITEMS["pistol_ammo"],18)
		add_item(0, Globals.ITEMS["g_herb"],1)
		add_item(0, Globals.ITEMS["r_herb"],1)
		add_item(0, Globals.ITEMS["diamond_key"],1)
		add_item(0, Globals.ITEMS["spade_key"],1)
	
	if InputManager.is_debug_key2_pressed():
		print("|  DEBUG  | Loading item set 2.")

		add_item(0, Globals.ITEMS["pistol_ammo"],15)
	
	if InputManager.is_debug_key3_pressed():
		print("|  DEBUG  | Loading item set 3.")

		add_item(0, Globals.ITEMS["pistol_ammo"],140)
	
	if InputManager.is_debug_key4_pressed():
		print("|  DEBUG  | Loading item set 4.")

		add_item(0, Globals.ITEMS["pistol_ammo"],150)

	if InputManager.is_debug_key5_pressed():
		print("|  DEBUG  | Loading item set 5.")

		add_item(0, Globals.ITEMS["pistol_ammo"],160)



"""
Inventory Functions
"""
var inventory_slots: Array[ItemInstance] = []
const INV_SLOT_COUNT: int = 8
@onready var inventory_slots_ui: GridContainer = $InventoryUI/InventoryScreen/Inventory/InventorySlots/Slots

var item_box_slots: Array[ItemInstance] = []
const BOX_SLOT_COUNT: int = 16
@onready var item_box_slots_ui: GridContainer = $InventoryUI/InventoryScreen/Inventory/ItemBoxSlots/ScrollContainer/Slots

func get_inventory_type(type: int) -> Dictionary:
	match type:
		0:
			return {
				"slots": inventory_slots,
				"size": INV_SLOT_COUNT,
				"ui": inventory_slots_ui
			}
		1:
			return {
				"slots": item_box_slots,
				"size": BOX_SLOT_COUNT,
				"ui": item_box_slots_ui
			}
		_:
			return {
				"slots": [],
				"size": 0,
				"ui": null
			}


func get_item(type: int, index: int) -> ItemInstance:
	var data: Dictionary = get_inventory_type(type)
	var inv: Array[ItemInstance] = data["slots"]
	var inv_size: int = data["size"]
	
	if index >= 0 and index < inv_size:
		return inv[index]
	return null

func can_add_item(type: int, definition: ItemDefinition, amount: int) -> int:
	var data: Dictionary = get_inventory_type(type)
	var inv: Array[ItemInstance] = data["slots"]
	
	#if type == 1:
		#return amount
	
	var free_item_space: int = 0
	
	for item in inv:
		if item == null:
			free_item_space += definition.max_stack

		elif item.item_def == definition and item.item_amount < definition.max_stack:
			free_item_space += definition.max_stack - item.item_amount
	
	free_item_space = min(free_item_space, amount)
	return free_item_space 

func add_item(type: int, definition: ItemDefinition, amount: int) -> int:
	var data: Dictionary = get_inventory_type(type)
	var inv: Array[ItemInstance] = data["slots"]
	var inv_size: int = data["size"]
	
	var remaining: int = amount

	for i in inv_size:
		
		if remaining == 0:
			break

		# add to new slot
		if inv[i] == null:
			#var stack_size = min(definition.max_stack, remaining) if type == 0 else remaining
			var stack_size = min(definition.max_stack, remaining)
			inv[i] = ItemInstance.new(definition, stack_size)
			remaining -= stack_size

		# add to existing slot
		elif inv[i].item_def == definition:
			#var add_amount = min(definition.max_stack - inv[i].item_amount, remaining) if type == 0 else remaining
			var add_amount = min(definition.max_stack - inv[i].item_amount, remaining)
			inv[i].item_amount += add_amount
			remaining -= add_amount

	sort_slots(type)
	inv_ui.update_slots_ui()
	return remaining

func get_item_count(type: int, definition: ItemDefinition) -> int:
	var data: Dictionary = get_inventory_type(type)
	var inv: Array[ItemInstance] = data["slots"]
	
	var amount: int = 0
	
	for slot in inv:
		if not slot:
			continue
		
		if slot.item_def == definition:
			amount += slot.item_amount
	
	return amount

func reduce_item(type: int, definition: ItemDefinition, amount: int, sort_after: bool = true) -> int:
	var data: Dictionary = get_inventory_type(type)
	var inv: Array[ItemInstance] = data["slots"]
	var inv_size: int = data["size"]

	var remaining: int = amount

	for i in range(inv_size - 1, -1, -1):

		if remaining <= 0:
			break

		var item: ItemInstance = inv[i]

		if item == null: continue
		if item.item_def != definition: continue

		# Entire stack gets removed
		if item.item_amount <= remaining:
			remaining -= item.item_amount
			remove_item(type, i, sort_after)

		# Only reduce the stack
		else:
			item.item_amount -= remaining
			remaining = 0

	sort_slots(type)
	inv_ui.update_slots_ui()

	# returns amount that could NOT be removed
	return remaining

func remove_item(type: int, index: int, sort_after: bool = true) -> void:
	var data: Dictionary = get_inventory_type(type)
	var inv: Array[ItemInstance] = data["slots"]
	var inv_size: int = data["size"]
	
	if index >= 0 and index < inv_size:
		inv[index] = null
		if sort_after:
			sort_slots(type)
			inv_ui.update_slots_ui()

func sort_slots(type: int) -> void:
	var data: Dictionary = get_inventory_type(type)
	var inv: Array[ItemInstance] = data["slots"]
	var inv_size: int = data["size"]
	
	var items: Array[ItemInstance] = []

	for item in inv:
		if item != null:
			items.append(item)

	items.sort_custom(func(a,b):

		if a.item_def.id == b.item_def.id:
			return a.item_amount > b.item_amount

		return a.item_def.id < b.item_def.id
	)

	inv.resize(inv_size)

	for i in range(inv_size):
		inv[i] = null

	for i in range(items.size()):
		inv[i] = items[i]

func clear_inventory(type: int):
	var data: Dictionary = get_inventory_type(type)
	var inv: Array[ItemInstance] = data["slots"]
	var inv_size: int = data["size"]
	
	inv.clear()
	inv.resize(inv_size)
	
	sort_slots(type)
	inv_ui.update_slots_ui()

func print_inventory(type: int) -> void:
	var data: Dictionary = get_inventory_type(type)
	var inv: Array[ItemInstance] = data["slots"]
	var _inv_size = data["size"]
	
	print("-----")
	for slot in inv:
		if slot == null:
			print("[ NULL ]")
		else:
			print("[ " + str(slot.item_def.name) + ": " + str(slot.item_amount) + "/" + str(slot.item_def.max_stack) + " ]")
	print("-----")
