extends Node3D


@export
var RingMarker : Node3D

var course_rings = Array()
var i = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for _i in $Rings.get_children ():
		print(_i)
		course_rings.append(_i)


func ship_flew_through_ring():

	i += 1
	print(course_rings[i])
	RingMarker.global_position = course_rings[i].global_position
	

	
	

