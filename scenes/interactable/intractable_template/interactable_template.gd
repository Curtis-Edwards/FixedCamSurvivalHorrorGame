extends Area3D
class_name Interactable

@onready var other_btns: VBoxContainer = $InteractionPromptBtns


func interact() -> void:
	GameManager.player.start_interaction(self)

func do_interaction() -> void:
	pass


@warning_ignore("unused_parameter")
func try_use_item(item: ItemDefinition) -> void:
	pass
