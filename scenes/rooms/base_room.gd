@icon("res://addons/at-icons/node3d/house.svg")
extends Node3D
class_name BaseRoom

@onready var room_collison: Node3D = $BlenderExport
@onready var camera_triggers: Node3D = $FixedCamTriggers
@onready var starting_point: Marker3D = $StartingPointMarker

func move_player_to_start_pos() -> void:
	GameManager.player.global_transform = starting_point.global_transform

func _ready() -> void:
	
	# setup collison layers and masks
	for mesh in room_collison.get_children():
		
		if mesh is not MeshInstance3D:
			continue
		
		var boxed_out_shape_collison: StaticBody3D = mesh.get_child(0)

		if boxed_out_shape_collison:
			boxed_out_shape_collison.set_collision_layer_value(1, false)
			
			boxed_out_shape_collison.set_collision_layer_value(Globals.STATIC_ENVIROMENT_COLLISION_LAYER, true)
			boxed_out_shape_collison.set_collision_mask_value(Globals.PLAYER_COLLISION_LAYER, true)
			boxed_out_shape_collison.set_collision_mask_value(Globals.PLAYER_PROJECTILE_COLLISION_LAYER, true)
			boxed_out_shape_collison.set_collision_mask_value(Globals.ENEMY_COLLISION_LAYER, true)
			boxed_out_shape_collison.set_collision_mask_value(Globals.ENEMY_PROJECTILE_COLLISION_LAYER, true)
		else:
			push_error("ERROR!  Static Body Not Found")
