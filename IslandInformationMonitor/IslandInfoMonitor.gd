extends Node3D

func _ready() -> void:
	$Backward.disable()

func _on_backward_pressed() -> void:
	$IslandInformationDisplay.backward()

func _on_forward_pressed() -> void:
	$IslandInformationDisplay.forward()
