extends Control
class_name MapUI

func _ready() -> void:
	self.hide()

"""
Map UI Functions
"""

func open_map() -> void:
	self.show()

func close_map() -> void:
	self.hide()
