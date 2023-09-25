extends RigidBody3D

var thrust_multiplier: float

@export
var max_thrust_main: float

@export
var max_thrust_retro: float

@export
var max_thrust_up: float

@export
var max_thrust_down: float

@export
var max_thrust_left: float

@export
var max_thrust_right: float

var acceleration: Vector3 
var v0

@export
var z: MeshInstance3D

@export
var x: MeshInstance3D

@export
var y: MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if linear_velocity.length() >= 10:
		thrust_multiplier = log(linear_velocity.length())
	else:
		thrust_multiplier = 1
		
	print(linear_velocity.length())
	
	z.scale.z = linear_velocity.z
	z.position.z = linear_velocity.z / 2.0
	
		
	x.scale.x = linear_velocity.x
	x.position.x = linear_velocity.x / 2.0
	
		
	y.scale.y = linear_velocity.y
	y.position.y = linear_velocity.y / 2.0

func _on_user_control_thrust_forwards(throttle):
	apply_thrust(-transform.basis.z, max_thrust_main, throttle)

func _on_user_control_thrust_backwards(throttle):
	apply_thrust(-transform.basis.z, max_thrust_retro, throttle)

func _on_user_control_thrust_left(throttle):
	apply_thrust(-transform.basis.x, max_thrust_left, throttle)

func _on_user_control_thrust_right(throttle):
	apply_thrust(transform.basis.x, max_thrust_right, throttle)

func _on_user_control_thrust_up(throttle):
	apply_thrust(transform.basis.y, max_thrust_main, throttle)

func _on_user_control_thrust_down(throttle):
	apply_thrust(-transform.basis.y, max_thrust_down, throttle)

func apply_thrust(direction: Vector3, force: float, throttle: float):
	apply_central_force(direction * force * (throttle / 100.0) * get_process_delta_time() * thrust_multiplier)

func _on_user_control_roll_left(percent):
	apply_torque(transform.basis.z * percent / 100.0 * 1000 * get_process_delta_time())

func _on_user_control_roll_right(percent):
	apply_torque(-transform.basis.z * percent / 100.0 * 1000 * get_process_delta_time())

func _on_user_control_pitch(percent):
	apply_torque(-transform.basis.x * percent * 1000 * get_process_delta_time())

func _on_user_control_yaw(percent):
	apply_torque(-transform.basis.y * percent * 1000 * get_process_delta_time())
