extends Resource
class_name UIElementData

signal inventory_inputed
signal pause_inputed
signal state_pushed
signal state_popped

enum UIType {
	NONE,
	INTERACTION,
	INVENTORY,
	PAUSE,
	# Add more as I go...
}

@export var ui_type: UIType = UIType.INVENTORY

func on_inventory_inputed() -> void:
	pass

func on_pause_inputed() -> void:
	pass

func on_state_pushed() -> void:
	pass

func on_state_popped() -> void:
	pass

# etc...
