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
	apply_central_force(Vector3(0,0,-max_thrust_main * (throttle / 100.0)) * get_process_delta_time()) # Replace with function body.

func _on_user_control_thrust_backwards(throttle):
	apply_central_force(Vector3(0,0,-max_thrust_retro * (throttle / 100.0)) * get_process_delta_time()) # Replace with function body.


func _on_user_control_thrust_down(throttle):
	apply_central_force(Vector3(0,-max_thrust_down * (throttle / 100.0),0 ) * get_process_delta_time()) # Replace with function body.


func _on_user_control_thrust_left(throttle):
	apply_central_force(Vector3(-max_thrust_left * (throttle / 100.0),0,0 ) * get_process_delta_time()) # Replace with function body.
	

func _on_user_control_thrust_right(throttle):
	apply_central_force(Vector3(max_thrust_right * (throttle / 100.0),0,0 ) * get_process_delta_time()) # Replace with function body.


func _on_user_control_thrust_up(throttle):
	apply_central_force(Vector3(0, max_thrust_up * (throttle / 100.0), 0) * get_process_delta_time())
