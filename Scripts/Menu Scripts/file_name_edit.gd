extends LineEdit

var regex: RegEx = RegEx.new()

func _on_text_changed(new_text: String) -> void:
	regex.compile("^[a-zA-Z0-9]*$")
	if not regex.search(new_text):
		text=new_text.left(new_text.length()-1)
	
