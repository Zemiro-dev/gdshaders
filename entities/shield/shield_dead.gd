extends State



var reactivation_delay := 0.

func _enter(previous_state, host: Shield):
	reactivation_delay = host.reactivation_delay
	print("I'm dead")


func _exit(new_state, host):
	pass


func _execute(delta, host: Shield):
	if host.can_reactivate:
		reactivation_delay -= delta

func _get_next_state(host: Shield):
	if reactivation_delay <= 0.:
		return host.States.REGENERATING
	return null
