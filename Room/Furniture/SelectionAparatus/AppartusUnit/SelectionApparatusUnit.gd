extends Node3D

var option:SelectionOption

func _ready() -> void:
	# changing the emission of one changes the emission of all, so we need to make it unique
	pass
	#$option_button/Cube.mesh = $option_button/Cube.mesh.duplicate()
	$ApparatusUnitButton/Cube.mesh.surface_set_material(1, $ApparatusUnitButton/Cube.mesh.surface_get_material(1).duplicate())

func set_option(option:SelectionOption) -> void:
	self.option = option
	$Label3D.text = option.name()
	enable()

func remove_option() -> void:
	self.option = null
	disable()

func enable():
	$button/Area3D/CollisionShape3D.disabled = false
	var display_material = $ApparatusUnitButton/Cube.mesh.surface_get_material(1)
	var emission_multiplier = 5.0
	var tween = create_tween()
	tween.tween_property(display_material,"emission_energy_multiplier",emission_multiplier,2).set_trans(Tween.TRANS_BOUNCE)

func disable():
	$button/Area3D/CollisionShape3D.disabled = true
	var display_material = $option_button/Cube.mesh.surface_get_material(1)
	var tween = create_tween()
	tween.tween_property(display_material,"emission_energy_multiplier",1.0,2).set_trans(Tween.TRANS_BOUNCE)

#region HOVER
var hovered:bool = false
const LIGHT_ENERGY = 0.1
func _on_area_3d_mouse_entered() -> void:
	hovered = true
	_hovered()

func _on_area_3d_mouse_exited() -> void:
	hovered = false
	_unhovered()

func _hovered():
	hovered = true
	$OmniLight3D.visible = true
	# Having the light visible when the game started was giving me a vulkan error
	var tween = create_tween()
	var time = 1
	tween.tween_property($OmniLight3D, "light_energy", LIGHT_ENERGY, time).set_trans(Tween.TRANS_BOUNCE)

func _unhovered():
	hovered = false
	$OmniLight3D.visible = false
	var tween = create_tween()
	var time = 0.5
	tween.tween_property($OmniLight3D, "light_energy", 0.0, time)
#endregion

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		if hovered:
			press_button()
			if !option:
				return

var button_initial_pos = Vector3(0.063,0,0)
var button_pressed_pos = Vector3(0.060,0,0)
func press_button():
	var tween = create_tween()
	tween.tween_property($button,"position",button_pressed_pos,0.1)
	await tween.finished
	var tween2 = create_tween()
	tween2.tween_property($button,"position",button_initial_pos,0.1)
