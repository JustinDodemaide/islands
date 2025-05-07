extends Control

func _ready() -> void:
	SignalBus.game_update.connect(update)

func update():
	$Label.text = str(SignalBus.game.resource_pool)
