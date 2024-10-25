extends Sprite2D

func _ready() -> void:
	var range : float = 10000.
	var rng1 : float = randf_range(-range, range)
	var rng2 : float = randf_range(-range, range)
	var rng3 : float = randf_range(-range, range)
	var rng4 : float = randf_range(-range, range)
	material.set_shader_parameter("scroll1", Vector2(rng1, rng2))
	material.set_shader_parameter("scroll2", Vector2(rng3, rng4))
	#material.get_shader_parameter("noise1").noise.offset = Vector3(rng1, rng2, 0.);
	#material.get_shader_parameter("noise2").noise.offset = Vector3(rng1, rng2, 0.);
