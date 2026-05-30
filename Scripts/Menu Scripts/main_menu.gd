extends Control

@onready var details = $Details
@onready var options_page = $Details/OptionsPage
@onready var credits_page = $Details/CreditsPage
@onready var load_page = $Details/LoadPage

func _ready() -> void:
	if SaveManager.save_index.has_section_key("meta", "last_used"):
		$MainButtons/MarginContainer/VBoxContainer/Play.disabled=false
	

func _on_play_pressed() -> void:
	var coords: = Vector2(143, -48)
	# TODO: Add a save manager and connect [member coords] to it.
	GameManager.respawn_scene="res://Scenes/scene_one.tscn"
	GameManager.respawn_point=coords
	GameManager.enter_new_scene("res://Scenes/scene_one.tscn", true, coords)
	

func _on_quit_pressed() -> void:
	get_tree().quit()
	

func disable_all_pages(disable_main:=false):
	for page in details.get_children():
		page.visible=false
	if disable_main:
		details.visible=false
	

func _on_load_pressed() -> void:
	if load_page.visible:
		disable_all_pages(true)
	else:
		details.visible=true
		disable_all_pages()
		load_page.visible=true
	

func _on_options_pressed() -> void:
	if options_page.visible:
		disable_all_pages(true)
	else:
		details.visible=true
		disable_all_pages()
		options_page.visible=true

func _on_credits_pressed() -> void:
	if credits_page.visible:
		disable_all_pages(true)
	else:
		details.visible=true
		disable_all_pages()
		credits_page.visible=true
