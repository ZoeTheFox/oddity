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
			is_first_person = true
		else:
			setDefaultPosition.emit(Vector3.ZERO)
			is_first_person = false

