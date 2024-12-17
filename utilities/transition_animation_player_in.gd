extends State

func _enter(previous_state, host: TransitionAnimationPlayer):
	if host.is_playing():
		host.pause()
	if host.has_animation('transition'):
		host.play('transition')


func _exit(new_state, host: TransitionAnimationPlayer):
	pass


func _execute(delta, host: TransitionAnimationPlayer):
	pass

func _get_next_state(host: TransitionAnimationPlayer):
	if host.direction == host.OUT:
		return host.States.OUT
	if !host.is_playing():
		return host.States.END
	return null
