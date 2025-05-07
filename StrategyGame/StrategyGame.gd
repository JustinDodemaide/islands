extends Node
class_name Game

# 🐵

var resource_pool:Dictionary = {
	Item.RESOURCE_CATEGORIES.ELECTRICITY: 0,
}

var soldier_pool:Dictionary = {
	
}

var equipment_pool:Dictionary = {
	
}

var island: Island

func _ready() -> void:
	SignalBus.game = self
	
	island = load("res://Island/Island.gd").new(self)
	add_child(island.get_map())
	
	$UpdateTimer.start()

func _on_update_timer_timeout() -> void:
	for facility in island.facilities:
		if facility.occupied_by is PlayerFaction:
			for resource in facility.produced_resources:
				resource_pool[resource] += facility.produced_resources[resource]
	SignalBus.emit_signal("game_update")
	
	_check_victory_condition()

func _check_victory_condition() -> void:
	for facility in island.facilities:
		if facility.occupied_by is not PlayerFaction:
			return
	get_tree().quit()
