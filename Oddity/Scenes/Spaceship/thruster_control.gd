extends RigidBody3D

var velocity : Vector3
var local_angular_velocity : Vector3
var velocity_last_frame : Vector3
var acceleration : Vector3

signal output_velocity(velocity : Vector3)
signal output_acceleration(acceleration : Vector3)
signal output_local_angular_velocity(local_angular_velocity : Vector3)

var output_thrusters : Dictionary

@export
var gravity : float

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
	output_local_angular_velocity.emit(local_angular_velocity)
	
	#print("velo: " + str(linear_velocity))
	#print("Velocity: " + str(velocity))
	#print(acceleration)
	var down = Vector3.DOWN
	#apply_central_force(Vector3.DOWN * -gravity)
	
	for t in output_thrusters:
		var thrust = get_node("Thrusters/" + str(t))
		#thrust.fire_thruster(output_thrusters[t])
	
	#print(output_thrusters)	
	
func calc_accelleration():
	acceleration = (snapped(velocity, Vector3(0.1, 0.1, 0.1)) - snapped(velocity_last_frame, Vector3(0.1, 0.1, 0.1))) / get_process_delta_time();
	
	print("acceleration: " + str(acceleration))
	
	velocity_last_frame = velocity

func calc_local_velocity():
	#print("basis " + str(global_transform.basis.inverse()))
	
	velocity = transform.basis.inverse() * linear_velocity

	# Now, local_velocity.x, local_velocity.y, and local_velocity.z represent the velocity along the ship's local x, y, and z axes respectivel

	### https://ask.godotengine.org/123178/how-do-i-get-local-linear-velocity ##
	#
	#var b = transform.basis
	#var v_len = linear_velocity.length()
	#var v_nor = linear_velocity.normalized()
#
	#velocity.x = b.x.dot(v_nor) * v_len
	#velocity.y = b.y.dot(v_nor) * v_len
	#velocity.z = b.z.dot(v_nor) * v_len

func calc_local_angular_velocity():
	local_angular_velocity = transform.basis.inverse() * angular_velocity


func _on_simple_flight_control_system_output(output_thrusters):
	self.output_thrusters = output_thrusters

func apply_local_thrust(direction : Vector3, force : float, throttle : float):
	apply_central_force(direction * force * (throttle / 100.0) * get_process_delta_time())

func apply_local_torque(direction : Vector3, force : float, throttle : float):
	apply_torque(direction * (throttle / 100.0) * force * get_process_delta_time())


func _on_simple_flight_control_system_output_thrust_vector(thrust_vector):
	thrust_vector = thrust_vector * global_basis.inverse()
	
	print("Real Thrust" + str(thrust_vector))
	
	apply_central_force(thrust_vector) # Replace with function body.


func _on_simple_flight_control_system_output_torque_vector(torque_vector):
	apply_torque(torque_vector * global_basis.inverse())
