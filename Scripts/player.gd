extends CharacterBody2D

# Children
@onready var standingSprite = $Standing
@onready var crouchingSprite = $Crouching
@onready var hitboxStanding = $HitboxStanding
@onready var hitboxCrouching = $HitboxCrouching

@export var coyote_time:=0.1
@export var jump_buffer_time:=0.1
var coyote_timer = 0.0
var jump_buffer_timer:= 0.0
var coyote_started:=false

var standing := true
var crouching := false



const SPEED = 300.0
const JUMP_VELOCITY = -400.0



#### Action Input Section
# Frame Data
var last_frames: Array # Holds the input data of the past 20 frames
var current_action_frame_data: Array # Holds the current frames input data
var write_index:=0 # The current index in [member last_frames]

# Important note: An action is a series of inputs, while an input is buttons that were
# pressed in the same frame
# Input Data
var inputs_for_current_action: Array # Holds all the inputs in the current action
var had_input:=false # Checks whether the previous frame had an input
var input_frames_held:=0 # The amount of frames the current input has held
var input_frame_limit:=9 # The maximum amount of frames an input can hold
var current_input_size:=0 # The number of inputs the current action has been given

# Action Data
var action_starting:=false # Whether an action is being started or not
var action_in_progress:=false # Whether an action is in progress or not
var action_playing: Array = [] # The action that will be played once inputs are finished


#### Movement Input Section
# State Data
var current_state:={
	"state": "standing", # The current state the player is in
	"frames": 1 # The number of frames the player has been in the current state
}


func _physics_process(delta: float) -> void:
	handle_inputs()
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var down_held := Input.is_action_pressed("down")
	if down_held: 
		crouch()
	elif crouching:
		stand()
	
	if is_on_floor():
		coyote_timer=coyote_time
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer=jump_buffer_time
	
	if jump_buffer_timer > 0 and coyote_timer > 0.0:
		velocity.y=JUMP_VELOCITY
		jump_buffer_timer = 0.0
		coyote_timer = 0.0
	
	coyote_timer-=delta
	jump_buffer_timer-=delta
	
	move_and_slide()
	

func handle_inputs():
	var action: Array
	if current_state["state"]:
		handle_movement_inputs_and_state()
		handle_action_inputs()
	
	if action_in_progress:
		action = inputs_for_current_action.duplicate(true)
		start_action(action)
	
	

func handle_movement_inputs_and_state():
	var current_input: Array = get_current_input()
	var next_state: Dictionary = InputStates.get_next_state(current_state, current_input)
	
	current_state=next_state
	
	# Make this function force a next state if current_state is none
	



func get_current_input():
	var inputs:=[]
	if Input.is_action_pressed("up"):
		inputs.append("up")
	if Input.is_action_pressed("down"):
		inputs.append("down")
	if Input.is_action_pressed("left"):
		inputs.append("left")
	if Input.is_action_pressed("right"):
		inputs.append("right")
	if inputs.is_empty():
		inputs.append("neutral")
	return inputs
	






## Handles everything related to action inputs and returns the action that was decided on
func handle_action_inputs():
	update_current_action_frame_data()
	var previous_frame: Array = get_frame_data(write_index-1)
	update_frames(current_action_frame_data)
	
	# Start the action and reset input state
	if input_frames_held>input_frame_limit:
		current_input_size=0
		input_frames_held=0
		action_starting=false
		action_in_progress=true
		had_input=false
	# End the last input
	elif not current_action_frame_data and had_input:
		update_inputs_for_current_action() # Checks for valid input somewhere
		if inputs_for_current_action.back().is_empty():
			input_frames_held+=input_frame_limit # Force start the action
			return
		current_input_size=0
		had_input=false
		action_starting=true
	# Start new input and update current frame and input data
	elif not current_action_frame_data.is_empty() and previous_frame.size()==0:
		input_frames_held=0
		had_input = true
		action_starting = true
		update_current_input_data()
	# Update current frame and input data
	elif action_starting:
		update_current_input_data()
	

## Updates [member inputs_for_current_action] with the latest input.
func update_inputs_for_current_action():
	var frame_index = find_largest_input_frame()
	var input_action = find_suitable_input(frame_index)
	if input_action:
		inputs_for_current_action.append(input_action)
		return true
	return false
	

## Finds and returns the biggest recent frame
func find_largest_input_frame():
	var frame_being_searched: Array 
	var frame_index:=0
	for i in input_frame_limit: # Find the largest input
		frame_being_searched = get_frame_data(write_index-i-1)
		if frame_being_searched.size()==current_input_size:
			frame_index=i+1
			return frame_index
	

## Finds the first suitable input starting from the frame given to it
func find_suitable_input(frame_index):
	var frame_being_searched: Array
	for i in input_frame_limit: # Find suitable input
		frame_being_searched=get_frame_data(write_index-frame_index-i)
		if frame_being_searched == []:
			return frame_being_searched
		var valid = InputActions.check_action_validity(inputs_for_current_action,
														frame_being_searched)
		if valid: return frame_being_searched
		else: continue
	return []
	

## Updates [member last_frames] based off of [member current_action_frame_data]
func update_frames(frame_data):
	if last_frames.size()<20:
		last_frames.append(frame_data)
		write_index+=1
	elif input_frames_held>input_frame_limit: # False frame when an action is made
		last_frames[write_index] = []
		write_index+=1
	else:
		last_frames[write_index] = frame_data
		write_index+=1
	if write_index>=20:
		write_index=0
	

## Updates the current input size and frames held
func update_current_input_data():
	if current_input_size<current_action_frame_data.size():
		current_input_size=current_action_frame_data.size()
	input_frames_held+=1
	

## Updates [member current_action_frame_data] to the current frame's input data
func update_current_action_frame_data():
	current_action_frame_data = []
	if Input.is_action_pressed("one"):
		current_action_frame_data.append("one")
	if Input.is_action_pressed("two"):
		current_action_frame_data.append("two")
	if Input.is_action_pressed("three"):
		current_action_frame_data.append("three")
	if Input.is_action_pressed("four"):
		current_action_frame_data.append("four")
	if Input.is_action_pressed("magic_button"):
		current_action_frame_data.append("magic_button")
	

## Grabs the frame data of the given frame index. The frame index should be based
## off of [member write_index]. [br]
## WARNING: if the frame index given is above or below double the size of
## [member write_index], this function will fail
func get_frame_data(frame_index):
	if last_frames.size()==0:
		return []
	# Frame index is based off of write_index, which can only be between 0 and 19
	while frame_index<0:
		frame_index+=last_frames.size()
	while frame_index>last_frames.size()-1:
		frame_index-=last_frames.size()
	return last_frames[frame_index]
	


# Important notes: This function must decide what the next state is, and also must
# be the one to start the next state. Inputs cannot be made until the action
# enters a state. This function must also set [member current_state] to null.
func start_action(action): # placeholder
	action = inputs_for_current_action.duplicate(true)
	if action.size()==0:
		push_error("action_failed")
		action_in_progress=false
		return
	action.append(InputActions.get_most_suitable_valid_action(action))
	await get_tree().process_frame
	action_in_progress=false
	inputs_for_current_action.clear()
	



func crouch():
	hitboxStanding.disabled = true
	standingSprite.visible = false
	hitboxCrouching.disabled = false
	crouchingSprite.visible = true
	crouching = true
	

func stand():
	hitboxCrouching.disabled = true
	crouchingSprite.visible = false
	hitboxStanding.disabled = false
	standingSprite.visible = true
	standing = true
	
