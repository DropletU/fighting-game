extends Node

## The config file holding the move list
var move_list: ConfigFile

## All moves
var moves:={}
## Moves that have no action inputs and enter stances.
var stances:={}


func _ready() -> void:
	move_list = ConfigFile.new()
	move_list.load("res://Scripts/Move Scripts/move_list.cfg")
	
	for move in move_list.get_sections():
		moves[move]=move_list.get_value(move, "sequence")
	
	for move in move_list.get_sections():
		if move_list.get_value(move, "stance", false):
			stances[move]=move_list.get_value(move, "sequence")
	


## Gets the move in the current stance. If no stance is given, it will return any move that
## matches. [br]
## If no move is found, it will return [code]""[/code]. [br]
## WARNING: There can be two identical moves in different stances.
func get_move(sequence: Array, stance:=""):
	for move in moves:
		if not move.begins_with(stance):
			continue
		if sequence==moves[move]:
			return move
	return ""
	




## Returns [code]true[/code] if [member test_sequence] is a subset of
## [member match_sequence]. If any input in [member match_sequence] happens
## to have [code]"(R)"[/code] at the end, this will ignore the [code]"(R)"[/code]. [br]
## If [member rshift_required] is [code]true[/code], then [member test_sequence] must
## match the [code]"(R)"[/code] inputs as well. [br]
## If [member fully_matches] is true, then [member test_sequence].[method size] must 
## be equal to [member match_sequence].[method size].
func sequence_matches(test_sequence: Array, match_sequence: Array, fully_matches:=false, rshift_required:=false):
	if fully_matches:
		if test_sequence.size()!=match_sequence.size():
			return false
	if test_sequence.size()>match_sequence.size():
		return false
	for i in test_sequence.size():
		if test_sequence[i]==match_sequence[i]:
			continue
		elif test_sequence[i]+"(R)"==match_sequence[i] and not rshift_required:
			continue
		else:
			return false
	return true
	

## Checks if the [member test_sequence] given matches any stance move. [br]
## If [member fully_matches] is [code]false[/code], it'll return [code]true[/code]
## if [member test_sequence] is a subset of a stance move.
func matches_any_stance(test_sequence: Array, fully_matches:=true):
	var stance_moves: Array = stances.keys()
	for i in stance_moves.size():
		var sequence: Array = move_list.get_value(stance_moves[i], "sequence")
		var rshift_required: bool = move_list.get_value(stance_moves[i], "required", false)
		if sequence_matches(test_sequence, sequence, fully_matches, rshift_required):
			return true
	return false
	

## Returns true if the [member test_sequence] is a subset of any move from
## the [member move_list]. [br]
## If [member fully_matches] is [code]true[/code], then the [member test_sequence]
## must be identical to [member fully_matches]
func matches_any_sequence(test_sequence: Array, current_stance: String, fully_matches:=false):
	var possible_moves: Array = Array(move_list.get_sections()).filter(func(s: String):
		return s.begins_with(current_stance+"/"))
	
	for i in possible_moves.size():
		var sequence: Array = move_list.get_value(possible_moves[i], "sequence")
		var rshift_required: bool = move_list.get_value(possible_moves[i], "required", false)
		if sequence_matches(test_sequence, sequence, fully_matches, rshift_required):
			return true
	return false
	
