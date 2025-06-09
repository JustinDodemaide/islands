extends State

func enter(previous_state_path: String = "", data := {}) -> void:
	$Control.visible = true

	var directory_access:DirAccess = DirAccess.open("user://")
	if directory_access == null:
		printerr("Could not open folder")
		return
	directory_access.list_dir_begin()
	
	var button_scene = load("res://MainMenu/Views/Load/Button/LoadGameButton.tscn")
	for file_name in directory_access.get_files():
		if file_name.contains("Game"):
			var button = button_scene.instantiate()
			button.init(isolate_id(file_name))
			button.selected.connect(_save_chosen)
			$Control/VBoxContainer/Buttons.add_child(button)

func isolate_id(full_file_name:String) -> String:
	var id = full_file_name.lstrip("Game")
	id = id.rstrip(".save")
	return id

func exit() -> void:
	for button in $Control/VBoxContainer/Buttons.get_children():
		button.queue_free()
	
	$Control.visible = false

func _save_chosen(id:String):
	var parameters = {
		"new_game":false,
		"game_id":id
	}
	get_parent().start_game(parameters)
