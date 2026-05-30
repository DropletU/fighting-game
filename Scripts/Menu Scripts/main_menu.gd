extends Control


func _on_play_pressed() -> void:
	GameManager.enter_new_scene("res://Scenes/scene_one.tscn", true, Vector2(143, -48))
	

func _on_quit_pressed() -> void:
	get_tree().quit()
	

func _on_save_one_pressed() -> void:
	pass
