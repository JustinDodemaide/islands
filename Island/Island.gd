extends Node3D
class_name Island

var id:String

var HEIGHT = 100
var WIDTH = 100
var tiles = {}
var facilities:Array[Facility] = []

var _all_resource_production:Dictionary = {}

func new():
	id = str(randi())
	_generate()

class IslandTile:
	var pos:Vector2
	var altitude:float
	func _init(pos:Vector2, altitude:float) -> void:
		self.pos = pos
		self.altitude = altitude

func _generate():
	# Make the island's terrain
	var center_x = WIDTH / 2
	var center_y = HEIGHT / 2
	var center = Vector2(center_x,center_y)
	var radius = 5
	
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.set_frequency(0.05)
	randomize()
	noise.seed = randi()
	var altidudes = []
	
	for theta in 360:
		for r in radius:
			if r == radius - 1:
				r += randi_range(-3,3)
				# This adds some randomness to the edges of the island to
				# make it look more natural
			var x = round(radius * cos(theta))
			var y = round(radius * sin(theta))
			var pos = Vector2(x,y) + center
			var altitude = abs(noise.get_noise_2dv(pos))
			print(altitude)
			
			var tile = IslandTile.new(pos, altitude)
			tiles[tile] = pos
		
	# Place the facilities
	var num_facilities = 1
	for i in num_facilities:
		var tile = tiles.keys().pick_random()
		var facility = preload("res://Facility/PowerPlant/PowerPlant.tscn").instantiate()
		facilities.append(facility)
		pass

func save() -> void:
	var island_save_dictionary = {
		"facility_ids":[]
	}
	 
	# facilities ids
	for facility in facilities:
		island_save_dictionary["facility_ids"].append(facility.id)
		facility.save()
		
	var island_save_file = FileAccess.open("user://Island" + id + ".save", FileAccess.WRITE)
	island_save_file.store_line(JSON.stringify(island_save_dictionary))

func load_from_id(id:String) -> void:
	self.id = id
	var save_dictionary = SignalBus.retrieve_dictionary_from_file("Island" + id)
	

	for facility in facilities:
		for resource in facility.produced_resources:
			var production = facility.produced_resources[resource]
			if _all_resource_production.has(resource):
				_all_resource_production[resource] += production
			else:
				_all_resource_production[resource] = production
