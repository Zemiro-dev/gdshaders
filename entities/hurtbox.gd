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
## A target is anything the hurtbox
## has damaged. It will prefer
## to damage targets again
## during active scan if possible
@export var max_total_targets: int = 0

## Should the hurtbox maintain a list
## of hurt nodes and not damage
## nodes again until they are removed
## from the blacklist
@export var use_blacklist: bool = false

## Amount of time to keep a node
## blacklisted before damage
## can be dealt to it again. Use
## 0 to blacklist forever
@export var blacklist_time: float = 0

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
		var nodes: Array[Node2D] = get_overlapping_nodes() 
		var targets_lost: Array[Node2D] = []
		targets = targets.filter(
			func(target):
				var within := nodes.find(target) > -1
				var blacklist_node := get_blacklist_node(target)
				var blacklisted := is_node_blacklisted(blacklist_node)
				return !within and !blacklisted
				
		)
		for node in nodes:
			process_node_for_pain(node)


func get_overlapping_nodes() -> Array[Node2D]:
	var result: Array[Node2D]
	result.assign(get_overlapping_areas() + get_overlapping_bodies())
	return result


## If the target array is less than the max total allowed
func can_acquire_more_targets() -> bool:
	return targets.size() < max_total_targets
	

func is_node_damageable(node: Node2D) -> bool:
	return node.has_method('take_damage') and !node.get('is_dead')


func is_node_blacklisted(blacklist_node: Node2D) -> bool:
	return false if !use_blacklist else blacklist.find(blacklist_node) > -1


## True if the node is in the targets array or if we have no max
func is_node_targeted(node: Node2D) -> bool:
	return true if !should_acquire_targets() else targets.find(node) > -1


func should_acquire_targets() -> bool:
	return max_total_targets != 0


func target(node: Node2D) -> void:
	targets.append(node)
	

func untarget(node: Node2D) -> void:
	var idx: int = targets.find(node)
	if idx > -1:
		targets.remove_at(idx)


func hurt(node: Node2D, blacklist_node: Node2D) -> void:
	node.take_damage(damage, get_owner())
	damage_dealt.emit(node)
	add_to_blacklist(blacklist_node)


func get_blacklist_node(node: Node2D) -> Node2D:
	return node if !node.has_method('get_hurtbox_blacklist_node') else node.get_hurtbox_blacklist_node()
	

func add_to_blacklist(node: Node2D) -> void:
	if use_blacklist:
		blacklist.append(node)
		if !is_zero_approx(blacklist_time) and blacklist_time > 0.:
			await get_tree().create_timer(blacklist_time).timeout
			var idx: int = blacklist.find(node)
			if idx > -1:
				blacklist.remove_at(idx)


func reset_blacklist() -> void:
	blacklist = []


func process_node_for_pain(node: Node2D) -> void:
	## Can we target or is it already a target
	var is_targeted := is_node_targeted(node)
	if is_targeted or can_acquire_more_targets():
		## Can we damage the node so it's worth looking at
		if is_node_damageable(node):
			## Get blacklistable node and see if we've already damaged the node
			var blacklist_node = get_blacklist_node(node)
			if !is_node_blacklisted(blacklist_node):
				if !is_targeted:
					target(node)
				hurt(node, blacklist_node)	


func on_enter(node: Node2D) -> void:
	process_node_for_pain(node)
