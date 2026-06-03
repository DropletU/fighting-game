extends Node

## The config file holding the move list
var move_list: ConfigFile

## All moves in the move list as well as their sequences.
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
	


func get_keep_executing_false(move: String):
	return move_list.get_value(move, "keep_executing_false", false)
	

## Returns the total number of times [code]"(R)"[/code] was found at the
## end of an input in the [member sequence].
func find_total_rshifts(sequence: Array):
	var r_count:=0
	for input in sequence:
		if input.ends_with("(R)"):
			r_count+=1
	return r_count
	

## Finds  and returns the callable action based on the [member move_name]
## and [member sequence].[method size].
func find_callable_action(move_name: String, sequence: Array) -> String:
	var int_to_str:={1: "one", 2: "two", 3: "three", 4: "four", 5: "five", 6: "six",
	7: "seven", 8: "eight", 9: "nine", 10: "ten"}
	var callable_action:=""
	var slash_index:=move_name.find("/")
	var number = int_to_str[sequence.size()]
	callable_action+=move_name.left(slash_index)+"_"+move_name.substr(slash_index+1)+"_"+number
	return callable_action
	

## Gets the stance move in the current stance. Assumes that the current stance is
## [code]"standing"[/code]. [br]
## If no stance is found, it will return [code]""[/code].
func find_callable_stance(sequence: Array, stance:="standing"):
	for stance_move: String in stances:
		if not stance_move.begins_with(stance):
			continue
		if sequences_match(sequence, stances[stance_move], true):
			var slash_index:=stance_move.find("/")
			return stance_move.substr(slash_index+1)
	return ""
	

## Gets the move in the current stance. If no stance is given, it will return any move that
## matches. [br]
## If no move is found, it will return [code]""[/code]. [br]
## WARNING: There can be two identical moves in different stances.
func get_move_name(sequence: Array, stance:="", rshift_required:=false):
	for move: String in moves:
		if not move.begins_with(stance):
			continue
		if sequence[0]==moves[move][0]:
			return move
		elif sequence[0]+"(R)"==moves[move][0] and not rshift_required:
			return move
	return ""
	

## Gets the name of the stance based on the sequence given. This does not care
## about the stance the player is currently in, and matches against all sequences in
## [member stances].
func get_stance(sequence: Array, fully_matches:=false, rshift_required:=false):
	for stance_name in stances:
		if sequence.size()!=stances[stance_name].size():
			continue
		if sequences_match(sequence, stances[stance_name], fully_matches, rshift_required):
			return stance_name
	



## Returns [code]true[/code] if [member test_sequence] is a subset of
## [member match_sequence]. If any input in [member match_sequence] happens
## to have [code]"(R)"[/code] at the end, this will ignore the [code]"(R)"[/code]. [br]
## If [member rshift_required] is [code]true[/code], then [member test_sequence] must
## match the [code]"(R)"[/code] inputs as well. [br]
## If [member fully_matches] is true, then [member test_sequence].[method size] must 
## be equal to [member match_sequence].[method size].
func sequences_match(test_sequence: Array, match_sequence: Array, fully_matches:=false, rshift_required:=false):
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
		if sequences_match(test_sequence, sequence, fully_matches, rshift_required):
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
		if sequences_match(test_sequence, sequence, fully_matches, rshift_required):
			return true
	return false
	
