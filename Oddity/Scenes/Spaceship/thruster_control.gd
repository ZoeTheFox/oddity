extends RigidBody3D

var velocity : Vector3
var local_angular_velocity : Vector3
var velocity_last_frame : Vector3
var acceleration : Vector3

signal output_velocity(velocity)
signal output_acceleration(acceleration)
signal output_local_angular_velocity(local_angular_velocity)

var output_thrusters : Dictionary

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
		apply_force(thrust.thrust_vector * output_thrusters[t], thrust.thrust_position)
		
	
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
