extends Node
class_name Game

var id
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
var active_island:Island

var resource_amounts = {
	"electricity":0,
}

func _ready() -> void:
	SignalBus.game = self
	
	if SignalBus.new_game:
		_new()
	else:
		load_from_file()
	add_child(load("res://Room/Room.tscn").instantiate())
	$Room.game_done_initializing()
	
	SignalBus.game_tick.connect(game_tick)
	$UpdateTimer.start(1)

func _new():
	id = str(randi())
	
	# figure out the layout of the islands
	# place the islands
	var num_islands = 1
	for i in num_islands:
		var island = preload("res://Island/Island.gd").new()
		island.new()
		islands.append(island)
	active_island = islands.front()
	add_child(load("res://Room/Room.tscn").instantiate())

func save():
	var game_save_dictionary = {
		"island_id_list":[]
	}
	
	var islands_ids = []
	# save islands
	for island in islands:
		game_save_dictionary["island_id_list"].append(island.id)
		island.save()
	
	var game_save_file = FileAccess.open("user://Game" + id + ".save", FileAccess.WRITE)
	game_save_file.store_line(JSON.stringify(game_save_dictionary))

func load_from_file() -> void:
	self.id = SignalBus.game_id
	
	var game_save_dictionary = SignalBus.retrieve_dictionary_from_file("Game" + id)
	print(game_save_dictionary)
	pass
	#active_island = islands.front()

func _on_button_pressed() -> void:
	save()


func _on_update_timer_timeout() -> void:
	SignalBus.emit_signal("game_tick")

func game_tick():
	var all_resource_production = active_island.get("_all_resource_production")
	for resource in all_resource_production:
		resource_amounts[resource] += all_resource_production[resource]
