extends Node

## Refers directly to the current player
var player: CharacterBody2D: set = set_player, get = get_player 
## The coordinates that the player should respawn to if they die.
var respawn_point: Vector2: set = set_respawn_point
## The scene that the player should respawn to if they die.
var respawn_scene: String: set = set_respawn_scene
## A preload of the player scene.
var player_node = preload("res://Scenes/Prefabs/Player.tscn")
## The difficulty of the game.
var difficulty: String

## Calls [member player].[method queue_free()]. [br]
## You are recommended to call [method spawn_new_player] immediately after this. [br]
## If you can't then call [member die_and_respawn] instead.
func player_died():
	player.queue_free()
	

## Creates a new instance of the [member player] and sets the info given through
## [member _handle_new_player_instance_info].
func spawn_new_player(spawn_coords:=respawn_point):
	var instance:=player_node.instantiate()
	_handle_new_player_instance_info(instance, spawn_coords)
	add_child(instance)
	player = instance
	

func die_and_respawn():
	player_died()
	enter_new_scene(respawn_scene)
	spawn_new_player()
	

## Calls [method get_tree].[member current_scene].[method queue_free], and then calls
## [method get_tree].[method change_scene_to_file] with [member new_scene]. [br]
## Note: [method get_tree].[member current_scene] is updated once
## [method change_scene_to_file] is finished. [br]
## If [member spawn_player] is [code]true[/code], it will spawn the player at the
## given location.
func enter_new_scene(new_scene: String):
	get_tree().current_scene.queue_free()
	get_tree().change_scene_to_file(new_scene)
	await get_tree().scene_changed
	

## Sets the args for the [memebr player_instance] given one by one. [br]
## WARNING: This currently only sets the new instance's [member global_position]
## and nothing else.
func _handle_new_player_instance_info(player_instance, spawn_location: Vector2):
	player_instance.global_position = spawn_location
	

func load_game(file_name: String):
	SaveManager.load_from_disk(file_name)
	var scene = SaveManager.get_data("location", "scene")
	var coords = SaveManager.get_data("location", "coordinates")
	var max_health = SaveManager.get_data("player", "max_health", 4)
	var health = SaveManager.get_data("player", "health", -1)
	await enter_new_scene(scene)
	spawn_new_player(coords)
	player.max_health = max_health
	if health<0:
		player.health = max_health
	else:
		player.health = health
	

func start_new_game(slot_name: String, diff: String):
	await SaveManager.add_new_save(slot_name, diff)
	SaveManager.add_data("location", "scene", "res://Scenes/scene_one.tscn")
	SaveManager.add_data("location", "coordinates", Vector2(143, -48))
	SaveManager.add_data("player", "max_health", 4)
	SaveManager.add_data("player", "health", 4)
	load_game(slot_name)
	SaveManager.save_to_disk(SaveManager._get_path_with_name(slot_name))
	

## Returns [member player].
func get_player():
	return player
	

## Checks whether the [member new_player] is in the player group and sets [member player]
## to it if so.
func set_player(new_player: CharacterBody2D):
	if new_player.is_in_group("Player"):
		player = new_player
	

func set_respawn_point(point: Vector2):
	respawn_point=point
	

func set_respawn_scene(scene_path: String):
	respawn_scene=scene_path
	
