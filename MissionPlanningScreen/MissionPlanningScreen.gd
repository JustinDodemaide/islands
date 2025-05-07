extends Node3D

# Initially, populate the podiums with the most ideal soldiers
# Clicking an occupied podium gives a prompt with the options Customize or Remove. Pressing remove clears the pedestal



var MAX_SQUAD_MEMBERS:int = 5
var podiums:Array[Podium]

func _ready() -> void:
	var podium_scene = preload("res://MissionPlanningScreen/Podium/Podium.tscn")
	for i in MAX_SQUAD_MEMBERS:
		var podium:Podium = podium_scene.instantiate()
		podiums.append(podium)
	$Camera3D.current = true
