extends Node3D

@export_category("Thruster Groups")

@export_group("Main")

@export
var main_thrusters : Array

@export_group("Retro")

@export
var retro_thrusters : Array

@export_group("Left")

@export
var left_thrusters : Array

@export_group("Right")

@export
var right_thrusters : Array

@export_group("Top")

@export
var top_thrusters : Array

@export_group("Bottom")

@export
var bottom_thrusters : Array

@export_group("Roll-Right")

@export
var roll_right_thrusters : Array

@export_group("Roll-Left")

@export
var roll_left_thrusters : Array

@export_group("Pitch-Up")

@export
var pitch_up_thrusters : Array

@export_group("Pitch-Down")

@export
var pitch_down_thrusters : Array

@export_group("Yaw-Right")

@export
var yaw_right_thrusters : Array

@export_group("Yaw-Left")

@export
var yaw_left_thrusters : Array

var main_thrust_force : float
var retro_thrust_force : float
var left_thrust_force : float
var right_thrust_force : float
var top_thrust_force : float
var bottom_thrust_force : float
var roll_right_thrust_force : float
var roll_left_thrust_force : float
var pitch_up_thrust_force : float
var pitch_down_thrust_force : float
var yaw_right_thrust_force : float
var yaw_left_thrust_force : float


# Called when the node enters the scene tree for the first time.
func _ready():
	update_thruster_force_values()
	

	

func update_thruster_force_values():
	for t in main_thrusters:
		main_thrust_force += get_thruster_force(t)

	for t in retro_thrusters:
		retro_thrust_force += get_thruster_force(t)

	for t in left_thrusters:
		left_thrust_force += get_thruster_force(t)

	for t in right_thrusters:
		right_thrust_force += get_thruster_force(t)

	for t in top_thrusters:
		top_thrust_force += get_thruster_force(t)
	
	for t in bottom_thrusters:
		bottom_thrust_force += get_thruster_force(t)

	for t in roll_right_thrusters:
		roll_right_thrust_force += get_thruster_force(t)

	for t in roll_left_thrusters:
		roll_left_thrust_force += get_thruster_force(t)

	for t in pitch_up_thrusters:
		pitch_up_thrust_force += get_thruster_force(t)

	for t in pitch_down_thrusters:
		pitch_down_thrust_force += get_thruster_force(t)

	for t in yaw_right_thrusters:
		yaw_right_thrust_force += get_thruster_force(t)

	for t in yaw_left_thrusters:
		yaw_left_thrust_force += get_thruster_force(t)

	print("Main Thrust Force: ", main_thrust_force)
	print("Retro Thrust Force: ", retro_thrust_force)
	print("Left Thrust Force: ", left_thrust_force)
	print("Right Thrust Force: ", right_thrust_force)
	print("Top Thrust Force: ", top_thrust_force)
	print("Bottom Thrust Force: ", bottom_thrust_force)
	print("Roll Right Thrust Force: ", roll_right_thrust_force)
	print("Roll Left Thrust Force: ", roll_left_thrust_force)
	print("Pitch Up Thrust Force: ", pitch_up_thrust_force)
	print("Pitch Down Thrust Force: ", pitch_down_thrust_force)
	print("Yaw Right Thrust Force: ", yaw_right_thrust_force)
	print("Yaw Left Thrust Force: ", yaw_left_thrust_force)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_thruster_force(thruster) -> float:
	return get_node(thruster).thruster_force
