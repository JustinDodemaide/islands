extends State

@export var duplicate_label:Label
@export var grid:GridContainer

var amount_labels = {}
var production_labels = {}

func _ready() -> void:
	SignalBus.resources_changed.connect(game_tick)
	
	for resource in SignalBus.game.player_resources:
		var str = str(resource)
		var name = duplicate_label.duplicate()
		name.text = str
		grid.add_child(name)
		
		var amount = duplicate_label.duplicate()
		amount.text = str(SignalBus.game.player_resources[resource])
		grid.add_child(amount)
		amount_labels[resource] = amount
		
		var production = duplicate_label.duplicate()
		production.text = "uhh"#str(SignalBus.game.active_island.get("_all_resource_production")[resource])
		grid.add_child(production)
		production_labels[resource] = production

func enter(previous_state_path: String = "", data := {}) -> void:
	$Control.visible = true

func exit() -> void:
	$Control.visible = false

func game_tick():
	for resource in SignalBus.game.player_resources:
		amount_labels[resource].text = str(SignalBus.game.player_resources[resource])
