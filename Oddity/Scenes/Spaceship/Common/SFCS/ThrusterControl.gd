extends RigidBody3D

var velocity : Vector3
var local_angular_velocity : Vector3
var velocity_last_frame : Vector3
var acceleration : Vector3

signal output_velocity(velocity : Vector3)
signal output_acceleration(acceleration : Vector3)
signal output_local_angular_velocity(local_angular_velocity : Vector3)

func _process(delta):
	calc_accelleration()
	calc_local_velocity()
	calc_local_angular_velocity()

	output_acceleration.emit(acceleration)
	output_velocity.emit(velocity)
	output_local_angular_velocity.emit(local_angular_velocity)
	
	#print(mass)
	
func calc_accelleration():
	acceleration = (snapped(velocity, Vector3(0.1, 0.1, 0.1)) - snapped(velocity_last_frame, Vector3(0.1, 0.1, 0.1))) / get_process_delta_time();
	velocity_last_frame = velocity

func calc_local_velocity():
	velocity = transform.basis.inverse() * linear_velocity

func calc_local_angular_velocity():
	local_angular_velocity = transform.basis.inverse() * angular_velocity

func _on_simple_flight_control_system_output_thrust_vector(thrust_vector):
	if ($"Components/Fuel Tanks".current_fuel_capacity > 0):
		apply_central_force(thrust_vector * global_basis.inverse() * %"Components/Fuel Tanks".current_active_fuel_tank.fuel_quality) 

func _on_simple_flight_control_system_output_torque_vector(torque_vector):
	if ($"Components/Fuel Tanks".current_fuel_capacity > 0):
		apply_torque(torque_vector * global_basis.inverse() * %"Components/Fuel Tanks".current_active_fuel_tank.fuel_quality)


func _on_simple_flight_control_system_output_unit_thrust_vector(thrust_vector):
	var fuel_consumption = 0.0
	
	if (thrust_vector.z > 0):
		fuel_consumption += %Thrusters.retro_thrust_fuel_consumption * thrust_vector.z
	else:
		fuel_consumption += %Thrusters.main_thrust_fuel_consumption * -thrust_vector.z

	if (thrust_vector.x > 0):
		fuel_consumption += %Thrusters.left_thrust_fuel_consumption * thrust_vector.x
	else:
		fuel_consumption += %Thrusters.right_thrust_fuel_consumption * -thrust_vector.x

	if (thrust_vector.y > 0):
		fuel_consumption += %Thrusters.bottom_thrust_fuel_consumption * thrust_vector.y
	else:
		fuel_consumption += %Thrusters.top_thrust_fuel_consumption * -thrust_vector.y
	
	fuel_consumption = snappedf(fuel_consumption, 0.1)
	
	$"Components/Fuel Tanks".use_fuel(fuel_consumption)

func _on_simple_flight_control_system_output_unit_torque_vector(torque_vector):
	var fuel_consumption = 0.0

	if (torque_vector.z > 0):
		fuel_consumption += %Thrusters.roll_right_thrust_fuel_consumption * torque_vector.z
	else:
		fuel_consumption += %Thrusters.roll_left_thrust_fuel_consumption * -torque_vector.z

	if (torque_vector.x > 0):
		fuel_consumption += %Thrusters.pitch_up_thrust_fuel_consumption * -torque_vector.z
	else:
		fuel_consumption += %Thrusters.pitch_down_thrust_fuel_consumption * torque_vector.z

	if (torque_vector.y > 0):
		fuel_consumption += %Thrusters.yaw_right_thrust_fuel_consumption * torque_vector.y
	else:
		fuel_consumption += %Thrusters.yaw_left_thrust_fuel_consumption * -torque_vector.y

	fuel_consumption = snappedf(fuel_consumption, 0.1)

	$"Components/Fuel Tanks".use_fuel(fuel_consumption)
