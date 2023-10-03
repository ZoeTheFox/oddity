extends Node3D

signal thrust_forwards(throttle)
signal thrust_backwards(throttle)
signal thrust_left(throttle)
signal thrust_right(throttle)
signal thrust_up(throttle)
signal thrust_down(throttle)
signal roll_left(percent)
signal roll_right(percent)
signal pitch(percent)
signal yaw(percent)

signal no_thrust_left()
signal no_thrust_right()
signal no_thrust_up()
signal no_thrust_down()
signal no_roll_left()
signal no_roll_right()
signal throttle_signal(throttle)

var throttle := 0.0
@export
var throttle_deadzone : float
@export
var throttle_sensivity : float

var mouseInput = Vector2(0,0)
var mouseJoyInput = Vector2(0,0)

var mouse_sensivity := 0.01

@onready
var timer := $Timer

var mouse_moved = false 

var max_rotation  = 25
var interpolation_time = 4

var interpolation_vector_default : Vector2 = Vector2(0, 0)
var last_mouse_move_relative : Vector2
var interpolate_torwards_vector : Vector2
var current_interpolating_vector : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_pressed("throttle-forwards")):
		throttle = throttle + throttle_sensivity * delta
		throttle = clamp(throttle, -100.0, 100.0)
	
	if (Input.is_action_pressed("throttle-backwards")):
		throttle = throttle - throttle_sensivity * delta
		throttle = clamp(throttle, -100.0, 100.0)
		
	if (throttle < throttle_deadzone and throttle > -throttle_deadzone):
		#print("deadzone")
		if (timer.is_stopped()):
			timer.start()
	
	if (throttle > 0):
		thrust_forwards.emit(throttle)
	else:
		thrust_backwards.emit(throttle)
		
	throttle_signal.emit(throttle)
		
	if (Input.is_action_pressed("move-left")):
		thrust_left.emit(100)
	else:
		no_thrust_left.emit()
	
	if (Input.is_action_pressed("move-right")):
		thrust_right.emit(100)
	else:
		no_thrust_right.emit()
		
	if (Input.is_action_pressed("move-up")):
		thrust_up.emit(100)
	else:
		no_thrust_up.emit()
		
	if (Input.is_action_pressed("move-down")):
		thrust_down.emit(100)
	else:
		no_thrust_down.emit()
		
	if (Input.is_action_pressed("roll-left")):
		roll_left.emit(100)
	else:
		no_roll_left.emit()
		
	if (Input.is_action_pressed("roll-right")):
		roll_right.emit(100)
	else:
		no_roll_right.emit()
		
	if mouse_moved:
		mouse_moved = false
		interpolate_torwards_vector = last_mouse_move_relative
	

	current_interpolating_vector = current_interpolating_vector.lerp(interpolate_torwards_vector, interpolation_time * delta)
	rotation_degrees.x = current_interpolating_vector.x
	rotation_degrees.y = current_interpolating_vector.y
	
	print("y " + str(rotation_degrees.y) + " x " + str(rotation_degrees.x))
	
	#if not Input.is_action_pressed("camera-look-around"):
		#yaw.emit(mouseInput.x)
		#pitch.emit(mouseInput.y)
		
		
		

   

func _input(event):
	if event is InputEventMouseMotion:
		mouse_moved = true
		last_mouse_move_relative = Vector2(clamp(event.relative.y, -max_rotation, max_rotation), 
		clamp(event.relative.x, -max_rotation, max_rotation)) * -1

func _on_timer_timeout():
	if (throttle < throttle_deadzone and throttle > -throttle_deadzone):
		throttle = 0
	
	timer.stop()
	
	#print("timer")
