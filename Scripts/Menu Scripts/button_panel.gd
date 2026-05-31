extends PanelContainer

var hovering:=false
var button_info:=""
@onready var name_node = find_child("Name")

## Emits when the panel is presed while being hovered over.
signal button_pressed(info: String)

func _on_mouse_entered() -> void:
	hovering=true

func _on_mouse_exited() -> void:
	hovering=false


func _on_gui_input(event: InputEvent) -> void:
	if hovering and event.is_action_pressed("left_click"):
		button_pressed.emit(button_info)
