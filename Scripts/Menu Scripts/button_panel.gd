extends PanelContainer

var hovering:=false
var slot_name:=""

signal start_new_save

func _on_mouse_entered() -> void:
	hovering=true

func _on_mouse_exited() -> void:
	hovering=false


func _on_gui_input(event: InputEvent) -> void:
	if hovering and event.is_action_pressed("left_click"):
		if slot_name!="":
			GameManager.load_game(slot_name)
		else:
			start_new_save.emit()
