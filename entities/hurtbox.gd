extends Area2D
class_name Hurtbox


signal damage_dealt(body: Node2D)
signal aftershock_damage(hurtable: Node2D)

@export var damage: int = 1
@export var one_shot: bool = true
var spent: bool = false

@export var max_targets: int = 256
@export var max_monitoring: int = 512
@export var refactory_period: float = 1.0
var blacklist: Array[Node2D] = []
var targets: Array[Node2D] = []
var monitoring_list: Array[Node2D] = []


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	body_exited.connect(_on_body_exited)
	area_exited.connect(_on_area_exited)
	aftershock_damage.connect(_on_aftershock_damage)


func _on_area_entered(area: Node2D):
	on_enter(area)


func _on_body_entered(body: Node2D) -> void:
	on_enter(body)


func _on_area_exited(area: Node2D) -> void:
	on_exit(area)


func _on_body_exited(body: Node2D) -> void:
	on_exit(body)


func can_monitor(thing: Node2D) -> bool:
	return thing.has_method('take_damage')


func is_hurtable(thing: Node2D) -> bool:
	return thing.has_method('take_damage') and !thing.get('is_dead')


func get_damage_host(thing: Node2D) -> Node2D:
	if thing.has_method('get_damage_host'):
		return thing.get_damage_host()
	return thing


func can_damage(thing: Node2D) -> bool:
	return blacklist.find(thing) == -1


func is_targeting(thing: Node2D) -> bool:
	return targets.find(thing) > -1


func is_monitoring_thing(thing: Node2D) -> bool:
	return monitoring_list.find(thing) > -1


func addToBlacklist(thing: Node2D) -> void:
	blacklist.append(thing)


func removeFromBlacklist(thing: Node2D) -> void:
	var idx : int = blacklist.find(thing)
	if idx > -1:
		blacklist.remove_at(idx)


func target(thing: Node2D) -> void:
	targets.append(thing)


func untarget(thing: Node2D) -> void:
	var idx : int = targets.find(thing)
	if idx > -1:
		targets.remove_at(idx)


func monitor(thing: Node2D) -> void:
	monitoring_list.append(thing)


func unmonitor(thing: Node2D) -> void:
	var idx : int = monitoring_list.find(thing)
	if idx > -1:
		monitoring_list.remove_at(idx)


func can_target_more() -> bool:
	return targets.size() < max_targets


func can_monitor_more() -> bool:
	return monitoring_list.size() < max_monitoring


func on_enter(thing: Node2D):
	if one_shot and is_hurtable(thing) and !spent:
		spent = true
		hurt(thing, false)
	var damage_host = get_damage_host(thing)
	if !spent and can_monitor_more() and can_monitor(damage_host) and !is_monitoring_thing(damage_host):
		monitor(damage_host)
		if can_target_more() and is_hurtable(thing) and !is_targeting(damage_host):
			target(damage_host)
			hurt(thing)


func on_exit(thing: Node2D):
	unmonitor(thing)
	untarget(thing)


func _on_aftershock_damage(hurtable: Node2D):
	var damage_host = get_damage_host(hurtable)
	if is_targeting(damage_host) and is_hurtable(hurtable):
		hurt(hurtable)
	else:
		removeFromBlacklist(hurtable)
		untarget(damage_host)


func hurt(hurtable: Node2D, with_aftershock: bool = true):
	if can_damage(hurtable):
		hurtable.take_damage(damage, get_owner())
		damage_dealt.emit(hurtable)
	if with_aftershock:
		await get_tree().create_timer(refactory_period).timeout
		aftershock_damage.emit(hurtable)
