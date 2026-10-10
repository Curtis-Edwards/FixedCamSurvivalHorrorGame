extends Resource
class_name InventorySystem

enum InvType {
	INVENTORY,
	ITEM_BOX
}
@export var inv_type: InvType = InvType.INVENTORY
@export var inv_size: int = 1
var slots: Array[ItemInstance] = []

func initialize() -> void:
	slots.resize(inv_size)

#region Inventory Functions

func get_item(index: int) -> ItemInstance:
	if index >= 0 and index < inv_size:
		return slots[index]
	return null

func can_add_item(definition: ItemDefinition, amount: int) -> int:
	var free_item_space: int = 0
	
	for item in slots:
		if item == null:
			free_item_space += definition.max_stack

		elif item.item_def == definition and item.item_amount < definition.max_stack:
			free_item_space += definition.max_stack - item.item_amount
	
	free_item_space = min(free_item_space, amount)
	return free_item_space 

func add_item(definition: ItemDefinition, amount: int) -> int:
	var remaining: int = amount

	for i in inv_size:
		
		if remaining == 0:
			break

		# add to new slot
		if slots[i] == null:
			var stack_size = min(definition.max_stack, remaining)
			slots[i] = ItemInstance.new(definition, stack_size)
			remaining -= stack_size

		# add to existing slot
		elif slots[i].item_def == definition:
			var add_amount = min(definition.max_stack - slots[i].item_amount, remaining)
			slots[i].item_amount += add_amount
			remaining -= add_amount

	sort_slots()
	return remaining

func get_item_count(definition: ItemDefinition) -> int:
	var amount: int = 0
	
	for slot in slots:
		if not slot:
			continue
		
		if slot.item_def == definition:
			amount += slot.item_amount
	
	return amount

func reduce_item(definition: ItemDefinition, amount: int, sort_after: bool = true) -> int:
	var remaining: int = amount

	for i in range(inv_size - 1, -1, -1):

		if remaining <= 0:
			break

		var item: ItemInstance = slots[i]

		if item == null: continue
		if item.item_def != definition: continue

		# Entire stack gets removed
		if item.item_amount <= remaining:
			remaining -= item.item_amount
			remove_item(i, sort_after)

		# Only reduce the stack
		else:
			item.item_amount -= remaining
			remaining = 0

	sort_slots()

	# returns amount that could NOT be removed
	return remaining

func remove_item(index: int, sort_after: bool = true) -> void:
	if index >= 0 and index < inv_size:
		slots[index] = null
		if sort_after:
			sort_slots()

func sort_slots() -> void:
	var items: Array[ItemInstance] = []

	for item in slots:
		if item != null:
			items.append(item)

	items.sort_custom(func(a,b):

		if a.item_def.id == b.item_def.id:
			return a.item_amount > b.item_amount

		return a.item_def.id < b.item_def.id
	)

	slots.resize(inv_size)

	for i in range(inv_size):
		slots[i] = null

	for i in range(items.size()):
		slots[i] = items[i]
	
	#GameManager.ui.inv_screen.update_slots_ui()

func clear_inventory():
	slots.clear()
	slots.resize(inv_size)
	
	sort_slots()

#endregion
