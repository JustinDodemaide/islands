extends Node

var new_game = true
var game_id:String
var game:Game

signal game_tick

signal facility_selected(facility:Facility)


func retrieve_dictionary_from_file(filename:String) -> Dictionary:
	# keeping this in a singleton is just convenient
	# assumes the only line in the file is the save dictionary
	if not FileAccess.file_exists("user://" + filename + ".save"):
		return {"error":null}
	
	var save_file = FileAccess.open("user://" + filename + ".save", FileAccess.READ)
	var json_string = save_file.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		push_error("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
	return json.data
