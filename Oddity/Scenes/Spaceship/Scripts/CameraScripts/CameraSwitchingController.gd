extends Node3D

signal setDefaultPosition(defaultPosition : Vector3)

@export
var first_person_camera := Camera3D

@onready
var timer := $Timer

var is_first_person = true

var third_person_position = Vector3(0, 5.238, 14.946)

func _input(event):	
	if Input.is_action_just_released("camera-switch-view"):
		if (not is_first_person):
			setDefaultPosition.emit(third_person_position)
			first_person_camera.position = first_person_camera.position.lerp(third_person_position, get_process_delta_time() * 2.0)
			is_first_person = true
		else:
			setDefaultPosition.emit(Vector3.ZERO)
			first_person_camera.position = first_person_camera.position.lerp(Vector3.ZERO, get_process_delta_time() * 2.0)
			is_first_person = false

