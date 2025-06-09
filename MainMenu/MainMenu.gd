extends Node

func _ready() -> void:
	var directory_access:DirAccess = DirAccess.open("user://")
	if directory_access == null:
		printerr("Could not open folder")
		return
	directory_access.list_dir_begin()
	
	var button_scene = load("res://MainMenu/LoadSaveButton.tscn")
	for file_name in directory_access.get_files():
		print(file_name)
		if file_name.contains("Game"):
			var button = button_scene.instantiate()
			button.init(isolate_id(file_name))
			button.selected.connect(_save_chosen)
			$VBoxContainer.add_child(button)
	pass

func isolate_id(full_file_name:String) -> String:
	var id = full_file_name.lstrip("Game")
	id = id.rstrip(".save")
	return id

func _on_new_pressed() -> void:
	SignalBus.new_game = true
	get_tree().change_scene_to_file("res://Game/Game.tscn")

func _save_chosen(id:String) -> void:
	SignalBus.new_game = false
	SignalBus.game_id = id
	get_tree().change_scene_to_file("res://Game/Game.tscn")
