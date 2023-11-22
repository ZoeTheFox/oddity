extends Node3D

@export_category("Throttle")

@export_range(0, 10)
var throttle_sensitivity : float

@export_range(0, 1)
var throttle_deadzone : float

@export_category("Mouse")

@export
var mouse_sensitivity : float

@export
var mouse_sensitivity_curve : Curve

var mouse_pitch : float
var mouse_yaw : float

var movement_vector : Vector3
var rotation_vector : Vector3

signal send_movement_vector(movement_vector)
signal send_rotation_vector(rotation_vector)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	movement_vector.x = 0
	movement_vector.y = 0
	rotation_vector.z = 0

	## Throttle
	
	if (Input.is_action_pressed("throttle-forwards")):
		movement_vector.z -= throttle_sensitivity * delta
	
	if (Input.is_action_pressed("throttle-backwards")):
		movement_vector.z += throttle_sensitivity * delta
	
	movement_vector.z = clamp(movement_vector.z, -1, 1)
	
	if (abs(movement_vector.z) < throttle_deadzone and movement_vector.z != 0):
		if ($ThrottleDeadzoneTimer.is_stopped()):
			$ThrottleDeadzoneTimer.start()
	
	## Left - Right
	
	if (Input.is_action_pressed("move-left")):
		movement_vector.x += 1.0
	
	if (Input.is_action_pressed("move-right")):
		movement_vector.x -= 1.0
	
	## Up - Down
	
	if (Input.is_action_pressed("move-up")):
		movement_vector.y += 1.0
	
	if (Input.is_action_pressed("move-down")):
		movement_vector.y -= 1.0
		
	## Roll
	
	if (Input.is_action_pressed("roll-left")):
		rotation_vector.z -= 1.0
	
	if (Input.is_action_pressed("roll-right")):
		rotation_vector.z += 1.0
		
	## Yaw
	
	rotation_vector.x = clamp(mouse_yaw, -1, 1)
	rotation_vector.x = rotation_vector.x * mouse_sensitivity_curve.sample(abs(rotation_vector.x)) 

	## Pitch
	
	rotation_vector.y = clamp(mouse_pitch, -1, 1)
	rotation_vector.y = rotation_vector.y * mouse_sensitivity_curve.sample(abs(rotation_vector.x)) 
	
	send_movement_vector.emit(movement_vector)
	send_rotation_vector.emit(rotation_vector)
	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_yaw += lerp(0,1,clamp(event.relative.x * get_process_delta_time(),-1,1)) * mouse_sensitivity
		mouse_pitch += lerp(0,1,clamp(event.relative.y * get_process_delta_time(),-1,1)) * mouse_sensitivity


func _on_throttle_deadzone_timer_timeout():
	if (abs(movement_vector.z) < throttle_deadzone):
		movement_vector.z = 0
