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
	
	island = preload("res://Island/Island.gd").new()
	island.new()
	
	setup_complete()


func continue_game(parameters:Dictionary) -> void:
	id = parameters.game_id
	
	var game_save_dictionary = SignalBus.retrieve_dictionary_from_file("Game" + id)
	print(game_save_dictionary)
	
	island = preload("res://Island/Island.gd").new()
	island.load_from_id(game_save_dictionary.island_id)
	
	player_resources = game_save_dictionary.player_resources
	opponent_resources = game_save_dictionary.opponent_resources
	
	setup_complete()

func setup_complete():
	SignalBus.player_turn_ended.connect(next_turn)
	room = load("res://Room/Room.tscn").instantiate()
	add_child(room)
	$Room.game_done_initializing()

func _on_button_pressed() -> void:
	save()

func save():
	var game_save_dictionary = {
		"island_id":island.id,
		"player_resources":player_resources,
		"opponent_resources":opponent_resources,
	}
	
	var game_save_file = FileAccess.open("user://Game" + id + ".save", FileAccess.WRITE)
	game_save_file.store_line(JSON.stringify(game_save_dictionary))
#endregion

var room
var island:Island

var player_turn:bool = true

var player_resources = {
	Item.RESOURCE_CATEGORIES.ELECTRICITY:0
}

var opponent_resources = {
	Item.RESOURCE_CATEGORIES.ELECTRICITY:0
}

func next_turn():
	distribute_resources()
	player_turn = not player_turn
	if not player_turn:
		room.move_camera("island")
		ai_decision()

func distribute_resources():
	for facility in island.facilities:
		for resource in facility.produced_resources:
			if facility.is_occupied_by_player:
				player_resources[resource] += facility.produced_resources[resource]
			else:
				opponent_resources[resource] += facility.produced_resources[resource]
	SignalBus.emit_signal("resources_changed")

func ai_decision():
	var tween = create_tween()
	tween.tween_interval(2)
	await tween.finished
	next_turn()
