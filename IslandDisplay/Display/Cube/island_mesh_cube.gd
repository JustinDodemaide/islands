extends MeshInstance3D

func init(tile):
	position = Vector3(tile.pos.x, tile.altitude, tile.pos.y)
