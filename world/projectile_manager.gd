extends Node


func _ready() -> void:
	GlobalSignals.projectile_spawn_requested.connect(spawn_projectile)


func spawn_projectile(projectile: Projectile):
	projectile.projectile_detonated.connect(_on_projectile_collided)
	add_child(projectile)	


func _on_projectile_collided(location: Vector2, explosion_scene: PackedScene):
	if explosion_scene != null:
		var explosion = explosion_scene.instantiate()
		explosion.global_position = location
		add_child(explosion)
