extends Node

## Refers directly to the current player
var player: CharacterBody2D: set = set_player, get = get_player 
## The coordinates that the player should respawn to if they die.
var respawn_point: Vector2
## The scene that the player should respawn to if they die.
var respawn_scene: String
## A preload of the player scene
var player_node = preload("res://Scenes/Prefabs/Player.tscn")

func _ready() -> void:
	await get_tree().current_scene.ready
	respawn_scene = get_tree().current_scene.scene_file_path
	respawn_point = Vector2(131, -48)
	spawn_new_player(respawn_point)
	

## Calls [member player].[method queue_free()]. [br]
## You are recommended to call [method spawn_new_player] immediately after this.
func player_died():
	player.queue_free()
	

## Creates a new instance of the [member player] and sets the info given through
## [member _handle_new_player_instance_info].
func spawn_new_player(spawn_location:=respawn_point):
	if get_tree().current_scene.scene_file_path!=respawn_scene:
		enter_new_scene(respawn_scene)
	var instance:=player_node.instantiate()
	_handle_new_player_instance_info(instance, spawn_location)
	add_child(instance)
	player = instance
	

## Calls [method get_tree].[member current_scene].[method queue_free], and then calls
## [method get_tree].[method change_scene_to_file] with [member new_scene]. [br]
## Note: [method get_tree].[member current_scene] is updated once
## [method change_scene_to_file] is finished.
func enter_new_scene(new_scene: String):
	get_tree().current_scene.queue_free()
	get_tree().change_scene_to_file(new_scene)
	

## Sets the args for the [memebr player_instance] given one by one. [br]
## WARNING: This currently only sets the new instance's [member global_position]
## and nothing else.
func _handle_new_player_instance_info(player_instance, spawn_location: Vector2):
	player_instance.global_position = spawn_location
	

## Returns [member player].
func get_player():
	return player
	

## Checks whether the [member new_player] is in the player group and sets [member player]
## to it if so.
func set_player(new_player: CharacterBody2D):
	if new_player.is_in_group("Player"):
		player = new_player
	
