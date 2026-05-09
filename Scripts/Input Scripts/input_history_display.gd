extends Node

@onready var history_node = $"../InputHistory"
@onready var vbox = $VBoxContainer
var frame_data: Array


func _ready() -> void:
	pass
	


func add_display_slot():
	var slot = HBoxContainer.new()
	
	# Add icon slots
	for j in 5:
		var icon = TextureRect.new()
		icon.visible=false
		slot.add_child(icon)
		var texture = AtlasTexture.new()
		texture.atlas = load("res://Assets/icons-keyboard-16x16-1bit-ansdor.png")
		texture.region = Rect2(0, 0, 16, 16)
		icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		icon.texture = texture
	
	# Add counter slot
	var counter = Label.new()
	
	counter.text = str(1)
	slot.add_child(counter)
	
	vbox.add_child(slot)
	vbox.move_child(slot, 0)
	if vbox.get_child_count()>24:
		vbox.remove_child(vbox.get_child(-1))
	


func _physics_process(_delta: float) -> void:
	if vbox.get_child_count()==0:
		add_display_slot()
	var newest_frame=history_node.input_history.back()
	if frame_data==newest_frame:
		var counter = vbox.get_child(0).get_child(-1) # Text label holding the frame count
		counter.text = str(int(counter.text)+1)
		return
	frame_data=history_node.input_history.back()
	add_display_slot()
	
	
