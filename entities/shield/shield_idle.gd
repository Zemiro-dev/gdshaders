extends State

func _enter(previous_state, host):
	print("I'm idle")


func _exit(new_state, host):
	pass


func _execute(delta, host):
	pass

func _get_next_state(host: Shield):
	if host.is_dead:
		return host.States.DEAD
	if host.entity.current_shield < host.entity.max_shield:
		return host.States.STUNNED
	return null
