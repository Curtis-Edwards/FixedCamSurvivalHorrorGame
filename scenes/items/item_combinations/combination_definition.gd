extends Resource
class_name CombinationDefinition

@export var item_a: ItemDefinition
@export var item_b: ItemDefinition

func can_combine(_index_a: int, _index_b: int) -> bool:
	return true

func combine(_index_a: int, _type_a: int, _index_b: int, _type_b: int):
	pass
