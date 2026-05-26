extends Area2D

class_name RespawnArea2D

@export var marker: Marker2D




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.respawn_point = marker.global_position
	
