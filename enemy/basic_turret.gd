extends Entity

var player: CharacterBody2D = null

@onready var detection_zone: Area2D = $DetectionZone
@onready var sprite: TextureRect = $Pivot/Sprite
@onready var main_cannon_marker: Marker2D = $Pivot/MainCannonMarker

@export var ignore_range := 1000
@export var rads_per_sec := PI;
@export var shoot_angle_threshold := .1;

var primary_weapon_cooldown := 0.0

var red_orb = preload("res://entities/projectiles/red_orb.tscn")


func _ready() -> void:
	super()
	detection_zone.body_entered.connect(_on_detection_zone_entered)
	
	sprite.material.set_shader_parameter('progress', 1.0);
	on_health_changed.connect(_on_health_changed)
	on_death.connect(_on_death)
	
func _physics_process(delta: float) -> void:
	super(delta)
	if is_dead: 
		return
		
	if player != null:
		var distance = global_position.distance_to(player.global_position)
		if distance > ignore_range:
			player = null
		else:
			var angle_to_target := global_position.direction_to(player.global_position).angle()
			var facing_angle := get_global_facing().angle()
			var new_rotation = rotate_toward(facing_angle, angle_to_target, rads_per_sec * delta)
			shoot()
			rotation = new_rotation + PI/2.;
	
	if primary_weapon_cooldown > 0.0:
		primary_weapon_cooldown -= delta
	move_and_slide()


func shoot() -> void:
	if player == null or primary_weapon_cooldown > 0.0:
		return
	else:
		var angle_to_target := global_position.direction_to(player.global_position).angle()
		var facing_angle := get_global_facing().angle()
		
		if abs(angle_to_target - facing_angle) < shoot_angle_threshold:
			var red_orb_instance = red_orb.instantiate()
			primary_weapon_cooldown = red_orb_instance.cooldown
			get_tree().root.add_child(red_orb_instance)
			red_orb_instance.shoot(main_cannon_marker.global_transform)


func _on_detection_zone_entered(body: Node2D) -> void:
	player = body;


func get_facing() -> Vector2:
	return Vector2.from_angle(rotation + PI/2.0)

func get_global_facing() -> Vector2:
	return -global_transform.y

func _on_health_changed(new_health: int, max_health: int) -> void:
	sprite.material.set_shader_parameter('progress', float(new_health) / float(max_health));

func _on_death(entity: Entity):
	sprite.material.set_shader_parameter('is_grayscale', true);
