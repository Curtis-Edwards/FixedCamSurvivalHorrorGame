extends CharacterBody3D
class_name Player

@onready var state_machine: AnimationTree = $AnimationTree

func update_animation_params() -> void:
	state_machine["parameters/conditions/is_idle"] = true

@export var f_move_speed: float = 4.0
@export var b_move_speed: float = 3.0
@export var sprint_multiplier: float = 2.0
@export var rotation_speed: float = 4.0
@export var gravity: float = 9.8

enum PlayerState {
	NORMAL, # Idle / Sprinting / Walking Backward
	QUICK_TURNING,
	AIMING, # / Shhoting
	INTERACTING
}

var cur_player_state: PlayerState = PlayerState.NORMAL

var lock_player_input: bool = false
var lock_menu_input: bool = false

func _ready() -> void:
	#GameManager.player = self
	pass

func _process(delta):
	
	update_lock_player_input()
	
	match cur_player_state:
		PlayerState.NORMAL:
			normal_process(delta)
		PlayerState.QUICK_TURNING:
			quick_turning_process(delta)
		PlayerState.AIMING:
			aiming_process(delta)
	
	#var playback: AnimationNodeStateMachinePlayback = state_machine.get(
		#"parameters/playback"
	#)
	#print(playback.get_current_node())
	
	if velocity.dot(-transform.basis.z) > 0.0:
		state_machine["parameters/conditions/is_idle"] = false
		state_machine["parameters/conditions/is_walking"] = true
	else:
		state_machine["parameters/conditions/is_idle"] = true
		state_machine["parameters/conditions/is_walking"] = false

#region Normal State Functions

var is_sprinting: bool = false

func normal_process(delta: float) -> void:
	# Interaction
	if InputManager.is_interact_pressed():
		var interactable: Interactable = get_best_interactable()
		if interactable:
			interactable.interact()
			return
	
	# Quick Turn
	if InputManager.is_quick_turn_inputed():
		cur_player_state = PlayerState.QUICK_TURNING
		quick_turn_start_y = rotation.y
		quick_turn_target_y = rotation.y + PI
		quick_turn_timer.start()
		return
	
	# Aiming
	if InputManager.is_aim_held():
		velocity.x = 0
		velocity.z = 0
		weapon_aim.rotation.x = 0
		cur_player_state = PlayerState.AIMING
		return
	
	# Sprinting
	is_sprinting = !is_sprinting if InputManager.is_sprint_pressed() else is_sprinting
	
	rotate_player(
		InputManager.get_player_rotation_axis(),
		delta
	)
	move_player(
		InputManager.get_player_move_axis(),
		delta
	)
	# Gravity
	velocity.y -= gravity * delta if not is_on_floor() else 0.0
	
	move_and_slide()


func rotate_player(rotation_input: float, delta: float) -> void:
	rotation.y -= rotation_input * rotation_speed * delta


func move_player(move_input: float, _delta: float) -> void:
	var direction = -transform.basis.z * move_input  # forward relative to player
	var true_f_move_speed: float = f_move_speed * sprint_multiplier if is_sprinting else f_move_speed
	velocity.x = direction.x * true_f_move_speed if move_input > 0 else direction.x * b_move_speed
	velocity.z = direction.z * true_f_move_speed if move_input > 0 else direction.z * b_move_speed
#endregion


#region Quick Turn State Functions

@onready var quick_turn_timer: Timer = $QuickTurnDuration

var quick_turn_target_y: float
var quick_turn_start_y: float

func quick_turning_process(_delta: float) -> void:
	# Quick Turn
	rotation.y = lerp_angle(
		quick_turn_target_y,
		quick_turn_start_y,
		quick_turn_timer.time_left / quick_turn_timer.wait_time
	)

	velocity.x = 0
	velocity.z = 0

func _on_quick_turn_duration_timeout() -> void:
	cur_player_state = PlayerState.NORMAL
#endregion


#region Aiming State Functions

@onready var weapon_aim: Node3D = $WeaponAim
@onready var weapon_aim_decal: Decal = $WeaponAim/SpringArm3D/Decal

func aiming_process(delta: float) -> void:
	weapon_aim.show()
	
	if not InputManager.is_aim_held():
		cur_player_state = PlayerState.NORMAL
		weapon_aim.hide()
		return
	
	if InputManager.is_shoot_held():
		print("Shot!") # TODO: Make an actual shot function later
	
	rotate_player(
		InputManager.get_player_rotation_axis(),
		delta
	)
	
	rotate_aim(
		InputManager.get_player_move_axis(),
		delta
	)


func rotate_aim(rotation_input: float, delta: float) -> void:
	weapon_aim.rotation.x += rotation_input * rotation_speed * delta
	weapon_aim.rotation.x = clamp(weapon_aim.rotation.x, deg_to_rad(-60), deg_to_rad(60))
#endregion


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
	
	cur_player_state = PlayerState.INTERACTING
	GameManager.ui.push_state(GameManager.ui.UIState.INTERACTING)

func stop_interaction() -> void:
	for btn in inteaction_prompt.other_btns.get_children():
		if btn.get_parent():
			btn.get_parent().remove_child(btn)
		active_interactable.other_btns.add_child(btn)
	
	
	GameManager.player.lock_player_input = false
	active_interactable = null
	
	cur_player_state = PlayerState.NORMAL
	
	GameManager.ui.pop_state()
#endregion


#region Other

func player_state_to_str(state: PlayerState) -> String:
	match state:
		PlayerState.NORMAL:
			return "0 (IDLE)"
		PlayerState.QUICK_TURNING:
			return "1 (QUICK_TURNING)"
		PlayerState.AIMING:
			return "2 (AIMING)"
		PlayerState.INTERACTING:
			return "3 (INTERACTING)"
		_:
			return "9999 (UNKNOWN)"

func update_lock_player_input(lock_override: bool = false) -> void:
	if lock_override: # lock input regardless of PlayerState
		lock_player_input = true
		return
	
	if cur_player_state == PlayerState.NORMAL or \
	cur_player_state == PlayerState.AIMING:
		lock_player_input = false
		return
		
	if cur_player_state == PlayerState.QUICK_TURNING or \
	cur_player_state == PlayerState.INTERACTING:
		lock_player_input = true
		return


func is_state_normal() -> bool:
	return cur_player_state == PlayerState.NORMAL

func is_state_quick_turning() -> bool:
	return cur_player_state == PlayerState.QUICK_TURNING

func is_state_aiming() -> bool:
	return cur_player_state == PlayerState.AIMING

func is_state_interacting() -> bool:
	return cur_player_state == PlayerState.INTERACTING

#endregion
