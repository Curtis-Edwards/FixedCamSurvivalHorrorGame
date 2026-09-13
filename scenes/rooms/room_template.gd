extends Node3D
class_name RoomTemplate

@onready var room_collison: Node3D = $BlenderExport
@onready var camera_triggers: Node3D = $FixedCamTriggers
@onready var items: Node3D = $Interactables/Items
@onready var starting_point: Marker3D = $DebugStartingPoint

func get_starting_pos() -> Transform3D:
	return starting_point.global_transform

func _ready() -> void:
	
	# setup collison layers and masks
	for room in room_collison.get_child(0).get_children():
		
		if room is not MeshInstance3D:
			continue
		
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
