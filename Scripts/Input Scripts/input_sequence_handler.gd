extends Node

## The current input sequence that the Executor node reads from to start the next action.
var current_sequence: Array[String] = []
@export var sequence_buffer:=15
var buffer_timer:=0
var sequence_started:=false
var waiting_for_release: = false
var last_input:="neutral"
var last_action_input

@onready var input_history = $"../InputHistory"
@onready var player = $"../.."
var movelist = ConfigFile.new()

func _ready() -> void:
	movelist.load("res://Scripts/Move Scripts/move_list.cfg")
	process_physics_priority = 1
	


func _physics_process(_delta: float) -> void:
	var history: Array = input_history.input_history
	var frame_count = history.size()
	if frame_count<3: # Edge case on the first three frames from when the player is instantiated
		return
	var last_frame: Array = history[-1]
	var second_last_frame: Array = history[-2]
	var current_input:=""
	
	if second_last_frame.size()==0:
		waiting_for_release=false
	if waiting_for_release:
		current_input = last_input
		return
	
	var wasd_keys = track_movement_keys(second_last_frame)
	var action_keys = track_action_keys(last_frame, second_last_frame)
	
	
	if wasd_keys=="neutral": # Remove neutral statement if an action input was made
		if action_keys!="":
			wasd_keys=""
	current_input=wasd_keys+action_keys
	
	if current_input!=last_input:
		last_input=current_input
		if match_from_move_list(current_input):
			sequence_started=true
			buffer_timer=0
			current_sequence.append(current_input)
		else:
			buffer_timer+=sequence_buffer
	
	if sequence_started:
		buffer_timer+=1
	
	if buffer_timer>=sequence_buffer:
		sequence_started=false
		buffer_timer=0
		current_sequence.clear()
	



func track_movement_keys(second_last_frame: Array):
	var current_input=""
	var movement_keys = ["up", "down", "left", "right"]
	var facing = player.facing
	if second_last_frame.all(func(i): return i not in movement_keys): # No movement was made
		current_input+="neutral"
		return current_input
	
	current_input = parse_movement_keys(second_last_frame, facing)
	return current_input
	

func track_action_keys(last_frame: Array, second_last_frame: Array):
	var action_keys = ["one", "two", "three", "four", "(R)"]
	var current_input: = ""
	
	if second_last_frame.all(func(i): return i not in action_keys):
		return "" # No action input was made in this frame
	
	if not has_more_actions(second_last_frame, last_frame, action_keys):
		current_input=add_action_inputs(last_frame, action_keys)
	else:
		current_input=add_action_inputs(second_last_frame, action_keys)
	waiting_for_release=true
	last_action_input=current_input
	return current_input
	


func parse_movement_keys(frame_data: Array, facing: String):
	var parsed_input:=""
	for input in frame_data:
		if input=="up" or input=="down":
			parsed_input+=input
		elif input=="right":
			parsed_input+="forward" if facing=="right" else "back"
		elif input=="left":
			parsed_input+="forward" if facing=="left" else "back"
	return parsed_input
	

## Checks if the first sequence has more action inputs than the second sequence.
func has_more_actions(test_sequence: Array, match_sequence: Array, action_keys: Array):
	var test_count:=0
	var match_count:=0
	for i in test_sequence.size():
		if test_sequence[i] in action_keys:
			test_count+=1
	
	for i in match_sequence.size():
		if match_sequence[i] in action_keys:
			match_count+=1
	
	return test_count>match_count
	

func add_action_inputs(frame_data: Array, action_keys: Array):
	var current_input:=""
	for input in frame_data:
		if input in action_keys:
			current_input+=input
	return current_input

func match_from_move_list(current_input):
	var test_sequence = current_sequence.duplicate(true)
	test_sequence.append(current_input)
	
	var stance: String = player.stance
	var stance_moves: Array = Array(movelist.get_sections()).filter(func(s: String):
		return s.begins_with(stance+"/"))
	for i in stance_moves.size():
		var sequence: Array = movelist.get_value(stance_moves[i], "sequence")
		if match_sequences(test_sequence, sequence):
			return true
	return false
	

func match_sequences(test_sequence: Array, match_sequence: Array):
	if test_sequence.size()>match_sequence.size():
		return false
	for i in test_sequence.size():
		if test_sequence[i]==match_sequence[i]:
			continue
		elif test_sequence[i]+"(R)"==match_sequence[i]:
			continue
		return false
	if test_sequence.size()==match_sequence.size():
		print("Action Successful")
	return true
	
