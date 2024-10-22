extends Node2D
class_name JellyShield


@onready var debug_dot: Sprite2D = $DebugDot
@onready var jelly_shield_sprite: Sprite2D = $JellyShieldSprite

@export var detection_ray_length : float = 400.
@export var detection_ray_count : float = 32.
@export var detection_ray_dead_length :  float = 100.

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
		debug_dot.visible = false
		
		add_child(ray)
		add_child(debug_dot)


func _physics_process(delta: float) -> void:
	for i in rays.size():
		update_debug_dot(i)
		
	var raw_jelly_strengths : Array = []
	var adjusted_jelly_strengths : Array = []
	var jelly_combined : Vector2 = Vector2.ZERO
	var jelly_max_strength : float = 0.;
	
	for i in rays.size():
		var ray: RayCast2D = rays[i]
		if !ray.is_colliding():
			raw_jelly_strengths.append(1.)
			adjusted_jelly_strengths.append(0.)
		else:
			var local_collision_point = to_local(ray.get_collision_point())
			var raw_strength = local_collision_point.length() / ray.target_position.length()
			var adjusted_strength = clamp(1. - (local_collision_point.length()-detection_ray_dead_length) / (ray.target_position.length()-detection_ray_dead_length), 0, 1.)
			raw_jelly_strengths.append(raw_strength)
			adjusted_jelly_strengths.append(adjusted_strength)
			jelly_combined += -ray.target_position.normalized() * adjusted_strength
	
	jelly_shield_sprite.material.set_shader_parameter('strengths', raw_jelly_strengths)
	
	jelly_vector = jelly_combined.normalized() * adjusted_jelly_strengths.max()
	debug_dot.material.set_shader_parameter('offset', jelly_vector * 300.)
	debug_dot.material.set_shader_parameter('strength', 1. - jelly_vector.length())


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
	
