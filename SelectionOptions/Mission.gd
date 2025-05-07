extends SelectionOption
class_name SelectionOption_Mission

func text() -> String:
	return "Mission"

func update_availability(facility:Facility) -> void:
	if facility.occupied_by is PlayerFaction:
		enabled = false
