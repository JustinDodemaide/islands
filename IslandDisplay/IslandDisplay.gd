extends Sprite3D

var enabled = false

func init(island:Island):
	var terrain_mesh = make_3d_model(island)
	$SubViewport.add_child(terrain_mesh)
	enable()

func make_3d_model(island) -> MeshInstance3D:
	var tile_to_feet_ratio = 1
	# Create the mesh for the island
	if island.tiles.is_empty():
		return
	
	# Create mesh data
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	# Generate vertices grid
	for x in island.WIDTH + 1:
		for y in island.HEIGHT + 1:
			var pos = Vector2(x,y)
			
			if !island.tiles.has(pos):
				continue
			var altitude = island.tiles[pos].altitude
			
			st.set_uv(pos * tile_to_feet_ratio)
			# Add vertex - scale x and z by tile_size
			st.add_vertex(Vector3(x, altitude, y) * tile_to_feet_ratio)
			print("adding vertex at ", pos)
	
	# Create triangles by connecting vertices
	for x in island.WIDTH:
		for y in island.HEIGHT:
			var i00 = y * (island.WIDTH + 1) + x
			var i10 = y * (island.WIDTH + 1) + x + 1
			var i01 = (y + 1) * (island.WIDTH + 1) + x
			var i11 = (y + 1) * (island.WIDTH + 1) + x + 1
			
			# First triangle
			st.add_index(i00)
			st.add_index(i10)
			st.add_index(i01)
			
			# Second triangle
			st.add_index(i10)
			st.add_index(i11)
			st.add_index(i01)
	
	# Material
	st.set_material(preload("res://IslandDisplay/placeholder.tres"))
	
	# Generate normals and assign mesh
	var mesh_instance = MeshInstance3D.new()
	st.generate_normals()
	mesh_instance.mesh = st.commit()
	
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

@export var camera:Camera3D
var camera_speed = 1000
var upper_bound = -1
var lower_bound = 1
var right_bound = 1
var left_bound = -1

func handle_camera(delta):
	if $"../..".current_setup != "monitor1":
		return
	
	var input_dir = Vector2.ZERO
	
	# Get input direction
	if Input.is_action_pressed("S"):
		input_dir.y += 1  # Down
	if Input.is_action_pressed("W"):
		input_dir.y -= 1  # Up
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
		if input_dir.y != 0:
			var new_z = camera.position.z + input_dir.y * camera_speed * delta
			camera.position.z = clamp(new_z, lower_bound, upper_bound)
		
		# Move left/right (x-axis)
		if input_dir.x != 0:
			var new_x = camera.position.x + input_dir.x * camera_speed * delta
			camera.position.x = lerp(camera.position.x, clamp(new_x, left_bound, right_bound), 1)

var zoom = 0 # 0 is most zoomed out
func zoom_out():
	pass
#endregion
