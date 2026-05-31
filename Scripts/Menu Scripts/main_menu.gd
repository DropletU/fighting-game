extends Control

var play_page = preload("res://Scenes/Menu/play_page.tscn")
@onready var play_instance = play_page.instantiate()

func _on_play_pressed() -> void:
	if not play_instance.get_parent():
		add_child(play_instance)
	else:
		play_instance.queue_free()
		play_instance = play_page.instantiate()
	

func _on_quit_pressed() -> void:
	get_tree().quit()
	
