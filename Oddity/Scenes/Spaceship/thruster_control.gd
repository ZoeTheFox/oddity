extends RigidBody3D

var velocity : Vector3
var local_angular_velocity : Vector3
var velocity_last_frame : Vector3
var acceleration : Vector3

signal output_velocity(velocity)
signal output_acceleration(acceleration)
signal output_local_angular_velocity(local_angular_velocity)

var output_thrusters : Dictionary

@export_range(0, 1)
var temp : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	calc_accelleration()
	calc_local_velocity()
	calc_local_angular_velocity()
	
	output_acceleration.emit(acceleration)
	output_velocity.emit(velocity)
	
	for t in output_thrusters:
		var thrust = get_node("Thrusters/" + str(t))
		
	get_node("Thrusters/" + "MainThruster").fire_thruster(temp)
		
	
func calc_accelleration():
	acceleration = (velocity - velocity_last_frame) / get_process_delta_time();
	
	velocity_last_frame = velocity

func calc_local_velocity():
	
	## https://ask.godotengine.org/123178/how-do-i-get-local-linear-velocity ##
	
	var b = transform.basis
	var v_len = linear_velocity.length()
	var v_nor = linear_velocity.normalized()

	velocity.x = b.x.dot(v_nor) * v_len
	velocity.y = b.y.dot(v_nor) * v_len
	velocity.z = b.z.dot(v_nor) * v_len

func calc_local_angular_velocity():
	local_angular_velocity = transform.basis.inverse() * angular_velocity


func _on_simple_flight_control_system_output(output_thrusters):
	self.output_thrusters = output_thrusters


func _on_simple_flight_control_system_fly_left(force):
	pass # Replace with function body.


func _on_simple_flight_control_system_fly_right(force):
	pass # Replace with function body.

#func fire_thrusters_forwards(throttle):
	#apply_local_thrust(-transform.basis.z, max_thrust_main, throttle)
	#
#func fire_thrusters_retro(throttle):
	#apply_local_thrust(-transform.basis.z, max_thrust_retro, throttle)
#
#func fire_thrusters_left(throttle):
	#apply_local_thrust(-transform.basis.x, max_thrust_left, throttle)
#
#func fire_thrusters_right(throttle):
	#apply_local_thrust(transform.basis.x, max_thrust_right, throttle)
#
#func fire_thrusters_up(throttle):
	#apply_local_thrust(transform.basis.y, max_thrust_up, throttle)
	#
#func fire_thrusters_down(throttle):
	#apply_local_thrust(-transform.basis.y, max_thrust_down, throttle)
		#
#func fire_thrusters_roll(throttle):
	#apply_local_torque(-transform.basis.z, max_roll_force, throttle)
#
#func fire_thrusters_pitch(throttle):
	#apply_local_torque(-transform.basis.x, max_pitch_force, throttle)
	#
#func fire_thrusters_yaw(throttle):
	#apply_local_torque(-transform.basis.y, max_yaw_force, throttle)
#
#func apply_local_thrust(direction : Vector3, force : float, throttle : float):
	#apply_central_force(direction * force * (throttle / 100.0) * get_process_delta_time() * thrust_multiplier)
#
#func apply_local_torque(direction : Vector3, force : float, throttle : float):
	#apply_torque(direction * (throttle / 100.0) * force * get_process_delta_time() * torque_multiplier)
