extends Node3D

var facility

func set_options(facility:Facility):
	self.facility = facility
	var child_index:int = 0
	var children = get_children()
	children.reverse()
	for option:SelectionOption in facility.selection_options:
		option.update_availability(facility)
		children[child_index].set_option(option, !option.enabled)
		child_index += 1

func clear():
	facility = null
	for child in get_children():
		child.reset()
