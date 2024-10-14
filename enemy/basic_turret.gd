extends Entity

var player: CharacterBody2D = null

@onready var detection_zone: Area2D = $DetectionZone
@onready var sprite: TextureRect = $Pivot/Sprite

@export var ignore_range := 1000
@export var rads_per_sec := PI;

func _ready() -> void:
	super()
	detection_zone.body_entered.connect(_on_detection_zone_entered)
	
	sprite.material.set_shader_parameter('progress', 1.0);
	on_health_changed.connect(_on_health_changed)
	on_death.connect(_on_death)
	
func _physics_process(delta: float) -> void:
	super(delta)
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

func _on_health_changed(new_health: int, max_health: int) -> void:
	sprite.material.set_shader_parameter('progress', float(new_health) / float(max_health));

func _on_death(entity: Entity):
	queue_free()
