class_name Island

var game:Game
var facilities:Array[Facility] = [
	load("res://Facility/Facility.gd").new(),
]

func _init(game:Game,file = null) -> void:
	self.game = game
	if not file:
		_generate()

func _generate():
	pass

func get_map() -> IslandMap:
	var map = load("res://IslandMap/test_map.tscn").instantiate()
	map.init(self)
	return map
