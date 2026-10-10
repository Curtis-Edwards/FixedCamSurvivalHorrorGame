extends Node

var combinations: Dictionary = {}

var combine_state: bool = false

var combine_type_a: InventorySystem
var combine_index_a: int
var combine_item_a: ItemInstance

var combine_type_b: InventorySystem
var combine_index_b: int
var combine_item_b: ItemInstance


#region Combine Setup
func _ready() -> void:
	register_recipe(
		Globals.ITEMS["g_herb"],
		Globals.ITEMS["g_herb"],
		basic_two_item_combo.bind(Globals.ITEMS["gg_herb"], 1)
	)
	register_recipe(
		Globals.ITEMS["g_herb"],
		Globals.ITEMS["r_herb"],
		basic_two_item_combo.bind(Globals.ITEMS["gr_herb"], 1)
	)
	register_recipe(
		Globals.ITEMS["blue_tablet_r"],
		Globals.ITEMS["blue_tablet_l"],
		basic_two_item_combo.bind(Globals.ITEMS["blue_tablet"], 1)
	)
	

func make_key(a_id: int, b_id: int) -> String:
	var low = min(a_id, b_id)
	var high = max(a_id, b_id)

	return str(low) + ":" + str(high)

#func register_recipe(a_id: int, b_id: int, result_callable: Callable) -> void:
func register_recipe(item_a: ItemDefinition, item_b: ItemDefinition, result_callable: Callable) -> void:
	
	var key = make_key(item_a.id, item_b.id)

	combinations[key] = CombinationRecipe.new(item_a.id, item_b.id, result_callable)

func combine(item_a: ItemInstance, item_b: ItemInstance) -> bool:
	var key = make_key(item_a.item_def.id, item_b.item_def.id)

	if not combinations.has(key):
		return false

	var recipe: CombinationRecipe = combinations[key]
	
	recipe.result.call()

	return true
#endregion


#region Combine State
func start_combine_state(_combine_type_a: InventorySystem, _combine_index_a: int, _combine_item_a: ItemInstance) -> void:
	combine_state = true
	assign_combine_a(_combine_type_a, _combine_index_a, _combine_item_a)

func end_combine_state() -> void:
	combine_state = false
	
	combine_type_a = null
	combine_index_a = -1
	combine_item_a = null

	combine_type_b = null
	combine_index_b = -1
	combine_item_b = null

func assign_combine_a(_combine_type_a: InventorySystem, _combine_index_a: int, _combine_item_a: ItemInstance) -> void:
	combine_type_a = _combine_type_a
	combine_index_a = _combine_index_a
	combine_item_a = _combine_item_a

func assign_combine_b(_combine_type_b: InventorySystem, _combine_index_b: int, _combine_item_b: ItemInstance) -> void:
	combine_type_b = _combine_type_b
	combine_index_b = _combine_index_b
	combine_item_b = _combine_item_b

func print_combine_state():
	print("- - -")
	print("type a: " + str(combine_type_a))
	print("index a: " + str(combine_index_b))
	print("item a: " + str(combine_item_b))
	print("  -  ")
	print("type b: " + str(combine_type_b))
	print("index b: " + str(combine_index_b))
	print("item b: " + str(combine_item_b))
	print("- - -")
#endregion


#region Combine Types
func basic_two_item_combo(_item_c: ItemDefinition, _amount: int):
	pass # TODO: Fix later
	#GameManager.inventory.reduce_item(combine_type_a, combine_item_a.item_def, 1, false)
	#GameManager.inventory.reduce_item(combine_type_b, combine_item_b.item_def, 1, false)
	#GameManager.inventory.add_item(combine_type_b, item_c, amount)
	#
	#GameManager.inventory.sort_slots(combine_type_a)
	#GameManager.inventory.sort_slots(combine_type_b)
	#
	#GameManager.inventory.inv_ui.update_slots_ui()
	#GameManager.inventory.inv_ui.focus_slot([combine_type_b, combine_index_b])
#endregion
