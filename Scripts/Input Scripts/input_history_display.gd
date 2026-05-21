extends Node

@onready var history_node = $"../InputHistory"
@onready var vbox = $VBoxContainer
var frame_data: Array


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
	
	


func add_display_slot():
	var slot = HBoxContainer.new()
	slot.add_theme_constant_override("separation", 2)
	# Add icon slots
	for input in frame_data:
		var icon = TextureRect.new()
		slot.add_child(icon)
		var texture: AtlasTexture = get_icon(input)
		icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		icon.texture = texture
	
	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slot.add_child(spacer)
	
	# Add counter slot
	var counter = Label.new()
	counter.text = str(1)
	slot.add_child(counter)
	
	vbox.add_child(slot)
	vbox.move_child(slot, 0)
	if vbox.get_child_count()>24:
		vbox.remove_child(vbox.get_child(-1))
	

func get_icon(input: String):
	var texture=AtlasTexture.new()
	texture.atlas = load("res://Assets/Icons/icons-keyboard-16x16-1bit-ansdor.png")
	match input:
		"up":
			texture.region = Rect2(144, 64, 16, 16)
		"down":
			texture.region = Rect2(160, 64, 16, 16)
		"left":
			texture.region = Rect2(112, 64, 16, 16)
		"right":
			texture.region = Rect2(128, 64, 16, 16)
		"one":
			texture.region = Rect2(16, 48, 16, 16)
		"two":
			texture.region = Rect2(32, 48, 16, 16)
		"three":
			texture.region = Rect2(48, 48, 16, 16)
		"four":
			texture.region = Rect2(64, 48, 16, 16)
		"(R)":
			texture.region = Rect2(16, 64, 16, 16)
		_:
			push_warning("No valid input found in get_icon().")
	return texture
	
