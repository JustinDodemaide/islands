extends Node3D

var enabled:bool = false
var option:Facility.FACILITY_SELECTION_OPTIONS

func set_option(option:Facility.FACILITY_SELECTION_OPTIONS, disabled = false) -> void:
	self.option = option
	$Label3D.text = Facility.FACILITY_SELECTION_OPTIONS.keys()[option]
	if not disabled:
		enable()

func reset() -> void:
	$Label3D.text = ""
	self.option = -1
	disable()

func enable():
	enabled = true
	$button/Area3D/CollisionShape3D.disabled = false
	var display_material = $ApparatusUnitButton/Cube.mesh.surface_get_material(1)
	var emission_multiplier = 2.5
	var tween = create_tween()
	tween.tween_property(display_material,"emission_energy_multiplier",emission_multiplier,1).set_trans(Tween.TRANS_CUBIC)

func disable():
	enabled = false
	$button/Area3D/CollisionShape3D.disabled = true
	var display_material = $ApparatusUnitButton/Cube.mesh.surface_get_material(1)
	var tween = create_tween()
	tween.tween_property(display_material,"emission_energy_multiplier",0.0,1).set_trans(Tween.TRANS_CUBIC)

#region HOVER
var hovered:bool = false
const LIGHT_ENERGY = 0.1
func _on_area_3d_mouse_entered() -> void:
	if not enabled:
		return
	hovered = true
	_hovered()

func _on_area_3d_mouse_exited() -> void:
	if not enabled:
		return
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
	var tween = create_tween()
	var time = 0.5
	tween.tween_property($OmniLight3D, "light_energy", 0.0, time)
	await tween.finished
	$OmniLight3D.visible = false

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
	if not enabled:
		return
	var tween = create_tween()
	tween.tween_property($button,"position",button_pressed_pos,0.1)
	await tween.finished
	var tween2 = create_tween()
	tween2.tween_property($button,"position",button_initial_pos,0.1)
	
	
	get_parent().facility.option_selected(option)
