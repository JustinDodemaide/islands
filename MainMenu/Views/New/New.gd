extends State


func enter(previous_state_path: String = "", data := {}) -> void:
	$Control.visible = true

func exit() -> void:
	$Control.visible = false

func _on_begin_pressed() -> void:
	var parameters = {
		"new_game":true,
		"number_of_players":2
	}
	get_parent().start_game(parameters)
