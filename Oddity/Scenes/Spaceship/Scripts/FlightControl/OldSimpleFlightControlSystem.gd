extends RigidBody3D

var thrust_multiplier : float
var torque_multiplier : float

signal speed_signal(speed)
signal accelleration_signal(accelaration : Vector3)

@export
var max_thrust_main : float

@export
var max_thrust_retro : float

@export
var max_thrust_up : float

@export
var max_thrust_down : float

@export
var max_thrust_left : float

@export
var max_thrust_right : float

@export
var max_roll_force : float

@export
var max_pitch_force : float

@export
var max_yaw_force : float

@export
var max_roll_velocity : float

@export
var max_pitch_velocity : float

@export
var max_yaw_velocity : float

@export
var max_total_velocity : float

@export
var max_side_velocity : float

@export
var max_up_down_velocity : float

var velocity : Vector3
var local_angular_velocity : Vector3

var velocity_last_frame : Vector3
var acceleration : Vector3

var user_throttle : float
var user_pitch : float
var user_yaw : float
var user_roll : float

var thrust_left : bool
var thrust_right : bool
var thrust_up : bool
var thrust_down : bool
var roll : bool
var pitch : bool
var yaw : bool

signal fire_thrusters_main_signal(throttle)
signal fire_thrusters_retro_signal(throttle)
signal fire_thrusters_up_signal(throttle)
signal fire_thrusters_down_signal(throttle)
signal fire_thrusters_left_signal(throttle)
signal fire_thrusters_right_signal(throttle)
signal fire_thrusters_roll_left_signal(throttle)
signal fire_thrusters_roll_right_signal(throttle)
signal fire_thrusters_pitch_up_signal(throttle)
signal fire_thrusters_pitch_down_signal(throttle)
signal fire_thrusters_yaw_left_signal(throttle)
signal fire_thrusters_yaw_right_signal(throttle)

@export
var flight_assist : bool

@export
var throttle_based_on_max_speed : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	thrust_multiplier = 1
	torque_multiplier = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	calc_local_velocity()
	calc_local_angular_velocity()
	calc_accelleration()
	
	speed_signal.emit(velocity.length())
	accelleration_signal.emit(acceleration)
	
	if (thrust_left == false and thrust_right == false and flight_assist):
		var throttle = calc_throttle(velocity.x)
	
		if (velocity.x > 0):
			fire_thrusters_left(throttle)
		else:
			fire_thrusters_right(throttle)
	
	if (thrust_up == false and thrust_down == false and flight_assist):
		var throttle = calc_throttle(velocity.y)

		if (velocity.y > 0):
			fire_thrusters_down(throttle)
		else:
			fire_thrusters_up(throttle)
			
	if (throttle_based_on_max_speed):
		if (-velocity.z > calc_speed_at_percentage(user_throttle, max_total_velocity) and velocity.z < 0):
			fire_thrusters_retro(-calc_throttle(abs(velocity.z)))
			#print(str(-velocity.z) + " " + str(calc_speed_at_percentage(user_throttle, max_total_velocity)))
		elif (velocity.z > calc_speed_at_percentage(-user_throttle, max_total_velocity) and velocity.z > 0):
			fire_thrusters_forwards(calc_throttle(abs(velocity.z)))
			#print(str(velocity.z) + " " + str(calc_speed_at_percentage(-user_throttle, max_total_velocity)))
	else:
		if (user_throttle >= 0):
			var throttle = calc_throttle(velocity.z)
			
			if (velocity.z > 0):
				fire_thrusters_forwards(throttle)
	
	if (roll == false and flight_assist):
		
		var throttle = calc_torque_throttle(local_angular_velocity.z)
		
		if (local_angular_velocity.z > 0):
			fire_thrusters_roll(throttle)
		else:
			fire_thrusters_roll(-throttle)
	
	if (roll == true and flight_assist):
		
		var throttle = calc_torque_throttle(local_angular_velocity.z)
		
		if (abs(local_angular_velocity.z) > calc_speed_at_percentage(abs(user_roll), max_roll_velocity)):
			
			if (local_angular_velocity.z > 0):
				fire_thrusters_roll(throttle)
			else:
				fire_thrusters_roll(-throttle)
	
	if (yaw == false and flight_assist):
		
		var throttle = calc_torque_throttle(local_angular_velocity.y)
		
		if (local_angular_velocity.y > 0):
			fire_thrusters_yaw(throttle)
		else:
			fire_thrusters_yaw(-throttle)
	
	if (yaw == true and flight_assist):
		
		var throttle = calc_torque_throttle(local_angular_velocity.y)
		
		if (abs(local_angular_velocity.y) > calc_speed_at_percentage(abs(user_yaw), max_yaw_velocity)):
			
			if (local_angular_velocity.y > 0):
				fire_thrusters_yaw(throttle)
			else:
				fire_thrusters_yaw(-throttle)
	
	if (pitch == false and flight_assist):
		
		var throttle = calc_torque_throttle(local_angular_velocity.x)
		
		if (local_angular_velocity.x > 0):
			fire_thrusters_pitch(throttle)
		else:
			fire_thrusters_pitch(-throttle)
	
	if (pitch == true and flight_assist):
		
		var throttle = calc_torque_throttle(local_angular_velocity.x)
		
		if (abs(local_angular_velocity.x) > calc_speed_at_percentage(abs(user_pitch), max_pitch_velocity)):
			
			if (local_angular_velocity.x > 0):
				fire_thrusters_pitch(throttle)
			else:
				fire_thrusters_pitch(-throttle)


