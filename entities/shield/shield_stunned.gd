extends State


var stunned_time_remaining := 0.
var previous_shield := 0


func _enter(previous_state, host: Shield):
	stunned_time_remaining = host.stunned_regeneration_delay
	previous_shield = host.entity.current_shield
	print("Stunned")


func _exit(new_state, host):
	pass


func _execute(delta, host: Shield):
	if previous_shield > host.entity.current_shield:
		previous_shield = host.entity.current_shield
		stunned_time_remaining = host.stunned_regeneration_delay
	stunned_time_remaining -= delta
	

func _get_next_state(host: Shield):
	if host.is_dead:
		return host.States.DEAD
	if stunned_time_remaining <= 0.:
		return host.States.REGENERATING
	return null
