extends Node3D

var game:Game
signal room_camera_moved(setup:String)

func game_done_initializing():
	# activate the game display and island display
	game = get_parent()
	$Monitor/IslandDisplay.init(game.active_island)

@onready var camera = $Camera3D
@export var initial_setup:String = "wide"
var current_setup:String = initial_setup
var setup_index:int = 0
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
	emit_signal("room_camera_moved", where)

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
	
	# main logic
	if event.is_action_pressed("ui_up") and setup_index < setup_order.size() - 1:
		setup_index += 1
		move_camera(setup_order[setup_index])
	if event.is_action_pressed("ui_down") and setup_index > 0:
		setup_index -= 1
		move_camera(setup_order[setup_index])
		
	if event.is_action_pressed("E"):
		pass
