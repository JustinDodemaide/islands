extends Node3D 
class_name Button3D

var enabled:bool = true
var is_hovered:bool = false
signal hovered
signal unhovered
signal pressed

func _ready() -> void:
	if get_node("CollisionShape3D") == null:
		push_error("ClickableArea3D needs CollisionShape!")

func enable():
	enabled = true

func disable():
	enabled = false
	emit_signal("unhovered")

func _on_mouse_entered() -> void:
	if enabled:
		is_hovered = true
		DisplayServer.cursor_set_shape(DisplayServer.CursorShape.CURSOR_POINTING_HAND)
		emit_signal("hovered")

func _on_mouse_exited() -> void:
	if enabled:
		is_hovered = false
		DisplayServer.cursor_set_shape(DisplayServer.CursorShape.CURSOR_ARROW)
		emit_signal("unhovered")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		#get_viewport().set_input_as_handled()
		if is_hovered:
			emit_signal("pressed")
