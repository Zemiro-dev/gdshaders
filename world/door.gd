extends AnimatableBody2D
class_name Door

enum States { IDLE, OPENING, OPEN }

@export var triggers: Array[AreaTrigger]


func _ready() -> void:
	triggers.all(func(area_trigger: AreaTrigger): area_trigger.triggered.connect(_on_triggered))


func _on_triggered(body: Node2D):
	pass