func calc_throttle(velocity):
	if (abs(velocity) > 10):
		return 100
	
	return 	(100.0 / 10) * abs(velocity)

func calc_torque_throttle(velocity):
	if (abs(velocity) > 1):
		return 100
	
	return (100.0 / 2) * abs(velocity)
	
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

func _on_user_control_thrust_forwards(throttle):
	if (throttle_based_on_max_speed):
		if (-velocity.z < calc_speed_at_percentage(throttle, max_total_velocity)):
			fire_thrusters_forwards(calc_throttle(calc_speed_at_percentage(throttle, max_total_velocity) - abs(velocity.z)))
	else:		
		if (-velocity.z <= max_total_velocity):
			fire_thrusters_forwards(throttle)

func _on_user_control_thrust_backwards(throttle):
	if (throttle_based_on_max_speed):
		if (velocity.z < calc_speed_at_percentage(abs(throttle), max_total_velocity)):
			fire_thrusters_retro(-calc_throttle(calc_speed_at_percentage(abs(throttle), max_total_velocity) - abs(velocity.z)))
	else:
		if (velocity.z <= max_total_velocity):
			fire_thrusters_retro(throttle)

func _on_user_control_thrust_left(throttle):
	if (-velocity.x <= max_side_velocity):
		fire_thrusters_left(throttle)

	thrust_left = true

func _on_user_control_thrust_right(throttle):
	if (velocity.x <= max_side_velocity):
		fire_thrusters_right(throttle)

	thrust_right = true

func _on_user_control_thrust_up(throttle):
	if (abs(velocity.y) <= max_up_down_velocity):
		fire_thrusters_up(throttle)
	
	thrust_up = true

func _on_user_control_thrust_down(throttle):
	if (abs(velocity.y) <= max_up_down_velocity):
		fire_thrusters_down(throttle)
	
	thrust_down = true

func _on_user_control_roll(throttle):
	if (abs(local_angular_velocity.z) < calc_speed_at_percentage(abs(throttle), max_roll_velocity)):
		fire_thrusters_roll(throttle)

	user_roll = throttle

	roll = true

func _on_user_control_pitch(throttle):
	if (abs(local_angular_velocity.x) < calc_speed_at_percentage(abs(throttle), max_pitch_velocity)):	
		fire_thrusters_pitch(throttle)
	
	user_pitch = throttle
	
	pitch = true

func _on_user_control_yaw(throttle):
	if (abs(local_angular_velocity.y) < calc_speed_at_percentage(abs(throttle), max_yaw_velocity)):
		fire_thrusters_yaw(throttle)
	
	user_yaw = throttle
		
	yaw = true

