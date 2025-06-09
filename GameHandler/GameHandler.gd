extends Node

# Handles program functions like saving, pausing, and quitting

var game_parameters:Dictionary
var game:Game

func _ready() -> void:
	game_parameters = SignalBus.game_params # only way to get the dictionary across the scenes
	game = load("res://Game/Game.tscn").instantiate()
	SignalBus.game = game
	if game_parameters["new_game"]:
		game.new_game(game_parameters)
	else:
		game.continue_game(game_parameters)
	add_child(game)

func pause() -> void:
	pass
