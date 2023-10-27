extends Node3D

signal setDefaultPosition(defaultPosition : Vector3)
signal is_first_person_signal(is_first_person : bool)

@export
var first_person_camera := Camera3D

@onready
var animation = $ViewCam/TwistPivot/PitchPivot/Camera3D/CameraViewSwitchAnimator

var is_first_person = true

var third_person_position = Vector3(0, 5.238, 14.946)


func _input(event):	
	if Input.is_action_just_pressed("camera-switch-view"):
		print(is_first_person)
		if (is_first_person and not animation.is_playing()):
			animation.play("SwitchCameraToThirdPersonView")
			setDefaultPosition.emit(third_person_position)
			is_first_person = false
			is_first_person_signal.emit(is_first_person)
		elif (not is_first_person and not animation.is_playing()):
			animation.play_backwards("SwitchCameraToThirdPersonView")
			is_first_person = true
			setDefaultPosition.emit(Vector3.ZERO)
			is_first_person_signal.emit(is_first_person)
