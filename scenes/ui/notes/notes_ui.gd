extends Control
class_name NotesUI

func _ready() -> void:
	self.hide()

"""
Notes UI Functions
"""

func open_notes() -> void:
	self.show()

func close_notes() -> void:
	self.hide()
