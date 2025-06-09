extends State


func enter(previous_state_path: String = "", data := {}) -> void:
	$Control.visible = true

func exit() -> void:
	$Control.visible = false

func _on_begin_pressed() -> void:
	var parameters = {
		"new_game":true,
		"players":["human","ai"]
	}
	get_parent().start_game(parameters)
