extends Node3D
class_name RoomTemplate

@onready var room_collison: Node3D = $BoxedOutRoom
@onready var camera_triggers: Node3D = $FixedCamTriggers
@onready var items: Node3D = $Interactables/Items

@onready var room_projection_material: Material = preload("res://assets/materials/room_projection.tres")

func _ready() -> void:
	
	# setup collison layers and masks
	for room in room_collison.get_child(0).get_children():
		
		if room is not MeshInstance3D:
			continue
		
		room.set_surface_override_material(0, room_projection_material)
		
		var boxed_out_shape_collison: StaticBody3D = room.get_child(0)

		if boxed_out_shape_collison:
			boxed_out_shape_collison.set_collision_layer_value(1, false)
			boxed_out_shape_collison.set_collision_layer_value(7, true)

			boxed_out_shape_collison.set_collision_mask_value(1, true)
			boxed_out_shape_collison.set_collision_mask_value(2, true)
			boxed_out_shape_collison.set_collision_mask_value(3, true)
			boxed_out_shape_collison.set_collision_mask_value(4, true)
		else:
			push_error("ERROR!  Static Body Not Found")
