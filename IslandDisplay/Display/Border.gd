extends Control

# Match these to the SubViewport size
var right_edge_pos = 1024
var bottom_edge_pos = 768
var margin_size = 56

func _ready():
	# Initialize the borders at the edges
	# Make sure the right and bottom borders are properly positioned
	$right.position = Vector2(right_edge_pos - $right.size.x, 0)
	$bottom.position = Vector2(0, bottom_edge_pos - $bottom.size.y)
	
	# Set the width and height of the borders to match the viewport
	$top.size.x = right_edge_pos
	$bottom.size.x = right_edge_pos
	$left.size.y = bottom_edge_pos
	$right.size.y = bottom_edge_pos

func move_lines_to_edge():
	if is_tracking:
		return
	
	var move_time = 0.5  # Faster animation
	
	var tween = create_tween()
	tween.tween_property($top, "position", Vector2(0, 0), move_time).set_trans(Tween.TRANS_CUBIC)

	var tween2 = create_tween()
	tween2.tween_property($bottom, "position", Vector2(0, bottom_edge_pos - $bottom.size.y), move_time).set_trans(Tween.TRANS_CUBIC)
	
	var tween3 = create_tween()
	tween3.tween_property($right, "position", Vector2(right_edge_pos - $right.size.x, 0), move_time).set_trans(Tween.TRANS_CUBIC)
	
	var tween4 = create_tween()
	tween4.tween_property($left, "position", Vector2(0, 0), move_time).set_trans(Tween.TRANS_CUBIC)

func move_lines_to_margins():
	if is_tracking:
		return
	
	var move_time = 0.5
	
	var tween = create_tween()
	tween.tween_property($top, "position", Vector2(0, margin_size), move_time).set_trans(Tween.TRANS_CUBIC)

	var tween2 = create_tween()
	tween2.tween_property($bottom, "position", Vector2(0, bottom_edge_pos - $bottom.size.y - margin_size), move_time).set_trans(Tween.TRANS_CUBIC)
	
	var tween3 = create_tween()
	tween3.tween_property($right, "position", Vector2(right_edge_pos - $right.size.x - margin_size, 0), move_time).set_trans(Tween.TRANS_CUBIC)
	
	var tween4 = create_tween()
	tween4.tween_property($left, "position", Vector2(margin_size, 0), move_time).set_trans(Tween.TRANS_CUBIC)

var icon_to_track:IslandDisplayIcon = null
var is_tracking:bool = false
func track(icon:IslandDisplayIcon) -> void:
	icon_to_track = icon
	is_tracking = true

func stop_tracking() -> void:
	icon_to_track = null
	is_tracking = false
	move_lines_to_edge()

func _process(delta: float) -> void:
	var tracking_weight = 0.15
	if icon_to_track:
		var pos:Vector2 = $"../../Camera3D".unproject_position(icon_to_track.position)
		$top.position.y = lerp($top.position.y, pos.y, tracking_weight)
		$bottom.position.y = lerp($bottom.position.y, pos.y, tracking_weight)
		$left.position.x = lerp($left.position.x, pos.x, tracking_weight)
		$right.position.x = lerp($right.position.x, pos.x, tracking_weight)
