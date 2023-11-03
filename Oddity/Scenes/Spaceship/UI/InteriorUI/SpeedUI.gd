extends Label3D

func _on_fighter_gen_7_speed_signal(speed):
	text = str(round(speed)) + "m/s"
