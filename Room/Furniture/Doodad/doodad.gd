extends MeshInstance3D

var green = Color(0.38,0.78,0.30)
var red = Color(0.63,0.14,0.20)

var colors = {
	"green":Color(0.38,0.78,0.30),
	"red":Color(0.63,0.14,0.20)
}

func change_color(color:String):
	get_surface_override_material(0).albedo_color = colors[color]
	get_surface_override_material(0).emission = colors[color]
