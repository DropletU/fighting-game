extends Node

## The current input sequence that the Executor node reads from to start the next action.
var current_sequence: Array[String]
var skip_action_frame: = false

@onready var input_history = $"../InputHistory"


func _ready() -> void:
	process_physics_priority = 1
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	var history: Array = input_history.input_history
	var frame_count = history.size()
	if frame_count<2: # Edge case on the first frame from when the player is instantiated
		return
	var second_last_frame: Array = history[-2]
	var current_input:=""
	current_input = track_movement_keys(history, second_last_frame, current_input)
	current_input = track_action_keys(history, second_last_frame, current_input)
	

func track_action_keys(history: Array, second_last_frame: Array, current_input: String):
	if skip_action_frame:
		skip_action_frame=false
		return current_input
	var action_keys = ["one", "two", "three", "four", "magic_button"]
	
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
	
	
