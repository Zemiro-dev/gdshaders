extends State


var regen_delay_remaining := 0.
var previous_shield := 0

func _enter(previous_state, host:Shield):
	regen_delay_remaining = host.regeneration_tick_delay
	previous_shield = host.entity.current_shield
	print("regeneration")


func _exit(new_state, host):
	pass


func _execute(delta, host: Shield):
	if host.can_regenerate and previous_shield <= host.entity.current_shield:
		regen_delay_remaining -= delta
		previous_shield = host.entity.current_shield
		if regen_delay_remaining <= 0.:
			regen_delay_remaining = host.regeneration_tick_delay
			host.heal_damage(host.regeneration_amount)

func _get_next_state(host: Shield):
	if host.is_dead and previous_shield != 0:
		return host.States.DEAD
	if previous_shield > host.entity.current_shield:
		return host.States.STUNNED
	if host.entity.current_shield >=	host.entity.max_shield:
		return host.States.IDLE
	return null
