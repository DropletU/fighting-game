extends Control


func _on_continue_pressed() -> void:
	GameManager.toggle_pause()
	


func _on_options_pressed() -> void:
	pass # TODO: Add/remove options menu as a child here. Use the same method used in the main menu for this.


func _on_quit_pressed() -> void:
	GameManager.quit_to_main_menu()
