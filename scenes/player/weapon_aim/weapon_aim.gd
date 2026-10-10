extends Node3D
class_name WeaponAim

@onready var beam_mesh_node: Node3D = $SpringArm3D/ProjectileStart/Laser
@onready var beam_mesh: MeshInstance3D = $SpringArm3D/ProjectileStart/Laser/BeamMesh
@onready var spring_arm: SpringArm3D = $SpringArm3D/ProjectileStart/SpringArm3D

func _ready() -> void:
	hide()

func _process(_delta: float) -> void:
	beam_mesh_node.scale.z = spring_arm.get_hit_length()
