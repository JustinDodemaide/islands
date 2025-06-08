extends Node3D
class_name Island

var id:String

var HEIGHT = 100
var WIDTH = 100
var tiles = {}
var facilities:Array[Facility] = []

func new():
	id = str(randi())
	_generate()

class IslandTile:
	var pos:Vector2
	var altitude:float
	func _init(pos:Vector2) -> void:
		self.pos = pos

func _generate():
	# Make the island's terrain
	var center_x = WIDTH / 2
	var center_y = HEIGHT / 2
	var radius = 5

	for y in range(HEIGHT):
		for x in range(WIDTH):
			# Calculate distance from this tile to the center
			var distance = sqrt(pow(x - center_x, 2) + pow(y - center_y, 2))
			
			# If the tile is within the radius, make it part of the island
			if distance <= radius:
				# Create a new IslandTile for this position
				var tile = IslandTile.new(Vector2(x,y))
				tiles[Vector2(x,y)] = tile
	
	# Place the facilities
	var num_facilities = 3
	for i in num_facilities:
		var tile = tiles.keys().pick_random()
		var facility = load("res://Facility/Facility.gd").new(tile)
		facilities.append(facility)

func save() -> void:
	var island_save_file = FileAccess.open("user://Island" + id + ".save", FileAccess.WRITE)
	# tiles
	island_save_file.store_line(JSON.stringify(tiles))
	# facilities
	var facility_ids = []
	for facility in facilities:
		facility_ids.append(facility.id)
		facility.save()
	island_save_file.store_line(JSON.stringify(facility_ids))

func load_from_id(id:String) -> void:
	self.id = id
	var island_save_file = FileAccess.open("user://Islands/" + id + ".save", FileAccess.READ)
