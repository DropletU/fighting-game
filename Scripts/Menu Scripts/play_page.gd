extends PanelContainer

@onready var margin_container = $MarginContainer
@onready var button_container = $MarginContainer/VButtonContainer
var new_game_page = preload("res://Scenes/Menu/new_game_page.tscn").instantiate()

func _ready() -> void:
	if not SaveManager.save_data.has_section("slots"):
		return
	var save_slots = SaveManager.save_data.get_section_keys("slots")
	var buttons = button_container.get_children()
	for i in range(save_slots.size()):
		buttons[i].button_info = save_slots[i]
		buttons[i].name_node.text = save_slots[i]
	

func button_pressed(info: String):
	if info:
		GameManager.load_game(info)
	else:
		button_container.visible=false
		margin_container.add_child(new_game_page)
	

func _on_button_one_button_pressed(info: String) -> void:
	button_pressed(info)

func _on_button_two_button_pressed(info: String) -> void:
	button_pressed(info)

func _on_button_three_button_pressed(info: String) -> void:
	button_pressed(info)

func _on_button_four_button_pressed(info: String) -> void:
	button_pressed(info)
