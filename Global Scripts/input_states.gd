extends Node

# The input priority is up down left right



## Returns the state that should be happening next based on [member current_state]
## and [member current_input]. It should also increment [member "frames"]
## if the state doesn't change.
func get_next_state(current_state: Dictionary, current_input: Array):
	var state=states[current_state["state"]]
	var frames = current_state["frames"]
	var transitions = state["transitions"]
	var next_state = current_state.duplicate(true)
	
	
	# Checks if the current state can stay as it is in the next frame
	if inputs_and_frames_match_current(state, current_input, frames):
		next_state["frames"]+=1
		return next_state
	
	print(frames)
	
	next_state["frames"]=1
	next_state["state"]=get_transition_requirement_met(transitions, current_input,
	frames)
	return next_state
	

func force_start_state(state: Dictionary):
	var forced_state: Dictionary
	forced_state["state"]=state["name"]
	forced_state["frames"] = 1
	




# Checks if current state should be maintained
func inputs_and_frames_match_current(state: Dictionary, current_input: Array,
							 frames: int):
	var requirements = { # Requirements to maintain current input
		"input_requirement":  state["input_requirement"], # array
		"max_frames": state["max_frames"] # integer
	}
	var input_requirements = requirements["input_requirement"] # array[string]
	var max_frames = requirements["max_frames"] # integer
	
	# Check if frames dont match
	if frames>=max_frames and max_frames>0: return false
	
	# Returns whether inputs match or not
	return check_if_input_requirements_met(input_requirements, current_input)
	

# Checks if the next frame should have a different state and returns it
# Returns false if not
func get_transition_requirement_met(transitions: Array, current_input: Array, 
									frames: int):
	
	for transition in transitions:
		var input_requirements: Array = transition["input_required"]
		var frames_required: int = transition["frames_required"]
		
		# Check if the frames reached the required amount
		if frames<frames_required-1: continue
		
		# Checks if inputs dont match any transition
		if not check_if_input_requirements_met(input_requirements, current_input):
			continue
		return transition["target"]
	
	

func check_if_input_requirements_met(input_requirements: Array, current_input: Array):
	for input_required in input_requirements:
		if input_required=="neutral":
			return current_input[0]==input_required # Neutral state should be alone
		# Check if the current input required is a false input
		elif input_required.begins_with("!"):
			# Check if the false input was made in the current input
			if check_for_false_input(input_required, current_input):
				return false
		# Check if the current input required was not made
		elif not current_input.has(input_required):
			return false
	return true
	

## Checks if any false input that is given to it is in the current input,
## returns true if it is.
func check_for_false_input(input_being_checked: String, current_input: Array):
	if current_input[0]=="neutral":
		return false
	for input in current_input:
		if "!"+input == input_being_checked:
			return true
	return false
	








var states: Dictionary = {
	"standing": {
		"name": "standing",
		"input_requirement": ["neutral"],
		"max_frames": -1,
		"is_stance": true,
		"transitions": [{
				"target": "while_crouching",
				"frames_required": 0,
				"input_required": ["down"]
			}, {
				"target": "start_running_right",
				"frames_required": 0,
				"input_required": ["right"]
			}, {
				"target": "start_running_left",
				"frames_required": 0,
				"input_required": ["left"]
			}
		]
	},
	
	# Crouching
	"while_crouching": {
		"name": "while_crouching",
		"input_requirement": ["down"],
		"max_frames": 10,
		"is_stance": false,
		"transitions": [{
				"target": "crouching",
				"frames_required": 10,
				"input_required": ["down"]
			}, {
				"target": "while_standing",
				"frames_required": 0,
				"input_required": ["!down"]
			}
		]
	},
	"crouching": {
		"name": "crouching",
		"input_requirement": ["down"],
		"max_frames": -1,
		"is_stance": false,
		"transitions": [{
				"target": "while_standing",
				"frames_required": 0,
				"input_required": ["!down"]
			}
		]
	},
	"while_standing": {
		"name": "while_standing",
		"input_requirement": ["!down"],
		"max_frames": 10,
		"is_stance": false,
		"transitions": [{
				"target": "standing",
				"frames_required": 10,
				"input_required": ["neutral"]
			}, {
				"target": "while_crouching",
				"frames_required": 0,
				"input_required": ["down"]
			}
		]
	},
	
	# Running
	"start_running_right": {
		"name": "start_running_right",
		"input_requirement": ["right"],
		"max_frames": 8,
		"is_stance": false,
		"transitions": [{
				"target": "running_right",
				"frames_required": 8,
				"input_required": ["right"]
			}, {
				"target": "standing",
				"frames_required": 0,
				"input_required": ["!right"]
			}
		]
	},
	"running_right": {
		"name": "running_right",
		"input_requirement": ["right"],
		"max_frames": -1,
		"is_stance": false,
		"transitions": [{
				"target": "standing",
				"frames_required": 0,
				"input_required": ["!right"]
			}
		]
	},
	"start_running_left": {
		"name": "start_running_left",
		"input_requirement": ["left"],
		"max_frames": 8,
		"is_stance": false,
		"transitions": [{
				"target": "running_left",
				"frames_required": 8,
				"input_required": ["left"]
			}, {
				"target": "standing",
				"frames_required": 0,
				"input_required": ["!left"]
			}
		]
	},
	"running_left": {
		"name": "running_left",
		"input_requirement": ["left"],
		"max_frames": -1,
		"is_stance": false,
		"transitions": [{
				"target": "standing",
				"frames_required": 0,
				"input_required": ["!left"]
			}
		]
	}
	
}
