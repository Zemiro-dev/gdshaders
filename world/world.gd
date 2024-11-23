extends Node2D

@onready var player_ship: Player = $PlayerShip

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HUD/LifeBar.initialize(player_ship)
	$HUD/HealthBar.initialize(player_ship.on_health_changed, player_ship.current_health, player_ship.max_health)
	$HUD/ShieldBar.initialize(player_ship.on_shield_changed, player_ship.current_shield, player_ship.max_shield)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
