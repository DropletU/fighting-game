extends Node


const WASD_WINDOW:=0.1


var facing:=1
var current_wasd:=[]
var current_sequence:=[]

enum Dir {
	UP, 
	DOWN, 
	FORWARD, 
	BACK, 
	RSHIFT,
	NEUTRAL
}

@warning_ignore("unused_signal")
signal action_triggered(action: String)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and not event.is_echo():
		handle_wasd(event)
	

func handle_wasd(event: InputEventKey) -> void:
	var direction = get_direction(event)
	if direction==-1:
		return
	
	if event.pressed:
		current_wasd.append(direction)
	else:
		current_wasd.erase(direction)
	
	current_sequence.append({
			"directions": current_wasd.duplicate(),
			"timestamp": Time.get_ticks_msec()
		}
	)
	
	check_wasd_actions()
	


func get_direction(event: InputEventKey):
	if event.is_action("up"): return Dir.UP
	if event.is_action("down"): return Dir.DOWN
	if event.is_action("right"): return Dir.FORWARD if facing==1 else Dir.BACK
	if event.is_action("left"): return Dir.BACK if facing==1 else Dir.FORWARD
	if event.is_action("magic_button"): return Dir.RSHIFT
	return -1
	



func check_wasd_actions():
	print()
	
