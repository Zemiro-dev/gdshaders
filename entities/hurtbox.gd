extends Area2D
class_name Hurtbox


signal damage_dealt(body: Node2D)

@export var damage: int = 1


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	var a = body.has_method('take_damage')
	var b = !body.is_dead
	if body.has_method("take_damage") and !body.is_dead:
		body.take_damage(damage, get_owner())
		damage_dealt.emit(body)
