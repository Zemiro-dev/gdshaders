extends Node2D
class_name JellyShield


@onready var debug_dot: Sprite2D = $DebugDot
@onready var jelly_shield_sprite: Sprite2D = $JellyShieldSprite

@export var detection_ray_length : float = 400.
@export var detection_ray_count : float = 32.
@export var detection_ray_dead_length :  float = 100.
@export var max_jelly_strength : float = 700.

var rays: Array = []
var debug_dots: Array = []

var jelly_vector: Vector2 = Vector2.ZERO

var debug_dot_scene = preload("res://debug/debug_dot.tscn")


func _ready() -> void:
	var theta_step : float = 2. * PI / detection_ray_count
	for i in range(detection_ray_count):
		var theta : float = i * theta_step
		var x = detection_ray_length * cos(theta)
		var y = detection_ray_length * sin(theta)
		
		var ray : RayCast2D = RayCast2D.new()
		ray.target_position = Vector2(x, y)
		var debug_dot = debug_dot_scene.instantiate()
		rays.append(ray)
		debug_dots.append(debug_dot)
		
		add_child(ray)
		add_child(debug_dot)


func _physics_process(delta: float) -> void:
	for i in rays.size():
		update_debug_dot(i)
		
	var jelly_strengths : Array = get_jelly_strengths(rays)
	jelly_shield_sprite.material.set_shader_parameter('strengths', jelly_strengths)
	var _jelly_vector : Vector2 = get_jelly_combined_weighted_normal(rays)
	debug_dot.material.set_shader_parameter('offset', _jelly_vector * max_jelly_strength / 3.)
	debug_dot.material.set_shader_parameter('strength', 1.)
	jelly_vector = _jelly_vector * max_jelly_strength


func get_jelly_strengths(rays) -> Array:
	var jelly_strengths = []
	for i in rays.size():
		var ray: RayCast2D = rays[i];
		if !ray.is_colliding():
			jelly_strengths.append(1.)
		else:
			var local_collision_point = to_local(ray.get_collision_point())
			var strength = local_collision_point.length() / ray.target_position.length()
			jelly_strengths.append(strength)
	return jelly_strengths


func get_jelly_combined_weighted_normal(rays) -> Vector2:
	var jelly_combined_weighted_normal = Vector2.ZERO
	for i in rays.size():
		var ray: RayCast2D = rays[i];
		var jelly_weight_normal = get_jelly_weighted_normal(ray)
		jelly_combined_weighted_normal += jelly_weight_normal
	if jelly_combined_weighted_normal.length() > 1.:
		jelly_combined_weighted_normal = jelly_combined_weighted_normal.normalized()
	return jelly_combined_weighted_normal


func get_jelly_weighted_normal(ray: RayCast2D) -> Vector2:
	if !ray.is_colliding():
		return Vector2.ZERO
	
	var local_collision_point = to_local(ray.get_collision_point())
	var strength = clamp(1. - (local_collision_point.length()-detection_ray_dead_length) / (ray.target_position.length()-detection_ray_dead_length), 0, 1.)
	return -ray.target_position.normalized() * strength


func update_debug_dot(index: int) -> void:
	var ray: RayCast2D = rays[index];
	var dot: Sprite2D = debug_dots[index];
	if ray.is_colliding():
		var local_collision_point = to_local(ray.get_collision_point())
		var strength = clamp(1. - (local_collision_point.length()-detection_ray_dead_length) / (ray.target_position.length()-detection_ray_dead_length), 0, 1.)
		dot.material.set_shader_parameter('offset', local_collision_point)
		dot.material.set_shader_parameter('strength', 1. - strength)
	else:
		dot.material.set_shader_parameter('offset', ray.target_position)
		dot.material.set_shader_parameter('strength', 1.)
	
