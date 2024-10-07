extends RigidBody2D

@export var force := 750;


func initialize(starting_position: Vector2, direction: Vector2, starting_impulse: Vector2):
	global_position = starting_position
	
	apply_impulse((direction * force) + starting_impulse)
