extends Node3D

@export
var first_person_camera := Camera3D

@export
var third_person_camera := Camera3D

func _input(event):
	if Input.is_action_pressed("camera-switch-view"):
		if first_person_camera.current == true:
			third_person_camera.current = true
		else:
			first_person_camera.current = true
			
			
