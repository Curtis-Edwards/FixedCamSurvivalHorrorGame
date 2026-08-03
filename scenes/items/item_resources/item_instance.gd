extends Resource
class_name ItemInstance

var item_def: ItemDefinition
var item_amount: int = 1

func _init(def: ItemDefinition = null, amount: int = 1):
	item_def = def
	item_amount = amount
