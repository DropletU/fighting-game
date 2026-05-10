extends Node

## The current input sequence that the Executor node reads from to start the next action.
var current_sequence: Array[String] = []
@export var sequence_buffer:=15
var buffer_timer:=0
var sequence_started:=false
var waiting_for_release: = false
var last_input:="neutral"

@onready var input_history = $"../InputHistory"
@onready var player = $"../.."
var movelist = ConfigFile.new()

func _ready() -> void:
	movelist.load("res://Scripts/Move Scripts/move_list.cfg")
	process_physics_priority = 1
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	var history: Array = input_history.input_history
	var frame_count = history.size()
	if frame_count<3: # Edge case on the first three frames from when the player is instantiated
		return
	var second_last_frame: Array = history[-2]
	var current_input:=""
	current_input = track_movement_keys(second_last_frame, current_input)
	current_input = track_action_keys(history.back(), second_last_frame, current_input)
	
	if current_input!=last_input:
		last_input=current_input
		if match_from_move_list(current_input):
			sequence_started=true
			buffer_timer=0
			current_sequence.append(current_input)
			print("current sequence ", current_sequence)
		else:
			buffer_timer+=sequence_buffer
	
	if sequence_started:
		buffer_timer+=1
	
	if buffer_timer>=sequence_buffer:
		sequence_started=false
		buffer_timer=0
		current_sequence.clear()
	



func track_movement_keys(second_last_frame: Array, current_input: String):
	var movement_keys = ["up", "down", "left", "right"]
	var facing = player.facing
	if second_last_frame.all(func(i): return i not in movement_keys): # No movement was made
		current_input+="neutral"
		return current_input
	
	current_input = parse_movement_keys(second_last_frame, facing)
	return current_input
	



func track_action_keys(last_frame: Array, second_last_frame: Array, current_input: String):
	var action_keys = ["one", "two", "three", "four", "(R)"]
	if waiting_for_release and second_last_frame.any(func(input): return input in action_keys):
		return current_input
	else: waiting_for_release=false
	
	if second_last_frame.all(func(i): return i not in action_keys): # No action was made
		return current_input
	
	if last_frame.size()<=second_last_frame.size(): # Last frame is not a superset of current
		for input in second_last_frame:
			if input in action_keys:
				if current_input=="neutral":
					current_input=""
				current_input+=input
	elif second_last_frame.all(func(i): return i in last_frame): # Last frame is a superset
		print(second_last_frame, last_frame)
		for input in last_frame:
			if input in action_keys:
				if current_input=="neutral":
					current_input=parse_movement_keys(last_frame, player.facing)
				current_input+=input
				print(current_input)
	waiting_for_release=true
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
	

func match_from_move_list(current_input):
	var test_sequence = current_sequence.duplicate(true)
	test_sequence.append(current_input)
	
	var stance: String = player.stance
	var stance_moves: Array = Array(movelist.get_sections()).filter(func(s: String):
		return s.begins_with(stance+"/"))
	
	for i in stance_moves.size():
		var sequence: Array = movelist.get_value(stance_moves[i], "sequence")
		if match_sequences(test_sequence, sequence):
			print(stance_moves[i])
			return true
	return false
	

func match_sequences(test_sequence: Array, match_sequence: Array):
	if test_sequence.size()>match_sequence.size():
		return false
	for i in test_sequence.size():
		if test_sequence[i]==match_sequence[i]:
			continue
		return false
	if test_sequence.size()==match_sequence.size():
		print("Action Successful")
	return true
	
