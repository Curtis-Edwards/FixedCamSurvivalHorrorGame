@icon ("res://addons/at-icons/node3d/chest.svg")
extends Interactable
class_name ItemBox

func interact() -> void:
	GameManager.ui.push_state(GameManager.ui.UIState.ITEM_BOX)
