extends Camera3D
class_name FixedCam

var room_material: ShaderMaterial = preload("res://assets/materials/room_projection.tres")

#func get_projection_texture() -> CompressedTexture2D:
	#return background_img

func apply_projection(background_img: CompressedTexture2D):

	room_material.set_shader_parameter("projection_texture", background_img)

	var view: Transform3D = global_transform.affine_inverse()

	room_material.set_shader_parameter("projector_view", view)

	room_material.set_shader_parameter("projector_projection", get_camera_projection())

#func get_projection_matrix():
	#return get_camera_projection()
