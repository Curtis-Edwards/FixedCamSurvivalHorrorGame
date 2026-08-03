extends Interactable

func interact() -> void:
	if not GameManager.player.lock_menu_input:
		GameManager.ui.push_state(GameManager.ui.UIState.ITEM_BOX)
