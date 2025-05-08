extends Node3D

var option:SelectionOption
var hovered:bool = false

func set_option(option:SelectionOption) -> void:
	self.option = option
	enable()

func remove_option() -> void:
	self.option = null
	disable()

const LIGHT_ENERGY = 0.1
const MIN_LIGHT_TWEEN_TIME = 0.1
const MAX_LIGHT_TWEEN_TIME = 1.5
func enable():
	$OmniLight3D.visible = true
	var tween = create_tween()
	var time = 1 #randf_range(MIN_LIGHT_TWEEN_TIME,MAX_LIGHT_TWEEN_TIME)
	tween.tween_property($OmniLight3D, "light_energy", LIGHT_ENERGY, time).set_trans(Tween.TRANS_BOUNCE)
	#$button/Area3D/CollisionShape3D.disabled = false

func disable():
	var tween = create_tween()
	var time = 0.5 # randf_range(MIN_LIGHT_TWEEN_TIME,MAX_LIGHT_TWEEN_TIME)
	tween.tween_property($OmniLight3D, "light_energy", 0.0, time)
	await tween.finished
	$OmniLight3D.visible = false
	# $button/Area3D/CollisionShape3D.disabled = true

func _on_area_3d_mouse_entered() -> void:
	hovered = true
	enable()

func _on_area_3d_mouse_exited() -> void:
	hovered = false
	disable()

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
