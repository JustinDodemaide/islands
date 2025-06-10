extends Facility

const MAX_TIER:int = 2
var tier:int
var production:Dictionary = {
	Item.RESOURCE_CATEGORIES.ELECTRICITY: 1
}

func get_selection_options() -> Dictionary[FACILITY_SELECTION_OPTIONS,bool]:
	selection_options[FACILITY_SELECTION_OPTIONS.UPGRADE] = tier < MAX_TIER
	selection_options[FACILITY_SELECTION_OPTIONS.MISSION] = !is_occupied_by_player
	return selection_options

func option_selected(option:FACILITY_SELECTION_OPTIONS) -> void:
	match option:
		FACILITY_SELECTION_OPTIONS.UPGRADE:
			upgrade()
		FACILITY_SELECTION_OPTIONS.MISSION:
			pass

func upgrade():
	if tier == MAX_TIER:
		return
	tier += 1
	production[Item.RESOURCE_CATEGORIES.ELECTRICITY] = tier + 1

func get_save_dictionary() -> Dictionary:
	return {"tier":tier}

func restore(save_dictionary:Dictionary) -> void:
	tier = save_dictionary.tier
	production[Item.RESOURCE_CATEGORIES.ELECTRICITY] = tier + 1
