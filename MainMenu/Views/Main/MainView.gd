extends State

func enter(previous_state_path: String = "", data := {}) -> void:
	$Control.visible = true

func exit() -> void:
	$Control.visible = false

func _on_new_pressed() -> void:
	get_parent()._transition("New")

func _on_load_pressed() -> void:
	get_parent()._transition("Load")
