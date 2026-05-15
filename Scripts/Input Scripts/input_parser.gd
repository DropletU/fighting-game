extends Node

## The last movement key that was pressed. [br]
## Sets to [code]"neutral"[/code] if none are pressed.
var last_wasd_input:="neutral"
## Whether [code](R)[/code] is pressed or not.
var r_shift_state:=false

var actions_buffer:=[]
var waiting_for_actions_release:=false

signal movement_inputs(inputs: String)
signal action_inputs(inputs: String, subtract_by: int)
signal right_shift(pressed: bool)

@onready var input_history = $"../InputHistory".input_history
@onready var player = $"../.."


## Processes the physics of the world all at once. [code]false[/code].
func _physics_process(_delta: float) -> void:
	var inputs = input_history.back()
	handle_wasd_keys(inputs)
	handle_action_keys(inputs)
	handle_right_shift(inputs)
	


## Parses movement keys and emits the [signal movement_inputs] signal.
func handle_wasd_keys(current_input: Array):
	var wasd_keys: = ["up", "down", "left", "right"]
	var inputs:=parse_inputs(current_input, wasd_keys, "neutral")
	
	if last_wasd_input==inputs:
		return
	last_wasd_input=inputs
	movement_inputs.emit(inputs)
	

## Parses action keys and deals with a bunch of mind numbing stuff and emits them.
func handle_action_keys(current_input: Array):
	var action_keys: = ["one", "two", "three", "four"]
	var actions_held_count:=input_type_count(current_input, action_keys)
	
	if waiting_for_actions_release and actions_held_count>0:
		return
	elif waiting_for_actions_release:
		waiting_for_actions_release=false
	
	if actions_buffer.size()==0 and actions_held_count==0:
		return
	
	actions_buffer.append(actions_held_count)
	
	if actions_buffer.size()!=3:
		return
	
	var best_frame = _find_best_frame()
	var inputs = parse_inputs(input_history[best_frame-3], action_keys)
	
	emit_actions(inputs, best_frame-2)
	

## Emits a boolean value every time [code]"(R)"[/code] is pressed or released.
func handle_right_shift(current_input: Array):
	var emit_the_signal:=false
	
	# Checks if pressed state changed
	if current_input.has("(R)") and r_shift_state==false:
		r_shift_state=true
		emit_the_signal=true
	elif not current_input.has("(R)") and r_shift_state==true:
		r_shift_state=false
		emit_the_signal=true
	
	if not emit_the_signal:
		return
	
	right_shift.emit(r_shift_state)
	



## Emits the data given to it by [method handle_action_keys] as well as whether
## [code]"(R)"[/code] is being pressed or not.
func emit_actions(inputs: String, subtract_by: int):
	waiting_for_actions_release=true
	actions_buffer.clear()
	action_inputs.emit(inputs, subtract_by)
	


## Finds the best frame for the function [method handle_action_keys] and returns it.
func _find_best_frame():
	var best_frame=0
	for i in range(1, 3):
		if actions_buffer[i-1]<actions_buffer[i]:
			best_frame=i
		elif actions_buffer[i-1]>actions_buffer[i]:
			break
	return best_frame
	

## Returns a single string consisting of only the values that are in the [member keys] array given
## to the function. [br]
## If none are found, it will return [member fallback] = [code]""[/code].
func parse_inputs(current_input: Array, keys: Array, fallback:="") -> String:
	var inputs:=""
	for input in current_input:
		if input in keys:
			inputs+=input
	if inputs=="":
		inputs=fallback
	return inputs
	

## Returns the number of inputs that are in the [member keys] array given to the function.
func input_type_count(current_input: Array, keys: Array) -> int:
	var count:=0
	for input in current_input:
		if input in keys:
			count+=1
	return count
	
