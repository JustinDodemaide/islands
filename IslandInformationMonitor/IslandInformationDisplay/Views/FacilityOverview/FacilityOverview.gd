extends State

var facilitiy_selected = false
@export var name_label:Label
@export var faction_label:Label
@export var production_label:Label
@export var actions_label:Label

func _ready() -> void:
	SignalBus.facility_selected.connect(facility_selected)
	SignalBus.facility_deselected.connect(facility_deselected)
	SignalBus.facility_updated.connect(facility_selected)

func facility_selected(facility:Facility):
	facilitiy_selected = true
	if get_parent().get_parent().state == self:
		$"No facility selected".visible = false
		$Control.visible = true
	
	name_label.text = facility.name().to_upper()
	
	if facility.is_occupied_by_player:
		faction_label.text = "OCCUPIED BY PLAYER"
	else:
		faction_label.text = "OCCUPIED BY OPPONENT"
	faction_label.text = faction_label.text.to_upper()
	
	production_label.text = "Produces\n"
	for resource in facility.production:
		production_label.text += str(Item.RESOURCE_CATEGORIES.keys()[resource]) + " ... " + str(facility.production[resource])
	production_label.text = production_label.text.to_upper()
	
	actions_label.text = "Options:\n"
	for option in facility.selection_options:
		actions_label.text += "- " + Facility.FACILITY_SELECTION_OPTIONS.keys()[option] + "\n"
	actions_label.text = actions_label.text.to_upper()

func facility_deselected():
	facilitiy_selected = true
	if get_parent().get_parent().state == self:
		$"No facility selected".visible = true
		$Control.visible = false

func enter(previous_state_path: String = "", data := {}) -> void:
	if facilitiy_selected:
		$Control.visible = true
	else:
		$"No facility selected".visible = true

func exit() -> void:
	if facilitiy_selected:
		$Control.visible = false
	else:
		$"No facility selected".visible = false
