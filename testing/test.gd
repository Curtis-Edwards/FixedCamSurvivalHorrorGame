@tool
extends Node

func _test():
	print("Hello")

@export_tool_button("Test")
var test := _test
