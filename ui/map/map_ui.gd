extends Control
class_name MapUI

func _ready() -> void:
	self.hide()


#region Map UI Functions

func open_map() -> void:
	self.show()

func close_map() -> void:
	self.hide()

#endregion
