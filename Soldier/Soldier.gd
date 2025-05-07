class_name Soldier

var name

func _init(profile:Dictionary = {}) -> void:
	if profile.has("name"):
		name = profile.name
