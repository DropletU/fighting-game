extends PanelContainer

@onready var difficulty_box = $MarginContainer/VerticalUISpacing/DifficultyVBox
var text = ""

func _ready() -> void:
	var difficulties = difficulty_box.get_children()
	for i in range(difficulties.size()):
		difficulties[i].button_info = difficulties[i].name.to_lower()
	

func start_new_game(info):
	if text=="":
		return
	GameManager.start_new_game(text, info)
	

func _on_normal_button_pressed(info: String) -> void:
	start_new_game(info)

func _on_deathless_button_pressed(info: String) -> void:
	start_new_game(info)

func _on_hitless_button_pressed(info: String) -> void:
	start_new_game(info)


func _on_name_edit_text_changed(new_text: String) -> void:
	text = new_text
