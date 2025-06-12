extends Sprite3D
class_name IslandDisplay

var enabled = true

func init():
	var island = SignalBus.game.island
	var terrain_mesh = _make_3d_model(island)
	$SubViewport.add_child(terrain_mesh)
	
	var icon_scene = preload("res://IslandDisplay/FacilityIcon/FacilityIcon.tscn")
	for facility in island.facilities:
		var icon = icon_scene.instantiate()
		icon.init(facility)
		icon.position = facility.island_pos
		$SubViewport.add_child(icon)
	enable()

func _make_3d_model(island) -> MultiMeshInstance3D:
	var multimesh_instance = MultiMeshInstance3D.new()
	var multimesh = MultiMesh.new()
	
	multimesh.use_colors = true
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.instance_count = island.tiles.size()
	
	var cube_mesh = BoxMesh.new()
	cube_mesh.size = Vector3(1, 1, 1)
	
	var material = preload("res://IslandDisplay/placeholder.tres")
	cube_mesh.material = material
	
	multimesh.mesh = cube_mesh
	
	var index = 0
	for tile in island.tiles:
		var transform = Transform3D()
		transform.origin = tile.pos
		multimesh.set_instance_transform(index, transform)
		
		var color = Color(0.8 + randf() * 0.2, 0.8 + randf() * 0.2, 0.8 + randf() * 0.2)
		multimesh.set_instance_color(index, color)
		
		index += 1
	
	multimesh_instance.multimesh = multimesh
	return multimesh_instance

func _make_3d_model_OLD(island) -> MeshInstance3D:
	var cube_size = 1 # 1 meter
		#var pos:Vector2
		#var altitude:float
	var model = MeshInstance3D.new()
	var cube_scene = load("res://IslandDisplay/Display/Cube/IslandMeshCube.tscn")
	for tile in island.tiles:
		var new_cube = cube_scene.instantiate()
		model.add_child(new_cube)
		new_cube.init(tile)
		$SubViewport/Camera3D.position.x = new_cube.position.x
		$SubViewport/Camera3D.position.x = new_cube.position.z

	return model

func enable():
	enabled = true
	visible = true

func disable():
	enabled = false
	visible = false

func _process(delta: float) -> void:
	if not enabled:
		return
	_handle_camera(delta)
	_handle_raycast()

@export var raycast:RayCast3D
@export var hover_indicator:Label3D
var hovered_icon:IslandDisplayIcon
func _handle_raycast():
	if not receiving_input:
		return
	if Input.is_action_pressed("E"):
		if hovered_icon:
			_icon_selected()
		else:
			$SubViewport/CanvasLayer/Border.stop_tracking()
			emit_signal("icon_deselected")
			SignalBus.emit_signal("facility_deselected")
	
	var collider = raycast.get_collider()
	if collider == null:
		if hovered_icon == null:
			return
		hovered_icon = null
		facility_unhovered()
		return
	if collider.get_parent() == hovered_icon:
		# only change things if a new facility is hovered over
		# otherwise it'll do the same thing over and over
		return
	hovered_icon = collider.get_parent()
	new_facility_hovered()

func new_facility_hovered():
	print("hovered")
	$SubViewport/CanvasLayer/Border.move_lines_to_margins()

func facility_unhovered():
	print("unhovered")
	$SubViewport/CanvasLayer/Border.move_lines_to_edge()

signal icon_selected(icon:IslandDisplayIcon)
signal icon_deselected()
func _icon_selected():
	if not $SelectionDebounce.is_stopped():
		return
	$SubViewport/CanvasLayer/Border.track(hovered_icon)
	#print("selected")
	emit_signal("icon_selected",hovered_icon)
	SignalBus.emit_signal("facility_selected",hovered_icon.facility)
	$SelectionDebounce.start(1)

#region Camera

var receiving_input:bool = false
@export var camera:Camera3D
var camera_speed = 100
var upper_bound = 100
var lower_bound = -100
var right_bound = 100
var left_bound = -100

var zoom_levels = [100,200,300]
var zoom_index = 0

func _handle_camera(delta):
	if not receiving_input:
		return
	
	if Input.is_action_pressed("X"):
		if zoom_index == 0:
			return
		zoom_index -= 1
		camera.position.y = zoom_levels[zoom_index]
	if Input.is_action_pressed("C"):
		if zoom_index == zoom_levels.size() - 1:
			return
		zoom_index += 1
		camera.position.y = zoom_levels[zoom_index]
	
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
		
		# Move left/right (x-axis) - FIX: negate the input_dir.x to correct the inversion
		if input_dir.x != 0:
			var new_x = camera.position.x + (-input_dir.x) * camera_speed * delta
			camera.position.x = clamp(new_x, left_bound, right_bound)

var zoom = 0 # 0 is most zoomed out
func _zoom_out():
	pass
#endregion
