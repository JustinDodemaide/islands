extends Node3D
class_name Facility

var is_occupied_by_player:bool = true
var island_pos:Vector2 = Vector2.ZERO

func name() -> String:
	return "Facility Name"

func mesh() -> MeshInstance3D:
	return null


enum FACILITY_SELECTION_OPTIONS {UPGRADE,MISSION}
@export var selection_options:Dictionary[FACILITY_SELECTION_OPTIONS,bool] = {}

func get_selection_options() -> Dictionary[FACILITY_SELECTION_OPTIONS,bool]:
	return selection_options

func option_selected(option:FACILITY_SELECTION_OPTIONS) -> void:
	pass

#region Saving and Loading
var id:String

func _init():
	id = str(randi())

func save() -> void:
	var facility_save_file = FileAccess.open("user://Facility" + id + ".save", FileAccess.WRITE)
	facility_save_file.store_line(JSON.stringify(get_save_dictionary()))

func load_from_id(id:String) -> void:
	self.id = id
	var save_dictionary = SignalBus.retrieve_dictionary_from_file("Facility" + id)
	restore(save_dictionary)

# Needs to be changed by inherited class
func get_save_dictionary() -> Dictionary:
	return {}

# Needs to be changed by inherited class
func restore(save_dictionary:Dictionary) -> void:
	pass
#endregion
