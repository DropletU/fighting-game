extends Node


func scene_transition(target_scene: String, coordinates: Vector2):
	var current_scene = get_tree().current_scene
	var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
	if target_scene!=current_scene.scene_file_path:
		var new_scene = load(target_scene)
		current_scene.queue_free()
		get_tree().root.add_child(new_scene)
	player.global_position=coordinates
	
