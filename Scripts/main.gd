extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.spawn_new_player(Vector2(131, -48))
	
