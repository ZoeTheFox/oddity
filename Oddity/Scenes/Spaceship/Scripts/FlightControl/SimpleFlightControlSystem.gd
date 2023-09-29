extends RigidBody3D

var thrust_multiplier: float

signal speed_signal(speed)

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
var local_angular_velocity : Vector3
var user_throttle: float

var thrust_left: bool
var thrust_right: bool
var thrust_up: bool
var thrust_down: bool
var roll_right: bool
var roll_left: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	thrust_multiplier = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	calc_local_velocity()
	calc_local_angular_velocity()
	
	speed_signal.emit(velocity.length())
	
	if (thrust_left == false and thrust_right == false):
		
		var throttle
		
		var max_throttle = 100
		var min_throttle = 100  # Set a small minimum throttle value		 var max_throttle = 1.0   # Set the maximum throttle value
	
		throttle = clamp(1.0 - abs(velocity.x) / 15, min_throttle, max_throttle)
	
		if (velocity.x > 0):
			apply_thrust(-transform.basis.x, max_thrust_left, throttle)
		else:
			apply_thrust(transform.basis.x, max_thrust_right, throttle)
	
	if (thrust_up == false and thrust_down == false):
		
		var throttle
		
		var max_throttle = 100
		var min_throttle = 100  # Set a small minimum throttle value		 var max_throttle = 1.0   # Set the maximum throttle value
	
		throttle = clamp(1.0 - abs(velocity.y) / 15, min_throttle, max_throttle)

		if (velocity.y > 0):
			apply_thrust(-transform.basis.y, max_thrust_down, throttle)
		else:
			apply_thrust(transform.basis.y, max_thrust_up, throttle)
			
	if (roll_left == false and roll_right == false):
		
		var throttle
		
		var max_throttle = 100
		var min_throttle = 100  # Set a small minimum throttle value		 var max_throttle = 1.0   # Set the maximum throttle value
	
		throttle = clamp(1.0 - abs(local_angular_velocity.z) / 15, min_throttle, max_throttle)
		
		if (local_angular_velocity.z > 0):
			apply_torque(-transform.basis.z * throttle / 100.0 * 1000 * get_process_delta_time())
		else:
			apply_torque(transform.basis.z * throttle / 100.0 * 1000 * get_process_delta_time())

func calc_local_velocity():
	
	## https://ask.godotengine.org/123178/how-do-i-get-local-linear-velocity ##
	
	var b = transform.basis
	var v_len = linear_velocity.length()
	var v_nor = linear_velocity.normalized()

	velocity.x = b.x.dot(v_nor) * v_len
	velocity.y = b.y.dot(v_nor) * v_len
	velocity.z = b.z.dot(v_nor) * v_len
	
func calc_local_angular_velocity():
	# Get the world-space angular velocity of the rigid body
	var world_angular_velocity = angular_velocity

	# Convert the world-space angular velocity to local space
	local_angular_velocity = transform.basis.inverse() * world_angular_velocity


func _on_user_control_thrust_forwards(throttle):
	apply_thrust(-transform.basis.z, max_thrust_main, throttle)

func _on_user_control_thrust_backwards(throttle):
	apply_thrust(-transform.basis.z, max_thrust_retro, throttle)

func _on_user_control_thrust_left(throttle):
	apply_thrust(-transform.basis.x, max_thrust_left, throttle)
	thrust_left = true

func _on_user_control_thrust_right(throttle):
	apply_thrust(transform.basis.x, max_thrust_right, throttle)
	thrust_right = true

func _on_user_control_thrust_up(throttle):
	apply_thrust(transform.basis.y, max_thrust_up, throttle)
	thrust_up = true

func _on_user_control_thrust_down(throttle):
	apply_thrust(-transform.basis.y, max_thrust_down, throttle)
	thrust_down = true

func apply_thrust(direction: Vector3, force: float, throttle: float):
	apply_central_force(direction * force * (throttle / 100.0) * get_process_delta_time() * thrust_multiplier)

func _on_user_control_roll_left(percent):
	apply_torque(transform.basis.z * percent / 100.0 * 1000 * get_process_delta_time())
	roll_left = true

func _on_user_control_roll_right(percent):
	apply_torque(-transform.basis.z * percent / 100.0 * 1000 * get_process_delta_time())
	roll_right = true

func _on_user_control_pitch(percent):
	apply_torque(-transform.basis.x * percent * 1000 * get_process_delta_time())

func _on_user_control_yaw(percent):
	apply_torque(-transform.basis.y * percent * 1000 * get_process_delta_time())


func _on_user_control_no_thrust_right():
	thrust_right = false


func _on_user_control_no_thrust_left():
	thrust_left = false


func _on_user_control_throttle_signal(throttle):
	user_throttle = throttle


func _on_user_control_no_thrust_down():
	thrust_down = false


func _on_user_control_no_thrust_up():
	thrust_up = false


func _on_user_control_no_roll_right():
	roll_right = false


func _on_user_control_no_roll_left():
	roll_left = false

