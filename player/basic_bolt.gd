extends Area2D


var target: CharacterBody2D = null;

@onready var detection_zone: Area2D = $DetectionZone
@onready var lifetime: Timer = $Lifetime

@export var eject_velocity := Vector2(0.0, -1500.0)
@export var acceleration := Vector2.ZERO
@export var max_speed := 1500.0
@export var steer_force = 20000.0

var velocity := Vector2.ZERO

func shoot(_global_transform):
	global_transform = _global_transform
	velocity = eject_velocity.rotated(eject_velocity.angle_to(-transform.y))
	
	#ttl
	lifetime.timeout.connect(_on_lifetime_timeout)
	detection_zone.body_entered.connect(_on_detection_zone_entered)
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if target != null:
		pass
	
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.limit_length(max_speed)
	rotation = velocity.angle()
	position += velocity * delta

func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * max_speed
		steer = (desired - velocity).normalized() * steer_force
	return steer


func _on_lifetime_timeout():
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	queue_free()


func _on_detection_zone_entered(body: Node2D) -> void:
	target = body;
