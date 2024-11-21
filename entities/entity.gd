extends CharacterBody2D
class_name Entity


signal on_damage_taken(attacker: Node2D)
signal on_health_changed(new_health: int, max_health: int)
signal on_shield_changed(new_shield: int, max_shield: int)
signal on_death(entity: Entity)

@export var should_trigger_hitstop := false
@export var hitstop_time_ms := 0.0

@export var max_health := 1
var current_health := 1
@export var max_shield := 0
var current_shield := 0

@export var max_invulnerability_time := 0.0
var remaining_invulnerability_time := 0.0

var is_dead := false


func _ready() -> void:
	current_health = max_health
	current_shield = max_shield


func _physics_process(delta: float) -> void:
	if remaining_invulnerability_time > 0.0:
		remaining_invulnerability_time -= delta


func take_damage(damage: int, attacker: Node2D):
	if is_dead or remaining_invulnerability_time > 0:
		return
	print(current_health, current_shield)
	if current_shield > 0:
		current_shield -= damage
		if current_shield <= 0:
			current_health = 0
		on_shield_changed.emit(current_shield, max_shield)
	else:
		current_health -= damage
		on_health_changed.emit(current_health, max_health)
	
	on_damage_taken.emit(attacker)
	if should_trigger_hitstop:
		GlobalSignals.hitstop_requested.emit(hitstop_time_ms)

	if max_invulnerability_time > 0.0 and current_health > 0:
		remaining_invulnerability_time = max_invulnerability_time

	if current_health <= 0:
		die()

func restore_health(health: int):
	var previous_health = current_health
	current_health = clampi(current_health + health, current_health, max_health)
	if current_health != previous_health:
		on_health_changed.emit(current_health, max_health)

func reset_shield():
	current_shield = max_shield
	on_shield_changed.emit(current_shield, max_shield)


func die():
	is_dead = true
	on_death.emit(self)
