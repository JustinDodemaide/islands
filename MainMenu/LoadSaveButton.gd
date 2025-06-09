extends Button

var id:String
signal selected(id:String)

func init(id:String) -> void:
	text = id
	self.id = id

func _on_pressed() -> void:
	emit_signal("selected",id)
