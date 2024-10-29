extends Area2D

@export var obstacle_name := 'Unknown'
@export var one_shot := true
var emit_count := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if !one_shot || emit_count < 1:
		emit_count += 1
		GlobalSignals.ping_obstacle.emit(obstacle_name)
