extends Area2D
class_name Projectile


signal projectile_detonated(location: Vector2, explosion_scene: PackedScene)


@onready var lifetime: Timer = $Lifetime
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var detection_area : Area2D = $DetectionArea
@onready var trail: Trail = $Trail
@onready var trail_marker: Marker2D = $TrailMarker

@export var explosion : PackedScene
@export var eject_velocity := Vector2(0., 0.)
@export var initial_speed := 10.
@export var acceleration := Vector2.ZERO
@export var natural_acceleration := Vector2.ZERO
@export var max_speed := 1500.0
@export var steer_force = 2000.0
@export var radial_spread := 0.
@export var side_spread := 0.
@export var cooldown := .5
@export var add_host_velocity: bool = false
@export var match_rotation_to_velocity: bool = true
@export var use_trail: bool = false
@export var use_detection_area: bool = false


var velocity := Vector2.ZERO
var target: Node2D


func _ready() -> void:
	if trail != null && trail_marker != null && use_trail:
		trail.init(trail_marker)
		trail.visible = true
	connect_signals()


func connect_signals() -> void:
	#signal setup
	lifetime.timeout.connect(_on_lifetime_timeout)
	body_entered.connect(_on_body_entered)
	hurtbox.damage_dealt.connect(_on_damage_dealt)
	if detection_area != null && use_detection_area:
		detection_area.body_entered.connect(set_target)
		detection_area.area_entered.connect(set_target)

func _physics_process(delta: float) -> void:
	if target != null:
		acceleration += seek()
	else:
		acceleration += natural_acceleration.rotated(natural_acceleration.angle_to(velocity))
	velocity += acceleration * delta
	velocity = velocity.limit_length(max_speed)
	if match_rotation_to_velocity:
		rotation = velocity.angle()
	position += velocity * delta


func shoot(_global_transform: Transform2D, target: Node2D = null, host_velocity: Vector2 = Vector2.ZERO):
	global_transform = _global_transform
	rotation += randf_range(-radial_spread, radial_spread)
	var spread: Vector2 = Vector2(0., randf_range(-side_spread, side_spread))
	spread = spread.rotated(global_transform.get_rotation())
	
	position += spread
	velocity = transform.x * initial_speed
	if add_host_velocity:
		velocity += host_velocity
	velocity += eject_velocity.rotated(eject_velocity.angle_to(transform.x))
	set_target(target)

func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.global_position - global_position).normalized() * max_speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

# sets target 
func set_target(body:Node2D, overwrite: bool = false) -> void:
	if target == null || overwrite:
		if body != null && !body.get("is_dead"):
			target = body
			if target.has_signal("on_death"):	
				target.on_death.connect(release_target)	


func release_target() -> void:
	target = null


func detonate():
	projectile_detonated.emit(global_position, explosion)
	fade()


func fade() -> void:
	queue_free()


func _on_lifetime_timeout() -> void:
	detonate()


func _on_body_entered(body: Node2D) -> void:
	detonate()


func _on_damage_dealt(body: Node2D) -> void:
	if hurtbox.spent:
		detonate()


func _on_detection_zone_entered(body: Node2D) -> void:
	set_target(body)
