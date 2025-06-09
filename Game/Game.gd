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


#region Saving and Loading
var id:String

func new_game(parameters:Dictionary):
	id = str(randi())
	
	var island = preload("res://Island/Island.gd").new()
	island.new()
	
	players.append(Player.new())
	players.append(Player.new(true))
	
	add_child(load("res://Room/Room.tscn").instantiate())
	$Room.game_done_initializing()

func continue_game(parameters:Dictionary) -> void:
	id = parameters.game_id
	
	var game_save_dictionary = SignalBus.retrieve_dictionary_from_file("Game" + id)
	print(game_save_dictionary)
	
	players.append(Player.new())
	players.append(Player.new(true))
	
	turn_index = game_save_dictionary.turn_index
	
	var island = preload("res://Island/Island.gd").new()
	island.load_from_id(game_save_dictionary.island_id)

func _on_button_pressed() -> void:
	save()
	
func save():
	var game_save_dictionary = {
		"island_id":island.id,
		"turn_index":turn_index
	}
	
	var game_save_file = FileAccess.open("user://Game" + id + ".save", FileAccess.WRITE)
	game_save_file.store_line(JSON.stringify(game_save_dictionary))
#endregion

var island:Island

var players:Array[Player] = []
var turn_index:int = 0

func next_turn():
	turn_index += 1
	if turn_index == players.size():
		turn_index = 0
	players[turn_index].turn()
