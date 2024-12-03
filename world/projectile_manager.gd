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
		

#var torch = preload("res://entities/archaeologist/torch.tscn")
#var torch_flames  = preload("res://entities/archaeologist/flames.tscn")
#var sword = preload("res://entities/henchman/sword.tscn")
#
#func initialize(enemies: Array[Node]):
	#for enemy in enemies:
		#if enemy.has_signal("torch_thrown"):
			#enemy.torch_thrown.connect(handle_torch_thrown)
		#if enemy.has_signal("sword_dropped"):
			#enemy.sword_dropped.connect(handle_sword_dropped)
#
#
#func handle_torch_thrown(location: Vector2, direction: float):
	#var torch_instance = torch.instantiate()
	#add_child(torch_instance)
	#torch_instance.initialize(location, direction)
	#torch_instance.torch_collided.connect(handle_torch_collided)
#
#func handle_torch_collided(location: Vector2):
	#var torch_flames_instance = torch_flames.instantiate()
	#torch_flames_instance.global_position = location
	#call_deferred("add_child", torch_flames_instance)
#
#func handle_sword_dropped(location: Vector2):
	#var sword_instance = sword.instantiate()
	#sword_instance.global_position = location
	#call_deferred("add_child", sword_instance)
