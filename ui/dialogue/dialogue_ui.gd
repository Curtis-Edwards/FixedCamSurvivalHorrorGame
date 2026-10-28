extends Control
class_name DialogueUI

func _ready() -> void:
	close_dialogue_ui()
	_hide_dialogue_btns()

func _process(_delta: float) -> void:
	if InputManager.is_accept_pressed():
		_on_accept_pressed()

func _on_accept_pressed() -> void:
	if dialogue_text.visible_characters != -1:
		typewriter_timer.stop()
		_finish_typewriter_text_display()
	elif not _is_on_last_page():
		_next_page_and_display()
	elif _is_on_last_page() and not display_options_after_text:
		close_dialogue_ui()

#region Dialogue Ui Functions
"""
Dialogue Ui Functions
"""
var display_options_after_text: bool = false


func open_dialogue_ui() -> void:
	show()

func close_dialogue_ui() -> void:
	hide()

func start_dialogue(display_options_after: bool = false) -> void:
	cur_page_index = -1
	display_options_after_text = display_options_after
	_hide_dialogue_btns()
	
	_next_page_and_display()

#endregion

#region Dialogue Pages Functions
"""
Dialogue Pages Functions
"""
var display_text_pages: Array[String] = []
var cur_page_index: int = -1


func set_pages(display_text_array: Array[String]) -> void:
	if not display_text_array:
		return
	
	display_text_pages = display_text_array
	cur_page_index = 0

func _next_page() -> void:
	if cur_page_index == len(display_text_pages):
		return
	
	cur_page_index += 1

func _next_page_and_display() -> void:
	_next_page()
	_display_text(display_text_pages[cur_page_index])

func _is_on_last_page() -> bool:
	return cur_page_index == len(display_text_pages) - 1

#endregion

#region Dialogue Text Functions
"""
Dialogue Text Functions
"""
@onready var dialogue_text: RichTextLabel = $VBox/DialogueTextControl/DialogueText
@onready var typewriter_timer: Timer = $VBox/DialogueTextControl/TypewriterTimer


func _display_text(new_text: String) -> void:
	_update_text(new_text)
	_start_typewriter_text_display()

func _update_text(new_text: String) -> void:
	dialogue_text.text = new_text


func _start_typewriter_text_display() -> void:
	dialogue_text.visible_characters = 0
	
	typewriter_timer.start()

func _on_typewriter_timer_timeout() -> void:
	dialogue_text.visible_characters += 1
	
	if dialogue_text.visible_characters == len(dialogue_text.text):
		_finish_typewriter_text_display()
	else:
		typewriter_timer.start()

func _finish_typewriter_text_display() -> void:
	dialogue_text.visible_characters = -1
	
	if _is_on_last_page() and display_options_after_text:
		_show_dialogue_btns()

#endregion

#region Dialogue Buttons Functions
"""
Dialogue Buttons Functions
"""
@onready var btns_h_box: HBoxContainer = $VBox/DialogueBtns/HBox

@onready var option_1_btn: DialogueUIBtn = $VBox/DialogueBtns/HBox/Option1Btn
@onready var option_2_btn: DialogueUIBtn = $VBox/DialogueBtns/HBox/Option2Btn
@onready var option_3_btn: DialogueUIBtn = $VBox/DialogueBtns/HBox/Option3Btn
@onready var option_4_btn: DialogueUIBtn = $VBox/DialogueBtns/HBox/Option4Btn
@onready var option_5_btn: DialogueUIBtn = $VBox/DialogueBtns/HBox/Option5Btn


func _show_dialogue_btns() -> void:
	btns_h_box.show()

func _hide_dialogue_btns() -> void:
	btns_h_box.hide()

"""
Example:
dialogue_ui.btns_setup([
	["Click Me!", test_3_opt_1],
	["No! Click Me instead!!!", test_3_opt_2],
	["", Callable()],
	["", Callable()],
	["", Callable()],
])
"""
func set_btns(buttons_config: Array) -> void:
	if len(buttons_config) != 5:
		return
	
	option_1_btn.set_btn(buttons_config[0][0], buttons_config[0][1])
	option_2_btn.set_btn(buttons_config[1][0], buttons_config[1][1])
	option_3_btn.set_btn(buttons_config[2][0], buttons_config[2][1])
	option_4_btn.set_btn(buttons_config[3][0], buttons_config[3][1])
	option_5_btn.set_btn(buttons_config[4][0], buttons_config[4][1])

#endregion
