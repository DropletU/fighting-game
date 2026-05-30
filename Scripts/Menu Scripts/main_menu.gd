extends Control

@onready var details = $Details

func _on_play_pressed() -> void:
	GameManager.enter_new_scene("res://Scenes/scene_one.tscn", true, Vector2(143, -48))
	

func _on_quit_pressed() -> void:
	get_tree().quit()
	


func disable_all_pages(disable_main:=false):
	for page in details.get_children():
		page.visible=false
	if disable_main:
		details.visible=false
	


func _on_save_one_pressed() -> void:
	pass
