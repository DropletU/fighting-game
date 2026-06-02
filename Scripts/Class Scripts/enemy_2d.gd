extends CharacterBody2D

## A class that has everything an Enemy needs.
## @experimental: This was made while making the [AttackArea2D] class, so there is a high chance that there are missing parts to it.
class_name Enemy2D

@export_category("Stats")
## The [Enemy2D]'s max health.
@export var max_health:=100: set = set_max_health
## The [Enemy2D]'s current health.
@export var health:=100: set = set_health
## The base damage that the [Enemy2D] can deal.
@export var damage:=1

# State
## The possible states the [Enemy2D] can be in.
enum States { NORMAL, ATTACKING, HITSTUN, DEAD }
## The current state the [Enemy2D] is in.
var state: = States.NORMAL

# Hitstun
## The duration of the hitstun the [Enemy2D] is in.
var hitstun_dur:=0.0

## Sets [member max_health] to the given [member value]. If [member value] is below or equal to [code]0[/code], it will set [member max_health] to [code]1[/code].
func set_max_health(value: int):
	if value<=0:
		max_health=1
	else:
		max_health=value
	

## Sets [member health] to [member value]. If [member value] is below [code]0[/code] or above [member max_health], it will be limited to those numbers.
func set_health(value: int):
	if value<=0:
		health=0
	elif value>=max_health:
		health=max_health
	else:
		health=value
	

## Adds the [Enemy2D] to the [code]"Enemy"[/code] and [code]"Damageable[/code] groups. [br]
## You are recommended to call [code]super[/code].[method _ready] if you wish to override this function.
func _ready() -> void:
	self.add_to_group("Enemy")
	self.add_to_group("Damageable")
	

## Handles the state machine. You are recommended to call [code]super[/code].[method _physics_process] at the start if you plan on overriding this function.
## WARNING: Does not call [method move_and_slide].
func _physics_process(delta: float) -> void:
	if state==States.NORMAL:
		_normal_process(delta)
	if state==States.ATTACKING:
		_attacking_process(delta)
	if state==States.HITSTUN:
		_hitstun_process(delta)
	if state==States.DEAD:
		_dead_process(delta)
	

## Takes damage and enters hitstun hitstun. [br]
## @experimental: [member velocity] is directly set to [member knockback_dir]. If your enemy should react to it differently, you should override this function.
func take_damage(damage_taken, knockback_dir, hitstun_f):
	if state==States.HITSTUN:
		return
	if health>0:
		health-=damage_taken
	velocity=knockback_dir
	hitstun_dur=hitstun_f
	state=States.HITSTUN
	

## This function should be overridden to decide how the [Enemy2D] moves while in normal state.
func _normal_process(_delta: float) -> void:
	pass
	

## This function should be overridden to decide how the [Enemy2D] moves while in attacking state.
func _attacking_process(_delta: float) -> void:
	pass

## This function should be overridden to decide how the [Enemy2D] moves while in hitstun state. [br]
## You are recommended to call [code]super[/code].[method _hitstun_process] when overriding this.
func _hitstun_process(delta: float) -> void:
	hitstun_dur-=delta
	if hitstun_dur<=0.0:
		hitstun_dur=0.0
		state=States.NORMAL if health>0 else States.DEAD
	

## This function should be overridden to decide how the [Enemy2D] moves while in dead state.
func _dead_process(_delta: float) -> void:
	pass
	
