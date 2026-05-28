extends Area2D

class_name Portal2D

@export var door_data: DoorData

var current_scene: Node
var target_scene: String
var target_coords: Vector2

func _ready() -> void:
	current_scene = get_tree().current_scene
	if door_data.scene_a==current_scene.scene_file_path:
		set_data(door_data.scene_b, door_data.coords_b)
	elif door_data.scene_b==current_scene.scene_file_path:
		set_data(door_data.scene_a, door_data.coords_a)
	

## Calls [Transitioner].[method scene_transition] with [member target_scene] and
## member [target_coords].
func enter_door():
	Transitioner.scene_transition(target_scene, target_coords)
	

func set_data(scene_target: String, coords_target: Vector2):
	target_scene = scene_target
	target_coords = coords_target
	
