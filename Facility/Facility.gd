extends Node3D
class_name Facility

var occupied_by:Faction

var island_pos:Vector2 = Vector2.ZERO

var produced_resources:Dictionary = {
	Item.RESOURCE_CATEGORIES.ELECTRICITY: 1
}

var selection_options = [
	preload("res://SelectionOptions/Upgrade.gd").new(),
	preload("res://SelectionOptions/Mission.gd").new(),
]

func _init(file = null) -> void:
	pass

func icon_image() -> Texture2D:
	return preload("res://MapIcon/facility.png")

func get_selection_options() -> Array:
	for option in selection_options:
		option.update_availability(self)
	return selection_options
