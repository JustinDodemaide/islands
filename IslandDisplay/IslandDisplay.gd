extends Sprite3D
class_name IslandDisplay

var enabled = false

func init(island:Island):
	var terrain_mesh = make_3d_model(island)
	$SubViewport.add_child(terrain_mesh)
	enable()

func make_3d_model(island) -> MeshInstance3D:
	#return load("res://IslandDisplay/placeholder.tscn").instantiate()
	
	var tile_to_feet_ratio = 12
	# Create the mesh for the island
	if island.tiles.is_empty():
		return null
	
	# Create mesh data
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	# Create a mapping of positions to vertex indices
	var position_to_index = {}
	var index = 0
	
	# First pass: add all vertices and map their positions to indices
	for pos in island.tiles.keys():
		var x = pos.x
		var y = pos.y
		var altitude = island.tiles[pos].altitude
		
		st.set_uv(pos * tile_to_feet_ratio)
		st.add_vertex(Vector3(x, altitude, y) * tile_to_feet_ratio)
		position_to_index[pos] = index
		index += 1
	
	# Second pass: create triangles only where all required vertices exist
	for x in island.WIDTH:
		for y in island.HEIGHT:
			var pos00 = Vector2(x, y)
			var pos10 = Vector2(x + 1, y)
			var pos01 = Vector2(x, y + 1)
			var pos11 = Vector2(x + 1, y + 1)
			
			# Only create a quad if all four corners exist
			if position_to_index.has(pos00) and position_to_index.has(pos10) and \
			   position_to_index.has(pos01) and position_to_index.has(pos11):
				
				# First triangle
				st.add_index(position_to_index[pos00])
				st.add_index(position_to_index[pos10])
				st.add_index(position_to_index[pos01])
				
				# Second triangle
				st.add_index(position_to_index[pos10])
				st.add_index(position_to_index[pos11])
				st.add_index(position_to_index[pos01])
	
	# Material
	st.set_material(preload("res://IslandDisplay/placeholder.tres"))
	
	# Generate normals and assign mesh
	var mesh_instance = MeshInstance3D.new()
	st.generate_normals()
	mesh_instance.mesh = st.commit()
	
	mesh_instance.rotation_degrees = Vector3(90,0,0)
	mesh_instance.position = Vector3(0,0,0)
	return mesh_instance

func enable():
	enabled = true
	visible = true

func disabled():
	enabled = false
	visible = false

func _process(delta: float) -> void:
	if not enabled:
		return
	handle_camera(delta)
	handle_raycast()

@export var raycast:RayCast3D
@export var hover_indicator:Label3D
var hovered_facility:Facility
func handle_raycast():
	var collider = raycast.get_collider()
	if collider == null:
		hovered_facility = null
		facility_unhovered()
		return 
	if collider.get_parent() == hovered_facility:
		# only change things if a new facility is hovered over
		# otherwise it'll do the same thing over and over
		return
	hovered_facility = collider.get_parent()
	new_facility_hovered()

func new_facility_hovered():
	hover_indicator.visible = true
	hover_indicator.position = hovered_facility.position
	#hover_indicator.position.y = camera.position.y - 100

func facility_unhovered():
	pass
	#hover_indicator.visible = false

#region Camera

var receiving_input:bool = false
@export var camera:Camera3D
var camera_speed = 100
var upper_bound = 100
var lower_bound = -100
var right_bound = 100
var left_bound = -100

func _on_room_camera_moved(setup: String) -> void:
	if setup == "monitor1" or setup == "selection_apparatus":
		receiving_input = true
	else:
		receiving_input = false

func handle_camera(delta):
	if not receiving_input:
		return
	
	var input_dir = Vector2.ZERO
	
	# Get input direction
	if Input.is_action_pressed("S"):
		input_dir.z += 1  # Down
	if Input.is_action_pressed("W"):
		input_dir.z -= 1  # Up
	if Input.is_action_pressed("A"):
		input_dir.x -= 1  # Left
	if Input.is_action_pressed("D"):
		input_dir.x += 1  # Right
	
	# Normalize input if we're moving diagonally
	if input_dir.length() > 1:
		input_dir = input_dir.normalized()
	
	# Apply movement
	if input_dir != Vector2.ZERO:
		# Move up/down (z-axis)
		if input_dir.z != 0:
			var new_z = camera.position.z + input_dir.z * camera_speed * delta
			camera.position.z = clamp(new_z, lower_bound, upper_bound)
		
		# Move left/right (x-axis) - FIX: negate the input_dir.x to correct the inversion
		if input_dir.x != 0:
			var new_x = camera.position.x + (-input_dir.x) * camera_speed * delta
			camera.position.x = clamp(new_x, left_bound, right_bound)

var zoom = 0 # 0 is most zoomed out
func zoom_out():
	pass
#endregion
