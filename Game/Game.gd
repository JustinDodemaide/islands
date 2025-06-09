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
	
	var num_islands = 1
	for i in num_islands:
		var island = preload("res://Island/Island.gd").new()
		island.new()
		islands.append(island)
	active_island = islands.front()
	add_child(load("res://Room/Room.tscn").instantiate())
	$Room.game_done_initializing()

func continue_game(parameters:Dictionary) -> void:
	id = parameters.game_id
	this_instances_player = players.front() # PLACEHOLDER
	
	var game_save_dictionary = SignalBus.retrieve_dictionary_from_file("Game" + id)
	print(game_save_dictionary)
	pass

func _on_button_pressed() -> void:
	save()
	
func save():
	var game_save_dictionary = {
		"island_id_list":[],
		"turn_index":turn_index
	}
	
	var islands_ids = []
	# save islands
	for island in islands:
		game_save_dictionary["island_id_list"].append(island.id)
		island.save()
	
	var game_save_file = FileAccess.open("user://Game" + id + ".save", FileAccess.WRITE)
	game_save_file.store_line(JSON.stringify(game_save_dictionary))
#endregion

var players:Array[Player] = [Player.new(), Player.new(true)]
var this_instances_player:Player
var turn_index:int = 0
var current_player:Player

func next_turn():
	pass

var islands = []
var active_island:Island

var resource_amounts = {
	"electricity":0,
}

func _on_update_timer_timeout() -> void:
	SignalBus.emit_signal("game_tick")

func game_tick():
	var all_resource_production = active_island.get("_all_resource_production")
	for resource in all_resource_production:
		resource_amounts[resource] += all_resource_production[resource]
