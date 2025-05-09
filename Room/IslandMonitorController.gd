extends Sprite3D

var parent_ready = false

func _on_island_ready() -> void:
	# it was calling process before the export variables could get assigned
	parent_ready = true

func _process(delta: float) -> void:
	if not parent_ready:
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
	#hover_indicator.position.y = island_camera.position.y - 100

func facility_unhovered():
	hover_indicator.visible = false

#region Camera

@export var island_camera:Camera3D
var camera_speed = 1000
var upper_bound = INF
var lower_bound = -INF
var right_bound = INF
var left_bound = -INF

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
			var new_z = island_camera.position.z + input_dir.y * camera_speed * delta
			island_camera.position.z = clamp(new_z, lower_bound, upper_bound)
		
		# Move left/right (x-axis)
		if input_dir.x != 0:
			var new_x = island_camera.position.x + input_dir.x * camera_speed * delta
			island_camera.position.x = lerp(island_camera.position.x, clamp(new_x, left_bound, right_bound), 1)
#endregion
