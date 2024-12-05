extends AnimatableBody2D


@export var triggers: Array[AreaTrigger]


func _ready() -> void:
	triggers.all(func(area_trigger: AreaTrigger): area_trigger.triggered.connect(_on_triggered))


func _on_triggered(body: Node2D):
	pass
