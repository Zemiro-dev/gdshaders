extends Node2D

@onready var player_ship: CharacterBody2D = $PlayerShip
@onready var background_grid: TextureRect = $BG/MarginContainer/BackgroundGrid

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background_grid.player = player_ship


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
