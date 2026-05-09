extends Node

var input_history:=[]
var current_frame_inputs:=[]


func _physics_process(_delta: float) -> void:
	set_input()
	input_history.append(current_frame_inputs)
	current_frame_inputs=[]
	


func set_input():
	if Input.is_action_pressed("up") and not Input.is_action_pressed("down"):
		if not current_frame_inputs.has("up"):
			current_frame_inputs.append("up")
	elif Input.is_action_just_released("up"):
		if current_frame_inputs.has("up"):
			current_frame_inputs.pop_at(current_frame_inputs.find("up"))
	if Input.is_action_pressed("down"):
		if not current_frame_inputs.has("down"):
			current_frame_inputs.append("down")
	elif Input.is_action_just_released("down"):
		if current_frame_inputs.has("down"):
			current_frame_inputs.pop_at(current_frame_inputs.find("down"))
	if Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		if not current_frame_inputs.has("left"):
			current_frame_inputs.append("left")
	elif Input.is_action_just_released("left"):
		if current_frame_inputs.has("left"):
			current_frame_inputs.pop_at(current_frame_inputs.find("left"))
	if Input.is_action_pressed("right"):
		if not current_frame_inputs.has("right"):
			current_frame_inputs.append("right")
	elif Input.is_action_just_released("right"):
		if current_frame_inputs.has("right"):
			current_frame_inputs.pop_at(current_frame_inputs.find("right"))
	if Input.is_action_pressed("one"):
		if not current_frame_inputs.has("one"):
			current_frame_inputs.append("one")
	elif Input.is_action_just_released("one"):
		if current_frame_inputs.has("one"):
			current_frame_inputs.pop_at(current_frame_inputs.find("one"))
	if Input.is_action_pressed("two"):
		if not current_frame_inputs.has("two"):
			current_frame_inputs.append("two")
	elif Input.is_action_just_released("two"):
		if current_frame_inputs.has("two"):
			current_frame_inputs.pop_at(current_frame_inputs.find("two"))
	if Input.is_action_pressed("three"):
		if not current_frame_inputs.has("three"):
			current_frame_inputs.append("three")
	elif Input.is_action_just_released("three"):
		if current_frame_inputs.has("three"):
			current_frame_inputs.pop_at(current_frame_inputs.find("three"))
	if Input.is_action_pressed("four"):
		if not current_frame_inputs.has("four"):
			current_frame_inputs.append("four")
	elif Input.is_action_just_released("four"):
		if current_frame_inputs.has("four"):
			current_frame_inputs.pop_at(current_frame_inputs.find("four"))
	if Input.is_action_pressed("magic_button"):
		if not current_frame_inputs.has("magic_button"):
			current_frame_inputs.append("magic_button")
	elif Input.is_action_just_released("magic_button"):
		if current_frame_inputs.has("magic_button"):
			current_frame_inputs.pop_at(current_frame_inputs.find("magic_button"))
	
