extends CharacterBody2D

class_name Player

# TODO: Add a way to save player stats as they update


# Stats

## The max health the player can have
@export_range(1, 10, 1) var max_health:=4 : set = set_max_health
## The players current health
@export_range(1, 10, 1) var health:=4 : set = set_health
## The players current stance
@export var stance:="standing" : set = change_stance
## The players base damage
@export_range(5, 25, 1) var base_damage:=10
## The location the [Player]'s [member global_position] will be set to when
## taking hazard damage
@export var hazard_respawn_point:=Vector2(0, 0) : set = set_hazard_respawn_point
## Whether the player is invincible or not
@export var invincible:=false : set = set_invincibility

# References

## The node holding the entire input and executor system under it
@onready var input_system = $InputSystem
## The [AnimatedSprite2D] that has all the animations in it
@onready var animated_sprite = $AnimatedSprite2D
## The [CollisionShape2D] that hits enemies
@onready var hitbox: CollisionShape2D = $Hitbox
## The [CollisionShape2D] that detects attacks that hit it
@onready var hurtbox: CollisionShape2D = $Hurtbox
## The [Control] node that displays all the UI
@export var ui: Control # TODO Add a UI scene that handles the ui


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



## Sets the players [member max_health] to the given [member value]. If [member value] is less
## than [member health], it also calls [method set_health] and sets it to [member max_health].
## [br] Emits [signal max_health_changed] after changing [member max_health].
func set_max_health(value: int):
	if value < 0:
		push_error("Attempted to set max health to zero.")
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
		push_error("Damage value given was negative.")
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
	
