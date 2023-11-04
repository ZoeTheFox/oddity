extends Node3D

@export
var max_particles : int

func fire(throttle):
	$Timer.start()
	if (round(throttle) == 0):
		$retro_left.emitting = false
		$retro_right.emitting = false
	else:
		$retro_left.emitting = true
		$retro_right.emitting = true
		$retro_left.amount = (throttle / 100.0) * max_particles + 1
		$retro_right.amount = (throttle / 100.0) * max_particles + 1


func _on_timer_timeout():
	fire(0)
