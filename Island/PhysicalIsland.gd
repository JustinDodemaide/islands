extends Node3D

@export var camera:Camera3D

func _process(delta: float) -> void:
	$CanvasLayer/Label.text = str(Engine.get_frames_per_second())
