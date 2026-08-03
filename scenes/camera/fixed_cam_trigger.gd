extends Node3D
class_name FixedCamTrigger

@onready var cam_trigger: Area3D = $CamTrigger
@onready var cam_position: Marker3D = $CamPos
@export var bg_img: CompressedTexture2D

func _on_cam_trigger_area_shape_entered(_area_rid: RID, _area: Area3D, _area_shape_index: int, _local_shape_index: int) -> void:
	GameManager.game_world.switch_camera(cam_position.global_transform, bg_img)
