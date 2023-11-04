extends Node3D

func _on_fighter_gen_7_fire_thrusters_main_signal(throttle):
	$Main.fire(throttle)


func _on_fighter_gen_7_fire_thrusters_retro_signal(throttle):
	$Retro.fire(throttle)


func _on_fighter_gen_7_fire_thrusters_down_signal(throttle):
	$TimerDown.start()
	$wing_top_left.fire(throttle)
	$wing_top_right.fire(throttle)
	$top_middle_left.fire(throttle)
	$top_middle_right.fire(throttle)
	$back_top_left.fire(throttle)
	$back_top_right.fire(throttle)
	$front_top.fire(throttle)

func _on_fighter_gen_7_fire_thrusters_left_signal(throttle):
	$TimerLeft.start()
	$back_right.fire(throttle)
	$front_right.fire(throttle)
	$middle_right.fire(throttle)


func _on_fighter_gen_7_fire_thrusters_pitch_down_signal(throttle):
	$front_bottom.fire(throttle)
	$bottom_middle_left.fire(throttle)
	$bottom_middle_right.fire(throttle)
	$back_top_left.fire(throttle)
	$back_top_right.fire(throttle)


func _on_fighter_gen_7_fire_thrusters_pitch_up_signal(throttle):
	$front_top.fire(throttle)
	$top_middle_left.fire(throttle)
	$top_middle_right.fire(throttle)
	$back_bottom_left.fire(throttle)
	$back_bottom_right.fire(throttle)

func _on_fighter_gen_7_fire_thrusters_right_signal(throttle):
	$TimerRight.start()
	$back_left.fire(throttle)
	$front_left.fire(throttle)
	$middle_left.fire(throttle)


func _on_fighter_gen_7_fire_thrusters_roll_left_signal(throttle):
	$wing_top_left.fire(throttle)
	$top_middle_left.fire(throttle)
	$back_top_left.fire(throttle)
	$wing_bottom_right.fire(throttle)
	$bottom_middle_right.fire(throttle)
	$back_bottom_right.fire(throttle)

func _on_fighter_gen_7_fire_thrusters_roll_right_signal(throttle):
	$wing_bottom_left.fire(throttle)
	$bottom_middle_left.fire(throttle)
	$back_bottom_left.fire(throttle)
	$wing_top_right.fire(throttle)
	$top_middle_right.fire(throttle)
	$back_top_right.fire(throttle)

func _on_fighter_gen_7_fire_thrusters_up_signal(throttle):
	$TimerUp.start()
	$wing_bottom_left.fire(throttle)
	$wing_bottom_right.fire(throttle)
	$bottom_middle_left.fire(throttle)
	$bottom_middle_right.fire(throttle)
	$back_bottom_left.fire(throttle)
	$back_bottom_right.fire(throttle)
	$front_bottom.fire(throttle)


func _on_fighter_gen_7_fire_thrusters_yaw_left_signal(throttle):
	$back_left.fire(throttle)
	$front_right.fire(throttle)
	$middle_right.fire(throttle)


func _on_fighter_gen_7_fire_thrusters_yaw_right_signal(throttle):
	$back_right.fire(throttle)
	$front_left.fire(throttle)
	$middle_left.fire(throttle)

func _on_timer_up_timeout():
	_on_fighter_gen_7_fire_thrusters_up_signal(0)

func _on_timer_down_timeout():
	_on_fighter_gen_7_fire_thrusters_down_signal(0)


func _on_timer_right_timeout():
	_on_fighter_gen_7_fire_thrusters_right_signal(0)


func _on_timer_left_timeout():
	_on_fighter_gen_7_fire_thrusters_left_signal(0)
