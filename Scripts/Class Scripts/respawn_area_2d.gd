@tool
extends Area2D

class_name RespawnArea2D

@export var marker: Marker2D
@onready var original_collision: = $CollisionShape2D
var new_collision: CollisionShape2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	if self.has_node("Marker2D"):
		marker = self.get_node("Marker2D")
	if marker.has_node("Sprite2D"):
		marker.get_node("Sprite2D").visible = Engine.is_editor_hint()
	if self.has_node("CollisionShape2D2"):
		new_collision = self.get_node("CollisionShape2D2")
	

func _notification(what: int) -> void:
	if not is_node_ready():
		return
	if new_collision:
		if not new_collision.shape:
			original_collision.disabled=false
		else:
			original_collision.disabled=true
	else:
		original_collision.disabled=false
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.respawn_point = marker.global_position
	


func _on_child_exiting_tree(node: Node) -> void:
	if node == new_collision:
		new_collision.queue_free()
		original_collision.disabled=false
	

func _on_child_entered_tree(node: Node) -> void:
	if node.name == "CollisionShape2D2":
		new_collision=node
