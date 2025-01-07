extends Area2D
class_name Hurtbox

signal damage_dealt(node: Node2D)

## Damage per tick
@export var damage: int = 1

## Should this hurtbox actively scan
## its overlapping bodies and areas
## or should it only acquire and 
## damage targets once on enter.
@export var active_scan: bool = false

## The max number of targets this 
## hurtbox can maintain. Use 0 for
## no maximum. Only active scan
## hurtboxes can release targets, so
## for non-active scan hurtboxes this
## determines the total target count
## for the life time of the hurtbox.
@export var max_total_targets: int = 1

## Amount of time to keep a target
## blacklisted before damage
## can be dealt to it again. Use
## 0 to not blacklist at all
@export var blacklist_time: float = 0

## Target count over the life space of the
## hurtbox. Includes occurances of losing
## and regaining the same target
var current_total_targets: int = 0

var blacklist: Array[Node2D] = []
var targets: Array[Node2D] = []

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)


func _on_body_entered(body: Node2D) -> void:
	on_enter(body)


func _on_area_entered(area: Node2D) -> void:
	on_enter(area)


func _physics_process(delta: float) -> void:
	if active_scan and monitoring:
		var overlaps: Array[Node2D] = get_overlapping_nodes()
		pass


func get_overlapping_nodes() -> Array[Node2D]:
	var result: Array[Node2D]
	result.assign(get_overlapping_areas() + get_overlapping_bodies())
	return result


func can_acquire_more_targets() -> bool:
	return max_total_targets == 0 || current_total_targets < max_total_targets

func is_node_damageable(node: Node2D) -> bool:
	return node.has_method('take_damage') and !node.get('is_dead')


func is_node_blacklisted(blacklist_node: Node2D) -> bool:
	return blacklist.find(blacklist_node) > -1


func is_node_targeted(node: Node2D) -> bool:
	return targets.find(node) > -1


func target(node: Node2D) -> void:
	current_total_targets += 1
	targets.append(node)
	

func untarget(node: Node2D) -> void:
	var idx: int = targets.find(node)
	if idx > -1:
		targets.remove_at(idx)


func hurt(node: Node2D, blacklist_node: Node2D) -> void:
	node.take_damage(damage, get_owner())
	damage_dealt.emit(node)
	blacklistNode(blacklist_node)


func get_blacklist_node(node: Node2D) -> Node2D:
	return node if !node.has_method('get_hurtbox_blacklist_node') else node.get_hurtbox_blacklist_node()
	

func blacklistNode(node: Node2D) -> void:
	if !is_zero_approx(blacklist_time):
		blacklist.append(node)
		await get_tree().create_timer(blacklist_time).timeout
		var idx: int = blacklist.find(node)
		if idx > -1:
			blacklist.remove_at(idx)


func on_enter(node: Node2D) -> void:
	## Can we target anything at all
	if can_acquire_more_targets():
		## Can we damage the node so it's worth targeting
		if is_node_damageable(node):
			## Get blacklistable node and see if we've already damaged the node
			var blacklist_node = get_blacklist_node(node)
			if !is_node_blacklisted(blacklist_node):
				if !is_node_targeted(node):
					target(node)
					hurt(node, blacklist_node)
