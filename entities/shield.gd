extends Area2D
class_name Shield


enum States { IDLE, DEAD, REGENERATING, STUNNED }

@export var is_dead: bool = false
@export var entity: Entity

@export var	stunned_regeneration_delay: float = 5.
@export var	regeneration_tick_delay: float = 1.
@export var regeneration_amount: int = 1
@export var reactivation_delay: float = 10.
@export var can_reactivate: bool = true
@export var can_regenerate: bool = true

@onready var state_machine:StateMachine = $StateMachine

func _ready() -> void:
	state_machine.add_state(States.IDLE, $StateMachine/Idle)
	state_machine.add_state(States.STUNNED, $StateMachine/Stunned)
	state_machine.add_state(States.REGENERATING, $StateMachine/Regenerating)
	state_machine.add_state(States.DEAD, $StateMachine/Dead)
	state_machine.initialize(self, States.IDLE)
	
# Called when the node enters the scene tree for the first time.
func take_damage(damage: int, attacker: Node2D):
	if entity != null:
		entity.take_damage(damage, attacker)
		if is_dead:
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector2.ZERO, .1)
			monitorable = false


func heal_damage(amount: int):
	if entity != null:
		var was_dead = is_dead
		entity.restore_shield(amount)
		if was_dead and !is_dead:
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector2.ONE, .1)
			monitorable = true
			
