extends Camera3D

var acceleration : Vector3
var speed : float
var defaultPosition : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	defaultPosition = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fov = adjustFOVBasedOnSpeed(speed)
	adjustCameraBasedOnAcceleration()
	#print(position)

func adjustCameraBasedOnAcceleration():
	var currentPosition = position
#
	position = position.lerp(acceleration + defaultPosition, get_process_delta_time() * 2.0)
#	position = position.lerp(acceleration, get_process_delta_time() * 2.0)
#
#	position = currentPosition + acceleration
#
#	# Define a threshold for the acceleration values to consider as "close to 0"
#	var accelerationThreshold = 0.0001  # Adjust this threshold as needed
#
#	if acceleration.length() < accelerationThreshold:
#		# If acceleration is close to 0, reset the position to the default position
#		position = position.lerp(defaultPosition, get_process_delta_time() * 2.0)
	
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

func logarithmicTransform(vector):
	# Logarithmic scaling factor to adjust the intensity of the transformation
	var logFactor = 0.01
	#var maxMovement = 0.0015
	var maxMovement = 2.5
	
	var transformedVector = Vector3()

	# Apply the logarithmic transformation to each component of the vector
	transformedVector.x = clamp(log(1 + abs(vector.x)) * sign(vector.x) * logFactor, -maxMovement, maxMovement)
	transformedVector.y = clamp(log(1 + abs(vector.y)) * sign(vector.y) * logFactor, -maxMovement, maxMovement)
	transformedVector.z = clamp(log(1 + abs(vector.z)) * sign(vector.z) * logFactor, -maxMovement, maxMovement)

	return -transformedVector

func _on_fighter_gen_7_accelleration_signal(accelaration):
	self.acceleration = logarithmicTransform(accelaration)


func _on_fighter_gen_7_speed_signal(speed):
	self.speed = speed
