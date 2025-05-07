extends Node3D
class_name IslandMap

var selection_options_menu = null

func init(island:Island) -> void:
	var icon_packed_scene:PackedScene = preload("res://MapIcon/MapIcon.tscn")
	for facility in island.facilities:
		var icon = icon_packed_scene.instantiate()
		icon.init(facility)
		icon.selected.connect(icon_selected)
		add_child(icon)

func icon_selected(icon:MapIcon) -> void:
	# make the options menu
	selection_options_menu = preload("res://SelectionOptionsMenu/SelectionOptionsMenu.tscn").instantiate()
	selection_options_menu.init(icon.facility)
	add_child(selection_options_menu)
