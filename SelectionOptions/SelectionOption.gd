class_name SelectionOption

var enabled:bool = true

func name() -> String:
	return "Option"

func description() -> String:
	return "This is an option!"

func update_availability(facility:Facility) -> void:
	pass

func selected(facility:Facility) -> void:
	var mission_planning_screen = preload("res://MissionPlanningScreen/MissionPlanningScreen.tscn").instantiate()
	SignalBus.game.add_child(mission_planning_screen)
