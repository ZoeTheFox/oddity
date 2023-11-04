extends Node3D

@export
var max_particles_main : int

@export
var max_particles_smoke : int


func fire(throttle):
	$Timer.start()
	
	if (round(throttle) == 0):
		$main.emitting = false
		$smoke.emitting = false
	else:
		$main.emitting = true
		$smoke.emitting = true
		$main.amount = (throttle / 100.0) * max_particles_main + 1
		$smoke.amount = (throttle / 100.0) * max_particles_smoke + 1


func _on_timer_timeout():
	fire(0)
