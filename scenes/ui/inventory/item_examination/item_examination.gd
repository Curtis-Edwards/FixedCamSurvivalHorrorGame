extends Node
class_name ItemExamination

var input_rotation_speed: float = 180.0
var idle_rotation_speed: float = 90.0
var reset_speed: float = 450.0
var zoom_speed: float = 10.0

var vertical_min: float = -90.0
var vertical_max: float = 90.0

var zoomed_in_val: float = 4.0
var zoomed_out_val: float = 7.0

@onready var camera: Camera3D = $Camera3D
@onready var item: Node3D = $Item

var is_idle: bool = true
var zoomed_in: bool = false
var is_reseting: bool = false


func _ready() -> void:
	camera.position.z = zoomed_out_val
	camera.current = true


func _process(delta):
	#zoomed_in = not zoomed_in if InputManager.is_inv_input_1_pressed() else zoomed_in
	var horizontal_magnitude = InputManager.get_horizontal_axis()
	var vertical_magnitude = InputManager.get_vertical_axis()
	
	if is_reseting:
		zoomed_in = false
		reset_rotation(reset_speed, delta)
		camera_zoom(zoomed_out_val, delta)
	elif is_idle:
		zoomed_in = false
		camera_zoom(get_zoom_value(), delta)
		rotate_item_horizontal(-1.0, idle_rotation_speed, delta)
		rotate_item_vertical(0.0, idle_rotation_speed, delta)
	else:
		camera_zoom(get_zoom_value(), delta)
		rotate_item_horizontal(horizontal_magnitude, input_rotation_speed, delta)
		rotate_item_vertical(vertical_magnitude, input_rotation_speed, delta)


func get_zoom_value() -> float:
	if zoomed_in:
		return zoomed_in_val
	else:
		return zoomed_out_val


func camera_zoom(zoom_value: float, delta: float) -> void:
	camera.position.z = lerp(
		camera.position.z,
		zoom_value,
		1.0 - exp(-zoom_speed * delta)
	)

func rotate_item_horizontal(magnitude: float, speed: float, delta: float) -> void:
	item.rotation.y -= magnitude * deg_to_rad(speed) * delta
	item.rotation.y = wrapf(item.rotation.y, -PI, PI)

func rotate_item_vertical(magnitude: float, speed: float, delta: float) -> void:
	item.rotation.x -= magnitude * deg_to_rad(speed) * delta
	item.rotation.x = clamp(item.rotation.x, deg_to_rad(vertical_min), deg_to_rad(vertical_max))

func reset_rotation(speed: float, delta: float) -> void:
	item.rotation.x = move_toward(item.rotation.x, 0.0, deg_to_rad(speed) * delta)
	item.rotation.y = move_toward(item.rotation.y, 0.0, deg_to_rad(speed) * delta)
	
	is_reseting = false if not item.rotation.x and not item.rotation.y else is_reseting
