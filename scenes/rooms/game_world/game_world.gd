extends Node3D
class_name GameWorld

func _ready() -> void:
	GameManager.game_world = self
	
	for i in range(1, rooms_node.get_child_count()):
		rooms_node.get_child(i).queue_free()

func _process(_delta: float) -> void:
	pass
	

"""
Room Functions
"""
@onready var rooms_node: Node3D = $Rooms

func load_room(room_scene: PackedScene) -> void:
	var room := room_scene.instantiate()
	rooms_node.add_child(room)

func unload_room() -> void:
	rooms_node.get_child(0).queue_free()


"""
Camera Functions
"""
@onready var camera: FixedCam = $FixedCam


func switch_camera(cam_pos: Transform3D, bg_img: CompressedTexture2D) -> void:
	camera.global_transform = cam_pos
	camera.apply_projection(bg_img)
