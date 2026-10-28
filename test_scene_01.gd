extends Node

@onready var dialogue_ui: DialogueUI = $DialogueUI


func _process(_delta: float) -> void:
	if InputManager.is_debug_key1_pressed():
		dialogue_ui.open_dialogue_ui()
		dialogue_ui.set_pages([
			"Hey! Im some dummy text! This test only has this one page."
		])
		dialogue_ui.start_dialogue()
	
	if InputManager.is_debug_key2_pressed():
		dialogue_ui.open_dialogue_ui()
		dialogue_ui.set_pages([
			"Hey! Im some dummy text! This test has three pages.",
			"Look at me im the 2nd page! I have one more page after this...",
			"The final page! Cool right?"
		])
		dialogue_ui.start_dialogue()
	
	if InputManager.is_debug_key3_pressed():
		dialogue_ui.open_dialogue_ui()

		dialogue_ui.set_btns([
			["Click Me!", test_3_opt_1],
			["No! Click Me instead!!!", test_3_opt_2],
			["", Callable()],
			["", Callable()],
			["", Callable()],
		])
		dialogue_ui.set_pages([
			"Hey! Im some dummy text! This test has Option buttons.\nWhich will you pick?",
		])
		dialogue_ui.start_dialogue(true)
	
	if InputManager.is_debug_key9_pressed():
		dialogue_ui.close_dialogue_ui()

func test_3_opt_1() -> void:
	dialogue_ui.set_pages([
		"Thanks for clicking the first option!"
	])
	dialogue_ui.start_dialogue()

func test_3_opt_2() -> void:
	dialogue_ui.set_pages([
		"Thanks for clicking the second option! Im WAY cooler then the first option!"
	])
	dialogue_ui.start_dialogue()
