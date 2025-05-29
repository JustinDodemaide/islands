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

var setups = {
	"wide":{
		"pos":Vector3(0.035,1.1,0.5),
		"rot":Vector3(-10,0.0,0.0),
		"up":"island_wide",
		"down":null,
		"left":"mission",
		"right":null,
	},
	"island_wide":{
		"pos":Vector3(0.135,1.104,0.26),
		"rot":Vector3(0.0,-1.7,0.0),
		"up":"island",
		"down":"wide",
		"left":null,
		"right":null,
	},
	"island":{
		"pos":Vector3(0.164,0.928,-0.199),
		"rot":Vector3(0.0,-13.4,0.0),
		"up":"island_info",
		"down":"island_wide",
		"left":"island_selection",
		"right":null,
	},
	"island_selection":{
		"pos":Vector3(0.164,0.928,-0.199),
		"rot":Vector3(0.0,-1.7,0.0),
		"up":"island_info",
		"down":"island_wide",
		"left":"mission",
		"right":"island",
	},
	"island_info":{
		"pos":Vector3(0.162,1.283,-0.167),
		"rot":Vector3(0.0,-13.1,0.0),
		"up":null,
		"down":"island",
		"left":"island_selection",
		"right":null,
	}
}

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
	if !setups.has(where):
		return
	current_setup = where
	var pos_tween = create_tween()
	var rot_tween = create_tween()
	pos_tween.tween_property(camera,"position", setups[where]["pos"], TRANSITION_TIME).set_trans(Tween.TRANS_CUBIC)
	rot_tween.tween_property(camera,"rotation_degrees", setups[where]["rot"], TRANSITION_TIME).set_trans(Tween.TRANS_CUBIC)
	emit_signal("room_camera_moved", where)

func _input(event: InputEvent) -> void:
	var direction = ""
	if event.is_action_pressed("ui_up"):
		direction = "up"
	if event.is_action_pressed("ui_down"):
		direction = "down"
	if event.is_action_pressed("ui_left"):
		direction = "left"
	if event.is_action_pressed("ui_right"):
		direction = "right"
		
	if direction == "":
		return
	if setups[current_setup][direction] == null:
		return
	move_camera(setups[current_setup][direction])


func _on_island_display_icon_selected(icon: IslandDisplayIcon) -> void:
	# Change view
	# Load options
	move_camera("selection_apparatus")
	$SelectionApparatus.set_options(icon.facility)

func _on_island_display_icon_deselected() -> void:
	$SelectionApparatus.clear()
