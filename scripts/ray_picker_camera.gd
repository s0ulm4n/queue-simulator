class_name RayPickerCamera
extends Camera3D

@onready var ray_caster: RayCast3D = $RayCast3D

## The point of collision between a ray we cast from the camera and the paper
var collision_point: Vector3

func _process(_delta: float) -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	ray_caster.target_position = project_local_ray_normal(mouse_pos) * 100.0
	ray_caster.force_raycast_update()
	
	if ray_caster.is_colliding():
		# There's only one object in this scene the ray can collide with, 
		# so no need to check what it is.
		collision_point = ray_caster.get_collision_point()
