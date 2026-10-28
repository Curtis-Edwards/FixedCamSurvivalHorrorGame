extends Button
class_name DialogueUIBtn

signal option_selected

var btn_text: String = ""

func set_btn(display_text: String = "", callable: Callable = Callable()) -> void:
	if display_text:
		update_text(display_text)
		update_option_selected_signal(callable)
		show()
	else:
		hide()
	print("set: " + name)

func un_set_btn(display_text: String = "", callable: Callable = Callable()) -> void:
	if callable.is_valid():
		update_text(display_text)
		update_option_selected_signal(callable)
		show()
	else:
		update_text("")
		hide()

func update_text(new_text: String) -> void:
	btn_text = new_text
	text = btn_text

func update_option_selected_signal(callable: Callable = Callable()) -> void:
	for connection in option_selected.get_connections():
		option_selected.disconnect(connection["callable"])
	
	option_selected.connect(callable)



func _on_pressed() -> void:
	option_selected.emit()

func _on_mouse_entered() -> void:
	grab_focus()

func _on_focus_entered() -> void:
	text = "> " + btn_text

func _on_focus_exited() -> void:
	text = btn_text
