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
	move_joystick("")

func move_joystick(direction):
	match direction:
		"forward":
			joystick.rotation_degrees = Vector3(0,0,0)
		"backward":
			joystick.rotation_degrees = Vector3(0,0,-45)
		"left":
			joystick.rotation_degrees = Vector3(21.6,-12.1,-30)
		"right":
			joystick.rotation_degrees = Vector3(-26.9,11.9,-30)
		_:
			joystick.rotation_degrees = Vector3(0,0,-30)
