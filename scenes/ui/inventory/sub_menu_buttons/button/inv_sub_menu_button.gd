extends Button

func _on_focus_entered() -> void:
	modulate.a = 0.6


func _on_focus_exited() -> void:
	modulate.a = 1.0


func _on_mouse_entered() -> void:
	grab_focus()

func _on_pressed() -> void:
	pass # Replace with function body.
