extends Camera3D
class_name FixedCam

#var room_material: ShaderMaterial = preload("res://assets/materials/room_projection.tres")

func apply_projection(_background_img: CompressedTexture2D):
	pass
	#var view: Transform3D = global_transform.affine_inverse()
	#room_material.set_shader_parameter("projection_texture", background_img)
	#room_material.set_shader_parameter("projector_view", view)
	#room_material.set_shader_parameter("projector_projection", get_camera_projection())
