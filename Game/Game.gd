extends Node
class_name Game

const save_file_name = "save" # PLACEHOLDER
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

func save():
	# game details
	var game_save_file = FileAccess.open("user://Games" + save_file_name + ".save", FileAccess.WRITE)
	game_save_file.store_line(JSON.stringify(resource_amounts))
	game_save_file.store_line(JSON.stringify(resource_production))
	
	var islands_ids = []
	# save islands
	for island in islands:
		islands_ids.append(island.id)
		island.save()
	game_save_file.store_line(JSON.stringify(islands_ids))

func load_from_file(filename:String) -> void:
	if not FileAccess.file_exists("user://" + filename + ".save"):
		return
	
	var save_file = FileAccess.open("user://" + filename + ".save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
	
		# Creates the helper class to interact with JSON.
		var json = JSON.new()
	
		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		var node_data = json.data
