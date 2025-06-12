extends Node3D
class_name Island

var id:String

var HEIGHT = 100
var WIDTH = 100
var tiles = []
var facilities:Array[Facility] = []

var _all_resource_production:Dictionary = {}

func new():
	id = str(randi())
	_generate()

class IslandTile:
	var pos:Vector3
	func _init(pos:Vector3) -> void:
		self.pos = pos

func _generate():
	# Very unoptimized bu not going to fix it until it becomes a problem
	# Make the island's terrain
	var center_x = WIDTH / 2
	var center_z = HEIGHT / 2
	var center = Vector3(center_x,0,center_z)
	var radius = 50
	
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.set_frequency(0.05)
	randomize()
	noise.seed = randi()
	
	var potential_facility_positions:Dictionary[Vector3, int] = {}
	
	for theta in 360:
		for r in radius:
			if r == radius - 1:
				r += randi_range(-3,3)
				# This adds some randomness to the edges of the island to
				# make it look more natural
			var x = round(r * cos(deg_to_rad(theta)))
			var z = round(r * sin(deg_to_rad(theta)))
			var y = abs(noise.get_noise_2dv(Vector2(x,z)))
			var pos = Vector3(x, y, z)
			var tile = IslandTile.new(pos)
			tiles.append(tile)
			
			potential_facility_positions[pos] = 0
	
	# Place the facilities
	var facility_buffer_size = 24
	var num_facilities = 10
	for i in num_facilities:
		var pos:Vector3 = potential_facility_positions.keys().pick_random()
		var facility = preload("res://Facility/PowerPlant/PowerPlant.tscn").instantiate()
		facilities.append(facility)
		facility.island_pos = pos + Vector3(0, 1, 0)
		
		for width in range(-facility_buffer_size,facility_buffer_size):
			for height in range(-facility_buffer_size,facility_buffer_size):
				var buffer_pos:Vector3 = Vector3(width, 0, height) + facility.island_pos
				potential_facility_positions.erase(buffer_pos)

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
