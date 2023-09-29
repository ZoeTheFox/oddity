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

var velocity : Vector3

var thrust_left_right: bool

var vel0 : Vector3
var acc : Vector3

var user_left: float
var user_right: float

# Called when the node enters the scene tree for the first time.
func _ready():
	thrust_multiplier = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	calc_local_velocity()
	
	if (acc.x == 0 and velocity.x < 0):
		apply_thrust(transform.basis.x, max_thrust_right, 10)
		print("scream")

	if (acc.x == 0 and velocity.x > 0):
		apply_thrust(-transform.basis.x, max_thrust_right, 10)
		print("scream")

	print(acc)

func calc_local_velocity():
	
	## https://ask.godotengine.org/123178/how-do-i-get-local-linear-velocity ##
	
	var b = transform.basis
	var v_len = linear_velocity.length()
	var v_nor = linear_velocity.normalized()

	velocity.x = b.x.dot(v_nor) * v_len
	velocity.y = b.y.dot(v_nor) * v_len
	velocity.z = b.z.dot(v_nor) * v_len

func calc_local_acceleration():
	if vel0:
		acc = (velocity - vel0) / get_process_delta_time()
	
	vel0 = velocity


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
