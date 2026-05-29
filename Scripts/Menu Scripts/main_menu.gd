extends Control

@onready var details = $Details
@onready var options = $Details/OptionsDetails
@onready var credits = $Details/CreditsDetails

func _on_play_pressed() -> void:
	var coords: = Vector2(143, -48)
	# TODO: Add a save manager and connect [member coords] to it.
	GameManager.enter_new_scene("res://Scenes/scene_one.tscn", true, coords)
	GameManager.respawn_scene="res://Scenes/scene_one.tscn"
	GameManager.respawn_point=coords
	

func _on_quit_pressed() -> void:
	get_tree().quit()
	

func _on_options_pressed() -> void:
	if options.visible:
		details.visible=false
		options.visible=false
	else:
		details.visible=true
		options.visible=true
		credits.visible=false

func _on_credits_pressed() -> void:
	if credits.visible:
		details.visible=false
		credits.visible=false
	else:
		details.visible=true
		credits.visible=true
		options.visible=false
