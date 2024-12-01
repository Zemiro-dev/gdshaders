class_name Trail
extends Line2D


@onready var curve := Curve2D.new()
@export var max_points : int = 100
var host:Node2D

func init(node: Node2D):
	host = node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if host == null:
		return
	curve.add_point(host.global_position)
	if curve.get_baked_points().size() > max_points:
		curve.remove_point(0)
	points = curve.get_baked_points()
