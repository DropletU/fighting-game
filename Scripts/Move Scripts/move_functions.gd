extends Node

## The player node.
@onready var player = $"../.."
## The [AnimationPlayer] hodling all of the animations the player can make.
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
## The history of the players inputs.
@onready var input_history = $"../InputHistory"
## The spritesheet holding all animations. [br]
## WARNING: Be sure to use this with caution, or you may end up with visual bugs
## after certain moves.
@onready var spritesheet: Sprite2D = $"../../Resizer/Spritesheet"
## The [AttackArea2D] being used for all attacks
@onready var attack_area: AttackArea2D = $"../../AttackArea2D"

# Dash

func dash_stance(_r_count: int):
	player.change_stance("dash")
	change_stance_after_delay("standing", 1.0)
	

# Sword Stance

func counter_stance(_r_count: int):
	player.change_stance("counter")
	player.play_animation("SwordStance", false, true)
	await await_animation()
	monitor_counter_stance_exit()
	

func monitor_counter_stance_exit():
	var wasd_keys:=["up", "down", "left", "right"]
	var move_timer:=0.0
	while player.stance=="counter":
		var newest_input: Array = input_history.input_history[-1]
		if newest_input.any(func(s): return s in wasd_keys) and not player.velocity==Vector2.ZERO:
			move_timer+=1.0/60.0
		else:
			move_timer=0.0
		if move_timer>=0.2:
			break
		await get_tree().physics_frame
	end_counter_stance()
	

func end_counter_stance(_r_count:=0):
	var backwards:=true
	player.play_animation("SwordStance", backwards, false)
	await await_animation()
	player.change_stance("standing")
	player.play_animation("Idle")
	

# Exploding Stance / Attack

func standing_explode_stance_one(_r_count:=1):
	player.play_animation("ExplodingStance")
	await await_animation()
	player.change_stance("exploding")
	call_function_after_delay("exit_exploding_stance", 1.0, "stance", "exploding")
	

func exit_exploding_stance():
	if animation_player.current_animation:
		return
	if player.stance=="standing":
		return
	player.play_animation("ExplodingStance", true)
	await animation_player.animation_finished
	player.change_stance("standing")
	player.play_animation("Idle")
	

func exploding_explode_one(_r_count:=0):
	if animation_player.current_animation:
		return
	player.play_animation("ExplodeAttack")
	await animation_player.animation_finished
	exit_exploding_stance()
	


# Utility Functions


## Checks if the [member animation_player] is playing or not, and calls await
## [member animation_player].[member animation_finished]. Afterwards, it returns.
func await_animation() -> void:
	if animation_player.is_animation_active():
		await animation_player.animation_finished
	return
	

func change_stance_after_delay(stance: String, time_sec: float):
	await get_tree().create_timer(time_sec).timeout
	player.change_stance(stance)
	
