extends StateMachine

var island:Island
var monitor:MeshInstance3D

@onready var views = [
	"SubViewport/IslandInfo",
	"SubViewport/FacilityOverview",
	"SubViewport/FacilityProduction",
	"SubViewport/FacilityMission"
]
var view_index = 0

func forward():
	if view_index == views.size() - 1:
		$"../Forward".disable()
		return
	$"../Backward".enable()
	view_index += 1
	_transition(views[view_index])

func backward():
	if view_index == 0:
		$"../Backward".disable()
		return
	$"../Forward".enable()
	view_index -= 1
	_transition(views[view_index])
