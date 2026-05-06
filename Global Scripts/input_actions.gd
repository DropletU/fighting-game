extends Node

# The input priority is one two three four magic_button"

## Returns [code]true[/code] if there is an action that can be or has been reached
## from [member frame_being_checked].
func check_input_validity(_action, _frame_being_checked):
	return true
	

## Returns the most suitable action it can find from [member action]
func get_most_suitable_valid_action(action: Array):
	if action.size()==0: return
	return "placeholder action"
	# This should return which action will be made, which state should be entered
	# next, and how many frames should pass until the next state starts. 0 should
	# mean start the next state immediately.
