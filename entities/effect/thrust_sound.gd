extends AudioStreamPlayer


@onready var transition_animation_player: TransitionAnimationPlayer = $TransitionAnimationPlayer

func on():
	transition_animation_player.direction = transition_animation_player.IN


func off():
	transition_animation_player.direction = transition_animation_player.OUT
