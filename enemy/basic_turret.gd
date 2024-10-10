extends CharacterBody2D

var player: CharacterBody2D = null

@onready var detection_zone: Area2D = $DetectionZone

@export var ignore_range := 1000
@export var rads_per_sec := PI;

func _ready() -> void:
	detection_zone.body_entered.connect(_on_detection_zone_entered)
	
func _physics_process(delta: float) -> void:
	if player != null:
		var distance = global_position.distance_to(player.global_position)
		if distance > ignore_range:
			player = null
		else:
			var target_angle = player.global_position.direction_to(global_position).angle()
			var facing_angle = get_facing().angle()
			var rotation_speed = rads_per_sec * delta
			var new_rotation = rotate_toward(facing_angle, target_angle, rotation_speed)
			rotation = new_rotation - PI/2.0 #reset to x axis
	move_and_slide()


func _on_detection_zone_entered(body: Node2D) -> void:
	player = body;
	
func get_facing() -> Vector2:
	return Vector2.from_angle(rotation + PI/2.0)
