extends Node
class_name ItemViewer

@export var rotation_speed: float = 2.0

@onready var camera: Camera3D = $Camera3D
@onready var item: Node3D = $Item
@onready var item_image: Sprite3D = $Item/ItemImage


func update_viewer(new_item: ItemDefinition) -> void:
	#item_image.rotation.y = 0e
	if not new_item:
		item_image.texture = null
	else:
		item_image.texture = new_item.inventory_texture

func _process(delta: float) -> void:
	item_image.rotation.y += rotation_speed * delta
