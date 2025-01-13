extends Resource
class_name TargetBaseStrategy

@export var can_target_self: bool = false
@export var can_target_owner: bool = false
@export var can_target_shooters_projectiles: bool = false

## Detection strength of the targeting strategy
@export var detection_strength: int = 5


func can_target(targeter: Node2D, target: Node2D):
	return (
		(can_target_self or targeter != target) and
		(can_target_owner or targeter.get_owner() != target) and 
		same_shooter_check(targeter, target) and
		detection_strength_check(target)
	)


func same_shooter_check(targeter: Node2D, target: Node2D) -> bool:
	var targeter_shooter = targeter.get("shooter")
	var target_shooter = target.get("shooter")
	if targeter_shooter == null or targeter_shooter == null:
		return true
	
	return can_target_shooters_projectiles or targeter_shooter != target_shooter


func detection_strength_check(target: Node2D) -> bool:
	var target_detection_difficulty = target.get("detection_difficulty")
	if target_detection_difficulty is int:
		return target_detection_difficulty <= detection_strength
	return true
