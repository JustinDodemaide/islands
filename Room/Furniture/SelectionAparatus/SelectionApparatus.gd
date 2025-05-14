extends Node3D

func set_options(facility:Facility):
	var child_index:int = 0
	var children = get_children()
	children.reverse()
	for option:SelectionOption in facility.selection_options:
		children[child_index].set_option(option)
		child_index += 1

func clear():
	for child in get_children():
		child.reset()
