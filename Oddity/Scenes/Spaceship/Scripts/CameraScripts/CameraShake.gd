extends Camera3D

var acceleration : Vector3
var speed : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fov = adjustFOVBasedOnSpeed(speed)
	
	
func adjustFOVBasedOnSpeed(speed: float) -> float:
	# Define the reasonable FOV range
	var min_fov = 60.0  # Minimum FOV
	var max_fov = 90.0  # Maximum FOV

	# Define the minimum and maximum speeds for mapping
	var min_speed = -400.0
	var max_speed = 400.0

	# Ensure that the speed is within the specified range
	speed = clamp(speed, min_speed, max_speed)

	# Calculate the FOV based on speed using linear mapping
	var fov = lerp(min_fov, max_fov, (speed - min_speed) / (max_speed - min_speed))

	return fov


func _on_fighter_gen_7_accelleration_signal(accelaration):
	self.acceleration = accelaration


func _on_fighter_gen_7_speed_signal(speed):
	self.speed = speed
