extends Resource
class_name KnockbackBaseStrategy

## Knockback force
@export var knockback_strength: float = 100.

## Camera Shake Strength
@export var camera_shake_strength: float = 1000.

## Camera Shake Duration in seconds
@export var camera_shake_duration: float = .5

## Applies any knockback actions to and around the targets
func knockback(target: Entity, damage_source: Node2D):
	if !target.can_knockback():
		return
		
	if target is Player and camera_shake_strength > 0.:
		GlobalSignals.camera_shake_requested.emit(camera_shake_duration, camera_shake_strength)
		
	var direction_to_attacker = damage_source.global_position.direction_to(target.global_position)
	var knockback_force: Vector2 = direction_to_attacker * knockback_strength
	target.current_knockback += knockback_force
