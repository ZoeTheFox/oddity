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

@export
var max_pitch_velocity : float

@export
var max_yaw_velocity : float

@export
var max_roll_velocity : float

@export
var controller_curve : Curve

@export_range(-1, 1)
var spe : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	output_thrusters.clear()
	
	thrust_vector = Vector3.ZERO
	torque_vector = Vector3.ZERO
	
	# Lateral Axis
	if (flight_assist):
		var desired_velocity = 0
		var velocity_delta = 0
		var desired_thrust = 0
		
		if (is_lateral_axis_based_on_speed):
			desired_velocity = calculate_desired_velocity(movement_vector.x)
			velocity_delta = calculate_velocity_delta(velocity.x, desired_velocity)
			desired_thrust = calculate_desired_thrust(velocity_delta)
			
			if (velocity_delta > 0):
				move_ship_left(desired_thrust)
			elif (velocity_delta < 0):
				move_ship_right(desired_thrust)
	
	# forwards
	if (flight_assist):
		var desired_velocity = 0
		var velocity_delta = 0
		var desired_thrust = 0
		
		if (is_forwards_axis_based_on_speed):
			desired_velocity = calculate_desired_velocity(movement_vector.z)
			velocity_delta = calculate_velocity_delta(velocity.z, desired_velocity)
			desired_thrust = calculate_desired_thrust(velocity_delta)
			
			#print(str(desired_velocity) + " " + str(desired_thrust) + " " + str(velocity_delta))
			
			if (velocity_delta < 0):
				move_ship_forward(desired_thrust)
			elif (velocity_delta > 0):
				move_ship_backward(desired_thrust)
	
	# vertical
	if (flight_assist):
		var desired_velocity = 0
		var velocity_delta = 0
		var desired_thrust = 0
		
		if (is_vertical_axis_based_on_speed):
			desired_velocity = calculate_desired_velocity(movement_vector.y)
			velocity_delta = calculate_velocity_delta(velocity.y, desired_velocity)
			desired_thrust = calculate_desired_thrust(velocity_delta)
			
			if (velocity_delta > 0):
				move_ship_up(desired_thrust)
			elif (velocity_delta < 0):
				move_ship_down(desired_thrust)	
	
	# yaw
	
	if (flight_assist):
		var desired_velocity = 0
		var velocity_delta = 0
		var desired_thrust = 0
		
		desired_velocity = calculate_desired_angular_velocity(rotation_vector.x, max_yaw_velocity)
		velocity_delta = calculate_velocity_delta(local_angular_velocity.x, desired_velocity)
		desired_thrust = calculate_desired_thrust(velocity_delta)
		
		#print(str(desired_velocity) + " " + str(desired_thrust) + " " + str(velocity_delta))
		
		if (velocity_delta > 0):
			yaw_ship_left(desired_thrust)
		elif (velocity_delta < 0):
			yaw_ship_right(desired_thrust)	
	
	#print(thrust_vector)
	
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

func move_ship_forward(thrust_percentage : float):
	for t in main_thrusters:
		output_thrusters[t] = thrust_percentage
		thrust_vector.z = %Thrusters.main_thrust_force * thrust_percentage

func move_ship_backward(thrust_percentage : float):
	for t in retro_thrusters:
		output_thrusters[t] = thrust_percentage
		thrust_vector.z = %Thrusters.retro_thrust_force * -thrust_percentage

func move_ship_up(thrust_percentage : float):
	for t in bottom_thrusters:
		output_thrusters[t] = thrust_percentage
		thrust_vector.y = %Thrusters.bottom_thrust_force * -thrust_percentage

func move_ship_down(thrust_percentage : float):
	for t in top_thrusters:
		output_thrusters[t] = thrust_percentage
		thrust_vector.y = %Thrusters.top_thrust_force * thrust_percentage

func roll_ship_right(thrust_percentage : float):
	for t in roll_left_thrusters:
		output_thrusters[t] = thrust_percentage
		torque_vector.x += %Thrusters.roll_left_thrust_force * thrust_percentage

func roll_ship_left(thrust_percentage : float):
	for t in roll_right_thrusters:
		output_thrusters[t] = thrust_percentage
		# Adjust the roll component (x-axis) of the torque vector
		torque_vector.x -= %Thrusters.roll_right_thrust_force * thrust_percentage

func pitch_ship_up(thrust_percentage : float):
	for t in pitch_down_thrusters:
		output_thrusters[t] = thrust_percentage
		# Adjust the pitch component (y-axis) of the torque vector
		torque_vector.y += %Thrusters.pitch_down_thrust_force * thrust_percentage

func pitch_ship_down(thrust_percentage : float):
	for t in pitch_up_thrusters:
		output_thrusters[t] = thrust_percentage
		# Adjust the pitch component (y-axis) of the torque vector
		torque_vector.y -= %Thrusters.pitch_up_thrust_force * thrust_percentage

func yaw_ship_right(thrust_percentage : float):
	for t in yaw_left_thrusters:
		output_thrusters[t] = thrust_percentage
		# Adjust the yaw component (z-axis) of the torque vector
		torque_vector.z += %Thrusters.yaw_left_thrust_force * thrust_percentage

func yaw_ship_left(thrust_percentage : float):
	for t in yaw_right_thrusters:
		output_thrusters[t] = thrust_percentage
		# Adjust the yaw component (z-axis) of the torque vector
		torque_vector.z -= %Thrusters.yaw_right_thrust_force * thrust_percentage


func calculate_desired_velocity(percentage : float) -> float:
	return percentage * max_velocity

func calculate_desired_angular_velocity(percentage : float, max_angular_velocity : float) -> float:
	return percentage * max_angular_velocity;

func calculate_velocity_delta(base_velocity : float, desired_velocity : float) -> float:
	return (base_velocity - desired_velocity)

func calculate_desired_thrust(velocity_delta : float) -> float:
	var normalized_velocity_delta = clamp(abs(velocity_delta) / max_velocity, 0.0, 1.0)

	#print(normalized_velocity_delta)

	# Ermitteln des entsprechenden Werts auf der Kurve
	var thrust = controller_curve.sample(normalized_velocity_delta)

	#print(thrust)
	
	# Sicherstellen, dass der Wert zwischen 0 und 1 bleibt
	return clamp(thrust, 0.0, 1.0)

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
