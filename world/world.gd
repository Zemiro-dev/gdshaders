extends Node2D

@onready var player_ship: Player = $PlayerShip

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HUD/LifeBar.initialize(player_ship)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
