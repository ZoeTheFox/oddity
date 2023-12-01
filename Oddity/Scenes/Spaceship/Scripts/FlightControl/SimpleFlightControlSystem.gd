extends Node3D

@onready
var ship_stats = %ShipStats

@onready
var main_thrusters = %Thrusters.main_thrusters

@onready
var retro_thrusters = %Thrusters.retro_thrusters

@onready
var left_thrusters = %Thrusters.left_thrusters

@onready
var right_thrusters = %Thrusters.right_thrusters

@onready
var top_thrusters = %Thrusters.top_thrusters

@onready
var bottom_thrusters = %Thrusters.bottom_thrusters

@onready
var roll_right_thrusters = %Thrusters.roll_right_thrusters

@onready
var roll_left_thrusters = %Thrusters.roll_left_thrusters

@onready
var pitch_up_thrusters = %Thrusters.pitch_up_thrusters

@onready
var pitch_down_thrusters = %Thrusters.pitch_down_thrusters

@onready
var yaw_right_thrusters = %Thrusters.yaw_right_thrusters

@onready
var yaw_left_thrusters = %Thrusters.yaw_left_thrusters

@export_category("Flight Control Settings")

@export
var flight_assist : bool

@export_group("Accelleration or Speed")

@export
var is_forwards_axis_based_on_speed : bool

@export
var is_lateral_axis_based_on_speed : bool

@export
var is_vertical_axis_based_on_speed : bool

var movement_vector : Vector3
var rotation_vector : Vector3

var velocity : Vector3
var acceleration : Vector3
var local_angular_velocity : Vector3


signal output(output_thrusters : Dictionary)

signal output_thrust_vector(thrust_vector : Vector3)
signal output_torque_vector(torque_vector : Vector3)

var thrust_vector : Vector3
var torque_vector : Vector3

var output_thrusters : Dictionary

@export
var max_velocity : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	output_thrusters.clear()
	
	thrust_vector = Vector3.ZERO
	torque_vector = Vector3.ZERO
	
	# Lateral Axis
	
	# right
	
	if (movement_vector.x == 0 and flight_assist):
		if (velocity.x < 0):
			move_ship_right(1)
		elif (velocity.x > 0):
			move_ship_left(1)
	
	if (movement_vector.x > 0):
		move_ship_right(movement_vector.x)
	# left
	if (movement_vector.x < 0):
		move_ship_left(-movement_vector.x)
	
	print(thrust_vector)
	
	output_thrust_vector.emit(thrust_vector)
	output_torque_vector.emit(torque_vector)

func move_ship_left(thrust_percentage : float):
	for t in right_thrusters:
		output_thrusters[t] = thrust_percentage
		thrust_vector.x = %Thrusters.right_thrust_force * -thrust_percentage

func move_ship_right(thrust_percentage : float):
	for t in left_thrusters:
		output_thrusters[t] = thrust_percentage
		thrust_vector.x = %Thrusters.left_thrust_force * thrust_percentage

func calculate_desired_velocity(percentage : float) -> float:
	return abs(percentage) * max_velocity

func _on_player_input_send_movement_vector(movement_vector):
	self.movement_vector = movement_vector


func _on_player_input_send_rotation_vector(rotation_vector):
	self.rotation_vector = rotation_vector


func _on_fighter_gen_7_output_acceleration(acceleration):
	self.acceleration = acceleration


func _on_fighter_gen_7_output_velocity(velocity):
	self.velocity = velocity


func _on_fighter_gen_7_output_local_angular_velocity(local_angular_velocity):
	self.local_angular_velocity = local_angular_velocity
