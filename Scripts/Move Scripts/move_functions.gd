extends Node

@onready var player = $"../.."
@onready var slime_sprites = $"../../SlimeSprites"
@onready var input_history = $"../InputHistory"

func dash_stance(_r_count: int):
	player.change_stance("dash")
	change_stance_after_delay("standing", 1.0)
	

func counter_stance(_r_count: int):
	player.change_stance("counter")
	slime_sprites.play("SwordStance")
	await slime_sprites.animation_finished
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
		if move_timer>=0.35:
			break
		await get_tree().physics_frame
	end_counter_stance()

func end_counter_stance(_r_count:=0):
	slime_sprites.play_backwards("SwordStance")
	await slime_sprites.animation_finished
	slime_sprites.play("Idle")
	player.change_stance("standing")
	

func change_stance_after_delay(stance: String, time_sec: float):
	await get_tree().create_timer(time_sec).timeout
	player.change_stance(stance)
	
