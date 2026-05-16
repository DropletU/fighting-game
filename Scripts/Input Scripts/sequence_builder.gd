extends Node

@onready var current_stance=$"../..".stance


# New Input Info
var newest_movement:="neutral"
var newest_action:=""
var newest_rshift:=""

# Sequence Info
var current_sequence:=[]
var sequence_ongoing:=false
var frame_buffer:=0


func _physics_process(_delta: float) -> void:
	if not sequence_ongoing:
		return
	
	
	


func _on_input_parser_action_inputs(inputs: String, subtract_by: int) -> void:
	pass # Replace with function body.


func _on_input_parser_movement_inputs(inputs: String) -> void:
	pass # Replace with function body.


func _on_input_parser_right_shift(pressed: bool) -> void:
	pass # Replace with function body.
