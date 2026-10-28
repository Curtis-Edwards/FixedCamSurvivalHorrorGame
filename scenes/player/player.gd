extends CharacterBody3D
class_name Player

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var weapon_aim: Node3D = $WeaponAim

@export var walk_f_speed: float = 3.0
@export var walk_b_speed: float = 2.0
@export var sprint_speed: float = 6.0

@export var max_aim_angle: float = 60

@export var non_aim_rotation_speed: float = 4.0
@export var aim_rotation_speed: float = 3.0

@export var gravity: float = 9.8

var player_move_axis_input: float = 0.0
var player_rotaion_axis_input: float = 0.0
var player_sprint_input: bool = false
var player_aim_input: bool = false
var player_shoot_input: bool = false
var player_interact_input: bool = false
var player_quick_turn_input: bool = false

enum PlayerState {
	IDLE,
	MOVING,
	AIMING,
	QUICK_TURNING,
	#INTERACTING,
}

var current_state: PlayerState = PlayerState.IDLE

func _ready() -> void:
	GameManager.player = self

func _physics_process(delta: float) -> void:
	get_player_input()
	handle_events()
	
	var move_speed: float = get_move_speed()
	var rotation_speed: float = get_rotation_speed()
	
	if current_state in [PlayerState.AIMING]:
		pass
	else:
		pass
	
	if (current_state in [PlayerState.IDLE, PlayerState.MOVING, PlayerState.AIMING]):
		velocity.x = (-transform.basis.z * player_move_axis_input).x * move_speed
		velocity.z = (-transform.basis.z * player_move_axis_input).z * move_speed
		rotation.y -= player_rotaion_axis_input * rotation_speed * delta
	else:
		velocity.x = 0.0
		velocity.z = 0.0
	
	velocity.y -= gravity * delta if not is_on_floor() else 0.0
	move_and_slide()

"""
Input Functions 
"""
func get_player_input() -> void:
	player_move_axis_input = InputManager.get_player_move_axis()
	player_rotaion_axis_input = InputManager.get_player_rotation_axis()
	player_sprint_input = InputManager.is_sprint_inputed()
	player_aim_input = InputManager.is_aim_inputed()
	player_shoot_input = InputManager.is_shoot_held()
	player_interact_input = InputManager.is_interact_pressed()
	player_quick_turn_input = InputManager.is_quick_turn_inputed()

func get_move_speed() -> float:
	if current_state not in [PlayerState.IDLE, PlayerState.MOVING]:
		return 0.0
	
	if player_move_axis_input == 0.0:
		return 0.0
	elif player_move_axis_input < 0.0:
		return walk_b_speed
	else: 
		if player_sprint_input:
			return sprint_speed
		else:
			return walk_f_speed

func get_rotation_speed() -> float:
	if current_state not in [PlayerState.IDLE, PlayerState.MOVING, PlayerState.AIMING]:
		return 0.0
	
	if player_aim_input:
		return aim_rotation_speed
	else:
		return non_aim_rotation_speed

"""
Player State Functions 
"""
func handle_events() -> void:
	# Interact
	if (current_state in [PlayerState.IDLE, PlayerState.MOVING]) and \
	player_interact_input:
		on_interaction()
		return
	
	# Aiming
	#if (current_state in [PlayerState.IDLE, PlayerState.MOVING, PlayerState.AIMING]) and \
	#player_aim_input:
		#if current_state != PlayerState.AIMING:
			#pass # Go to AIMING
			#return
		#else:
			#return
	
	# Quick Turn
	if (current_state in [PlayerState.IDLE, PlayerState.MOVING]) and \
	player_quick_turn_input:
		start_quick_turn()
		return

func change_state(new_state: PlayerState) -> void:
	var _prev_state: PlayerState = current_state
	current_state = new_state

"""
Quick Turn Functions
"""

func start_quick_turn() -> void:
	change_state(PlayerState.QUICK_TURNING)
	rotation.y += PI
	animation_player.play("quick_turn")

func end_quick_turn() -> void:
	change_state(PlayerState.IDLE)

"""
Interaction Functions
"""
@onready var interaction_area: Area3D = $InteractionStuff/InteractionArea

var nearby_interactables: Array[InteractionComponent] = []

func _on_interaction_area_area_entered(area: Area3D) -> void:
	var interactable = area as InteractionComponent
	if interactable:
		nearby_interactables.append(interactable)

func _on_interaction_area_area_exited(area: Area3D) -> void:
	var interactable = area as InteractionComponent
	if interactable:
		nearby_interactables.erase(interactable)

func get_best_interactable() -> InteractionComponent:
	if nearby_interactables.is_empty():
		return null

	var closest: InteractionComponent = nearby_interactables[0]
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
#
#
#@onready var inteaction_prompt: InteractionPrompt = $InteractionStuff/InteractionPrompt
#
#var active_interactable: Interactable = null
#
#func start_interaction(interactable: Interactable) -> void:
	#if not interactable:
		#return
	#
	#active_interactable = interactable
	##GameManager.player.lock_player_input = true
	#
	#for btn in active_interactable.other_btns.get_children():
		#if btn.get_parent():
			#btn.get_parent().remove_child(btn)
		#inteaction_prompt.other_btns.add_child(btn)
	#
	#change_state(PlayerState.INTERACTING)
	#GameManager.ui.push_state(GameManager.ui.UIState.INTERACTING)
#
#func stop_interaction() -> void:
	#for btn in inteaction_prompt.other_btns.get_children():
		#if btn.get_parent():
			#btn.get_parent().remove_child(btn)
		#active_interactable.other_btns.add_child(btn)
	#
	#
	##GameManager.player.lock_player_input = false
	#active_interactable = null
#
	#change_state(PlayerState.IDLE)
	#
	#GameManager.ui.pop_state()

func on_interaction() -> void:
		var interactable: InteractionComponent = get_best_interactable()
		if interactable:
			interactable.interact.emit()


func is_player_input_locked() -> bool:
	return not GameManager.ui.get_current_state() == GameUI.UIState.CLOSED
