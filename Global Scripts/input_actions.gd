extends Node

## Returns [code]true[/code] if there is an action that can be or has been reached
## from [member frame_being_checked].
func check_action_validity(frame_being_checked):
	return true
	

## Returns the most suitable action it can find from [member action]
func get_most_suitable_valid_action(action):
	if action.size()==0: return
	return ["placeholder action"]
