extends CharacterBody3D
class_name NewPlayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

@export var walk_speed_forward: float = 4.0
@export var walk_speed_backward: float = 3.0
@export var sprint_speed: float = 6.0
@export var rotation_speed: float = 4.0

@export var gravity: float = 9.8
var is_sprinting: bool = false

func _ready() -> void:
	#GameManager.player = self
	pass

func _process(delta):
	
	var player_move_axis: float = InputManager.get_player_move_axis()
	var player_rotation_axis: float = InputManager.get_player_rotation_axis()
	var speed: float = 0.0
	is_sprinting = !is_sprinting if InputManager.is_sprint_pressed() else is_sprinting
	
	
	if InputManager.is_quick_turn_inputed():
		state_machine.travel("Quick Turn")
		animation_player.play("quick_turn")
		
		print("Quick Turn")
	
	if can_player_move():
	
		if player_move_axis == 0.0:
			state_machine.travel("Idle")
			speed = 0.0
		elif player_move_axis < 0.0:
			state_machine.travel("Walk Backward")
			speed = walk_speed_backward
		elif player_move_axis > 0.0:
			if is_sprinting:
				state_machine.travel("Sprint Forward")
				speed = sprint_speed
			else:
				state_machine.travel("Walk Forward")
				speed = walk_speed_forward
	
	velocity.x = (-transform.basis.z * player_move_axis).x * speed
	velocity.z = (-transform.basis.z * player_move_axis).z * speed
	rotation.y -= player_rotation_axis * rotation_speed * delta
	
	velocity.y -= gravity * delta if not is_on_floor() else 0.0
	
	move_and_slide()

func do_quick_turn() -> void:
	rotation.y += PI

#region Interaction Functions
@onready var interaction_area: Area3D = $InteractionStuff/InteractionArea

var nearby_interactables: Array[Interactable] = []

func _on_interaction_area_area_entered(area: Area3D) -> void:
	nearby_interactables.append(area)

func _on_interaction_area_area_exited(area: Area3D) -> void:
	nearby_interactables.erase(area)

func get_best_interactable() -> Interactable:
	if nearby_interactables.is_empty():
		return null

	var closest: Interactable = nearby_interactables[0]
	var closest_dist: float = global_position.distance_squared_to(
		closest.global_position
	)

	for interactable in nearby_interactables:
		var dist: float = global_position.distance_squared_to(
			interactable.global_position
		)

		if dist < closest_dist:
			closest = interactable
			closest_dist = dist

	return closest

@onready var inteaction_prompt: InteractionPrompt = $InteractionStuff/InteractionPrompt

var active_interactable: Interactable = null

func start_interaction(interactable: Interactable) -> void:
	if not interactable:
		return
	
	active_interactable = interactable
	GameManager.player.lock_player_input = true
	
	for btn in active_interactable.other_btns.get_children():
		if btn.get_parent():
			btn.get_parent().remove_child(btn)
		inteaction_prompt.other_btns.add_child(btn)
	
	#cur_player_state = PlayerState.INTERACTING
	GameManager.ui.push_state(GameManager.ui.UIState.INTERACTING)

func stop_interaction() -> void:
	for btn in inteaction_prompt.other_btns.get_children():
		if btn.get_parent():
			btn.get_parent().remove_child(btn)
		active_interactable.other_btns.add_child(btn)
	
	
	GameManager.player.lock_player_input = false
	active_interactable = null
	
	#cur_player_state = PlayerState.NORMAL
	
	GameManager.ui.pop_state()
#endregion


#region Other

func get_player_state() -> String:
	return state_machine.get_current_node()

func can_player_move() -> bool:
	if get_player_state() == " Quick Turn":
		return false
	else:
		return true

#endregion
