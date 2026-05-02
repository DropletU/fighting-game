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

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var standing := true
var crouching := false
var buffer_jump := false

func _physics_process(delta: float) -> void:
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
	
