extends Node3D

@export_category("Thruster Groups")

@export_group("Main")

@export
var main_thrusters : Array




# Called when the node enters the scene tree for the first time.
func _ready():
	for thruster in main_thrusters:
		thruster.placeholder()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
