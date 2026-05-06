extends Node

# The input priority is one two three four magic_button"

## Returns [code]true[/code] if there is an action that can be or has been reached
## from [member frame_being_checked].
func check_input_validity(inputs_for_action: Array, input_being_checked: Array,
						  current_state: Dictionary):
	var actions_possible=_get_actions_possible(current_state)
	
	for action in actions_possible:
		var input_sequence = action["input_sequence"]
		if _inputs_match_current_or_future(input_sequence, inputs_for_action,
		input_being_checked):
			return true
	return false
	

## Returns the most suitable action it can find from [member action]
func get_most_suitable_valid_action(inputs_for_action: Array, current_state: Dictionary):
	if inputs_for_action.size()==0:
		push_error("No action was made.")
		return
	if not current_state["state"]:
		push_error("Action started while not in a stance/state.")
		return
	var actions_possible=_get_actions_possible(current_state)
	var inputs = inputs_for_action.duplicate(true)
	
	for i in range(inputs_for_action.size()):
		var action = _get_action_from_inputs(actions_possible, inputs)
		if action=="none":
			inputs.pop_back()
			continue
		return action
	return "none"
	

func _get_action_from_inputs(actions_possible, inputs_for_action):
	for action in actions_possible:
		var input_sequence = action["input_sequence"]
		if _inputs_match_current(input_sequence, inputs_for_action):
			return action["name"]
	return "none"
	


func _get_actions_possible(current_state: Dictionary):
	var state = current_state["state"]
	var actions_possible:=[]
	for action in actions.values():
		if action["required_stance"]==state:
			actions_possible.append(action)
	return actions_possible
	

func _inputs_match_current_or_future(input_sequence: Array,
	inputs_done: Array, new_input: Array):
	var input_sequence_test = inputs_done.duplicate(true)
	input_sequence_test.append(new_input)
	
	if input_sequence_test.size()>input_sequence.size():
		return false
	
	for i in range(input_sequence_test.size()):
		if input_sequence[i]==input_sequence_test[i]:
			continue
		return false
	return true
	

func _inputs_match_current(input_sequence: Array, inputs_done: Array):
	return input_sequence==inputs_done
	


const actions: Dictionary = {
	"placeholder_action": {
		"name": "placeholder_action",
		"frames": 30, # Number of frames until a new state starts
		"next_state": "", # State that will force start after this, ""=="standing"
		"required_stance": "standing", # Stance required to be in for this to happen
		"input_sequence": [["one"], ["two"], ["three"], ["four"]] # Input sequence needed
	}
}
