extends Node3D

@export_category("Thruster Capacity")

@export
var thruster_force : float

@onready
var thrust_position = Vector3.ZERO

@onready
var thrust_vector = Vector3(0, 0, -thruster_force)

func _ready():
	#print(thrust_vector)
	
	thrust_vector = thrust_vector.rotated(Vector3(1,0,0), rotation.x)
	thrust_vector = thrust_vector.rotated(Vector3(0,1,0), rotation.y)
	thrust_vector = thrust_vector.rotated(Vector3(0,0,1), rotation.z)
	
	#print(thrust_vector)
	#print(thrust_vector.length())
