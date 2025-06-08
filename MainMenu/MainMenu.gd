extends Node



func _on_new_pressed() -> void:
	SignalBus.new_game = true
	get_tree().change_scene_to_file("res://Game/Game.tscn")

func _on_load_pressed() -> void:
	SignalBus.new_game = false
	get_tree().change_scene_to_file("res://Game/Game.tscn")
