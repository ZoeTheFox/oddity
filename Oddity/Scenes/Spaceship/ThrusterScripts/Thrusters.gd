extends Node3D

func _on_fighter_gen_7_fire_thrusters_main_signal(throttle):
	$Main.fire(throttle)


func _on_fighter_gen_7_fire_thrusters_retro_signal(throttle):
	$Retro.fire(throttle)


func _on_fighter_gen_7_fire_thrusters_down_signal(throttle):
	$TimerUp.start()
	$wing_top_left.fire(throttle)
	$wing_top_right.fire(throttle)
	$top_middle_left.fire(throttle)
	$top_middle_right.fire(throttle)
	$back_top_left.fire(throttle)
	$back_top_right.fire(throttle)
	$front_top.fire(throttle)
	print("owo " + str(throttle))


func _on_fighter_gen_7_fire_thrusters_left_signal(throttle):
	pass # Replace with function body.


func _on_fighter_gen_7_fire_thrusters_pitch_down_signal(throttle):
	pass # Replace with function body.


func _on_fighter_gen_7_fire_thrusters_pitch_up_signal(throttle):
	pass # Replace with function body.


func _on_fighter_gen_7_fire_thrusters_right_signal(throttle):
	pass # Replace with function body.


func _on_fighter_gen_7_fire_thrusters_roll_left_signal(throttle):
	pass # Replace with function body.


func _on_fighter_gen_7_fire_thrusters_roll_right_signal(throttle):
	pass # Replace with function body.


func _on_fighter_gen_7_fire_thrusters_up_signal(throttle):
	pass


func _on_fighter_gen_7_fire_thrusters_yaw_left_signal(throttle):
	pass # Replace with function body.


func _on_fighter_gen_7_fire_thrusters_yaw_right_signal(throttle):
	pass # Replace with function body.


func _on_timer_up_timeout():
	_on_fighter_gen_7_fire_thrusters_down_signal(0)
