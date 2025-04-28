extends Node3D
class_name MapIcon

var facility:Facility

var hovered:bool = false
var default_scale:Vector3 = Vector3(1,1,1)

func init(facility:Facility) -> void:
	self.facility = facility
	$Sprite3D.texture = facility.icon_image()

func _on_area_3d_mouse_entered() -> void:
	hovered = true
	focus()

func _on_area_3d_mouse_exited() -> void:
	hovered = false
	unfocus()

func focus():
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector3(1.5,1.5,1.5),1).set_trans(Tween.TRANS_ELASTIC)

func unfocus():
	var tween = create_tween()
	tween.tween_property(self,"scale",default_scale,1).set_trans(Tween.TRANS_ELASTIC)
