extends State

func enter(previous_state_path: String = "", data := {}) -> void:
	$Control.visible = true
	get_parent().get_parent().island

func exit() -> void:
	$Control.visible = false
	pass
