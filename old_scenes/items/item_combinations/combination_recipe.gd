# combination_recipe.gd
extends RefCounted
class_name CombinationRecipe

var item_a_id: int
var item_b_id: int
var result: Callable

func _init(a_id: int, b_id: int, result_callable: Callable):
	item_a_id = a_id
	item_b_id = b_id
	result = result_callable
