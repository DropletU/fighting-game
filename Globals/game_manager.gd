extends Node

var player: CharacterBody2D
var respawn_point:=Vector2.ZERO
var player_node = preload("res://Scenes/Prefabs/Player.tscn")

func player_died():
	player.visible=false
	player.queue_free()
	await get_tree().process_frame
	spawn_new_player()
	

func spawn_new_player(spawn_location:=respawn_point):
	var instance:=player_node.instantiate()
	_handle_new_player_instance_info(instance, spawn_location)
	add_child(instance)
	player = instance
	

func _handle_new_player_instance_info(instance, spawn_location: Vector2):
	instance.global_position = spawn_location
	

func set_player(new_player: CharacterBody2D):
	if new_player!=player:
		player = new_player
	
