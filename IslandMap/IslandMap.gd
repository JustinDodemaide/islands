extends Node3D
class_name IslandMap

func init(island:Island) -> void:
	# This is where you'd take all the island's facilities and make icons for them
	var icon_packed_scene:PackedScene = preload("res://MapIcon/MapIcon.tscn")
	for facility in island.facilities:
		var icon = icon_packed_scene.instantiate()
		icon.init(facility)
		add_child(icon)
