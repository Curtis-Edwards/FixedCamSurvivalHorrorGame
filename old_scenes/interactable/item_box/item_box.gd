@icon ("res://addons/at-icons/node3d/chest.svg")
extends Interactable
class_name ItemBox

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func interact() -> void:
	GameManager.ui.push_state(GameManager.ui.UIState.ITEM_BOX)

func entered_interactable() -> void:
	animation_player.play("peak_lid_open")

func exited_interactable() -> void:
	animation_player.play("peak_lid_close")
