@icon("res://addons/at-icons/node3d/globe.svg")
extends Node3D
class_name GameWorld

func _ready() -> void:
	GameManager.game_world = self
	
	init_starting_room()


func _process(_delta: float) -> void:
	pass

@export var starting_room: StringName = &"room_b"


#region Room Functions
@onready var rooms_node: Node3D = $Rooms

func load_room(room_id: StringName) -> void:
	var room_scene: PackedScene = Globals.ROOMS[room_id]
	var room := room_scene.instantiate() as RoomTemplate
	rooms_node.add_child(room)

func unload_room() -> void:
	rooms_node.get_child(0).queue_free()

func init_starting_room() -> void:
	
	for child in rooms_node.get_children():
		child.queue_free()
	
	
	load_room(starting_room)
	GameManager.player.global_transform = rooms_node.get_child(0).get_starting_pos()

#endregion


#region Camera Functions
@onready var camera: FixedCam = $FixedCam


func switch_camera(cam_pos: Transform3D, _bg_img: CompressedTexture2D) -> void:
	camera.global_transform = cam_pos
	#camera.apply_projection(bg_img)
#endregion
