extends Node2D

@onready var player_ship: Player = $PlayerShip
@onready var background_grid: TextureRect = $BG/MarginContainer/BackgroundGrid
@onready var life_bar: TextureRect = $UI/LifeBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background_grid.player = player_ship
	life_bar.initialize(player_ship)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
