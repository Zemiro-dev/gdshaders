extends TextureRect

var player = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_rect_changed.connect(foo)
	material.set_shader_parameter('offset', Vector2(0, 0.0));
	material.set_shader_parameter('gridSize', 512.0);	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player != null:
		material.set_shader_parameter('offset', player.position);
	
func foo() -> void:
	material.set_shader_parameter('dim', get_rect().size);
