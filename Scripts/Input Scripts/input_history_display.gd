extends Node

@onready var history_node = $"../InputHistory"


func _physics_process(_delta: float) -> void:
	var new_frame_data=history_node.input_history
	
