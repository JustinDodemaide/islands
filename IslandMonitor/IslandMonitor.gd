extends Node3D


func _on_room_camera_moved(setup: String) -> void:
	if setup == "island" or setup == "island_selection":
		$IslandDisplayController.enable()
		$IslandDisplay.receiving_input = true
	else:
		$IslandDisplayController.disable()
		$IslandDisplay.receiving_input = false
