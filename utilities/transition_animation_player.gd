extends AnimationPlayer
class_name TransitionAnimationPlayer


enum States { START, END, IN, OUT }

const IN: String = 'IN'
const OUT: String = 'OUT'

@onready var state_machine: StateMachine = $StateMachine

var direction := OUT

func _ready() -> void:
	state_machine.add_state(States.START, $StateMachine/Start)
	state_machine.add_state(States.END, $StateMachine/End)
	state_machine.add_state(States.IN, $StateMachine/In )
	state_machine.add_state(States.OUT, $StateMachine/Out)
	state_machine.initialize(self, States.START)
