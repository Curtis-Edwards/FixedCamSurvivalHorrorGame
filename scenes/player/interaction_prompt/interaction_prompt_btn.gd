extends Button
class_name InteractionPromptBtn

func _on_mouse_entered() -> void:
	grab_focus()


func _on_focus_entered() -> void:
	GameManager.player.inteaction_prompt.focused_btn = self
