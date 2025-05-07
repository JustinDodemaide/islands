class_name SelectionOption

var enabled:bool = true

func text() -> String:
	return "Option"

func update_availability(facility:Facility) -> void:
	pass

func selected(facility:Facility) -> void:
	var mission_planning_screen = preload("res://MissionPlanningScreen/MissionPlanningScreen.tscn").instantiate()
	SignalBus.game.add_child(mission_planning_screen)
