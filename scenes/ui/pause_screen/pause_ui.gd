extends Control
class_name PauseUI

func _ready() -> void:
	self.hide()

"""
Pause UI Functions
"""

func open_pause() -> void:
	self.show()

func close_pause() -> void:
	self.hide()
