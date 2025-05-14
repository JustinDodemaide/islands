extends IslandDisplayIcon
class_name FacilityIcon

var facility:Facility = load("res://Facility/Facility.gd").new(Vector2(position.x,position.z))

func init(facility:Facility) -> void:
	self.facility = facility
