class_name Trail
extends Line2D


const MAX_POINTS: int = 100
@onready var curve := Curve2D.new()

var host:Node2D

func init(node: Node2D):
	host = node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if host == null:
		return
	curve.add_point(host.global_position)
	if curve.get_baked_points().size() > MAX_POINTS:
		curve.remove_point(0)
	points = curve.get_baked_points()
