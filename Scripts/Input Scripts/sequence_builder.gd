extends Node

@onready var current_stance=$"../..".stance


# New Input Info
var newest_movement:="neutral"
var newest_action:=""
var subtract_by:=0
var newest_rshift:=""
var newest_input:="neutral"

# Sequence Info
var current_sequence:=[]
var sequence_ongoing:=false
var frame_buffer_limit:=10
var frame_buffer:=0


func _physics_process(_delta: float) -> void:
	if not sequence_ongoing:
		return
	frame_buffer+=1
	var current_input=newest_movement+newest_action
	
	if newest_input!=current_input:
		append_current_sequence(current_input)
		if valid_input():
			frame_buffer_limit=frame_buffer+10
	
	
	
	if frame_buffer==frame_buffer_limit:
		current_sequence.clear()
		sequence_ongoing=false
		frame_buffer_limit=10
		frame_buffer=0
	


func append_current_sequence(current_input):
	if subtract_by!=0:
		remove_higher_frame_values()
	newest_input=current_input
	current_sequence.append({
			"input": current_input,
			"frame": frame_buffer+subtract_by, # subtract_by is a negative value
			"(R)": newest_rshift=="(R)"
		}
	)
	subtract_by=0
	


func remove_higher_frame_values():
	var to_remove:=[]
	for input in current_sequence:
		if input["frame"]>=frame_buffer+subtract_by:
			to_remove.append(input)
	for item in to_remove:
		current_sequence.erase(item)
	


func valid_input():
	return true
	


func _on_input_parser_action_inputs(inputs: String, subtract_frames: int) -> void:
	sequence_ongoing=true
	newest_action=inputs
	subtract_by=subtract_frames


func _on_input_parser_movement_inputs(inputs: String) -> void:
	sequence_ongoing=true
	newest_movement=inputs


func _on_input_parser_right_shift(input: String) -> void:
	newest_rshift=input
