extends CharacterBody2D


@export var impulse_acceleration: float = 300.0
@export var impulse_break: float = impulse_acceleration;
@export var main_thrust_acceleration: float = 1000.0
const ANGULAR_SPEED := PI;
const MAX_SPEED := 2000.0;


func _physics_process(delta: float) -> void:
	var impulse: Vector2 = get_impulse()
	var main_thrust: Vector2 = get_main_thrust()
	if not impulse.is_zero_approx() or not main_thrust.is_zero_approx():
		var impulse_reverse_multiplier: float = 2 if abs(impulse.angle_to(velocity)) > PI / 2 else 1
		print(impulse_reverse_multiplier)
		velocity += impulse * impulse_acceleration * delta * impulse_reverse_multiplier
		velocity += main_thrust * main_thrust_acceleration * delta
	else:
		if velocity.length() < (impulse_break * delta):
			velocity = Vector2.ZERO
		else:
			var normalized_velocity = velocity.normalized()
			normalized_velocity *= - (impulse_break * delta)
			velocity += normalized_velocity
		
	var rotation : float = delta * ANGULAR_SPEED * get_rotation_impulse()
	rotate(rotation);
	
	velocity = velocity.min(Vector2(MAX_SPEED, MAX_SPEED)).max(Vector2(-MAX_SPEED, -MAX_SPEED))

	move_and_slide()


func get_rotation_impulse() -> float:
	return Input.get_axis("rotate_ccw", "rotate_cw");


func get_impulse() -> Vector2:
	return Vector2(Input.get_axis("impulse_left", "impulse_right"), Input.get_axis("impulse_up", "impulse_down"));

func get_main_thrust() -> Vector2:
	return Vector2.from_angle(rotation - PI/2.0) * Input.get_action_strength("main_thrust")
