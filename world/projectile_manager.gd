extends Node


func _ready() -> void:
	GlobalSignals.projectile_spawn_requested.connect(spawn_projectile)
	var children: Array[Node] = get_children()
	for i in children.size():
		if children[i] is Projectile:
			var child_projectile: Projectile = children[i]
			child_projectile.projectile_detonated.connect(_on_projectile_collided)


func spawn_projectile(projectile: Projectile):
	projectile.projectile_detonated.connect(_on_projectile_collided)
	add_child(projectile)	


func _on_projectile_collided(location: Vector2, explosion_scene: PackedScene):
	if explosion_scene != null:
		var explosion = explosion_scene.instantiate()
		explosion.global_position = location
		add_child(explosion)
