extends State

func _enter(previous_state, host: TransitionAnimationPlayer):
	pass


func _exit(new_state, host: TransitionAnimationPlayer):
	pass


func _execute(delta, host: TransitionAnimationPlayer):
	pass

func _get_next_state(host: TransitionAnimationPlayer):
	if host.direction == host.OUT:
		return host.States.OUT
	return null
