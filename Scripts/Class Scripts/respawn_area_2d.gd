extends Area2D

class_name RespawnArea2D

@export var marker: Marker2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	if self.has_node("Marker2D"):
		marker = self.get_node("Marker2D")
	if marker.has_node("Sprite2D"):
		marker.get_node("Sprite2D").visible = Engine.is_editor_hint()
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.respawn_point = marker.global_position
	
