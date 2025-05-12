extends Node3D

var on = true

var hovered = false
var red = Color(0.894, 0.231, 0.267)
var green = Color(0.243, 0.537, 0.282)

func _ready() -> void:
	# "Make Unique" in the editor wasn't working, so we do it manually
	var current_material = $On_OffButton.get_surface_override_material(0)
	if current_material:
		var unique_material = current_material.duplicate()
		$On_OffButton.set_surface_override_material(0, unique_material)

func _on_area_3d_mouse_entered() -> void:
	print(name + " hovered")
	hovered = true

func _on_area_3d_mouse_exited() -> void:
	hovered = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		if hovered:
			if on:
				turn_off()
			else:
				turn_on()

func turn_off():
	on = false
	$On_OffButton.get_surface_override_material(0).albedo_color = red
	$On_OffButton.get_surface_override_material(0).emission = red
	$On_OffButton/OmniLight3D.light_color = red
	$IslandDisplay.visible = false

func turn_on():
	on = true
	$On_OffButton.get_surface_override_material(0).albedo_color = green
	$On_OffButton.get_surface_override_material(0).emission = green
	$On_OffButton/OmniLight3D.light_color = green
	$IslandDisplay.visible = true
