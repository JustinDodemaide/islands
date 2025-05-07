extends Sprite3D

@export var text:String
@export var icon:Texture2D
var _hovered:bool = false

signal pressed()

func _ready() -> void:
	$SubViewport/Button.text = text
	$SubViewport/Button.icon = icon
	$Area3D/CollisionShape3D.shape.size.x = $SubViewport/Button.size.x
	$Area3D/CollisionShape3D.shape.size.y = $SubViewport/Button.size.y


func _on_area_3d_mouse_entered() -> void:
	_hovered = true

func _on_area_3d_mouse_exited() -> void:
	_hovered = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick") and _hovered:
		emit_signal("pressed")
