extends Node

@onready var current_stance=$"../..".stance
@onready var executor=$"../Executor"


# New Input Info
var newest_movement:="neutral"
var newest_action:=""
var newest_rshift:=""
var newest_input:="neutral"

# Sequence Info
## The sequence that will be signaled every time an action is made, or every time a
## full stance sequence is made. 
var valid_sequence:=[]
## Tracks whether the sequence is ongoing or not. 
var sequence_ongoing:=false
## The buffer limit for valid sequences. 
var frame_buffer_limit:=10
## The buffer counter. 
var frame_buffer:=0

# Signals
## Emits when a stance is perfectly matched from the players inputs. 
signal stance_matched(sequence: Array, stance: String)
## Emits when a valid input is made by the player. 
signal valid_action(sequence: Array, stance: String)



func _physics_process(_delta: float) -> void:
	if not sequence_ongoing:
		return
	frame_buffer+=1
	var current_input=newest_movement+newest_action+newest_rshift
	if newest_action!="":
		if newest_movement.begins_with("neutral"):
			current_input=newest_action+newest_rshift
	
	if newest_input!=current_input:
		handle_new_input(current_input)
		newest_input=current_input
	
	if frame_buffer==frame_buffer_limit:
		end_sequence()
	

func end_sequence():
	valid_sequence.clear()
	sequence_ongoing=false
	frame_buffer_limit=10
	frame_buffer=0
	

func append_valid_sequence(current_input: String):
	valid_sequence.append(current_input)
	if MoveUtils.matches_any_stance(valid_sequence):
		stance_matched.emit(valid_sequence.duplicate(), current_stance)
		end_sequence()
	if is_new_action():
		valid_action.emit(valid_sequence.duplicate(), current_stance)

func handle_new_input(current_input: String):
	var test_sequence: Array
	
	for input in valid_sequence:
		test_sequence.append(input)
	test_sequence.append(current_input)
	
	if MoveUtils.matches_any_sequence(test_sequence, current_stance):
		append_valid_sequence(current_input)
		frame_buffer_limit=frame_buffer+10
		return
	
	if test_sequence.size()<=1:
		return
	
	if current_input.begins_with(test_sequence[-2]): # If current is a superset of previous
		test_sequence.remove_at(-2)
	else:
		return
	
	if MoveUtils.matches_any_sequence(test_sequence, current_stance):
		valid_sequence.remove_at(-1)
		append_valid_sequence(current_input)
		frame_buffer_limit=frame_buffer+10
	


func is_new_action():
	if valid_sequence.size()<1:
		return false
	var action_keys: = ["one", "two", "three", "four"]
	var new_input: String = valid_sequence[-1]
	if action_keys.any(func(s): return s in new_input):
		return true
	return false
	


func new_action_input(inputs: String) -> void:
	newest_action=inputs
	if executor.executing:
		return
	sequence_ongoing=true
	

func new_movement_input(inputs: String) -> void:
	newest_movement=inputs
	if executor.executing:
		return
	sequence_ongoing=true
	

func right_shift_updated(input: String) -> void:
	newest_rshift=input
	


func _on_player_stance_changed(new_stance: String) -> void:
	current_stance=new_stance
