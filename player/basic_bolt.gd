extends RigidBody2D


@onready var lifetime: Timer = $Lifetime

@export var force := 1500;


func initialize(starting_position: Vector2, direction: Vector2, starting_impulse: Vector2):
	global_position = starting_position
	
	apply_impulse((direction * force) + starting_impulse)
	lifetime.timeout.connect(on_lifetime_timeout)


func on_lifetime_timeout():
	queue_free()
