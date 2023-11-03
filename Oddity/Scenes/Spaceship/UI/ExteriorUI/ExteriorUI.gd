extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_fighter_gen_7_speed_signal(speed):
	$Speed.text = str(round(speed)) + "m/s"

func _on_user_control_throttle_signal(throttle):
	$ThrustBar2D.value = abs(throttle)


func _on_cameras_is_first_person_signal(is_first_person):
	if (is_first_person):
		hide()
	else:
		show()
