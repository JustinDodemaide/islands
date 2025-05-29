extends Node3D

var enabled = false
@export var joystick:MeshInstance3D
@export var display:IslandDisplay

func enable():
	enabled = true

func disable():
	enabled = false

func _input(event: InputEvent) -> void:
	if not enabled:
		return
	move_joystick("")
	if event.is_action_pressed("W"):
		move_joystick("forward")
		return
	if event.is_action_pressed("S"):
		move_joystick("backward")
		return
	if event.is_action_pressed("A"):
		move_joystick("left")
		return
	if event.is_action_pressed("D"):
		move_joystick("right")
		return

func move_joystick(direction):
	var lerp_time = 1
	match direction:
		"forward":
			joystick.rotation_degrees = lerp(joystick.rotation_degrees, Vector3(0,0,0), lerp_time)
		"backward":
			joystick.rotation_degrees = lerp(joystick.rotation_degrees, Vector3(0,0,-45), lerp_time)
		"left":
			joystick.rotation_degrees = lerp(joystick.rotation_degrees, Vector3(22,-12,-30), lerp_time)
		"right":
			joystick.rotation_degrees = lerp(joystick.rotation_degrees, Vector3(-27,12,-30), lerp_time)
		_:
			joystick.rotation_degrees = lerp(joystick.rotation_degrees, Vector3(0,0,-30), lerp_time)
