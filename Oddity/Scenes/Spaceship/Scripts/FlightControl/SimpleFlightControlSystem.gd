extends RigidBody3D

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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
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
	apply_central_force(direction * force * (throttle / 100.0) * get_process_delta_time())

func _on_user_control_roll_left(percent):
	apply_torque(transform.basis.z * percent / 100.0 * 1000 * get_process_delta_time())

func _on_user_control_roll_right(percent):
	apply_torque(-transform.basis.z * percent / 100.0 * 1000 * get_process_delta_time())

func _on_user_control_pitch(percent):
	apply_torque(-transform.basis.x * percent * 1000 * get_process_delta_time())

func _on_user_control_yaw(percent):
	apply_torque(-transform.basis.y * percent * 1000 * get_process_delta_time())
