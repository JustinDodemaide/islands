extends State

@export var duplicate_label:Label
@export var grid:GridContainer

func _ready() -> void:
	for resource:String in SignalBus.game.resource_amounts:
		var name = duplicate_label.duplicate()
		name.text = resource
		grid.add_child(name)
		
		var amount = duplicate_label.duplicate()
		amount.text = str(SignalBus.game.resource_amounts[resource])
		grid.add_child(amount)
		
		var production = duplicate_label.duplicate()
		production.text = str(SignalBus.game.resource_production[resource])
		grid.add_child(production)

func enter(previous_state_path: String = "", data := {}) -> void:
	$Control.visible = true

func exit() -> void:
	$Control.visible = false
