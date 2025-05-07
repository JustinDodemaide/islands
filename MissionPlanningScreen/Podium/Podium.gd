extends Node3D
class_name Podium

var soldier:Soldier

func _on_add_pressed() -> void:
	pass # Replace with function body.

func add_soldier(soldier:Soldier) -> void:
	self.soldier = soldier
	$UnoccupiedUI.visible = false
	$OccupiedUI.visible = true

func remove_soldier() -> void:
	soldier = null
	$UnoccupiedUI.visible = true
	$OccupiedUI.visible = true


func _on_customize_pressed() -> void:
	pass # Replace with function body.


func _on_remove_pressed() -> void:
	remove_soldier()

func _input(event: InputEvent) -> void:
	pass
	#$UnoccupiedUI/SubViewport.push_input(event)
	#$OccupiedUI/SubViewport.push_input(event)
