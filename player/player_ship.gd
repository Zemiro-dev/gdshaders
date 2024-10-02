extends CharacterBody2D


const SPEED = 300.0
const ANGULAR_SPEED := PI;


func _physics_process(delta: float) -> void:
	velocity = get_impulse() * SPEED;
	var rotation : float = delta * ANGULAR_SPEED * get_rotation_impulse();
	rotate(rotation);

	move_and_slide()


func get_rotation_impulse() -> float:
	return Input.get_axis("rotate_ccw", "rotate_cw");


func get_impulse() -> Vector2:
	return Vector2(Input.get_axis("impulse_left", "impulse_right"), Input.get_axis("impulse_up", "impulse_down"));
