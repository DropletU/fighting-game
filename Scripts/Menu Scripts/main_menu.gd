extends Control

@onready var details = $Details
@onready var options_page = $Details/OptionsPage
@onready var credits_page = $Details/CreditsPage
@onready var play_page = $Details/PlayPage

func _on_play_pressed() -> void:
	if play_page.visible:
		disable_all_pages(true)
	else:
		details.visible=true
		disable_all_pages()
		play_page.visible=true
	

func _on_quit_pressed() -> void:
	get_tree().quit()
	

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
	

func disable_all_pages(disable_main:=false):
	for page in details.get_children():
		page.visible=false
	if disable_main:
		details.visible=false
	


func _on_save_one_pressed() -> void:
	pass
