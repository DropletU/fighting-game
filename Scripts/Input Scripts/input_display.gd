extends Control

@onready var up = $Up
@onready var down = $Down
@onready var left = $Left
@onready var right = $Right
@onready var one = $One
@onready var two = $Two
@onready var three = $Three
@onready var four = $Four
@onready var magic = $RightShift

func _ready() -> void:
	$ColorRect.size=self.size
	




func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
		up.button_pressed=true
	elif event.is_action_released("up"):
		up.button_pressed=false
	
	if event.is_action_pressed("down"):
		down.button_pressed=true
	elif event.is_action_released("down"):
		down.button_pressed=false
	
	if event.is_action_pressed("left"):
		left.button_pressed=true
	elif event.is_action_released("left"):
		left.button_pressed=false
	
	if event.is_action_pressed("right"):
		right.button_pressed=true
	elif event.is_action_released("right"):
		right.button_pressed=false
	
	if event.is_action_pressed("one"):
		one.button_pressed=true
	elif event.is_action_released("one"):
		one.button_pressed=false
	
	if event.is_action_pressed("two"):
		two.button_pressed=true
	elif event.is_action_released("two"):
		two.button_pressed=false
	
	if event.is_action_pressed("three"):
		three.button_pressed=true
	elif event.is_action_released("three"):
		three.button_pressed=false
	
	if event.is_action_pressed("four"):
		four.button_pressed=true
	elif event.is_action_released("four"):
		four.button_pressed=false
	
	if event.is_action_pressed("(R)"):
		magic.button_pressed=true
	elif event.is_action_released("(R)"):
		magic.button_pressed=false
	
