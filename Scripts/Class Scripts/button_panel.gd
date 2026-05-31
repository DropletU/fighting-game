extends PanelContainer

class_name ButtonPanel

var hovering:=false
var button_info:=""

## Emits when the panel is presed while being hovered over.
signal button_pressed(info: String)

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)
	

func _on_mouse_entered() -> void:
	hovering=true

func _on_mouse_exited() -> void:
	hovering=false


func _on_gui_input(event: InputEvent) -> void:
	if hovering and event.is_action_pressed("left_click"):
		button_pressed.emit(button_info)
