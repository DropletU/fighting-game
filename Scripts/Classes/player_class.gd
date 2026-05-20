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


# References

## The node holding the entire input and executor system under it
@onready var input_system = $InputSystem
## The [AnimatedSprite2D] that has all the animations in it
@onready var animated_sprite = $AnimatedSprite2D
## The [CollisionShape2D] that hits enemies
@onready var hitbox = $Hitbox
## The [CollisionShape2D] that detects attacks that hit it
@onready var hurtbox = $Hurtbox
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
signal damage_taken(new_health: int)


## Sets the players [member max_health] to the given [member value]. If [member value] is less
## than [member health], it also calls [method set_health] and sets it to [member max_health].
## [br] Emits [signal max_health_changed] after changing [member max_health].
func set_max_health(value):
	max_health = value
	max_health_changed.emit(value)
	if max_health<health:
		set_health(max_health)
	

## Sets the players [member health] to the given [member value]. If [member value] is greater
## than [member max_health], it sets [member health] to [member max_health]. [br]
## Emits [signal health_changed] afterwards.
func set_health(value):
	if health<=max_health:
		health = value
		health_changed.emit(health)
	else:
		health = max_health
		health_changed.emit(health)
	

## Sets the players [member stance] to the [member new_stance] given, and emits
## [signal stance_changed] afterwards.
func change_stance(new_stance):
	stance = new_stance
	stance_changed.emit(stance)
	

## Makes sure the [member damage] value given is negative and then calls [method set_health]
## with the [member damage] value given. [br]
## Emits [signal damage_taken] afterwards.
func take_damage(damage: int):
	if damage>0:
		push_error("Damage value given was positive.")
		damage*=-1
	set_health(damage)
	damage_taken.emit(health)
	
