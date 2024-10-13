extends TextureRect


func initialize(player: Player):
	player.on_health_changed.connect(_handle_player_health_changed)
	var remaining = float(player.current_health) / float(player.max_health)
	material.set_shader_parameter('remaining', remaining);
	material.set_shader_parameter('units', 5);	


func _handle_player_health_changed(new_health: int, max_health: int) -> void:
	material.set_shader_parameter('remaining', float(new_health) / float(max_health));
