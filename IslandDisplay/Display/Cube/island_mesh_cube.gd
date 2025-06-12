extends MeshInstance3D

var colors = [
	Color.RED,
	Color.ORANGE,
	Color.GREEN,
	Color.BLUE,
	Color.INDIGO,
	Color.VIOLET
]

func init(tile):
	position = Vector3(tile.pos.x, tile.altitude, tile.pos.y)
	randomize()
	var material = get_surface_override_material(0)
	material.albedo_color = colors.pick_random()
