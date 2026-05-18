extends Node

@onready var player = $"../.."


func dash_stance(_r_count: int):
	player.change_stance("dash")
	change_stance_after_delay("standing", 1.0)
	

func change_stance_after_delay(stance: String, time_sec: float):
	await get_tree().create_timer(time_sec).timeout
	player.change_stance(stance)
	
