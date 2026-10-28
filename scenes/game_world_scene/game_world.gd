@icon("res://addons/at-icons/node3d/globe.svg")
extends Node3D
class_name GameWorld

enum RoomsEnum {
	ROOM_01,
	ROOM_02,
}

const ROOMS: Dictionary[RoomsEnum, PackedScene] = {
	RoomsEnum.ROOM_01: preload("res://scenes/rooms/room_01.tscn"),
	RoomsEnum.ROOM_02: preload("res://scenes/rooms/room_02.tscn"),
}

func _ready() -> void:
	GameManager.game_world = self
	
	load_room(starting_room)
	
	get_cur_room().move_player_to_start_pos()


func _process(_delta: float) -> void:
	pass

@export var starting_room: RoomsEnum = RoomsEnum.ROOM_02


#region Room Functions
@onready var rooms_node: Node3D = $Rooms

func get_cur_room() -> BaseRoom:
	return rooms_node.get_child(0) as BaseRoom

func load_room(room_id: RoomsEnum) -> void:
	var room_scene: PackedScene = ROOMS[room_id]
	var room := room_scene.instantiate() as BaseRoom
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
