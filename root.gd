extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Make background transparent for easy screenshots
	get_tree().get_root().set_transparent_background(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("save"):
		# Retrieve the captured Image using get_image().
		var img = get_viewport().get_texture().get_image()
		img.save_png("user://out.png")
