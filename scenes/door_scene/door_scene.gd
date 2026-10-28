@icon("res://addons/at-icons/node3d/doors.svg")
extends Node3D
class_name DoorScene



func _on_interaction_component_interact() -> void:
	print("Door interacted with!")
