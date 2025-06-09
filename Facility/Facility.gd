extends Node3D
class_name Facility

var id:String

var occupied_by:Faction = Faction.new()

var island_pos:Vector2 = Vector2.ZERO

var produced_resources:Dictionary = {
	Item.RESOURCE_CATEGORIES.ELECTRICITY: 1
}

var selection_options = [
	preload("res://SelectionOptions/Upgrade.gd").new(),
	preload("res://SelectionOptions/Mission.gd").new(),
]

func _init(pos:Vector2):
	id = str(randi())
	self.island_pos = island_pos

func name() -> String:
	return "Facility"

func mesh() -> MeshInstance3D:
	return null

func get_selection_options() -> Array:
	for option in selection_options:
		option.update_availability(self)
	return selection_options

func save() -> void:
	var facility_save_dictionary = {
		
	}
	
	var facility_save_file = FileAccess.open("user://Facility" + id + ".save", FileAccess.WRITE)
	facility_save_file.store_line(JSON.stringify(id))

func load_from_id(id:String) -> void:
	self.id = id
	var save_dictionary = SignalBus.retrieve_dictionary_from_file("Facility" + id)
