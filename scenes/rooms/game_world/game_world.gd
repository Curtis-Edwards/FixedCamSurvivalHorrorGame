@icon("res://addons/at-icons/node3d/globe.svg")
extends Node3D
class_name GameWorld


func _ready() -> void:
	GameManager.game_world = self
	
	#for i in range(1, rooms_node.get_child_count()):
		#rooms_node.get_child(i).queue_free()
	
	for child in rooms_node.get_children():
		child.queue_free()
	
	if ROOMS[starting_room]:
		load_room(starting_room)
		GameManager.player.global_transform = rooms_node.get_child(0).get_starting_pos()


func _process(_delta: float) -> void:
	pass

@export var starting_room: StringName = &"MainHall"

# Rooms
const ROOMS: Dictionary[StringName, PackedScene] = {
	&"MainHall": preload("res://scenes/rooms/test_layout_02/tl_02_mh.tscn"),
	&"SaveRoom": preload("res://scenes/rooms/test_layout_02/tl_02_sr.tscn"),
	&"EastWing": preload("res://scenes/rooms/test_layout_02/tl_02_ew.tscn"),
	&"WestWing": preload("res://scenes/rooms/test_layout_02/tl_02_ww.tscn"),
}



#region Room Functions
@onready var rooms_node: Node3D = $Rooms

func load_room(room_id: StringName) -> void:
	#var room := room_scene.instantiate() as RoomTemplate
	#rooms_node.add_child(room)
	var room_scene: PackedScene = ROOMS[room_id]
	var room := room_scene.instantiate() as RoomTemplate
	rooms_node.add_child(room)

func unload_room() -> void:
	rooms_node.get_child(0).queue_free()
#endregion


#region Camera Functions
@onready var camera: FixedCam = $FixedCam


func switch_camera(cam_pos: Transform3D, _bg_img: CompressedTexture2D) -> void:
	camera.global_transform = cam_pos
	#camera.apply_projection(bg_img)
#endregion
