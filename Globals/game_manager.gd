extends Node

var player: CharacterBody2D: set = set_player, get = get_player 
var respawn_point:=Vector2.ZERO
var player_node = preload("res://Scenes/Prefabs/Player.tscn")

func _ready() -> void:
	await get_tree().current_scene.ready
	spawn_new_player(Vector2(131, -48))
	

func player_died():
	player.visible=false
	player.queue_free()
	await get_tree().process_frame
	

func spawn_new_player(spawn_location:=respawn_point):
	var instance:=player_node.instantiate()
	_handle_new_player_instance_info(instance, spawn_location)
	add_child(instance)
	player = instance
	

func enter_new_scene(new_scene: String):
	get_tree().current_scene.queue_free()
	get_tree().change_scene_to_file(new_scene)
	get_tree().current_scene=get_tree().current_scene
	

func _handle_new_player_instance_info(instance, spawn_location: Vector2):
	instance.global_position = spawn_location
	

func get_player():
	return player
	

func set_player(new_player: CharacterBody2D):
	if new_player!=player:
		player = new_player
	
