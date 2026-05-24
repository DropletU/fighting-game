extends CharacterBody2D

# TODO: Add a way to save player stats as they update


# Stats

## The max health the player can have
@export_range(1, 10, 1) var max_health:=4 : set = set_max_health
## The players current health
@export_range(1, 10, 1) var health:=4 : set = set_health


# Jumping

## How high the player jumps
@export_range(-600, -100, 5) var jump_velocity:=-400
## How high the player double jumps
@export_range(-400, -100, 5) var double_jump_velocity:=-250
## How much gravity affects the player while space is pressed
@export_range(600, 1800, 50) var jump_gravity:=1000 # TODO: Remove @export after finding a good value
## How much gravity affects the player after space is released
@export_range(1500, 2400, 50) var fall_gravity:=2000 # TODO: Remove @export after finding a good value
var jumping:=false


# Movement

## The max speed the player can move
@export_range(-600.0, 600.0) var max_speed:=400
## The players acceleration to the max speed
@export_range(4000, 12000) var acceleration:=8000
## The friction the player experiences every frame
@export_range(2000, 6000) var friction:=4000


# Facing
@export var facing:="right"
var facing_buffer:=0
var facing_buffer_limit:=9


# Fighting related

## The players current stance
@export var stance:="standing" : set = change_stance
## The players base damage
@export_range(5, 25, 1) var base_damage:=10
## The location the [Player]'s [member global_position] will be set to when
## taking hazard damage
var hazard_respawn_point:=Vector2(0, 0) : set = set_hazard_respawn_point
## Whether the player is invincible or not
@export var invincible:=false : set = set_invincibility

# References

## The node holding the entire input and executor system under it
@onready var input_system = $InputSystem
## The [AnimationPlayer] that has all the animations in it
@onready var animation_player = $AnimationPlayer
## The [CollisionShape2D] that hits enemies
@onready var hitbox: CollisionShape2D = $Hitbox
## The [CollisionShape2D] that detects attacks that hit it
@onready var hurtbox: CollisionShape2D = $Hurtbox
## The [Control] node that displays all the UI
@onready var ui: Control # TODO Add a UI scene that handles the ui


# Signals

## Emits when [member max_health] is changed through [method set_max_health]
signal max_health_changed(new_max_health: int)
## Emits when [member health] is changed through [method set_health]
signal health_changed(new_health: int)
## Emits when [member stance] is changed through [method change_stance]
signal stance_changed(new_stance: String)
## Emits when [method take_damage] is called
signal damage_taken(damage: int)
## Emits when player health reaches 0
signal player_died
## Emits when player takes damage from a hazard
signal hazard_damage_taken(last_safe_position: Vector2)


# Basic Functions

## Sets the players [member max_health] to the given [member value]. If [member value] is less
## than [member health], it also calls [method set_health] and sets it to [member max_health].
## [br] Emits [signal max_health_changed] after changing [member max_health].
func set_max_health(value: int):
	if value < 0:
		push_warning("Attempted to set max health to zero.")
		value = 1
	max_health = value
	max_health_changed.emit(value)
	if max_health<health:
		set_health(max_health)
	

## Sets the players [member health] to the given [member value]. If [member value] is greater
## than [member max_health], it sets [member health] to [member max_health]. [br]
## Emits [signal health_changed] afterwards.
func set_health(value: int):
	if value<0:
		value = 0
	if health<=max_health:
		health = value
		health_changed.emit(health)
	else:
		health = max_health
		health_changed.emit(health)
	if health==0:
		died()
	

## Sets the players [member stance] to the [member new_stance] given, and emits
## [signal stance_changed] afterwards.
func change_stance(new_stance: String):
	stance = new_stance
	stance_changed.emit(stance)
	

## Makes sure the [member damage] value given is negative and then calls [method set_health]
## with the [member damage] value given minus [member health]. [br]
## Emits [signal damage_taken] afterwards.
func take_damage(damage: int):
	if damage<0:
		push_warning("Damage value given was negative.")
		damage*=-1
	set_health(health-damage)
	damage_taken.emit(damage)
	

## Emits [signal player_died].
func died():
	player_died.emit()
	

## Calls [method take_damage] and emits [signal hazard_damage_taken].
func take_hazard_damage(damage:=1):
	take_damage(damage)
	hazard_damage_taken.emit()
	

## Sets [member hazard_respawn_point] to [member respawn_point].
func set_hazard_respawn_point(respawn_point: Vector2):
	hazard_respawn_point=respawn_point
	

## Sets [member invincible] and [member hurtbox].[member disabled] to [member value].
func set_invincibility(value: bool):
	invincible=value
	hurtbox.disabled=value
	


# Mechanics

func _physics_process(delta: float) -> void:
	# Jumping/gravity handling
	if jumping and not (velocity.y < 0 and Input.is_action_pressed("jump")):
			jumping = false # If the player lets go of space or starts falling
	if not is_on_floor():
		apply_gravity(delta)
	
	# Movement handling
	handle_movement(delta)
	
	move_and_slide()
	

## Handles left and right movement and applies friction every frame
func handle_movement(delta):
	velocity.x = move_toward(velocity.x, 0.0, friction*delta)
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x += acceleration*direction*delta
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
	if abs(velocity.x)>140:
		play_animation("Walking")
	elif animation_player.current_animation!="Idle":
		play_animation("Idle")
	
	match direction:
		1.0:
			_try_turn("right")
		-1.0:
			_try_turn("left")
		0.0:
			_try_turn("")
	

## Applies gravity to the player based on whether they're jumping or not, and
## sets jumping to false when they stop rising.
func apply_gravity(delta: float) -> void:
	if jumping:
		velocity.y+=jump_gravity*delta
	else:
		velocity.y+=fall_gravity*delta
	if (velocity.y<0 or Input.is_action_just_released("jump")) and jumping:
		jumping = false
	

## Attempts to turn if the player is moving in the opposite direction of [member facing].
## Increments [member facing_buffer] every frame until [member facing_buffer_limit] is reached,
## or until the player stops moving in the opposite direction. [br]
## Once [member facing_buffer] reaches [member facing_buffer_limit], [member facing] is
## allowed to change.
func _try_turn(direction: String) -> void:
	if direction=="" or direction==facing:
		facing_buffer=0
		return
	elif facing_buffer>=facing_buffer_limit:
		force_turn(direction)
	else:
		facing_buffer+=1
	

## Sets [member facing] to [member direction] and resets [member facing_buffer].
func force_turn(direction: String) -> void:
	var spritesheet = $Spritesheet
	facing=direction
	facing_buffer=0
	if facing=="left":
		spritesheet.flip_h=true
	else:
		spritesheet.flip_h=false
	

## Sets [member velocity].[member y] to [member jump_vel]
func _jump(jump_vel: float=-400) -> void:
	velocity.y=jump_vel
	jumping=true
	

## Plays the animation given from [member anim] in the [member animation_player]. [br]
## If [member anim] doesn't match any animation in [member animation_player],
## nothing happens. [br]
## If [member force] is [code]true[/code], it will override the current animation and
## start the one given immediately.
func play_animation(anim: String, force:=false):
	if not anim in animation_player.get_animation_list():
		return
	if force:
		animation_player.play(anim)
	else:
		if animation_player.is_playing():
			await animation_player.animation_finished
		animation_player.play(anim)
	
