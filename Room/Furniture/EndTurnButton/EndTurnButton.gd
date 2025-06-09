extends Node3D

func _on_clickable_area_3d_pressed() -> void:
	SignalBus.emit_signal("player_turn_ended")
