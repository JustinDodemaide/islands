class_name Facility

var occupied_by:Faction

var island_pos:Vector2 = Vector2.ZERO

var produced_resources:Dictionary = {
	Item.RESOURCE_CATEGORIES.ELECTRICITY: 1
}

func _init(file = null) -> void:
	pass

func icon_image() -> Texture2D:
	return preload("res://MapIcon/facility.png")
