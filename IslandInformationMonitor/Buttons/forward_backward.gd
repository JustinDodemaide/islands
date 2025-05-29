extends Node3D

var enabled = true
var default_emission_energy = 1

func enable():
	var tween = create_tween()
	tween.tween_property($MeshInstance3D.get_surface_override_material(0),"emission_energy_multiplier", default_emission_energy, 0.25)

func disable():
	var tween = create_tween()
	tween.tween_property($MeshInstance3D.get_surface_override_material(0),"emission_energy_multiplier",0, 0.25)

func _on_clickable_area_3d_hovered() -> void:
	var tween = create_tween()
	tween.tween_property($MeshInstance3D.get_surface_override_material(0),"emission_energy_multiplier",5, 0.25)

func _on_clickable_area_3d_unhovered() -> void:
	var tween = create_tween()
	tween.tween_property($MeshInstance3D.get_surface_override_material(0),"emission_energy_multiplier", default_emission_energy, 0.25)

func _on_clickable_area_3d_pressed() -> void:
	var tween = create_tween()
	tween.tween_property($MeshInstance3D,"position",$Marker3D.position, 0.1)
	await tween.finished
	var tween1 = create_tween()
	tween1.tween_property($MeshInstance3D,"position",Vector3.ZERO, 0.1)
