extends Portal2D

var player_nearby:=false

func _ready() -> void:
	super._ready()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_nearby:
		enter_door()

func _on_body_entered(body: Node):
	if body.is_in_group("Player"):
		player_nearby=true

func _on_body_exited(body: Node):
	if body.is_in_group("Player"):
		player_nearby=false
