extends AnimatableBody2D
class_name Door 

enum States { IDLE, OPENING, OPEN }


@onready var top_path_follow: PathFollow2D = $TopPath/PathFollow2D
@onready var bottom_path_follow: PathFollow2D = $BottomPath/PathFollow2D
@onready var anim: AnimationPlayer = $AnimationPlayer

@export var triggers: Array[AreaTrigger]
@export var progress_speed: float = .1

@export var top_progress_target: float =	0.
@export var bottom_progress_target: float = 0.

@export var is_active: bool = true

func _ready() -> void:
	triggers.all(func(area_trigger: AreaTrigger): area_trigger.triggered.connect(_on_triggered))


func _process(delta: float) -> void:
	if !anim.is_playing() and is_active:
		progress_along_path(delta, top_path_follow, top_progress_target)
		progress_along_path(delta, bottom_path_follow, bottom_progress_target)


func progress_along_path(delta: float, path_follow: PathFollow2D, progress_target: float):
	if !is_zero_approx(path_follow.progress_ratio - progress_target):
		var x = move_toward(path_follow.progress_ratio, progress_target, progress_speed * delta)
		path_follow.progress_ratio = x


func open(body: Node2D) -> void:
	top_progress_target = 1.
	bottom_progress_target = 1.

func _on_triggered(body: Node2D):
	open(body)
