extends Node
class_name Game

# 🐵
# GameHandler - Handles starting, pausing, and closing the game. Either makes a new game save or loads a preexisting one
# Game - The game save. Handles game data (like resources, islands, soldiers, player progression), and instantiates the Room
# Room - Where all the visual elements are kept, diagetically
# Parts of the room:
#	Game display - Displays a simplified version of the archipelego, and the player stats/resources. Allows the player to choose which island they're currently focused on
#	Island display - Displays a simplified version of the current island.
#	Mission display - Displays the active Mission.
#	Do we need a dedicated display for the soldiers?
# Island - Stores respective facilities and resource production/depletion

var islands = []
var active_island: Island

var resource_amounts = {
	"electricity":0,
}

var resource_production = {
	"electricity":1,
}

func _ready() -> void:
	SignalBus.game = self
	_new()

func _new():
	# figure out the layout of the islands
	# place the islands
	var num_islands = 1
	for i in num_islands:
		var island = preload("res://Island/Island.gd").new()
		island.new()
		islands.append(island)
	active_island = islands.front()
	add_child(load("res://Room/Room.tscn").instantiate())
	$Room.game_done_initializing()

func from_file(file):
	pass
