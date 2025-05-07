extends Control

var facility:Facility

func init(facility:Facility) -> void:
	self.facility = facility
	var options = facility.get_selection_options()
	var option_card_scene = preload("res://SelectionOptionsMenu/SelectionOptionCard.tscn")
	for option in options:
		var card = option_card_scene.instantiate()
		card.init(option)
		card.selected.connect(option_selected)
		$MarginContainer/VBoxContainer.add_child(card)

func option_selected(option:SelectionOption):
	option.selected(facility)
	queue_free()
