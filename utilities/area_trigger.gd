extends Area2D
class_name AreaTrigger


signal triggered(body: Node2D)


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D):
	triggered.emit(body)
