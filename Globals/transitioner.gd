extends Node

## Transitions the [member current_scene] into [member target_scene] and sets the
## players [member global_position] to [member coordinates]. [br]
## If [member current_scene].[member scene_file_path] is the same as
## [member target_scene], a new scene will not be loaded. [br]
## If [member respawn] is [code]true[/code], the method [method queue_free] will
## be called on the current player scene, and a new one will be instantiated. 
func scene_transition(target_scene: String, coordinates: Vector2, respawn:=false):
	var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
	if target_scene!=get_tree().current_scene.scene_file_path:
		GameManager.enter_new_scene(target_scene)
	if respawn:
		GameManager.player_died()
		GameManager.spawn_new_player(target_scene, coordinates)
		player = GameManager.get_player()
	else:
		player.global_position=coordinates
	
