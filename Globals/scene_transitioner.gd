extends Node


## Transitions the [member current_scene] into [member target_scene] and sets the
## players [member global_position] to [member coordinates]. [br]
## If [member current_scene].[member scene_file_path] is the same as
## [member target_scene], a new scene will not be loaded. [br]
## If [member respawn] is [code]true[/code], the method [method queue_free] will
## be called on the current player scene, and a new one will be instantiated. 
func scene_transition(target_scene: String, coordinates: Vector2, respawn:=false):
	var current_scene = get_tree().current_scene
	var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
	if target_scene!=current_scene.scene_file_path:
		var new_scene = load(target_scene)
		current_scene.queue_free()
		get_tree().root.add_child(new_scene)
		current_scene=get_tree().current_scene
	if respawn:
		player.queue_free()
		var new_player = load("res://Scenes/player.tscn")
		current_scene.add_child(new_player)
		player = get_tree().get_first_node_in_group("Player")
	player.global_position=coordinates
	
