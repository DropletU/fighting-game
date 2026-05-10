extends Node

## The current input sequence that the Executor node reads from to start the next action.
var current_sequence: Array[String] = []
var sequence_buffer:=0.0
var sequence_started:=false
var skip_action_frame: = false

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
	if frame_count<2: # Edge case on the first frame from when the player is instantiated
		return
	var second_last_frame: Array = history[-2]
	var current_input:=""
	current_input = track_movement_keys(second_last_frame, current_input)
	current_input = track_action_keys(history, second_last_frame, current_input)
	
	match_from_move_list(current_input)



func track_movement_keys(second_last_frame: Array, current_input: String):
	var movement_keys = ["up", "down", "left", "right"]
	var facing = player.facing
	if second_last_frame.all(func(i): return i not in movement_keys): # No movement was made
		current_input+="neutral"
		return current_input
	
	for input in second_last_frame:
		if input=="up" or input=="down":
			current_input+=input
		elif input=="right":
			current_input+="forward" if facing=="right" else "back"
		elif input=="left":
			current_input+="forward" if facing=="left" else "back"
	return current_input
	

func track_action_keys(history: Array, second_last_frame: Array, current_input: String):
	if skip_action_frame:
		skip_action_frame=false
		return current_input
	var action_keys = ["one", "two", "three", "four", "(R)"]
	
	if second_last_frame.all(func(i): return i not in action_keys): # No action was made
		return current_input
	
	if history.back().size()<=second_last_frame.size(): # Last frame is not a superset of current
		for input in second_last_frame:
			if input in action_keys:
				current_input+=input
	elif second_last_frame.all(func(i): return i in history.back()): # Last frame is a superset
		for input in history.back():
			if input in action_keys:
				skip_action_frame=true
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
		print(stance_moves[i])
		if match_sequences(test_sequence, sequence):
			return true
		continue
	return false
	

func match_sequences(test_sequence: Array, match_sequence: Array):
	if test_sequence.size()>match_sequence.size():
		return false
	for i in test_sequence.size():
		if test_sequence[i]==match_sequence[i]:
			continue
		return false
	return true
	
