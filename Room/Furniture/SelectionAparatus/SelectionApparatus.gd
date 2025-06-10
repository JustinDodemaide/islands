extends Node3D

var facility

func _ready() -> void:
	SignalBus.facility_selected.connect(set_options)
	SignalBus.facility_deselected.connect(clear)

func set_options(facility:Facility):
	self.facility = facility
	var child_index:int = 0
	var children = get_children()
	children.reverse()
	for option in facility.selection_options:
		children[child_index].set_option(option,facility.selection_options[option])
		child_index += 1

func clear():
	facility = null
	for child in get_children():
		child.reset()
