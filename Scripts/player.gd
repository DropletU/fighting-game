extends CharacterBody2D

# Children
@onready var standingSprite = $Standing
@onready var crouchingSprite = $Crouching
@onready var hitboxStanding = $HitboxStanding
@onready var hitboxCrouching = $HitboxCrouching
@onready var sprites = $SlimeSprites


@export var coyote_time:=0.1
@export var jump_buffer_time:=0.1
var coyote_timer = 0.0
var jump_buffer_timer:= 0.0
var coyote_started:=false

var standing := true
var crouching := false
var facing:="right"
var facing_buffer_limit:=12
var change_facing_buffer:=0

var stance := "standing"

### Player Stats

# Velocity
@export_category("Movement")
@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

# Stats
@export_category("Stats")
@export_range(0, 10, 1) var hp:=4
@export_range(10, 20, 1) var damage:=10
@export var invincible:=false
@export_range(0.0, 2.0, 0.05) var magic_buff:=1.05


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
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
	
	handle_animations()
	
	move_and_slide()
	


func handle_animations():
	if velocity.x!=0:
		sprites.play("Walk")
	elif sprites.frame==0:
		sprites.play("Idle")
	else: change_facing_buffer=0
		
	
	if velocity.x>0:
		if not facing=="right":
			change_facing_buffer+=1
		if change_facing_buffer>=facing_buffer_limit:
			facing = "right"
			sprites.flip_h=false
			change_facing_buffer=0
	
	if velocity.x<0:
		if not facing=="left":
			change_facing_buffer+=1
		if change_facing_buffer>=facing_buffer_limit:
			facing = "left"
			sprites.flip_h=true
			change_facing_buffer=0
	
