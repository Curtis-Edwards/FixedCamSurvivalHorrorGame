extends Node
class_name MainScene

func _ready() -> void:
	GameManager.main_scene = self
	DisplayServer.window_set_current_screen(0)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
