extends CharacterBody3D
class_name Player

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

@export var gravity: float = 9.8

enum PlayerState {
	IDLE,
	MOVING_FORWARD,
	MOVING_BACKWARD,
	AIMING,
	QUICK_TURNING,
	INTERACTING
}

var current_state: PlayerState = PlayerState.IDLE


func _ready() -> void:
	GameManager.player = self

func _physics_process(delta: float) -> void:
	match current_state:
		PlayerState.IDLE:
			idle_state(delta)
		PlayerState.MOVING_FORWARD:
			moving_forward_state(delta)
		PlayerState.MOVING_BACKWARD:
			moving_backward_state(delta)
		PlayerState.AIMING:
			aiming_state(delta)
		PlayerState.QUICK_TURNING:
			quick_turning_state(delta)
		PlayerState.INTERACTING:
			interacting_state(delta)
		_:
			push_error("Err: State not found.")
	
	move_and_slide()


func change_state(new_state: PlayerState) -> void:
	current_state = new_state
	
	match new_state:
		PlayerState.IDLE:
			animation_state_machine.travel("Idle")
		PlayerState.MOVING_FORWARD:
			animation_state_machine.travel("Moving Forward")
		PlayerState.MOVING_BACKWARD:
			animation_state_machine.travel("Moving Backward")
		PlayerState.AIMING:
			weapon_aim.show()
			weapon_aim.rotation.x = 0.0
			animation_state_machine.travel("Aiming")
		PlayerState.QUICK_TURNING:
			quick_turn_start_y = rotation.y
			quick_turn_target_y = rotation.y + PI
			quick_turn_progress = 0.0
			animation_state_machine.travel("Quick Turning")
		PlayerState.INTERACTING:
			animation_state_machine.travel("Interacting")
		_:
			push_error("Err: State not found.")
#region Player State

#region IDLE

@export var rotation_speed: float = 4.0

func idle_state(delta: float) -> void:
	var move_axis: float = InputManager.get_player_move_axis()
	var rotation_axis: float = InputManager.get_player_rotation_axis()
	
	if InputManager.is_interact_pressed():
		var interactable: Interactable = get_best_interactable()
		if interactable:
			interactable.interact()
			return
	
	if InputManager.is_aim_held():
		change_state(PlayerState.AIMING)
		return
	
	if move_axis < 0.0:
		change_state(PlayerState.MOVING_BACKWARD)
		return
	
	if move_axis > 0.0:
		change_state(PlayerState.MOVING_FORWARD)
		return
	
	velocity.x = 0
	velocity.z = 0
	rotation.y -= rotation_axis * rotation_speed * delta
	
	velocity.y -= gravity * delta if not is_on_floor() else 0.0
	
#endregion

#region MOVING_FORWARD

@export var forward_speed: float = 4.0
@export var sprinting_speed: float = 6.0

func moving_forward_state(delta: float) -> void:
	var move_axis: float = InputManager.get_player_move_axis()
	var rotation_axis: float = InputManager.get_player_rotation_axis()
	
	if InputManager.is_interact_pressed():
		var interactable: Interactable = get_best_interactable()
		if interactable:
			interactable.interact()
			return
	
	if InputManager.is_aim_held():
		change_state(PlayerState.AIMING)
		return
	
	if move_axis == 0.0:
		change_state(PlayerState.IDLE)
		return
	if move_axis < 0.0:
		change_state(PlayerState.MOVING_BACKWARD)
		return
	
	var move_speed: float = forward_speed
	
	if InputManager.is_sprint_inputed():
		move_speed = sprinting_speed
		animation_tree["parameters/conditions/is_sprinting"] = true
		animation_tree["parameters/conditions/not_sprinting"] = false
	else:
		move_speed = forward_speed
		animation_tree["parameters/conditions/is_sprinting"] = false
		animation_tree["parameters/conditions/not_sprinting"] = true
	
	velocity.x = (-transform.basis.z * move_axis).x * move_speed
	velocity.z = (-transform.basis.z * move_axis).z * move_speed
	rotation.y -= rotation_axis * rotation_speed * delta
	
	velocity.y -= gravity * delta if not is_on_floor() else 0.0

#endregion

#region MOVING_BACKWARD

@export var backward_speed: float = 3.0

