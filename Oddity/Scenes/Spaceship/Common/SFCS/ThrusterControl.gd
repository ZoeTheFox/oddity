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
	
func calc_accelleration():
	acceleration = (snapped(velocity, Vector3(0.1, 0.1, 0.1)) - snapped(velocity_last_frame, Vector3(0.1, 0.1, 0.1))) / get_process_delta_time();
	velocity_last_frame = velocity

func calc_local_velocity():
	velocity = transform.basis.inverse() * linear_velocity

func calc_local_angular_velocity():
	local_angular_velocity = transform.basis.inverse() * angular_velocity

func apply_local_thrust(direction : Vector3, force : float, throttle : float):
	apply_central_force(direction * force * (throttle / 100.0) * get_process_delta_time())

func apply_local_torque(direction : Vector3, force : float, throttle : float):
	apply_torque(direction * (throttle / 100.0) * force * get_process_delta_time())


func _on_simple_flight_control_system_output_thrust_vector(thrust_vector):
	apply_central_force(thrust_vector * global_basis.inverse())

func _on_simple_flight_control_system_output_torque_vector(torque_vector):
	apply_torque(torque_vector * global_basis.inverse())
