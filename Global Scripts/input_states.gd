extends Node


## Checks if there's any state that matches the current input based on the
## current state
func check_state_validity(current_state, current_input):
	return true # placeholder
	

## Returns the state that should be happening next based on [member current_state]
## and [member current_input]. It should also increment [member "frames"]
## if the state doesn't change.
func get_state(current_state, current_input):
	return {"state": "standing", "frames": 0} # placeholder
	

var states: Dictionary = {
	"standing": {
		"name": "standing",
		"max_frames": -1,
		"is_stance": true,
		"transitions": [{
				"target": "while_crouching",
				"frames_required": 0,
				"input_required": ["down"
	]}]},
	"while_crouching": {
		"name": "while_crouching",
		"max_frames": 10,
		"is_stance": false,
		"transitions": [{
			"target": "crouching",
			"frames_required": 10,
			"input_required": ["down"
	]}]}
	
}
