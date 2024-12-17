extends State

func _enter(previous_state, host: TransitionAnimationPlayer):
	if host.is_playing():
		host.pause()
	host.play_backwards('transition')


func _exit(new_state, host: TransitionAnimationPlayer):
	pass


func _execute(delta, host: TransitionAnimationPlayer):
	pass

func _get_next_state(host: TransitionAnimationPlayer):
	if host.direction == host.IN:
		return host.States.IN
	if !host.is_playing():
		return host.States.START
	return null
