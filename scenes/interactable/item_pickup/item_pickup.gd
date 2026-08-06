@tool
extends Interactable
class_name ItemPickup

@onready var image: Sprite3D = $Image
@onready var label: Label3D = $Amount
@onready var take_btn: InteractionPromptBtn = $InteractionPromptBtns/TakeBtn
@onready var increase_btn: InteractionPromptBtn = $InteractionPromptBtns/IncreaseBtn
@onready var decrease_btn: InteractionPromptBtn = $InteractionPromptBtns/DecreaseBtn

@export var item_definition: ItemDefinition:
	set(value):
		item_definition = value
		_update_display()
@export var amount: int = 1:
	set(value):
		amount = value
		_update_display()

var max_pickup_amount: int = 0
var pickup_amount: int = 0

func _ready() -> void:
	_update_display()

func _update_display():
	if !is_node_ready():
		return

	if item_definition:
		image.texture = item_definition.inventory_texture
		label.text = str(amount)
	else:
		image.texture = null
		label.text = ""


func interact() -> void:
	GameManager.player.start_interaction(self)
	
	var amount_str = " (" + str(amount) + ")" if item_definition.max_stack > 1 else ""
	
	max_pickup_amount = GameManager.inventory.can_add_item(0, item_definition, amount)
	pickup_amount = max_pickup_amount
	
	if max_pickup_amount == 0:
		take_btn.hide()
		increase_btn.hide()
		decrease_btn.hide()
		
		GameManager.player.inteaction_prompt.start_interaction_text(
			"Inventory full. Cannot pick up the " +
			str(item_definition.name) + amount_str
		)
	else:
		take_btn.show()
		if item_definition.max_stack == 1:
			increase_btn.hide()
			decrease_btn.hide()
			
			update_take_btn_text(true)
			
		else:
			increase_btn.show()
			decrease_btn.show()
			
			update_take_btn_text(false)
		
		GameManager.player.inteaction_prompt.start_interaction_text(
			"Will you take the " +
			str(item_definition.name) + amount_str + "?"
		)

func update_take_btn_text(not_statckable: bool) -> void:
	if not_statckable:
		take_btn.text = "Take"
	
	elif pickup_amount == amount:
		take_btn.text = "Take All"
	else:
		take_btn.text = "Take " + str(pickup_amount)


func _on_take_btn_pressed() -> void:
	GameManager.inventory.add_item(0, item_definition, pickup_amount)
	amount -= pickup_amount
	
	GameManager.player.stop_interaction()
	
	if amount <= 0:
		queue_free()
	else:
		_update_display()


func _on_increase_btn_pressed() -> void:
	pickup_amount = min(max_pickup_amount, pickup_amount + 1)
	update_take_btn_text(false)

func _on_decrease_btn_pressed() -> void:
	pickup_amount = max(1, pickup_amount - 1)
	update_take_btn_text(false)
