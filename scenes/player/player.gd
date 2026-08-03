extends CharacterBody3D
class_name Player

@onready var quick_turn_timer: Timer = $QuickTurnDuration

@export var f_move_speed: float = 4.0
@export var run_f_move_speed: float = 7.0
@export var b_move_speed: float = 3.0
@export var rotation_speed: float = 4.0
@export var gravity: float = 9.8
@export var toggle_sprint_on: bool = true

var is_sprinting: bool = false

var lock_player_input: bool = false
var lock_menu_input: bool = false

var is_quick_turning: bool = false
var quick_turn_target_y: float
var quick_turn_start_y: float

func _ready() -> void:
	GameManager.player = self

func _process(delta):
	# Interaction
	if InputManager.is_interact_pressed():
		var interactable := get_best_interactable()

		if interactable:
			interactable.interact()
	
	# Quick Turn
	if InputManager.get_quick_turn():
		is_quick_turning = true

		quick_turn_timer.start()
		quick_turn_start_y = rotation.y
		quick_turn_target_y = rotation.y + PI
	
	# Sprinting
	if not toggle_sprint_on:
		# hold sprint
		is_sprinting = InputManager.is_sprint_held()
	else:
		# toggle sprint
		is_sprinting = !is_sprinting if InputManager.is_sprint_pressed() else is_sprinting
	
	if is_quick_turning:
		# Quick Turn
		rotation.y = lerp_angle(
			quick_turn_target_y,
			quick_turn_start_y,
			quick_turn_timer.time_left / quick_turn_timer.wait_time
		)

		velocity.x = 0
		velocity.z = 0
	else:
		# Normal movment
		var turn_input = InputManager.get_player_rotation_axis()
		rotation.y -= turn_input * rotation_speed * delta
		
		var move_input = InputManager.get_player_move_axis()
		var direction = -transform.basis.z * move_input  # forward relative to player
		var true_f_move_speed: float = run_f_move_speed if is_sprinting else f_move_speed
		velocity.x = direction.x * true_f_move_speed if move_input > 0 else direction.x * b_move_speed
		velocity.z = direction.z * true_f_move_speed if move_input > 0 else direction.z * b_move_speed
	
	# Gravity
	velocity.y -= gravity * delta if not is_on_floor() else 0

	move_and_slide()

func _on_quick_turn_duration_timeout() -> void:
	is_quick_turning = false

"""
Interaction Functions
"""
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
	
	
	GameManager.ui.push_state(GameManager.ui.UIState.INTERACTING)

func stop_interaction() -> void:
	for btn in inteaction_prompt.other_btns.get_children():
		if btn.get_parent():
			btn.get_parent().remove_child(btn)
		active_interactable.other_btns.add_child(btn)
	
	
	GameManager.player.lock_player_input = false
	active_interactable = null
	GameManager.ui.pop_state()
