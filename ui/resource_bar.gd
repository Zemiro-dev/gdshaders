extends TextureProgressBar


func initialize(resource_signal: Signal, current_value: int, max_value: int):
	resource_signal.connect(_handle_resource_changed)
	set_remaining(current_value, max_value)


func set_remaining(new_value: int, max_value: int):
	var remaining = float(new_value) / float(max_value) * 100.
	var tween = create_tween()
	tween.tween_property(self, "value", remaining, .1)
	
func _handle_resource_changed(new_value: int, max_value: int) -> void:
	set_remaining(new_value, max_value)
