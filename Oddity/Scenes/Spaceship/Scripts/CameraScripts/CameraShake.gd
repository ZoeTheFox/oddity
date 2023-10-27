extends Camera3D

var acceleration : Vector3
var speed : float
var defaultPosition : Vector3

var min_fov : float
var max_fov : float
var logFactor : float
var maxMovement : float
var camera_shake_factor : float

# Called when the node enters the scene tree for the first time.
func _ready():
	defaultPosition = position
	
	min_fov = 60.0
	max_fov = 90.0
	logFactor = 0.025
	maxMovement = 3
	camera_shake_factor = 30


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fov = adjustFOVBasedOnSpeed(speed)
	adjustCameraBasedOnAcceleration()
	camera_shake()

func adjustCameraBasedOnAcceleration():
	var currentPosition = position
#
	position = position.lerp(acceleration + defaultPosition, get_process_delta_time() * 2.0)
	
func adjustFOVBasedOnSpeed(speed: float) -> float:
	# Define the minimum and maximum speeds for mapping
	var min_speed = -400.0
	var max_speed = 400.0

	# Ensure that the speed is within the specified range
	speed = clamp(speed, min_speed, max_speed)

	# Calculate the FOV based on speed using linear mapping
	var fov = lerp(min_fov, max_fov, (speed - min_speed) / (max_speed - min_speed))

	return fov

func camera_shake():
	var offset =  Vector2(randf(), randf()) * acceleration.length() / camera_shake_factor
	h_offset = offset.x
	v_offset = offset.y

func logarithmicTransform(vector):
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



func _on_cameras_set_default_position(defaultPosition):
	self.defaultPosition = defaultPosition


func _on_cameras_is_first_person_signal(is_first_person):
	if (is_first_person):
		min_fov = 60.0
		max_fov = 90.0
		logFactor = 0.025
		maxMovement = 3
		camera_shake_factor = 5
	else:
		min_fov = 80.0
		max_fov = 110.0
		logFactor = 0.2
		maxMovement = 40
		camera_shake_factor = 100
