extends Node

@onready var move_functions = $"../MoveFunctions"

var executing:=false

var callable_sequence:=[]
var current_index:=0

func execute(keep_executing_false:=false):
	if not keep_executing_false:
		executing=true
	
	print("executed")
	var callable: String = callable_sequence[current_index]["callable"]
	var r_count: int = callable_sequence[current_index]["right_shift_count"]
	
	if move_functions.has_method(callable):
		await move_functions.call(callable, r_count)
		current_index+=1
	
	
	if callable_sequence.size()>current_index:
		execute(keep_executing_false)
	else:
		executing=false
		current_index=0
	
	


func add_to_executing_queue(callable_move: String, total_right_shifts,
							keep_executing_false:=false):
	var full_move: = {"callable": callable_move,
	"right_shift_count": total_right_shifts}
	callable_sequence.append(full_move)
	
	if executing==false:
		execute(keep_executing_false)
	




func _on_sequence_builder_stance_matched(sequence: Array, stance: String = "standing") -> void:
	var stance_name = MoveUtils.get_stance(sequence)
	var stance_callable = MoveUtils.find_callable_stance(sequence, stance)
	var total_right_shifts = MoveUtils.find_total_rshifts(sequence)
	var keep_executing_false = MoveUtils.get_keep_executing_false(stance_name)
	add_to_executing_queue(stance_callable, total_right_shifts, keep_executing_false)
	



func _on_sequence_builder_valid_action(sequence: Array, stance: String) -> void:
	pass # Replace with function body.
	
