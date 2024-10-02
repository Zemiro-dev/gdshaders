extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material.set_shader_parameter('dim', Vector2(512.0, 512.0));
	material.set_shader_parameter('offset', Vector2(20.0, 0.0));
	material.set_shader_parameter('gridSize', 128.0);	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
