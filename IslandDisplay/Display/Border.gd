extends Control

var right_edge_pos = 640
var bottom_edge_pos = 360
var margin_size = 24

func move_lines_to_edge():
	var move_time = 1
	
	var tween = create_tween()
	tween.tween_property($top, "position", Vector2(0,0), move_time).set_trans(Tween.TRANS_CUBIC)

	var tween2 = create_tween()
	tween2.tween_property($bottom, "position", Vector2(0,bottom_edge_pos), move_time).set_trans(Tween.TRANS_CUBIC)
	
	var tween3 = create_tween()
	tween3.tween_property($right, "position", Vector2(right_edge_pos,0), move_time).set_trans(Tween.TRANS_CUBIC)
	
	var tween4 = create_tween()
	tween4.tween_property($left, "position", Vector2(0,0), 1).set_trans(Tween.TRANS_CUBIC)

func move_lines_to_margins():
	var move_time = 1
	
	var tween = create_tween()
	tween.tween_property($top, "position", Vector2(0,0), move_time).set_trans(Tween.TRANS_CUBIC)

	var tween2 = create_tween()
	tween2.tween_property($bottom, "position", Vector2(0,bottom_edge_pos - margin_size), move_time).set_trans(Tween.TRANS_CUBIC)
	
	var tween3 = create_tween()
	tween3.tween_property($right, "position", Vector2(right_edge_pos - margin_size,0), move_time).set_trans(Tween.TRANS_CUBIC)
	
	var tween4 = create_tween()
	tween4.tween_property($left, "position", Vector2(0,0), 1).set_trans(Tween.TRANS_CUBIC)
