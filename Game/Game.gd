extends Node3D
class_name Game

var resources:Dictionary = {
	Item.RESOURCE_CATEGORIES.ELECTRICITY: 0,
}

var island:Island

func _ready() -> void:
	SignalBus.game = self
	island = preload("res://Island/Island.gd").new(self)
	add_child(island.get_map())

func _on_update_timer_timeout() -> void:
	for facility in island.facilities:
		for resource in facility.produced_resources:
			resources[resource] += facility.produced_resources[resource]
	SignalBus.emit_signal("game_update")
