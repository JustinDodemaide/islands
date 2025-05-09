extends Node3D

@onready var camera = $Camera3D
@export var initial_setup:String = "wide"
var current_setup:String = initial_setup
var setup_index:int = 1
var setup_order = ["wide","monitor1","selection_apparatus"]

const TRANSITION_TIME = 1.5

const CAMERA_POSITIONS = {
	"wide":Vector3(0.035,1.1,0.5),
	"monitor1":Vector3(0.164,0.928,-0.199),
	"selection_apparatus":Vector3(0.164,0.928,-0.199),
}

const CAMERA_ROTATIONS = {
	"wide":Vector3(-10,0.0,0.0),
	"monitor1":Vector3(0.0,-13.4,0.0),
	"selection_apparatus":Vector3(0.0,-1.7,0.0),
}

func _ready() -> void:
	camera.position = CAMERA_POSITIONS[initial_setup]
	camera.rotation_degrees = CAMERA_ROTATIONS[initial_setup]

func move_camera(where:String) -> void:
	if !setup_order.has(where):
		push_error("NO")
	if !CAMERA_POSITIONS.has(where):
		return
	if !CAMERA_ROTATIONS.has(where):
		return
	current_setup = where
	var pos_tween = create_tween()
	var rot_tween = create_tween()
	pos_tween.tween_property(camera,"position",CAMERA_POSITIONS[where],TRANSITION_TIME).set_trans(Tween.TRANS_CUBIC)
	rot_tween.tween_property(camera,"rotation_degrees",CAMERA_ROTATIONS[where],TRANSITION_TIME).set_trans(Tween.TRANS_CUBIC)

func _input(event: InputEvent) -> void:
	# Special cases
	if current_setup == "monitor1" and event.is_action_pressed("ui_left"):
		setup_index = setup_order.find("selection_apparatus")
		move_camera("selection_apparatus")
		return
	if current_setup == "selection_apparatus" and event.is_action_pressed("ui_right"):
		setup_index = setup_order.find("monitor1")
		move_camera("monitor1")
		return
		
	if event.is_action_pressed("ui_up") and setup_index < setup_order.size() - 1:
		setup_index += 1
		move_camera(setup_order[setup_index])
	if event.is_action_pressed("ui_down") and setup_index > 0:
		setup_index -= 1
		move_camera(setup_order[setup_index])
		
	if event.is_action_pressed("E"):
		pass

@onready var island_camera = $Monitor/Sprite3D/SubViewport/Island.camera
var camera_speed = 1000
var upper_bound = INF
var lower_bound = -INF
var right_bound = INF
var left_bound = -INF

func _process(delta: float) -> void:
	if current_setup != "monitor1":
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
			island_camera.position.x = clamp(new_x, left_bound, right_bound)
