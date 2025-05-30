extends State

@export var name_label:Label
@export var faction_label:Label
@export var production_label:Label
@export var actions_label:Label


func _ready() -> void:
	SignalBus.facility_selected.connect(facility_selected)

func facility_selected(facility:Facility):
	print("selected")
	name_label.text = facility.name().to_upper()
	
	faction_label.text = "OCCUPIED BY " + facility.occupied_by.name
	faction_label.text = faction_label.text.to_upper()
	
	production_label.text = "Produces\n"
	for resource in facility.produced_resources:
		production_label.text += str(resource) + " ... " + str(facility.produced_resources[resource])
	production_label.text = production_label.text.to_upper()
	
	actions_label.text = "Options:\n"
	for option in facility.selection_options:
		actions_label.text += "- " + option.name() + "\n"
	actions_label.text = actions_label.text.to_upper()

func enter(previous_state_path: String = "", data := {}) -> void:
	$Control.visible = true

func exit() -> void:
	$Control.visible = false
