extends Button

var option:SelectionOption
signal selected(option:SelectionOption)

func init(option:SelectionOption) -> void:
	self.option = option
	text = option.text()
	disabled = not option.enabled

func _on_pressed() -> void:
	emit_signal("selected",option)
