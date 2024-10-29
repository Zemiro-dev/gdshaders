extends Node2D


@onready var path_follow: PathFollow2D = $ObstaclePath/PathFollow2D

@export var progress_speed := .1;
@export var my_obstacle_name := 'Unknown'

var current_progress_target := 0.;

func _ready() -> void:
	GlobalSignals.ping_obstacle.connect(ping_obstacle)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_zero_approx(path_follow.progress_ratio - current_progress_target):
		var x = move_toward(path_follow.progress_ratio, current_progress_target, progress_speed * delta)
		path_follow.progress_ratio = x


func ping_obstacle(obstacle_name: String):
	if obstacle_name == my_obstacle_name:
		current_progress_target = abs(current_progress_target - 1.) #swap target
