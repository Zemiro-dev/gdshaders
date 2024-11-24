extends Area2D
class_name Shield

@export var is_dead: bool = false
@export var entity: Entity


# Called when the node enters the scene tree for the first time.
func take_damage(damage: int, attacker: Node2D):
	if entity != null:
		entity.take_damage(damage, attacker)
		if is_dead:
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector2.ZERO, .1)
			monitorable = false
