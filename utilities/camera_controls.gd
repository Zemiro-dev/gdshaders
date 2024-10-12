extends Camera2D


@export var base_offset := Vector2(0, 0)
@export var look_ahead_distance := 300.0
@export var look_ahead_speed := 1.5

var player: Player

var shake_offset := Vector2.ZERO
var shake_strength := 0.0

@onready var shake_timer: Timer = $ShakeTimer


func _ready() -> void:
	offset = base_offset
	GlobalSignals.camera_shake_requested.connect(shake)


func shake(duration: float, strength: float):
	shake_timer.start(duration)
	shake_strength = strength


func _process(delta: float) -> void:
	var direction = Vector2.ZERO
	if player != null:
		direction = player.get_global_facing()
		if !player.velocity.is_zero_approx():
			direction += player.get_impulse() + (player.get_main_thrust() * player.get_global_facing())
		direction = direction.normalized()
	
	if not shake_timer.is_stopped():
		shake_offset = Vector2(
			randf_range(-1, 1) * shake_strength,
			randf_range(-1, 1) * shake_strength
		)
	else:
		shake_offset = shake_offset.lerp(Vector2.ZERO, 0.5)
	
	var look_ahead = base_offset + direction * look_ahead_distance
	offset = offset.lerp(look_ahead + shake_offset, look_ahead_speed * delta)
