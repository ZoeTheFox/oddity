extends Node3D

func _on_user_control_throttle_signal(throttle):
	$SubViewport/ThrustBar2D.value = abs(throttle)