func moving_backward_state(delta: float) -> void:
	var move_axis: float = InputManager.get_player_move_axis()
	var rotation_axis: float = InputManager.get_player_rotation_axis()
	
	if InputManager.is_interact_pressed():
		var interactable: Interactable = get_best_interactable()
		if interactable:
			interactable.interact()
			return
	
	if InputManager.is_aim_held():
		change_state(PlayerState.AIMING)
		return
	
	if InputManager.is_quick_turn_inputed():
		change_state(PlayerState.QUICK_TURNING)
		return
	
	if move_axis == 0.0:
		change_state(PlayerState.IDLE)
		return
	if move_axis > 0.0:
		change_state(PlayerState.MOVING_BACKWARD)
		return
	
	velocity.x = (-transform.basis.z * move_axis).x * backward_speed
	velocity.z = (-transform.basis.z * move_axis).z * backward_speed
	rotation.y -= rotation_axis * rotation_speed * delta
	
	velocity.y -= gravity * delta if not is_on_floor() else 0.0

#endregion

#region AIMING

@onready var weapon_aim: Node3D = $WeaponAim

@export var max_aim_angle: float = 60
@export var aim_rotation_speed: float = 3.0

func aiming_state(delta: float) -> void:
	var move_axis: float = InputManager.get_player_move_axis()
	var rotation_axis: float = InputManager.get_player_rotation_axis()
	
	if not InputManager.is_aim_held():
		weapon_aim.hide()
		change_state(PlayerState.IDLE)
		return
	
	if InputManager.is_shoot_held():
		print("Shoot!")
	
	velocity.x = 0
	velocity.z = 0
	
	weapon_aim.rotation.x += move_axis * aim_rotation_speed * delta
	weapon_aim.rotation.x = clamp(weapon_aim.rotation.x, deg_to_rad(-max_aim_angle), deg_to_rad(max_aim_angle))
	rotation.y -= rotation_axis * aim_rotation_speed * delta
	
	velocity.y -= gravity * delta if not is_on_floor() else 0.0

#endregion

#region QUICK_TURNING

var quick_turn_target_y: float
var quick_turn_start_y: float

var quick_turn_progress: float = 0.0
var quick_turn_duration: float = 0.4

func quick_turning_state(delta: float) -> void:
	quick_turn_progress += delta / quick_turn_duration
	rotation.y = lerp_angle(
		quick_turn_start_y,
		quick_turn_target_y,
		quick_turn_progress / quick_turn_duration
	)
	
	velocity.x = 0
	velocity.z = 0
	
	velocity.y -= gravity * delta if not is_on_floor() else 0.0
	
	if quick_turn_progress >= quick_turn_duration:
		change_state(PlayerState.IDLE)

#endregion

#region INTERACTING

func interacting_state(delta: float) -> void:
	velocity.x = 0
	velocity.z = 0
	
	velocity.y -= gravity * delta if not is_on_floor() else 0.0


@onready var interaction_area: Area3D = $InteractionStuff/InteractionArea

var nearby_interactables: Array[Interactable] = []

func _on_interaction_area_area_entered(area: Area3D) -> void:
	var interactable: Interactable = area.get_parent()
	nearby_interactables.append(interactable)
	interactable.entered_interactable()

func _on_interaction_area_area_exited(area: Area3D) -> void:
	var interactable: Interactable = area.get_parent()
	nearby_interactables.erase(area.get_parent())
	interactable.exited_interactable()

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
	#GameManager.player.lock_player_input = true
	
	for btn in active_interactable.other_btns.get_children():
		if btn.get_parent():
			btn.get_parent().remove_child(btn)
		inteaction_prompt.other_btns.add_child(btn)
	
	change_state(PlayerState.INTERACTING)
	GameManager.ui.push_state(GameManager.ui.UIState.INTERACTING)

func stop_interaction() -> void:
	for btn in inteaction_prompt.other_btns.get_children():
		if btn.get_parent():
			btn.get_parent().remove_child(btn)
		active_interactable.other_btns.add_child(btn)
	
	
	#GameManager.player.lock_player_input = false
	active_interactable = null

	change_state(PlayerState.IDLE)
	
	GameManager.ui.pop_state()


#endregion

#endregion

#func 

#region Other

func get_player_state() -> String:
	return animation_state_machine.get_current_node()

func is_player_input_locked() -> bool:
	return false

#endregion
