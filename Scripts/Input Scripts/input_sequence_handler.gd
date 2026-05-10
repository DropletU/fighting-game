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
	track_movement_keys(history)
	track_action_keys(history)
	

func track_action_keys(history: Array):
	if skip_action_frame:
		skip_action_frame=false
		return
	var frame_count = history.size()
	if frame_count<=2: # Edge case of the second frame from when the player is instantiated
		return
	var second_last_frame: Array = history[-2]
	var action_keys = ["one", "two", "three", "four", "magic_button"]
	var current_input:=""
	
	if second_last_frame.all(func(i): return i not in action_keys): # No action was made
		return
	if history.back().size()<=second_last_frame.size(): # Last frame is not a superset of current
		for input in second_last_frame:
			if input in action_keys:
				current_input+=input
	elif second_last_frame.all(func(i): return i in history.back()): # Last frame is a superset
		for input in history.back():
			if input in action_keys:
				skip_action_frame=true
				current_input+=input
	current_sequence[-1]+=current_input
	
