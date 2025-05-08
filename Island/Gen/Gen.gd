extends TileMapLayer
var height = 100
var width = 100
const WATER_LEVEL = 1
var tile_scale = 12
var height_scale = 3#tile_scale / 2

func generate() -> void:
	terrain()

func terrain():
	var noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.frequency = 0.005
	for row in height:
		for col in width:
			var tile = Vector2i(row,col)
			var atlas = noise.get_noise_2dv(tile)
			atlas = abs(atlas)
			atlas = round(atlas * 20)
			# print(atlas)
			#if atlas <= WATER_LEVEL:
			#    atlas = WATER
			_s(self,tile,atlas)
	mesh()

func mesh():
	var used_cells = get_used_cells()  # 0 is the layer index
	if used_cells.is_empty():
		return
	
	# Find bounds of the tilemap
	var min_x = INF
	var max_x = -INF
	var min_y = INF
	var max_y = -INF
	
	for cell in used_cells:
		min_x = min(min_x, cell.x)
		max_x = max(max_x, cell.x)
		min_y = min(min_y, cell.y)
		max_y = max(max_y, cell.y)
	
	var width = max_x - min_x + 1
	var height = max_y - min_y + 1
	
	# Create mesh data
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	# Generate vertices grid
	for x in range(width + 1):
		for y in range(height + 1):
			var world_x = min_x + x
			var world_y = min_y + y
			var depth = _g(self, Vector2i(world_x, world_y))
			
			st.set_uv(Vector2(x,y) * tile_scale)
			# Add vertex - scale x and z by tile_size
			st.add_vertex(Vector3(x * tile_scale, depth * height_scale, y * tile_scale))
	
	# Create triangles by connecting vertices
	for x in range(width):
		for y in range(height):
			var i00 = y * (width + 1) + x
			var i10 = y * (width + 1) + x + 1
			var i01 = (y + 1) * (width + 1) + x
			var i11 = (y + 1) * (width + 1) + x + 1
			
			# First triangle
			st.add_index(i00)
			st.add_index(i10)
			st.add_index(i01)
			
			# Second triangle
			st.add_index(i10)
			st.add_index(i11)
			st.add_index(i01)
	
	# Material
	st.set_material(load("res://Island/Gen/material.tres"))
	
	# Generate normals and assign mesh
	var mesh_instance = MeshInstance3D.new()
	st.generate_normals()
	mesh_instance.mesh = st.commit()
	
	# StaticBody
	var collision_shape = CollisionShape3D.new()
	var concave_shape = ConcavePolygonShape3D.new()
	var mesh_data = mesh_instance.mesh.get_faces()
	concave_shape.set_faces(mesh_data)
	collision_shape.shape = concave_shape
	
	var static_body = StaticBody3D.new()
	static_body.add_child(collision_shape)
	mesh_instance.add_child(static_body)

	get_parent().add_child.call_deferred(mesh_instance)

func _get_average_neighbor_depth(pos: Vector2i) -> float:
	var neighbors = [
		Vector2i(pos.x + 1, pos.y),
		Vector2i(pos.x - 1, pos.y),
		Vector2i(pos.x, pos.y + 1),
		Vector2i(pos.x, pos.y - 1)
	]

	var total_depth = 0.0
	var count = 0

	for neighbor in neighbors:
		var cell_data = get_cell_source_id(neighbor)
		if cell_data != -1:
			var tile_data = _g(self, neighbor)
			total_depth += float(tile_data)
			count += 1

	if count > 0:
		return total_depth / count
	else:
		return 0.0  # Default depth if no neighbors found



func _s(which:TileMapLayer,where:Vector2i,atlas:int):
	which.set_cell(where,0,Vector2i(atlas,0))

func _g(which,where):
	return which.get_cell_atlas_coords(where).x

func is_water(tile:Vector2i) -> bool:
	if get_cell_atlas_coords(tile).x <= WATER_LEVEL:
		return true
	return false

func tile_to_local(tile:Vector2i):
	var x = tile.x * tile_scale
	var z = tile.y * tile_scale
	var height = _g(self, tile) * height_scale
	var pos = Vector3(x,height,z)
	return pos
