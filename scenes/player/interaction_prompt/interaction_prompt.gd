extends Control
class_name InteractionPrompt

@onready var interaction_label: RichTextLabel = $HBoxContainer/Text/RichTextLabel
@onready var visible_char_timer: Timer = $IncrementCharTimer
@onready var exit_btn: Button = $HBoxContainer/Buttons/ExitBtn

@onready var other_btns: VBoxContainer = $HBoxContainer/Buttons/OtherButtons

var is_text_printing: bool = false

func _ready() -> void:
	GameManager.interaction_prompt = self


func start_interaction_text(text: String) -> void:
	is_text_printing = true
	exit_btn.text = "Skip"
	
	interaction_label.visible_characters = 0
	interaction_label.text = text
	
	visible_char_timer.start()

func stop_interaction_text() -> void:
	is_text_printing = false
	exit_btn.text = "Exit"


func preemptively_stop_interaction_text() -> void:
	interaction_label.visible_characters = len(interaction_label.text)
	visible_char_timer.timeout.emit()


func _on_increment_char_timer_timeout() -> void:
	if interaction_label.visible_characters == len(interaction_label.text):
		stop_interaction_text()
	else:
		interaction_label.visible_characters += 1
		visible_char_timer.start()


func _on_exit_btn_pressed() -> void:
	if is_text_printing:
		preemptively_stop_interaction_text()
	else:
		GameManager.player.stop_interaction()
