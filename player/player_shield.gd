extends Node2D


@onready var rays: Array = [
	$RayX, $RayY, $RayNegX, $RayNegY
]

@onready var debug_dots: Array = [
	$DebugDotX, $DebugDotY, $DebugDotNegX, $DebugDotNegY
]


func _physics_process(delta: float) -> void:
	for i in rays.size():
		update_debug_dot(i)

func update_debug_dot(index: int) -> void:
	var ray: RayCast2D = rays[index];
	var dot: Sprite2D = debug_dots[index];
	if ray.is_colliding():
		var local_collision_point = to_local(ray.get_collision_point())
		var strength = 1. - local_collision_point.length() / ray.target_position.length()
		dot.material.set_shader_parameter('offset', local_collision_point)
		dot.material.set_shader_parameter('strength', 1. - strength)
	else:
		dot.material.set_shader_parameter('offset', ray.target_position)
		dot.material.set_shader_parameter('strength', 1.)
	
