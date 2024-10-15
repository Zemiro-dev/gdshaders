extends Area2D
class_name Projectile


@onready var lifetime: Timer = $Lifetime
@onready var hurtbox: Hurtbox = $Hurtbox

@export var eject_velocity := Vector2(0.0, -1500.0)
@export var acceleration := Vector2.ZERO
@export var max_speed := 1500.0
@export var spread := 0.
@export var cooldown := .1

var velocity := Vector2.ZERO


func shoot(_global_transform):
	global_transform = _global_transform
	velocity = eject_velocity.rotated(eject_velocity.angle_to(-transform.y)).rotated((randf() * spread) - spread / 2)
	
	#ttl
	lifetime.timeout.connect(_on_lifetime_timeout)
	body_entered.connect(_on_body_entered)
	hurtbox.damage_dealt.connect(_on_damage_dealt)


func _physics_process(delta: float) -> void:
	velocity += acceleration * delta
	velocity = velocity.limit_length(max_speed)
	rotation = velocity.angle() + PI/2.0;
	position += velocity * delta


func fade():
	queue_free()

func _on_lifetime_timeout():
	fade()


func _on_body_entered(body: Node2D) -> void:
	fade()


func _on_damage_dealt(body: Node2D) -> void:
	fade()
