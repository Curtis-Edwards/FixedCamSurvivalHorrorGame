extends Control
class_name DevPanel


const GREEN_COL: Color = Color(0.0, 1.0, 0.017, 1.0)
const RED_COL: Color = Color(1.0, 0.0, 0.0, 1.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.dev_panel = self
	self.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_general_labels()
	
	if InputManager.is_debug_key9_pressed():
		self.visible = !self.visible
	

	color_label_for_pressed(
		InputManager.is_interact_pressed(),
		interaction_label
	)
	
	color_label_for_pressed(
		InputManager.is_quick_turn_inputed(),
		quick_turn_label
	)
	
	color_label_for_pressed(
		InputManager.is_quick_turn_inputed(),
		quick_turn_label
	)
	
	color_label_for_pressed(
		InputManager.is_sprint_pressed(),
		sprint_pressed_label
	)
	
	color_label_for_held(
		InputManager.is_sprint_held(),
		sprint_held_label
	)
	
	color_label_for_pressed(
		InputManager.is_aim_pressed(),
		aim_pressed_label
	)
	
	color_label_for_held(
		InputManager.is_aim_held(),
		aim_held_label
	)
	
	color_label_for_pressed(
		InputManager.is_shoot_held(),
		shoot_label
	)
	
	
	color_label_for_pressed(
		InputManager.is_accept_pressed(),
		confirm_label
	)
	
	color_label_for_pressed(
		InputManager.is_cancel_pressed(),
		cancel_label
	)
	
	color_label_for_pressed(
		InputManager.is_inventory_pressed(),
		inventory_label
	)
	
	color_label_for_pressed(
		InputManager.is_map_pressed(),
		map_label
	)
	
	color_label_for_pressed(
		InputManager.is_notes_pressed(),
		notes_label
	)
	
	color_label_for_pressed(
		InputManager.is_paused_pressed(),
		pause_label
	)
	

#region Input Functions

@onready var interaction_label: Label = $Inputs/InputLabels/HBox/VBox1/Interact
@onready var quick_turn_label: Label = $Inputs/InputLabels/HBox/VBox1/QuickTurn
@onready var sprint_pressed_label: Label = $Inputs/InputLabels/HBox/VBox1/SprintPressed
@onready var sprint_held_label: Label = $Inputs/InputLabels/HBox/VBox1/SprintHeld
@onready var aim_pressed_label: Label = $Inputs/InputLabels/HBox/VBox1/AimPressed
@onready var aim_held_label: Label = $Inputs/InputLabels/HBox/VBox1/AimHeld
@onready var shoot_label: Label = $Inputs/InputLabels/HBox/VBox1/Shoot

@onready var confirm_label: Label = $Inputs/InputLabels/HBox/VBox2/Confirm
@onready var cancel_label: Label = $Inputs/InputLabels/HBox/VBox2/Cancel
@onready var inventory_label: Label = $Inputs/InputLabels/HBox/VBox2/Inventory
@onready var map_label: Label = $Inputs/InputLabels/HBox/VBox2/Map
@onready var notes_label: Label = $Inputs/InputLabels/HBox/VBox2/Notes
@onready var pause_label: Label = $Inputs/InputLabels/HBox/VBox2/Pause

func color_label_for_held(input_event: bool, label: Label) -> void:
	if input_event:
		label.modulate = GREEN_COL
	else:
		label.modulate = RED_COL

func color_label_for_pressed(input_event: bool, label: Label) -> void:
	if input_event:
		label.modulate = GREEN_COL
	else:
		label.modulate = lerp(
			label.modulate,
			RED_COL,
			0.1
		)

#endregion



#region General Functions

@onready var ui_state_label: Label = $General/DebugLabels/UIStateLabel
@onready var player_state_label: Label = $General/DebugLabels/PlayerStateLabel
@onready var fps_label: Label = $General/DebugLabels/FPSLabel


func update_general_labels() -> void:
	fps_label.text = str(Engine.get_frames_per_second()) + " FPS"
	ui_state_label.text = GameManager.ui.ui_state_to_str(GameManager.ui.get_current_state())
	player_state_label.text = GameManager.player.get_player_state()
#endregion
