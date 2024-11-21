extends Area2D
class_name Hurtbox


signal damage_dealt(body: Node2D)

@export var damage: int = 1


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Node2D):
	check_body(area) 


func _on_body_entered(body: Node2D) -> void:
	check_body(body) 
	
func check_body(body: Node2D):
	var a = body.has_method('take_damage')
	var b = !body.get("is_dead")
	if body.has_method("take_damage") and !body.get("is_dead"):
		body.take_damage(damage, get_owner())
		damage_dealt.emit(body)
