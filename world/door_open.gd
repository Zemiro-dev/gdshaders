extends Node


func _enter(previous_state, host):
	pass


func _exit(new_state, host):
	pass


func _execute(delta, host):
	pass

func _get_next_state(host: Door):
	#if host.is_dead:
		#return host.States.DEAD
	return null
