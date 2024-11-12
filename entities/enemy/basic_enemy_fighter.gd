extends Entity


@onready var radar: Area2D = $Radar
@onready var rays: Node2D = $Rays


@export var target_distance: float = 512.
@export var strafe_distance: float = 128.
@export var chase_grav: float = 500.
@export var wall_avoid_grav: float = 500.
@export var max_speed: float = 500.
@export var ray_rotation_speed: float = TAU * 6.

var player: Player = null


func _ready() -> void:
	super()
	radar.body_entered.connect(_on_radar_entered)


func _physics_process(delta: float) -> void:
	if player != null:
		look_at(player.global_position)
		var vec_to_player: Vector2 = (player.global_position - global_position)
		var distance_to_player: float = vec_to_player.length()
		var player_grav : Vector2 = vec_to_player.normalized() * chase_grav * delta
		if distance_to_player < target_distance:
			player_grav *= -1
		if abs(distance_to_player - target_distance) < strafe_distance:
			var strafe_direction_mod: float = 1. if randf() < .5 else -1.
			var strafe_vec = player_grav.rotated(PI/2.) * strafe_direction_mod
			player_grav *= .25 #reduce speed within band
			player_grav += strafe_vec
		
		velocity += player_grav
	
		#find walls
		var closest_collision = null
		rays.rotation += delta * ray_rotation_speed
		for ray in rays.get_children():
			if ray.is_colliding():
				var collision_point: Vector2 = ray.get_collision_point() - global_position
				var avoidance_vec: Vector2 = -collision_point.normalized()
				velocity += avoidance_vec * wall_avoid_grav * delta
		if velocity.length() > max_speed:
			velocity = velocity.normalized() * max_speed
	move_and_slide()


func _on_radar_entered(body: Node2D) -> void:
	if body is Player:
		player = body
