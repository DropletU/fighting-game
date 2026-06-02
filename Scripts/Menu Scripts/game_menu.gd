extends Control


func _on_continue_pressed() -> void:
	GameManager.toggle_pause()
	


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	GameManager.quit_to_main_menu()