func fire_thrusters_forwards(throttle):
	apply_local_thrust(-transform.basis.z, max_thrust_main, throttle)
	fire_thrusters_main_signal.emit(throttle)
	
func fire_thrusters_retro(throttle):
	apply_local_thrust(-transform.basis.z, max_thrust_retro, throttle)
	fire_thrusters_retro_signal.emit(abs(throttle))

func fire_thrusters_left(throttle):
	apply_local_thrust(-transform.basis.x, max_thrust_left, throttle)
	fire_thrusters_left_signal.emit(throttle)

func fire_thrusters_right(throttle):
	apply_local_thrust(transform.basis.x, max_thrust_right, throttle)
	fire_thrusters_right_signal.emit(throttle)

func fire_thrusters_up(throttle):
	apply_local_thrust(transform.basis.y, max_thrust_up, throttle)
	fire_thrusters_up_signal.emit(throttle)
	
func fire_thrusters_down(throttle):
	apply_local_thrust(-transform.basis.y, max_thrust_down, throttle)
	fire_thrusters_down_signal.emit(throttle)
		
func fire_thrusters_roll(throttle):
	apply_local_torque(-transform.basis.z, max_roll_force, throttle)
	if (throttle > 0):
		fire_thrusters_roll_right_signal.emit(throttle)
	else:
		fire_thrusters_roll_left_signal.emit(-throttle)

func fire_thrusters_pitch(throttle):
	apply_local_torque(-transform.basis.x, max_pitch_force, throttle)
	
	if (throttle > 0):
		fire_thrusters_pitch_up_signal.emit(throttle)
	else:
		fire_thrusters_pitch_down_signal.emit(-throttle)
	
func fire_thrusters_yaw(throttle):
	apply_local_torque(-transform.basis.y, max_yaw_force, throttle)
	
	if (throttle > 0):
		fire_thrusters_yaw_right_signal.emit(throttle)
	else:
		fire_thrusters_yaw_left_signal.emit(-throttle)

func apply_local_thrust(direction : Vector3, force : float, throttle : float):
	apply_central_force(direction * force * (throttle / 100.0) * get_process_delta_time() * thrust_multiplier)

func apply_local_torque(direction : Vector3, force : float, throttle : float):
	apply_torque(direction * (throttle / 100.0) * force * get_process_delta_time() * torque_multiplier)

func calc_speed_at_percentage(percent : float, max_speed : float):
	return (percent * max_speed) / 100.0

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

func _on_user_control_no_pitch():
	pitch = false

func _on_user_control_no_yaw():
	yaw = false

func _on_user_control_no_roll():
	roll = false




func _on_player_input_send_movement_vector(movement_vector: Vector3):
	# Assuming movement_vector is normalized and in the range [-1, 1]

	# Forward/Backward Thrust
	if movement_vector.z > 0:
		_on_user_control_thrust_forwards(movement_vector.z * 100)
	elif movement_vector.z < 0:
		_on_user_control_thrust_backwards(-movement_vector.z * 100)

	# Left/Right Thrust
	if movement_vector.x < 0:
		_on_user_control_thrust_left(abs(movement_vector.x) * 100)
		_on_user_control_no_thrust_right()
	elif movement_vector.x > 0:
		_on_user_control_thrust_right(movement_vector.x * 100)
		_on_user_control_no_thrust_left()
		
	# Up/Down Thrust
	if movement_vector.y < 0:
		_on_user_control_thrust_down(abs(movement_vector.y) * 100)
		_on_user_control_no_thrust_up()
	elif movement_vector.y > 0:
		_on_user_control_thrust_up(movement_vector.y * 100)
		_on_user_control_no_thrust_down()


func _on_player_input_send_rotation_vector(rotation_vector):
	# Assuming rotation_vector is normalized and in the range [-1, 1]

	# Roll
	_on_user_control_roll(rotation_vector.z * 100)

	# Pitch
	_on_user_control_pitch(-rotation_vector.y * 100)

	# Yaw
	_on_user_control_yaw(rotation_vector.x * 100)