extends Node3D

@export
var course : Node3D

func _on_area_3d_body_entered(body):
	course.ship_flew_through_ring()
