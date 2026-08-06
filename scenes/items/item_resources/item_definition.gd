extends Resource
class_name ItemDefinition

@export var id: int
@export var name: String
@export var description: String
@export var inventory_texture: AtlasTexture
@export var max_stack: int = 1

@export var can_equip: bool = false
@export var can_consume: bool = false
@export var can_discard: bool = false
